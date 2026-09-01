package librarysystem

class Payment {

    String referenceCode
    String purpose
    Long targetId

    BigDecimal amount
    String currency = 'USD'

    String cardBrand = 'VISA'
    String cardLastFour
    String cardholderName

    String status = 'COMPLETED'
    Date paidAt
    Date dateCreated

    User user

    static constraints = {

        referenceCode nullable: false,
                      blank: false,
                      unique: true

        purpose nullable: false,
                blank: false,
                inList: [
                    'PURCHASE',
                    'ROOM_RESERVATION'
                ]

        targetId nullable: false,
                 min: 1L

        amount nullable: false,
               min: 0.0

        currency nullable: false,
                 blank: false,
                 inList: ['USD']

        cardBrand nullable: false,
                  blank: false,
                  inList: ['VISA']

        cardLastFour nullable: false,
                     blank: false,
                     matches: /\d{4}/

        cardholderName nullable: false,
                       blank: false,
                       maxSize: 100

        status nullable: false,
               blank: false,
               inList: [
                   'COMPLETED',
                   'FAILED',
                   'CANCELLED'
               ]

        paidAt nullable: true

        user nullable: false
    }
}