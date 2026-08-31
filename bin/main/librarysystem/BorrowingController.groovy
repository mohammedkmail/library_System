package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class BorrowingController {

    SpringSecurityService springSecurityService
    BorrowingService borrowingService

    static allowedMethods = [
        borrow    : 'POST',
        returnBook: 'POST'
    ]

    def index() {

        borrowingService.updateOverdueBorrowings()

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        List<Borrowing> borrowingList

        List<User> userList = []
        List<BookCopy> availableCopyList = []

        if (admin) {

            borrowingList =
                Borrowing.list(
                    sort: 'borrowDate',
                    order: 'desc'
                )

            userList =
                User.list(
                    sort: 'username',
                    order: 'asc'
                ).findAll { User user ->

                    user.authorities
                        *.authority
                        .contains('ROLE_USER')
                }

            availableCopyList =
                BookCopy.findAllByStatus(
                    'AVAILABLE',
                    [
                        sort : 'copyCode',
                        order: 'asc'
                    ]
                )

        } else {

            borrowingList =
                Borrowing.findAllByUser(
                    currentUser,
                    [
                        sort : 'borrowDate',
                        order: 'desc'
                    ]
                )
        }

        respond borrowingList,
            model: [
                isAdmin          : admin,
                userList         : userList,
                availableCopyList: availableCopyList
            ]
    }

    def show(Long id) {

        borrowingService.updateOverdueBorrowings()

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

        respond borrowing,
            model: [
                isAdmin: isAdmin(currentUser)
            ]
    }

    @Secured(['ROLE_ADMIN'])
    def borrow(
        Long userId,
        Long bookCopyId
    ) {

        User borrower =
            User.get(userId)

        BookCopy bookCopy =
            BookCopy.get(bookCopyId)

        if (!borrower) {

            flash.message =
                'User not found.'

            redirect action: 'index'
            return
        }

        if (!bookCopy) {

            flash.message =
                'Book copy not found.'

            redirect action: 'index'
            return
        }

        try {

            Borrowing borrowing =
                borrowingService.borrowBook(
                    borrower,
                    bookCopy
                )

            flash.message =
                'Book borrowed successfully.'

            redirect action: 'show',
                     id: borrowing.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message =
                e.message

            redirect action: 'index'
        }
    }

    @Secured(['ROLE_ADMIN'])
    def returnBook(Long id) {

        try {

            Borrowing borrowing =
                borrowingService.returnBook(id)

            if (!borrowing) {
                notFound()
                return
            }

            flash.message =
                'Book returned successfully.'

            redirect action: 'show',
                     id: borrowing.id

        } catch (
            IllegalStateException e
        ) {

            flash.message =
                e.message

            redirect action: 'show',
                     id: id
        }
    }

    private boolean isAdmin(User user) {

        if (user == null) {
            return false
        }

        for (def role : user.authorities) {
            if (role.authority == 'ROLE_ADMIN') {
                return true
            }
        }

        return false
    }

    protected void notFound() {
        render status: 404
    }
}