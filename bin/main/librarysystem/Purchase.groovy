package librarysystem

class Purchase {

    String purchaseType
    Integer quantity = 1

    BigDecimal unitPrice
    BigDecimal totalAmount

    Date purchaseDate = new Date()
    String status = 'PENDING'

    User user
    Book book

    static constraints = {
        purchaseType nullable: false, blank: false, inList: [
            'PHYSICAL',
            'DIGITAL'
        ]

        quantity nullable: false, min: 1

        unitPrice nullable: false, min: 0.0
        totalAmount nullable: false, min: 0.0

        purchaseDate nullable: false

        status nullable: false, blank: false, inList: [
            'PENDING',
            'COMPLETED',
            'FAILED',
            'CANCELLED'
        ]

        user nullable: false
        book nullable: false
    }
}