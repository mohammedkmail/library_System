package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class BorrowingService {

    MembershipService membershipService
    ReservationService reservationService

    Borrowing get(Serializable id) {
        Borrowing.get(id)
    }

    List<Borrowing> list(Map params = [:]) {
        Borrowing.list(params)
    }

    Long count() {
        Borrowing.count()
    }

    Borrowing borrowBook(User user, BookCopy bookCopy) {

        if (!user) {
            throw new IllegalArgumentException(
                'User is required.'
            )
        }

        if (!bookCopy) {
            throw new IllegalArgumentException(
                'Book copy is required.'
            )
        }

        // User must have an active membership
        if (!membershipService.hasActiveMembership(user)) {
            throw new IllegalStateException(
                'An active membership is required to borrow books.'
            )
        }

        // The physical copy must be available
        if (bookCopy.status != 'AVAILABLE') {
            throw new IllegalStateException(
                'This book copy is not available.'
            )
        }

        // Extra protection against borrowing the same copy twice
        Borrowing activeBorrowing =
            Borrowing.findByBookCopyAndStatus(
                bookCopy,
                'ACTIVE'
            )

        if (activeBorrowing) {
            throw new IllegalStateException(
                'This book copy is already borrowed.'
            )
        }

        Date borrowDate = new Date()

        // Standard borrowing period: 14 days
        Date dueDate = borrowDate + 14

        Borrowing borrowing = new Borrowing(
            user: user,
            bookCopy: bookCopy,
            borrowDate: borrowDate,
            dueDate: dueDate,
            status: 'ACTIVE',
            lateFee: 0.0
        )

        borrowing.save(
            flush: true,
            failOnError: true
        )

        // Mark the physical copy as borrowed
        bookCopy.status = 'BORROWED'

        bookCopy.save(
            flush: true,
            failOnError: true
        )

        borrowing
    }

    Borrowing returnBook(Long id) {

        Borrowing borrowing = Borrowing.get(id)

        if (!borrowing) {
            return null
        }

        if (borrowing.status == 'RETURNED') {
            throw new IllegalStateException(
                'This book has already been returned.'
            )
        }

        Date returnDate = new Date()

        borrowing.returnDate = returnDate
        borrowing.status = 'RETURNED'

        // Late fee = 1.00 for every late day
        if (returnDate > borrowing.dueDate) {

            long milliseconds =
                returnDate.time - borrowing.dueDate.time

            long lateDays =
                Math.ceil(
                    milliseconds /
                    (1000.0 * 60 * 60 * 24)
                ) as long

            borrowing.lateFee =
                new BigDecimal(lateDays)

        } else {

            borrowing.lateFee = 0.0
        }

        borrowing.save(
            flush: true,
            failOnError: true
        )

        BookCopy returnedCopy = borrowing.bookCopy

        if (returnedCopy?.book) {

            // Give the returned copy to the first waiting reservation
            Reservation reservation =
                reservationService.assignCopy(
                    returnedCopy.book,
                    returnedCopy
                )

            if (!reservation) {

                // Nobody is waiting for this book
                returnedCopy.status = 'AVAILABLE'

                returnedCopy.save(
                    flush: true,
                    failOnError: true
                )
            }
        }

        borrowing
    }

    Long countActiveBorrowings() {
        Borrowing.countByStatus('ACTIVE')
    }

    Long countOverdueBorrowings() {
        Borrowing.countByStatus('OVERDUE')
    }
}