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

        if (!membershipService.hasActiveMembership(user)) {
            throw new IllegalStateException(
                'An active membership is required to reserve books.'
            )
        }

        Reservation existingReservation =
            Reservation.findByUserAndBookAndStatus(
                user,
                book,
                'WAITING'
            )

        if (existingReservation) {
            throw new IllegalStateException(
                'You already have an active reservation for this book.'
            )
        }

        Reservation reservation = new Reservation(
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

    Reservation getNextWaitingReservation(Book book) {

        Reservation.findByBookAndStatus(
            book,
            'WAITING',
            [sort: 'reservationDate', order: 'asc']
        )
    }

    Reservation assignCopy(
        Book book,
        BookCopy bookCopy
    ) {

        if (!book || !bookCopy) {
            throw new IllegalArgumentException(
                'Book and book copy are required.'
            )
        }

        Reservation reservation =
            getNextWaitingReservation(book)

        if (!reservation) {
            return null
        }

        reservation.assignedCopy = bookCopy
        reservation.status = 'READY'

        // User has 1 day to collect the reserved copy
        reservation.readyUntil = new Date() + 1

        reservation.save(
            flush: true,
            failOnError: true
        )

        bookCopy.status = 'RESERVED'

        bookCopy.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    Reservation fulfillReservation(Long id) {

        Reservation reservation = Reservation.get(id)

        if (!reservation) {
            return null
        }

        if (reservation.status != 'READY') {
            throw new IllegalStateException(
                'Reservation is not ready for pickup.'
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

        Reservation reservation = Reservation.get(id)

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

        reservation.status = 'CANCELLED'

        if (reservation.assignedCopy) {

            reservation.assignedCopy.status = 'AVAILABLE'

            reservation.assignedCopy.save(
                flush: true,
                failOnError: true
            )
        }

        reservation.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    void expireReadyReservations() {

        Date now = new Date()

        List<Reservation> expiredReservations =
            Reservation.findAllByStatus('READY')
                .findAll {
                    it.readyUntil && it.readyUntil < now
                }

        expiredReservations.each { Reservation reservation ->

            reservation.status = 'EXPIRED'

            if (reservation.assignedCopy) {

                BookCopy copy = reservation.assignedCopy

                reservation.assignedCopy = null

                copy.status = 'AVAILABLE'

                copy.save(
                    flush: true,
                    failOnError: true
                )
            }

            reservation.save(
                flush: true,
                failOnError: true
            )
        }
    }

    Long countWaitingReservations() {
        Reservation.countByStatus('WAITING')
    }
}