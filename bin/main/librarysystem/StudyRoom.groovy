package librarysystem

class StudyRoom {

    String roomNumber
    Integer capacity
    BigDecimal pricePerHour
    Boolean active = true

    static hasMany = [
        reservations: RoomReservation
    ]

    static constraints = {
        roomNumber nullable: false, blank: false, unique: true
        capacity nullable: false, min: 1
        pricePerHour nullable: false, min: 0.0
        active nullable: false
    }
}