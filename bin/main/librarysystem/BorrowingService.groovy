package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class BorrowingService {

    MembershipService membershipService
    ReservationService reservationService

    /** Retrieves a borrowing by ID. */
    Borrowing get(Serializable id) {
        Borrowing.get(id)
    }

    /** Returns a list of borrowings based on the provided options. */
    List<Borrowing> list(Map params = [:]) {
        Borrowing.list(params)
    }

    /** Returns the total number of borrowings. */
    Long count() {
        Borrowing.count()
    }

    /** Creates a manual borrowing for an available book copy. */
    Borrowing borrowBook(
        User user,
        BookCopy bookCopy
    ) {

        validateBorrower(user)

        if (!bookCopy) {
            throw new IllegalArgumentException(
                'Book copy is required.'
            )
        }

        if (bookCopy.status != 'AVAILABLE') {
            throw new IllegalStateException(
                'This book copy is not available.'
            )
        }

        ensureCopyIsNotBorrowed(bookCopy)

        createBorrowing(user, bookCopy)
    }

    /** Creates a borrowing from a reservation that is ready for pickup. */
    Borrowing borrowReservedBook(Long reservationId) {

        reservationService.expireReadyReservations()

        Reservation reservation =
            reservationService.get(reservationId)

        if (!reservation) {
            throw new IllegalArgumentException(
                'Reservation not found.'
            )
        }

        if (reservation.status != 'READY') {
            throw new IllegalStateException(
                'Reservation is not ready for pickup.'
            )
        }

        if (!reservation.assignedCopy) {
            throw new IllegalStateException(
                'No physical copy is assigned to this reservation.'
            )
        }

        User user = reservation.user
        BookCopy bookCopy = reservation.assignedCopy

        validateBorrower(user)

        if (bookCopy.status != 'RESERVED') {
            throw new IllegalStateException(
                'The assigned copy is not reserved.'
            )
        }

        if (bookCopy.book?.id != reservation.book?.id) {
            throw new IllegalStateException(
                'The assigned copy does not belong to the reserved book.'
            )
        }

        ensureCopyIsNotBorrowed(bookCopy)

        Borrowing borrowing =
            createBorrowingRecord(user, bookCopy)

        bookCopy.status = 'BORROWED'

        bookCopy.save(
            flush: true,
            failOnError: true
        )

        reservationService.fulfillReservation(
            reservation.id
        )

        borrowing
    }

    /** Returns a borrowed book and calculates any applicable late fee. */
    Borrowing returnBook(Long id) {

        Borrowing borrowing = Borrowing.get(id)

        if (!borrowing) {
            return null
        }

        if (!(borrowing.status in [
            'ACTIVE',
            'OVERDUE'
        ])) {
            throw new IllegalStateException(
                'This borrowing has already been closed.'
            )
        }

        Date returnDate = new Date()

        borrowing.returnDate = returnDate
        borrowing.status = 'RETURNED'

        if (returnDate > borrowing.dueDate) {

            long milliseconds =
                returnDate.time -
                borrowing.dueDate.time

            long lateDays =
                Math.ceil(
                    milliseconds /
                    (1000.0 * 60 * 60 * 24)
                ) as long

            borrowing.lateFee =
                BigDecimal.valueOf(lateDays)

        } else {

            borrowing.lateFee =
                BigDecimal.ZERO
        }

        borrowing.save(
            flush: true,
            failOnError: true
        )

        BookCopy returnedCopy =
            borrowing.bookCopy

        if (returnedCopy) {

            Book book = returnedCopy.book

            returnedCopy.status = 'AVAILABLE'

            returnedCopy.save(
                flush: true,
                failOnError: true
            )

            if (book) {
                reservationService.assignCopy(
                    book,
                    returnedCopy
                )
            }
        }

        borrowing
    }

    /** Marks active borrowings as overdue when their due date has passed. */
    void updateOverdueBorrowings() {

        Date now = new Date()

        List<Borrowing> overdueBorrowings =
            Borrowing.findAllByStatusAndDueDateLessThan(
                'ACTIVE',
                now
            )

        overdueBorrowings.each {
            Borrowing borrowing ->

            borrowing.status = 'OVERDUE'

            borrowing.save(
                flush: true,
                failOnError: true
            )
        }
    }

    /** Returns the number of active borrowings. */
    Long countActiveBorrowings() {

        updateOverdueBorrowings()

        Borrowing.countByStatus('ACTIVE')
    }

    /** Returns the number of overdue borrowings. */
    Long countOverdueBorrowings() {

        updateOverdueBorrowings()

        Borrowing.countByStatus('OVERDUE')
    }

    /** Creates a borrowing and marks the book copy as borrowed. */
    private Borrowing createBorrowing(
        User user,
        BookCopy bookCopy
    ) {

        Borrowing borrowing =
            createBorrowingRecord(
                user,
                bookCopy
            )

        bookCopy.status = 'BORROWED'

        bookCopy.save(
            flush: true,
            failOnError: true
        )

        borrowing
    }

    /** Creates and saves the borrowing record with a fourteen-day due date. */
    private Borrowing createBorrowingRecord(
        User user,
        BookCopy bookCopy
    ) {

        Date borrowDate = new Date()

        Calendar dueCalendar =
            Calendar.getInstance()

        dueCalendar.time =
            borrowDate

        dueCalendar.add(
            Calendar.DAY_OF_MONTH,
            14
        )

        Date dueDate =
            dueCalendar.time

        Borrowing borrowing =
            new Borrowing(
                user: user,
                bookCopy: bookCopy,
                borrowDate: borrowDate,
                dueDate: dueDate,
                status: 'ACTIVE',
                lateFee: BigDecimal.ZERO
            )

        borrowing.save(
            flush: true,
            failOnError: true
        )

        borrowing
    }

    /** Validates that the user is allowed to borrow books. */
    private void validateBorrower(
        User user
    ) {

        if (!user) {
            throw new IllegalArgumentException(
                'User is required.'
            )
        }

        if (!membershipService
            .hasActiveMembership(user)) {

            throw new IllegalStateException(
                'An active membership is required to borrow books.'
            )
        }
    }

    /** Ensures that the book copy does not already have an open borrowing. */
    private void ensureCopyIsNotBorrowed(
        BookCopy bookCopy
    ) {

        Borrowing openBorrowing =
            Borrowing.findByBookCopyAndStatusInList(
                bookCopy,
                ['ACTIVE', 'OVERDUE']
            )

        if (openBorrowing) {
            throw new IllegalStateException(
                'This book copy is already borrowed.'
            )
        }
    }
}