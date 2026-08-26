package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class PurchaseController {

    SpringSecurityService springSecurityService
    PurchaseService purchaseService

    def index() {

        User currentUser =
            springSecurityService.currentUser as User

        List<Purchase> purchases

        if (isAdmin(currentUser)) {

            purchases = Purchase.list(
                sort: 'purchaseDate',
                order: 'desc'
            )

        } else {

            purchases = Purchase.findAllByUser(
                currentUser,
                [
                    sort : 'purchaseDate',
                    order: 'desc'
                ]
            )
        }

        respond purchases
    }

    def show(Long id) {

        Purchase purchase =
            purchaseService.get(id)

        if (!purchase) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            purchase.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        respond purchase
    }

    def buy(Long bookId) {

        User currentUser =
            springSecurityService.currentUser as User

        Book book = Book.get(bookId)

        if (!book) {
            flash.message = 'Book not found.'
            redirect controller: 'book', action: 'index'
            return
        }

        String purchaseType =
            params.purchaseType?.toUpperCase()

        Integer quantity =
            params.int('quantity') ?: 1

        try {

            Purchase purchase =
                purchaseService.createPurchase(
                    currentUser,
                    book,
                    purchaseType,
                    quantity
                )

            flash.message =
                'Purchase completed successfully.'

            redirect action: 'show',
                     id: purchase.id

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

    private boolean isAdmin(User user) {

        user.authorities*.authority
            .contains('ROLE_ADMIN')
    }

    protected void notFound() {
        render status: 404
    }
}