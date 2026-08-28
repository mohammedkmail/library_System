package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class DigitalAccessController {

    SpringSecurityService springSecurityService
    DigitalAccessService digitalAccessService
    MembershipService membershipService

    static allowedMethods = [
        rent: 'POST'
    ]

    def index() {

        digitalAccessService.expireOldRentals()

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        /*
         * ADMIN:
         * Show actual DigitalAccess records.
         */
        if (admin) {

            List<DigitalAccess> digitalAccessList =
                DigitalAccess.list(
                    sort: 'startDate',
                    order: 'desc'
                )

            respond digitalAccessList,
                model: [
                    isAdmin: true
                ]

            return
        }


        /*
         * USER DIGITAL LIBRARY
         *
         * A book can be accessible through:
         *
         * 1. PURCHASE
         * 2. RENTAL
         * 3. MEMBERSHIP
         *
         * We use a Map keyed by book id so the same
         * book never appears more than once.
         */

        Map<Long, Map> libraryItems = [:]


        /*
         * --------------------------------------------------
         * DIGITAL ACCESS RECORDS
         * --------------------------------------------------
         */

        List<DigitalAccess> userAccessList =
            DigitalAccess.findAllByUser(
                currentUser,
                [
                    sort : 'startDate',
                    order: 'desc'
                ]
            )


        userAccessList.each { DigitalAccess access ->

            if (!access.book) {
                return
            }


            if (
                access.accessType == 'PURCHASE' &&
                access.status == 'ACTIVE'
            ) {

                libraryItems[access.book.id] = [
                    book         : access.book,
                    source       : 'PURCHASE',
                    access       : access,
                    endDate      : null,
                    permanent    : true
                ]

                return
            }


            if (
                access.accessType == 'RENTAL' &&
                access.status == 'ACTIVE' &&
                (
                    access.endDate == null ||
                    access.endDate.after(new Date())
                )
            ) {

                /*
                 * Purchase always has priority over rental.
                 */
                if (!libraryItems.containsKey(access.book.id)) {

                    libraryItems[access.book.id] = [
                        book      : access.book,
                        source    : 'RENTAL',
                        access    : access,
                        endDate   : access.endDate,
                        permanent : false
                    ]
                }
            }
        }


        /*
         * --------------------------------------------------
         * COMPLETED DIGITAL PURCHASES
         *
         * This also covers old purchase data where a
         * DigitalAccess record might not have existed.
         * --------------------------------------------------
         */

        List<Purchase> digitalPurchases =
            Purchase.findAllByUserAndPurchaseTypeAndStatus(
                currentUser,
                'DIGITAL',
                'COMPLETED',
                [
                    sort : 'purchaseDate',
                    order: 'desc'
                ]
            )


        digitalPurchases.each { Purchase purchase ->

            if (!purchase.book) {
                return
            }

            libraryItems[purchase.book.id] = [
                book      : purchase.book,
                source    : 'PURCHASE',
                access    : libraryItems[purchase.book.id]?.access,
                endDate   : null,
                permanent : true
            ]
        }


        /*
         * --------------------------------------------------
         * MEMBERSHIP INCLUDED DIGITAL BOOKS
         * --------------------------------------------------
         */

        if (membershipService.hasActiveMembership(currentUser)) {

            List<Book> membershipBooks =
                Book.findAllByMembershipIncludedAndDigitalAvailableAndActive(
                    true,
                    true,
                    true,
                    [
                        sort : 'title',
                        order: 'asc'
                    ]
                )


            membershipBooks.each { Book book ->

                /*
                 * Do not replace PURCHASE or RENTAL.
                 */
                if (!libraryItems.containsKey(book.id)) {

                    libraryItems[book.id] = [
                        book      : book,
                        source    : 'MEMBERSHIP',
                        access    : null,
                        endDate   : null,
                        permanent : false
                    ]
                }
            }
        }


        List<Map> digitalLibraryItems =
            libraryItems
                .values()
                .toList()
                .sort { Map item ->
                    item.book?.title?.toLowerCase()
                }


        render view: 'index',
            model: [
                isAdmin            : false,
                digitalLibraryItems: digitalLibraryItems
            ]
    }


    def show(Long id) {

        digitalAccessService.expireOldRentals()

        DigitalAccess digitalAccess =
            DigitalAccess.get(id)

        if (!digitalAccess) {
            notFound()
            return
        }


        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)


        if (
            !admin &&
            digitalAccess.user?.id != currentUser?.id
        ) {

            render status: 403
            return
        }


        boolean canRead =
            !admin &&
            digitalAccessService.canAccessBook(
                currentUser,
                digitalAccess.book
            )


        respond digitalAccess,
            model: [
                isAdmin: admin,
                canRead: canRead
            ]
    }


    @Secured(['ROLE_USER'])
    def read(Long bookId) {

        digitalAccessService.expireOldRentals()

        User currentUser =
            springSecurityService.currentUser as User


        Book book =
            Book.get(bookId)


        if (!book) {
            notFound()
            return
        }


        boolean canRead =
            digitalAccessService.canAccessBook(
                currentUser,
                book
            )


        if (!canRead) {

            flash.message =
                'You do not currently have digital access to this book.'

            redirect controller: 'book',
                     action: 'show',
                     id: book.id

            return
        }


        render view: 'read',
            model: [
                book: book
            ]
    }


    @Secured(['ROLE_USER'])
    def rent(
        Long bookId,
        Integer rentalDays
    ) {

        User currentUser =
            springSecurityService.currentUser as User


        Book book =
            Book.get(bookId)


        if (!book) {
            notFound()
            return
        }


        try {

            DigitalAccess digitalAccess =
                digitalAccessService.grantRentalAccess(
                    currentUser,
                    book,
                    rentalDays ?: 1
                )


            flash.message =
                'Digital rental created successfully.'


            redirect action: 'show',
                     id: digitalAccess.id

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


    private boolean isAdmin(User user) {

        user?.authorities
            *.authority
            .contains('ROLE_ADMIN')
    }


    protected void notFound() {

        render status: 404
    }
}