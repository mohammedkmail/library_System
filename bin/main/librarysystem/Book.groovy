package librarysystem

class Book {

    String title
    String isbn
    String description
    Integer publishYear

    byte[] coverData
    String coverContentType

    Integer physicalSaleStock = 0
    BigDecimal physicalSalePrice

    Boolean digitalAvailable = false
    BigDecimal digitalPurchasePrice
    BigDecimal digitalRentalPrice
    Boolean membershipIncluded = false
    String digitalContent

    Boolean active = true

    Category category
    Author author

    Date dateCreated
    Date lastUpdated

    static hasMany = [
        copies         : BookCopy,
        reservations   : Reservation,
        purchases      : Purchase,
        digitalAccesses: DigitalAccess
    ]

    static constraints = {
        title nullable: false, blank: false
        isbn nullable: false, blank: false, unique: true
        description nullable: true, blank: true
        publishYear nullable: true, min: 0

        coverData nullable: true
        coverContentType nullable: true

        physicalSaleStock nullable: false, min: 0
        physicalSalePrice nullable: true, min: 0.0

        digitalAvailable nullable: false
        digitalPurchasePrice nullable: true, min: 0.0
        digitalRentalPrice nullable: true, min: 0.0
        membershipIncluded nullable: false
        digitalContent nullable: true

        active nullable: false

        category nullable: false
        author nullable: false
    }

    static mapping = {
        digitalContent type: 'text'
        coverData sqlType: 'LONGBLOB'
    }
}