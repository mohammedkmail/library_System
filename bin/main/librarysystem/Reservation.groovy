package librarysystem

class Reservation {

    Date reservationDate = new Date()
    String status = 'WAITING'
    Date readyUntil

    User user
    Book book
    BookCopy assignedCopy

    static constraints = {
        reservationDate nullable: false

        status nullable: false, blank: false, inList: [
            'WAITING',
            'READY',
            'FULFILLED',
            'EXPIRED',
            'CANCELLED'
        ]

        readyUntil nullable: true

        user nullable: false
        book nullable: false
        assignedCopy nullable: true
    }
}