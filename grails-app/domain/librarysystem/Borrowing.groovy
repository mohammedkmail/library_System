package librarysystem

class Borrowing {

    Date borrowDate = new Date()
    Date dueDate
    Date returnDate

    String status = 'ACTIVE'
    BigDecimal lateFee = 0.0

    User user
    BookCopy bookCopy

    static constraints = {
        borrowDate nullable: false
        dueDate nullable: false
        returnDate nullable: true

        status nullable: false, blank: false, inList: [
            'ACTIVE',
            'RETURNED',
            'OVERDUE'
        ]

        lateFee nullable: false, min: 0.0

        user nullable: false
        bookCopy nullable: false
    }
}