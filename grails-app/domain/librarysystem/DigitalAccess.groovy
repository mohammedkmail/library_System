package librarysystem

class DigitalAccess {

    String accessType
    Date startDate = new Date()
    Date endDate
    String status = 'ACTIVE'

    User user
    Book book

    static constraints = {
        accessType nullable: false, blank: false, inList: [
            'RENTAL',
            'PURCHASE'
        ]

        startDate nullable: false
        endDate nullable: true

        status nullable: false, blank: false, inList: [
            'ACTIVE',
            'EXPIRED',
            'REVOKED'
        ]

        user nullable: false
        book nullable: false
    }
}