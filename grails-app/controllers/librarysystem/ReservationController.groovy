package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class ReservationController {

    SpringSecurityService springSecurityService
    ReservationService reservationService
    BorrowingService borrowingService
    PaymentService paymentService

    static allowedMethods = [reserve: 'POST', cancel: 'POST', assignCopy: 'POST', checkout: 'POST',
                             handover: 'POST', outForDelivery: 'POST']

    def index() {
        reservationService.expireReadyReservations()
        User currentUser = springSecurityService.currentUser as User
        boolean admin = isAdmin(currentUser)
        List<Reservation> list = admin ? Reservation.list(sort: 'reservationDate', order: 'desc') :
            Reservation.findAllByUser(currentUser, [sort: 'reservationDate', order: 'desc'])
        respond list, model: [isAdmin: admin]
    }

    def show(Long id) {
        reservationService.expireReadyReservations()
        Reservation reservation = reservationService.get(id)
        if (!reservation) { notFound(); return }
        User currentUser = springSecurityService.currentUser as User
        boolean admin = isAdmin(currentUser)
        if (!admin && reservation.user?.id != currentUser.id) { render status: 403; return }
        List<BookCopy> available = admin && reservation.status == 'WAITING' ?
            BookCopy.findAllByBookAndStatus(reservation.book, 'AVAILABLE', [sort: 'copyCode', order: 'asc']) : []
        Payment payment = Payment.findByPurposeAndTargetIdAndStatus('BOOK_RESERVATION', reservation.id, 'COMPLETED')
        respond reservation, model: [isAdmin: admin, availableCopyList: available, payment: payment]
    }

    @Secured(['ROLE_USER'])
    def reserve(Long bookId) {
        User user = springSecurityService.currentUser as User
        Book book = Book.get(bookId)
        if (!book) { flash.message = 'الكتاب غير موجود.'; redirect controller: 'book', action: 'index'; return }
        try {
            Reservation reservation = reservationService.createReservation(user, book)
            flash.message = reservation.status == 'READY' ?
                'تم حفظ نسخة لك مباشرة. أكمل الدفع لتثبيت الاستعارة.' :
                'أضيف طلبك إلى قائمة الانتظار. عند توفر نسخة ستظهر لك إمكانية الدفع والتأكيد.'
            redirect action: 'show', id: reservation.id
        } catch (Exception e) {
            flash.message = e.message
            redirect controller: 'book', action: 'show', id: book.id
        }
    }

    @Secured(['ROLE_USER'])
    def checkout(Long id) {
        Reservation reservation = reservationService.get(id)
        User user = springSecurityService.currentUser as User
        if (!reservation || reservation.user?.id != user.id) { render status: 403; return }
        try {
            reservationService.updateFulfillmentPreference(id, params.fulfillmentMethod, params.deliveryAddress)
            redirect controller: 'payment', action: 'checkout', params: [purpose: 'BOOK_RESERVATION', targetId: id]
        } catch (Exception e) {
            flash.message = e.message
            redirect action: 'show', id: id
        }
    }

    def cancel(Long id) {
        Reservation reservation = reservationService.get(id)
        if (!reservation) { notFound(); return }
        User currentUser = springSecurityService.currentUser as User
        boolean admin = isAdmin(currentUser)
        if (!admin && reservation.user?.id != currentUser.id) { render status: 403; return }
        try {
            reservationService.cancelReservation(id, admin)
            flash.message = 'تم إلغاء حجز الكتاب.'
            redirect action: 'index'
        } catch (Exception e) {
            flash.message = e.message
            redirect action: 'show', id: id
        }
    }

    @Secured(['ROLE_ADMIN'])
    def assignCopy(Long id, Long bookCopyId) {
        try {
            Reservation reservation = reservationService.assignCopyToReservation(id, bookCopyId)
            flash.message = 'تم تخصيص النسخة. الحجز الآن جاهز للدفع والاستلام.'
            redirect action: 'show', id: reservation.id
        } catch (Exception e) {
            flash.message = e.message
            redirect action: 'show', id: id
        }
    }

    @Secured(['ROLE_ADMIN'])
    def outForDelivery(Long id) {
        try {
            reservationService.markOutForDelivery(id)
            flash.message = 'تم تحديث الطلب إلى: خرج للتوصيل.'
        } catch (Exception e) { flash.message = e.message }
        redirect action: 'show', id: id
    }

    @Secured(['ROLE_ADMIN'])
    def handover(Long id) {
        try {
            Map result
            Reservation reservation = reservationService.get(id)
            if (reservation?.status == 'PAID') {
                result = [borrowing: borrowingService.borrowPaidReservation(id)]
            } else {
                result = paymentService.recordCounterReservationHandover(id, params.paymentMethod ?: 'CASH', params.notes)
            }
            flash.message = 'تم تسليم الكتاب وبدأت مدة الاستعارة.'
            redirect controller: 'borrowing', action: 'show', id: result.borrowing.id
        } catch (Exception e) {
            flash.message = e.message
            redirect action: 'show', id: id
        }
    }

    private boolean isAdmin(User user) { user?.authorities*.authority?.contains('ROLE_ADMIN') }
    protected void notFound() { render status: 404 }
}
