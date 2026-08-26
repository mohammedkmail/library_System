package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class DigitalAccessController {

    SpringSecurityService springSecurityService
    DigitalAccessService digitalAccessService

    def index() {

        User currentUser =
            springSecurityService.currentUser as User

        List<DigitalAccess> digitalAccessList

        if (isAdmin(currentUser)) {

            digitalAccessList = DigitalAccess.list(
                sort: 'startDate',
                order: 'desc'
            )

        } else {

            digitalAccessList = DigitalAccess.findAllByUser(
                currentUser,
                [
                    sort : 'startDate',
                    order: 'desc'
                ]
            )
        }

        respond digitalAccessList
    }

    def show(Long id) {

        DigitalAccess digitalAccess =
            digitalAccessService.get(id)

        if (!digitalAccess) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            digitalAccess.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        respond digitalAccess
    }

    def rent(Long bookId) {

        User currentUser =
            springSecurityService.currentUser as User

        Book book = Book.get(bookId)

        if (!book) {
            flash.message = 'Book not found.'
            redirect controller: 'book', action: 'index'
            return
        }

        Integer rentalDays =
            params.int('rentalDays') ?: 7

        try {

            DigitalAccess access =
                digitalAccessService.grantRentalAccess(
                    currentUser,
                    book,
                    rentalDays
                )

            flash.message =
                'Digital book rented successfully.'

            redirect action: 'show',
                     id: access.id

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

    def read(Long bookId) {

        User currentUser =
            springSecurityService.currentUser as User

        Book book = Book.get(bookId)

        if (!book) {
            notFound()
            return
        }

        digitalAccessService.expireOldRentals()

        boolean allowed =
            digitalAccessService.canAccessBook(
                currentUser,
                book
            )

        if (!allowed) {
            flash.message =
                'You do not have access to this digital book.'

            redirect controller: 'book',
                     action: 'show',
                     id: book.id

            return
        }

        render view: 'read',
               model: [book: book]
    }

    private boolean isAdmin(User user) {

        user.authorities*.authority
            .contains('ROLE_ADMIN')
    }

    protected void notFound() {
        render status: 404
    }
}