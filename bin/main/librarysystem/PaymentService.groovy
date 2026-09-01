package librarysystem

import grails.gorm.transactions.Transactional

import java.time.YearMonth

@Transactional
class PaymentService {

    PurchaseService purchaseService
    RoomReservationService roomReservationService

    Payment processPayment(
        User user,
        String purpose,
        Long targetId,
        String cardholderName,
        String cardNumber,
        String expiry,
        String cvv
    ) {
        if (!user) {
            throw new IllegalArgumentException('يجب تسجيل الدخول لإتمام الدفع.')
        }

        String normalizedPurpose = purpose?.trim()?.toUpperCase()
        if (!(normalizedPurpose in ['PURCHASE', 'ROOM_RESERVATION'])) {
            throw new IllegalArgumentException('نوع عملية الدفع غير صالح.')
        }

        if (!targetId) {
            throw new IllegalArgumentException('العملية المطلوب دفعها غير موجودة.')
        }

        String holder = cardholderName?.trim()
        String number = cardNumber?.replaceAll(/\D/, '')
        String securityCode = cvv?.replaceAll(/\D/, '')

        if (!holder) {
            throw new IllegalArgumentException('أدخل اسم حامل البطاقة.')
        }

        if (!number || !(number.size() in [13, 16, 19]) || !number.startsWith('4') || !passesLuhn(number)) {
            throw new IllegalArgumentException('رقم بطاقة Visa غير صالح. للمحاكاة يمكنك استخدام 4242 4242 4242 4242.')
        }

        if (!securityCode || securityCode.size() != 3) {
            throw new IllegalArgumentException('رمز الأمان CVV يجب أن يتكون من 3 أرقام.')
        }

        validateExpiry(expiry)

        Payment existing = Payment.findByPurposeAndTargetIdAndStatus(
            normalizedPurpose,
            targetId,
            'COMPLETED'
        )

        if (existing) {
            if (existing.user.id != user.id) {
                throw new IllegalStateException('هذه العملية لا تخص حسابك.')
            }
            return existing
        }

        BigDecimal amount

        if (normalizedPurpose == 'PURCHASE') {
            Purchase purchase = purchaseService.get(targetId)
            validateOwnership(purchase?.user, user)
            if (!purchase || purchase.status != 'PENDING') {
                throw new IllegalStateException('عملية الشراء لم تعد بانتظار الدفع.')
            }
            amount = purchase.totalAmount
        } else {
            RoomReservation reservation = roomReservationService.get(targetId)
            validateOwnership(reservation?.user, user)
            if (!reservation || reservation.status != 'PENDING') {
                throw new IllegalStateException('حجز الغرفة لم يعد بانتظار الدفع.')
            }
            amount = reservation.totalPrice
        }

        Payment payment = new Payment(
            referenceCode: generateReference(),
            purpose: normalizedPurpose,
            targetId: targetId,
            amount: amount,
            currency: 'USD',
            cardBrand: 'VISA',
            cardLastFour: number[-4..-1],
            cardholderName: holder,
            status: 'COMPLETED',
            paidAt: new Date(),
            user: user
        )

        payment.save(flush: true, failOnError: true)

        if (normalizedPurpose == 'PURCHASE') {
            purchaseService.completePurchase(targetId)
        } else {
            roomReservationService.confirmPaidReservation(targetId)
        }

        payment
    }

    void cancelPending(User user, String purpose, Long targetId) {
        String normalizedPurpose = purpose?.trim()?.toUpperCase()

        if (normalizedPurpose == 'PURCHASE') {
            Purchase purchase = purchaseService.get(targetId)
            validateOwnership(purchase?.user, user)
            purchaseService.cancelPendingPurchase(targetId)
        } else if (normalizedPurpose == 'ROOM_RESERVATION') {
            RoomReservation reservation = roomReservationService.get(targetId)
            validateOwnership(reservation?.user, user)
            roomReservationService.cancelReservation(targetId)
        }
    }

    private void validateOwnership(User owner, User currentUser) {
        if (!owner || !currentUser || owner.id != currentUser.id) {
            throw new IllegalStateException('هذه العملية لا تخص حسابك.')
        }
    }

    private void validateExpiry(String expiry) {
        String normalized = expiry?.trim()?.replaceAll(/\s/, '')
        if (!normalized) {
            throw new IllegalArgumentException('أدخل تاريخ انتهاء البطاقة.')
        }

        def matcher = normalized =~ /^(\d{2})\/(\d{2}|\d{4})$/
        if (!matcher.matches()) {
            throw new IllegalArgumentException('اكتب تاريخ الانتهاء بصيغة MM/YY مثل 12/30.')
        }

        int month = matcher[0][1] as int
        String yearPart = matcher[0][2]
        int year = yearPart.size() == 2 ? 2000 + (yearPart as int) : (yearPart as int)

        if (month < 1 || month > 12) {
            throw new IllegalArgumentException('شهر انتهاء البطاقة غير صالح.')
        }

        YearMonth value = YearMonth.of(year, month)
        if (value.isBefore(YearMonth.now())) {
            throw new IllegalArgumentException('البطاقة منتهية الصلاحية.')
        }
    }

    private boolean passesLuhn(String number) {
        int sum = 0
        boolean doubleDigit = false

        for (int i = number.length() - 1; i >= 0; i--) {
            int digit = Character.digit(number.charAt(i), 10)
            if (doubleDigit) {
                digit *= 2
                if (digit > 9) {
                    digit -= 9
                }
            }
            sum += digit
            doubleDigit = !doubleDigit
        }

        sum % 10 == 0
    }

    private String generateReference() {
        "MN-${System.currentTimeMillis()}-${UUID.randomUUID().toString().substring(0, 6).toUpperCase()}"
    }
}
