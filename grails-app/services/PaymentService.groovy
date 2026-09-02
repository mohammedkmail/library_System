package librarysystem

import grails.gorm.transactions.Transactional
import java.math.RoundingMode

@Transactional
class PaymentService {

    BraintreeGatewayService braintreeGatewayService
    CheckoutIntentService checkoutIntentService
    PurchaseService purchaseService
    RoomReservationService roomReservationService
    ReservationService reservationService
    BorrowingService borrowingService
    MembershipService membershipService
    DigitalAccessService digitalAccessService

    String clientToken() {
        braintreeGatewayService.clientToken()
    }

    boolean isOnlineGatewayConfigured() {
        braintreeGatewayService.configured
    }

    Payment processOnlinePayment(User user, String purpose, Long targetId, String checkoutToken,
                                 String paymentMethodNonce) {
        if (!user) throw new IllegalArgumentException('يجب تسجيل الدخول لإتمام الدفع.')
        String normalized = purpose?.trim()?.toUpperCase()
        if (!(normalized in ['PURCHASE', 'ROOM_RESERVATION', 'BOOK_RESERVATION', 'DIGITAL_RENTAL', 'MEMBERSHIP'])) {
            throw new IllegalArgumentException('نوع عملية الدفع غير صالح.')
        }

        String reference = generateReference()
        BigDecimal amount
        Closure finalizeOperation
        Closure<Long> resolvedTargetId
        CheckoutIntent intent = null

        if (normalized == 'PURCHASE') {
            Purchase purchase = Purchase.lock(targetId)
            validateOwnership(purchase?.user, user)
            if (!purchase || purchase.status != 'PENDING') throw new IllegalStateException('عملية الشراء لم تعد بانتظار الدفع.')
            Book lockedBook = Book.lock(purchase.book.id)
            if (purchase.purchaseType == 'PHYSICAL' && (lockedBook.physicalSaleStock ?: 0) < purchase.quantity) {
                throw new IllegalStateException('الكمية المطلوبة نفدت قبل الدفع. لم يتم خصم أي مبلغ.')
            }
            if (purchase.purchaseType == 'DIGITAL' &&
                (DigitalAccess.findByUserAndBookAndAccessTypeAndStatus(user, lockedBook, 'PURCHASE', 'ACTIVE') ||
                 Purchase.findByUserAndBookAndPurchaseTypeAndStatus(user, lockedBook, 'DIGITAL', 'COMPLETED'))) {
                throw new IllegalStateException('أنت تملك النسخة الرقمية بالفعل.')
            }
            amount = purchase.totalAmount
            finalizeOperation = { purchaseService.completePurchase(purchase.id) }
            resolvedTargetId = { purchase.id }

        } else if (normalized == 'BOOK_RESERVATION') {
            reservationService.expireReadyReservations()
            Reservation reservation = Reservation.lock(targetId)
            validateOwnership(reservation?.user, user)
            if (!reservation || reservation.status != 'READY') throw new IllegalStateException('حجز الكتاب لم يعد جاهزًا للدفع.')
            if (!reservation.assignedCopy || reservation.assignedCopy.status != 'RESERVED') {
                throw new IllegalStateException('النسخة المخصصة للحجز لم تعد متاحة.')
            }
            amount = reservation.feeAmount ?: reservation.book?.borrowingFee ?: BigDecimal.ZERO
            if (amount <= BigDecimal.ZERO) throw new IllegalStateException('لا توجد رسوم على هذا الحجز؛ راجع الإدارة لتأكيد الاستلام.')
            finalizeOperation = { reservationService.confirmPayment(reservation.id) }
            resolvedTargetId = { reservation.id }

        } else if (normalized == 'MEMBERSHIP') {
            Membership membership = Membership.lock(targetId)
            validateOwnership(membership?.user, user)
            if (!membership || membership.status != 'PENDING') throw new IllegalStateException('طلب العضوية لم يعد بانتظار الدفع.')
            amount = membership.price
            finalizeOperation = { membershipService.activateMembership(membership.id) }
            resolvedTargetId = { membership.id }

        } else {
            intent = checkoutIntentService.findOpen(checkoutToken, user)
            if (!intent || intent.purpose != normalized) throw new IllegalStateException('جلسة الدفع انتهت أو لم تعد صالحة.')
            Map payload = checkoutIntentService.payload(intent)
            amount = intent.amount

            if (normalized == 'ROOM_RESERVATION') {
                Long roomId = (payload.studyRoomId as Number)?.longValue()
                Date startTime = new Date((payload.startTime as Number).longValue())
                Date endTime = new Date((payload.endTime as Number).longValue())
                StudyRoom lockedRoom = StudyRoom.lock(roomId)
                if (!lockedRoom) throw new IllegalStateException('غرفة الدراسة لم تعد موجودة.')
                Map quote = roomReservationService.quote(user, lockedRoom, startTime, endTime)
                if (quote.totalPrice.setScale(2, RoundingMode.HALF_UP) != amount.setScale(2, RoundingMode.HALF_UP)) {
                    throw new IllegalStateException('تغيّر سعر الحجز. أعد فتح صفحة الحجز قبل الدفع.')
                }
                Map holder = [:]
                finalizeOperation = {
                    RoomReservation reservation = roomReservationService.createConfirmedReservation(
                        user, lockedRoom.id, startTime, endTime, amount)
                    holder.id = reservation.id
                    checkoutIntentService.complete(intent)
                    reservation
                }
                resolvedTargetId = { holder.id as Long }

            } else {
                Long bookId = (payload.bookId as Number)?.longValue()
                Integer rentalDays = (payload.rentalDays as Number)?.intValue()
                Book lockedBook = Book.lock(bookId)
                if (!lockedBook) throw new IllegalStateException('الكتاب لم يعد موجودًا.')
                BigDecimal currentAmount = digitalAccessService.calculateRentalPrice(lockedBook, rentalDays)
                if (currentAmount.setScale(2, RoundingMode.HALF_UP) != amount.setScale(2, RoundingMode.HALF_UP)) {
                    throw new IllegalStateException('تغيّر سعر الاستئجار الرقمي. أعد المحاولة.')
                }
                if (digitalAccessService.canAccessBook(user, lockedBook)) {
                    throw new IllegalStateException('لديك وصول فعال لهذا الكتاب بالفعل.')
                }
                Map holder = [:]
                finalizeOperation = {
                    DigitalAccess access = digitalAccessService.grantPaidRentalAccess(user, lockedBook, rentalDays, amount)
                    holder.id = access.id
                    checkoutIntentService.complete(intent)
                    access
                }
                resolvedTargetId = { holder.id as Long }
            }
        }

        Map gatewayResult = braintreeGatewayService.sale(amount, paymentMethodNonce, reference)
        try {
            finalizeOperation.call()
            Long finalTargetId = resolvedTargetId.call()
            Payment payment = new Payment(
                referenceCode: reference,
                provider: 'BRAINTREE',
                providerTransactionId: gatewayResult.transactionId,
                purpose: normalized,
                targetId: finalTargetId,
                amount: amount,
                currency: 'USD',
                paymentMethod: 'CARD',
                cardBrand: gatewayResult.cardBrand,
                cardLastFour: gatewayResult.lastFour,
                cardholderName: gatewayResult.cardholderName,
                channel: 'ONLINE',
                status: 'COMPLETED',
                paidAt: new Date(),
                user: user
            )
            payment.save(flush: true, failOnError: true)
            payment
        } catch (Exception e) {
            braintreeGatewayService.voidTransactionQuietly(gatewayResult.transactionId as String)
            throw e
        }
    }

    Payment recordCounterPurchase(User user, Long purchaseId, String method, String notes = null) {
        Purchase purchase = Purchase.lock(purchaseId)
        validateOwnership(purchase?.user, user)
        if (!purchase || purchase.status != 'PENDING') throw new IllegalStateException('عملية الشراء ليست بانتظار الدفع.')
        Payment payment = createCounterPayment(user, 'PURCHASE', purchase.id, purchase.totalAmount, method, notes)
        purchaseService.completePurchase(purchase.id)
        payment
    }

    Map recordCounterBorrowing(User user, Long bookCopyId, String method, String notes = null) {
        BookCopy copy = BookCopy.get(bookCopyId)
        if (!copy) throw new IllegalArgumentException('نسخة الكتاب غير موجودة.')
        BigDecimal amount = borrowingService.counterBorrowingFee(copy)
        Borrowing borrowing = borrowingService.borrowBookAfterCounterPayment(user, copy)
        Payment payment = createCounterPayment(user, 'BORROWING', borrowing.id, amount, method, notes)
        [borrowing: borrowing, payment: payment]
    }

    Map recordCounterReservationHandover(Long reservationId, String method, String notes = null) {
        reservationService.expireReadyReservations()
        Reservation reservation = Reservation.lock(reservationId)
        if (!reservation) throw new IllegalArgumentException('الحجز غير موجود.')
        if (reservation.status == 'READY') {
            Payment payment = createCounterPayment(
                reservation.user, 'BOOK_RESERVATION', reservation.id,
                reservation.feeAmount ?: reservation.book?.borrowingFee ?: BigDecimal.ZERO,
                method, notes)
            reservationService.confirmPayment(reservation.id)
            Borrowing borrowing = borrowingService.borrowPaidReservation(reservation.id)
            return [borrowing: borrowing, payment: payment]
        }
        if (reservation.status == 'PAID') {
            Borrowing borrowing = borrowingService.borrowPaidReservation(reservation.id)
            Payment payment = Payment.findByPurposeAndTargetIdAndStatus('BOOK_RESERVATION', reservation.id, 'COMPLETED')
            return [borrowing: borrowing, payment: payment]
        }
        throw new IllegalStateException('الحجز غير جاهز للتسليم.')
    }

    Payment createCounterPayment(User user, String purpose, Long targetId, BigDecimal amount,
                                 String method, String notes = null) {
        String normalizedMethod = method?.toUpperCase() in ['CASH', 'CARD'] ? method.toUpperCase() : 'CASH'
        new Payment(
            referenceCode: generateReference('POS'),
            provider: 'COUNTER',
            providerTransactionId: null,
            purpose: purpose,
            targetId: targetId,
            amount: amount ?: BigDecimal.ZERO,
            currency: 'USD',
            paymentMethod: normalizedMethod,
            channel: 'COUNTER',
            status: 'COMPLETED',
            notes: notes?.trim(),
            paidAt: new Date(),
            user: user
        ).save(flush: true, failOnError: true)
    }

    void cancelCheckout(User user, String purpose, Long targetId, String checkoutToken) {
        String normalized = purpose?.toUpperCase()
        if (normalized == 'PURCHASE') {
            Purchase purchase = purchaseService.get(targetId)
            validateOwnership(purchase?.user, user)
            purchaseService.cancelPendingPurchase(targetId)
        } else if (normalized == 'MEMBERSHIP') {
            Membership membership = membershipService.get(targetId)
            validateOwnership(membership?.user, user)
            membershipService.cancelMembership(targetId)
        } else if (normalized in ['ROOM_RESERVATION', 'DIGITAL_RENTAL']) {
            CheckoutIntent intent = checkoutIntentService.findOpen(checkoutToken, user)
            if (intent) checkoutIntentService.cancel(intent)
        }
        // BOOK_RESERVATION remains READY when the customer simply leaves checkout.
    }

    private void validateOwnership(User owner, User currentUser) {
        if (!owner || !currentUser || owner.id != currentUser.id) {
            throw new IllegalStateException('هذه العملية لا تخص حسابك.')
        }
    }

    private String generateReference(String prefix = 'MN') {
        "${prefix}-${System.currentTimeMillis()}-${UUID.randomUUID().toString().substring(0, 6).toUpperCase()}"
    }
}
