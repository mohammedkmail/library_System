package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class BorrowingController {

    SpringSecurityService springSecurityService
    BorrowingService borrowingService

    def index() {

        User currentUser =
            springSecurityService.currentUser as User

        List<Borrowing> borrowings

        if (isAdmin(currentUser)) {

            borrowings = Borrowing.list(
                sort: 'borrowDate',
                order: 'desc'
            )

        } else {

            borrowings = Borrowing.findAllByUser(
                currentUser,
                [
                    sort : 'borrowDate',
                    order: 'desc'
                ]
            )
        }

        respond borrowings
    }

    def show(Long id) {

        Borrowing borrowing =
            borrowingService.get(id)

        if (!borrowing) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            borrowing.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        respond borrowing
    }

    def borrow(Long bookCopyId) {

        User currentUser =
            springSecurityService.currentUser as User

        BookCopy bookCopy =
            BookCopy.get(bookCopyId)

        if (!bookCopy) {
            flash.message = 'Book copy not found.'
            redirect controller: 'book', action: 'index'
            return
        }

        try {

            Borrowing borrowing =
                borrowingService.borrowBook(
                    currentUser,
                    bookCopy
                )

            flash.message =
                'Book borrowed successfully.'

            redirect action: 'show', id: borrowing.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message = e.message

            redirect controller: 'book',
                     action: 'show',
                     id: bookCopy.book?.id
        }
    }

    def returnBook(Long id) {

        Borrowing borrowing =
            borrowingService.get(id)

        if (!borrowing) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            borrowing.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        try {

            borrowingService.returnBook(id)

            flash.message =
                'Book returned successfully.'

            redirect action: 'index'

        } catch (IllegalStateException e) {

            flash.message = e.message

            redirect action: 'show', id: id
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