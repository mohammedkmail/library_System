package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class ReservationController {

    SpringSecurityService springSecurityService
    ReservationService reservationService
    BorrowingService borrowingService

    static allowedMethods = [
        reserve   : 'POST',
        cancel    : 'POST',
        assignCopy: 'POST',
        fulfill   : 'POST'
    ]

    def index() {

        reservationService.expireReadyReservations()

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        List<Reservation> reservationList

        if (admin) {

            reservationList =
                Reservation.list(
                    sort: 'reservationDate',
                    order: 'desc'
                )

        } else {

            reservationList =
                Reservation.findAllByUser(
                    currentUser,
                    [
                        sort : 'reservationDate',
                        order: 'desc'
                    ]
                )
        }

        respond reservationList,
            model: [
                isAdmin: admin
            ]
    }

    def show(Long id) {

        reservationService.expireReadyReservations()

        Reservation reservation =
            reservationService.get(id)

        if (!reservation) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        if (
            !admin &&
            reservation.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        List<BookCopy> availableCopyList = []

        if (
            admin &&
            reservation.status == 'WAITING'
        ) {

            availableCopyList =
                BookCopy.findAllByBookAndStatus(
                    reservation.book,
                    'AVAILABLE',
                    [
                        sort : 'copyCode',
                        order: 'asc'
                    ]
                )
        }

        respond reservation,
            model: [
                isAdmin          : admin,
                availableCopyList: availableCopyList
            ]
    }

    @Secured(['ROLE_USER'])
    def reserve(Long bookId) {

        User currentUser =
            springSecurityService.currentUser as User

        Book book =
            Book.get(bookId)

        if (!book) {

            flash.message =
                'Book not found.'

            redirect controller: 'book',
                     action: 'index'

            return
        }

        try {

            Reservation reservation =
                reservationService.createReservation(
                    currentUser,
                    book
                )

            flash.message =
                'Book reservation created successfully.'

            redirect action: 'show',
                     id: reservation.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message =
                e.message

            redirect controller: 'book',
                     action: 'show',
                     id: book.id
        }
    }

    def cancel(Long id) {

        Reservation reservation =
            reservationService.get(id)

        if (!reservation) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            reservation.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        try {

            reservationService.cancelReservation(id)

            flash.message =
                'Reservation cancelled successfully.'

            redirect action: 'index'

        } catch (
            IllegalStateException e
        ) {

            flash.message =
                e.message

            redirect action: 'show',
                     id: id
        }
    }

    @Secured(['ROLE_ADMIN'])
    def assignCopy(
        Long id,
        Long bookCopyId
    ) {

        try {

            Reservation reservation =
                reservationService
                    .assignCopyToReservation(
                        id,
                        bookCopyId
                    )

            flash.message =
                'Book copy prepared for pickup.'

            redirect action: 'show',
                     id: reservation.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message =
                e.message

            redirect action: 'show',
                     id: id
        }
    }

    @Secured(['ROLE_ADMIN'])
    def fulfill(Long id) {

        try {

            Borrowing borrowing =
                borrowingService
                    .borrowReservedBook(id)

            flash.message =
                'Book handed over and borrowing created successfully.'

            redirect controller: 'borrowing',
                     action: 'show',
                     id: borrowing.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message =
                e.message

            redirect action: 'show',
                     id: id
        }
    }

    private boolean isAdmin(User user) {

        user?.authorities
            *.authority
            .contains('ROLE_ADMIN')
    }

    protected void notFound() {
        render status: 404
    }
}