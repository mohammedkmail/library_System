package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class DigitalAccessService {

    MembershipService membershipService

    /** Retrieves a digital access record by ID. */
    DigitalAccess get(Serializable id) {
        DigitalAccess.get(id)
    }

    /** Returns a list of digital access records based on the provided options. */
    List<DigitalAccess> list(Map params = [:]) {
        DigitalAccess.list(params)
    }

    /** Returns the total number of digital access records. */
    Long count() {
        DigitalAccess.count()
    }

    /** Grants temporary digital rental access to a book. */
    DigitalAccess grantRentalAccess(
        User user,
        Book book,
        Integer rentalDays = 7
    ) {

        if (!user) {
            throw new IllegalArgumentException(
                'User is required.'
            )
        }

        if (!book) {
            throw new IllegalArgumentException(
                'Book is required.'
            )
        }

        if (!book.digitalAvailable) {
            throw new IllegalStateException(
                'Digital version is not available.'
            )
        }

        if (book.digitalRentalPrice == null) {
            throw new IllegalStateException(
                'Digital rental is not available for this book.'
            )
        }

        if (rentalDays == null || rentalDays < 1) {
            throw new IllegalArgumentException(
                'Rental period must be at least one day.'
            )
        }

        Date startDate = new Date()
        Date endDate = startDate + rentalDays

        DigitalAccess access = new DigitalAccess(
            user: user,
            book: book,
            accessType: 'RENTAL',
            startDate: startDate,
            endDate: endDate,
            status: 'ACTIVE'
        )

        access.save(
            flush: true,
            failOnError: true
        )

        access
    }

    /** Grants permanent digital access after purchasing a book. */
    DigitalAccess grantPurchaseAccess(
        User user,
        Book book
    ) {

        if (!user) {
            throw new IllegalArgumentException(
                'User is required.'
            )
        }

        if (!book) {
            throw new IllegalArgumentException(
                'Book is required.'
            )
        }

        if (!book.digitalAvailable) {
            throw new IllegalStateException(
                'Digital version is not available.'
            )
        }

        DigitalAccess existingPurchase =
            DigitalAccess.findByUserAndBookAndAccessType(
                user,
                book,
                'PURCHASE'
            )

        if (existingPurchase) {
            return existingPurchase
        }

        DigitalAccess access = new DigitalAccess(
            user: user,
            book: book,
            accessType: 'PURCHASE',
            startDate: new Date(),
            endDate: null,
            status: 'ACTIVE'
        )

        access.save(
            flush: true,
            failOnError: true
        )

        access
    }

    /** Checks whether a user currently has digital access to a book. */
    boolean canAccessBook(
        User user,
        Book book
    ) {

        if (!user || !book || !book.digitalAvailable) {
            return false
        }

        DigitalAccess purchase =
            DigitalAccess.findByUserAndBookAndAccessTypeAndStatus(
                user,
                book,
                'PURCHASE',
                'ACTIVE'
            )

        if (purchase) {
            return true
        }

        Date now = new Date()

        List<DigitalAccess> rentals =
            DigitalAccess.findAllByUserAndBookAndAccessTypeAndStatus(
                user,
                book,
                'RENTAL',
                'ACTIVE'
            )

        DigitalAccess activeRental = rentals.find {
            it.endDate && it.endDate >= now
        }

        if (activeRental) {
            return true
        }

        if (
            book.membershipIncluded &&
            membershipService.hasActiveMembership(user)
        ) {
            return true
        }

        return false
    }

    /** Marks expired digital rentals as expired. */
    void expireOldRentals() {

        Date now = new Date()

        List<DigitalAccess> expiredRentals =
            DigitalAccess.findAllByAccessTypeAndStatus(
                'RENTAL',
                'ACTIVE'
            ).findAll {
                it.endDate && it.endDate < now
            }

        expiredRentals.each { DigitalAccess access ->

            access.status = 'EXPIRED'

            access.save(
                flush: true,
                failOnError: true
            )
        }
    }
}