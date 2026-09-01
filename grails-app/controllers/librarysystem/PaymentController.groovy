package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
class PaymentController {

    SpringSecurityService springSecurityService
    PaymentService paymentService
    PurchaseService purchaseService
    RoomReservationService roomReservationService

    static allowedMethods = [
        checkout: 'GET',
        process : 'POST',
        cancel  : 'POST'
    ]

    def checkout(String purpose, Long targetId) {
        User currentUser = springSecurityService.currentUser as User
        Map target = resolveTarget(currentUser, purpose, targetId)

        if (!target) {
            flash.message = 'عملية الدفع غير موجودة أو لم تعد متاحة.'
            redirect controller: 'dashboard', action: 'index'
            return
        }

        render view: 'checkout', model: target + [
            purpose : purpose?.toUpperCase(),
            targetId: targetId
        ]
    }

    def process() {
        User currentUser = springSecurityService.currentUser as User
        String purpose = params.purpose
        Long targetId = params.long('targetId')

        try {
            Payment payment = paymentService.processPayment(
                currentUser,
                purpose,
                targetId,
                params.cardholderName,
                params.cardNumber,
                params.expiry,
                params.cvv
            )

            flash.message = "تم الدفع بنجاح. رقم العملية ${payment.referenceCode}."

            if (payment.purpose == 'PURCHASE') {
                redirect controller: 'purchase',
                         action: 'show',
                         id: payment.targetId
            } else {
                redirect controller: 'roomReservation',
                         action: 'show',
                         id: payment.targetId
            }

        } catch (IllegalArgumentException | IllegalStateException e) {

            flash.message = e.message

            redirect action: 'checkout',
                     params: [
                         purpose : purpose,
                         targetId: targetId
                     ]
        }
    }

    def cancel() {
        User currentUser = springSecurityService.currentUser as User
        String purpose = params.purpose
        Long targetId = params.long('targetId')

        try {

            paymentService.cancelPending(
                currentUser,
                purpose,
                targetId
            )

            flash.message = 'تم إلغاء العملية قبل الدفع.'

        } catch (IllegalArgumentException | IllegalStateException e) {

            flash.message = e.message
        }

        if (purpose?.toUpperCase() == 'PURCHASE') {

            redirect controller: 'purchase',
                     action: 'index'

        } else {

            redirect controller: 'roomReservation',
                     action: 'index'
        }
    }

    private Map resolveTarget(
        User user,
        String purpose,
        Long targetId
    ) {

        String normalized = purpose?.toUpperCase()

        /*
         * ==========================
         * شراء كتاب
         * ==========================
         */
        if (normalized == 'PURCHASE') {

            Purchase purchase = purchaseService.get(targetId)

            if (
                !purchase ||
                purchase.user?.id != user?.id ||
                purchase.status != 'PENDING'
            ) {
                return null
            }

            return [
                amount: purchase.totalAmount,

                targetTitle: purchase.book?.title,

                targetDescription:
                    purchase.purchaseType == 'DIGITAL'
                        ? 'شراء النسخة الرقمية'
                        : 'شراء نسخة ورقية',

                targetIcon: 'bi-book'
            ]
        }

        /*
         * ==========================
         * حجز غرفة دراسة
         * ==========================
         */
        if (normalized == 'ROOM_RESERVATION') {

            RoomReservation reservation =
                roomReservationService.get(targetId)

            if (
                !reservation ||
                reservation.user?.id != user?.id ||
                reservation.status != 'PENDING'
            ) {
                return null
            }

            return [
                amount: reservation.totalPrice,

                targetTitle:
                    "غرفة ${reservation.studyRoom?.roomNumber}",

                targetDescription:
                    'حجز غرفة دراسة',

                targetIcon:
                    'bi-door-open'
            ]
        }

        return null
    }
}