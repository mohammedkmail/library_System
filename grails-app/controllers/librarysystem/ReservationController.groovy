package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class ReservationController {

    SpringSecurityService springSecurityService
    ReservationService reservationService

    def index() {

        User currentUser =
            springSecurityService.currentUser as User

        List<Reservation> reservations

        if (isAdmin(currentUser)) {

            reservations = Reservation.list(
                sort: 'reservationDate',
                order: 'desc'
            )

        } else {

            reservations = Reservation.findAllByUser(
                currentUser,
                [
                    sort : 'reservationDate',
                    order: 'desc'
                ]
            )
        }

        respond reservations
    }

    def show(Long id) {

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

        respond reservation
    }

    def reserve(Long bookId) {

        User currentUser =
            springSecurityService.currentUser as User

        Book book = Book.get(bookId)

        if (!book) {
            flash.message = 'Book not found.'
            redirect controller: 'book', action: 'index'
            return
        }

        try {

            Reservation reservation =
                reservationService.createReservation(
                    currentUser,
                    book
                )

            flash.message =
                'Book reserved successfully.'

            redirect action: 'show',
                     id: reservation.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message = e.message

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

        } catch (IllegalStateException e) {

            flash.message = e.message

            redirect action: 'show',
                     id: id
        }
    }

    @Secured(['ROLE_ADMIN'])
    def fulfill(Long id) {

        try {

            Reservation reservation =
                reservationService.fulfillReservation(id)

            if (!reservation) {
                notFound()
                return
            }

            flash.message =
                'Reservation fulfilled successfully.'

            redirect action: 'show',
                     id: reservation.id

        } catch (IllegalStateException e) {

            flash.message = e.message

            redirect action: 'show',
                     id: id
        }
    }

    private boolean isAdmin(User user) {

        user.authorities*.authority
            .contains('ROLE_ADMIN')
    }

    protected void notFound() {
        render status: 404
    }
}