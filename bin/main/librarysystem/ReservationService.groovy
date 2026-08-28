package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class ReservationService {

    MembershipService membershipService

    Reservation get(Serializable id) {
        Reservation.get(id)
    }

    List<Reservation> list(Map params = [:]) {
        Reservation.list(params)
    }

    Long count() {
        Reservation.count()
    }

    Reservation createReservation(
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

        if (!book.active) {
            throw new IllegalStateException(
                'This book is not currently available.'
            )
        }

        if (!membershipService
            .hasActiveMembership(user)) {

            throw new IllegalStateException(
                'An active membership is required to reserve books.'
            )
        }

        Reservation existingReservation =
            Reservation
                .findByUserAndBookAndStatusInList(
                    user,
                    book,
                    ['WAITING', 'READY']
                )

        if (existingReservation) {
            throw new IllegalStateException(
                'You already have an active reservation for this book.'
            )
        }

        Reservation reservation =
            new Reservation(
                user: user,
                book: book,
                reservationDate: new Date(),
                status: 'WAITING',
                readyUntil: null,
                assignedCopy: null
            )

        reservation.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    Reservation getNextWaitingReservation(
        Book book
    ) {

        Reservation.findByBookAndStatus(
            book,
            'WAITING',
            [
                sort : 'reservationDate',
                order: 'asc'
            ]
        )
    }

    /*
     * Used automatically when a physical copy
     * becomes available, for example after return.
     */
    Reservation assignCopy(
        Book book,
        BookCopy bookCopy
    ) {

        validateAvailableCopy(
            book,
            bookCopy
        )

        Reservation reservation =
            getNextWaitingReservation(book)

        if (!reservation) {
            return null
        }

        prepareReservation(
            reservation,
            bookCopy
        )
    }

    /*
     * Used by the admin when preparing
     * a specific waiting reservation.
     */
    Reservation assignCopyToReservation(
        Long reservationId,
        Long bookCopyId
    ) {

        Reservation reservation =
            Reservation.get(reservationId)

        if (!reservation) {
            throw new IllegalArgumentException(
                'Reservation not found.'
            )
        }

        if (reservation.status != 'WAITING') {
            throw new IllegalStateException(
                'Only waiting reservations can be prepared.'
            )
        }

        BookCopy bookCopy =
            BookCopy.get(bookCopyId)

        if (!bookCopy) {
            throw new IllegalArgumentException(
                'Book copy not found.'
            )
        }

        validateAvailableCopy(
            reservation.book,
            bookCopy
        )

        prepareReservation(
            reservation,
            bookCopy
        )
    }

    /*
     * This method only closes the reservation.
     * BorrowingService creates the actual borrowing first.
     */
    Reservation fulfillReservation(Long id) {

        Reservation reservation =
            Reservation.get(id)

        if (!reservation) {
            return null
        }

        if (reservation.status != 'READY') {
            throw new IllegalStateException(
                'Reservation is not ready for pickup.'
            )
        }

        if (!reservation.assignedCopy) {
            throw new IllegalStateException(
                'Reservation has no assigned copy.'
            )
        }

        reservation.status = 'FULFILLED'

        reservation.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    Reservation cancelReservation(Long id) {

        Reservation reservation =
            Reservation.get(id)

        if (!reservation) {
            return null
        }

        if (reservation.status in [
            'FULFILLED',
            'EXPIRED',
            'CANCELLED'
        ]) {
            throw new IllegalStateException(
                'Reservation cannot be cancelled.'
            )
        }

        BookCopy releasedCopy =
            reservation.assignedCopy

        Book book =
            reservation.book

        reservation.status = 'CANCELLED'

        reservation.save(
            flush: true,
            failOnError: true
        )

        if (releasedCopy) {

            releasedCopy.status =
                'AVAILABLE'

            releasedCopy.save(
                flush: true,
                failOnError: true
            )

            /*
             * Give the copy to the next
             * person waiting for the same book.
             */
            assignCopy(
                book,
                releasedCopy
            )
        }

        reservation
    }

    void expireReadyReservations() {

        Date now = new Date()

        List<Reservation> expiredReservations =
            Reservation
                .findAllByStatusAndReadyUntilLessThan(
                    'READY',
                    now
                )

        expiredReservations.each {
            Reservation reservation ->

            BookCopy releasedCopy =
                reservation.assignedCopy

            Book book =
                reservation.book

            reservation.status =
                'EXPIRED'

            reservation.save(
                flush: true,
                failOnError: true
            )

            if (releasedCopy) {

                releasedCopy.status =
                    'AVAILABLE'

                releasedCopy.save(
                    flush: true,
                    failOnError: true
                )

                /*
                 * Pass the released copy
                 * to the next waiting user.
                 */
                assignCopy(
                    book,
                    releasedCopy
                )
            }
        }
    }

    Long countWaitingReservations() {

        expireReadyReservations()

        Reservation.countByStatus(
            'WAITING'
        )
    }

    private Reservation prepareReservation(
        Reservation reservation,
        BookCopy bookCopy
    ) {

        reservation.assignedCopy =
            bookCopy

        reservation.status =
            'READY'

        /*
         * User has one day to collect it.
         */
        reservation.readyUntil =
            new Date() + 1

        reservation.save(
            flush: true,
            failOnError: true
        )

        bookCopy.status =
            'RESERVED'

        bookCopy.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    private void validateAvailableCopy(
        Book book,
        BookCopy bookCopy
    ) {

        if (!book || !bookCopy) {
            throw new IllegalArgumentException(
                'Book and book copy are required.'
            )
        }

        if (bookCopy.book?.id != book.id) {
            throw new IllegalArgumentException(
                'The selected copy does not belong to this book.'
            )
        }

        if (bookCopy.status != 'AVAILABLE') {
            throw new IllegalStateException(
                'The selected book copy is not available.'
            )
        }
    }
}