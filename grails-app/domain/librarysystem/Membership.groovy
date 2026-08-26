package librarysystem

class Membership {

    Date startDate
    Date endDate
    String status = 'ACTIVE'
    BigDecimal price

    User user

    static constraints = {
        startDate nullable: false
        endDate nullable: false

        status nullable: false, blank: false, inList: [
            'ACTIVE',
            'EXPIRED',
            'CANCELLED'
        ]

        price nullable: false, min: 0.0
        user nullable: false
    }
}