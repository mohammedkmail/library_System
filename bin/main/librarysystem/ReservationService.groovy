package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class ReservationService {

    MembershipService membershipService

    /** Retrieves a reservation by ID. */
    Reservation get(Serializable id) {
        Reservation.get(id)
    }

    /** Returns a list of reservations based on the provided options. */
    List<Reservation> list(Map params = [:]) {
        Reservation.list(params)
    }

    /** Returns the total number of reservations. */
    Long count() {
        Reservation.count()
    }

    /** Creates a waiting reservation for a book. */
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

    /** Returns the next waiting reservation for a book. */
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

    /** Assigns an available book copy to the next waiting reservation. */
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

    /** Assigns a specific book copy to a waiting reservation. */
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

    /** Marks a ready reservation as fulfilled. */
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

    /** Cancels a reservation and releases its assigned copy. */
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

            assignCopy(
                book,
                releasedCopy
            )
        }

        reservation
    }

    /** Expires ready reservations whose pickup period has passed. */
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

                assignCopy(
                    book,
                    releasedCopy
                )
            }
        }
    }

    /** Returns the number of reservations currently waiting for a copy. */
    Long countWaitingReservations() {

        expireReadyReservations()

        Reservation.countByStatus(
            'WAITING'
        )
    }

    /** Prepares a reservation and marks its assigned copy as reserved. */
    private Reservation prepareReservation(
        Reservation reservation,
        BookCopy bookCopy
    ) {

        reservation.assignedCopy =
            bookCopy

        reservation.status =
            'READY'

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

    /** Validates that a book copy is available and belongs to the book. */
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