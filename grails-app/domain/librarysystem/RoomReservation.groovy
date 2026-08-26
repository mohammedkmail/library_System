package librarysystem

class RoomReservation {

    Date startTime
    Date endTime
    BigDecimal totalPrice

    String status = 'PENDING'

    User user
    StudyRoom studyRoom

    static constraints = {
        startTime nullable: false
        endTime nullable: false
        totalPrice nullable: false, min: 0.0

        status nullable: false, blank: false, inList: [
            'PENDING',
            'CONFIRMED',
            'COMPLETED',
            'CANCELLED'
        ]

        user nullable: false
        studyRoom nullable: false
    }
}