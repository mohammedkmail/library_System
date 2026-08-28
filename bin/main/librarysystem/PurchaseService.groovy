package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class PurchaseService {

    DigitalAccessService digitalAccessService

    Purchase get(Serializable id) {
        Purchase.get(id)
    }

    List<Purchase> list(Map params = [:]) {
        Purchase.list(params)
    }

    Long count() {
        Purchase.count()
    }

    Purchase createPurchase(
        User user,
        Book book,
        String purchaseType,
        Integer quantity
    ) {

        if (!user) {
            throw new IllegalArgumentException(
                'User is required.'
            )
        }

        if (!book) {
            throw new IllegalArgumentException(
                'Book is required.'
            )
        }

        if (book.active != true) {
            throw new IllegalStateException(
                'This book is not currently available.'
            )
        }

        if (!(purchaseType in ['PHYSICAL', 'DIGITAL'])) {
            throw new IllegalArgumentException(
                'Invalid purchase type.'
            )
        }

        if (quantity == null || quantity < 1) {
            throw new IllegalArgumentException(
                'Quantity must be at least 1.'
            )
        }

        BigDecimal unitPrice

        if (purchaseType == 'PHYSICAL') {

            if (book.physicalSalePrice == null) {
                throw new IllegalStateException(
                    'Physical purchase is not available for this book.'
                )
            }

            Integer currentStock =
                book.physicalSaleStock ?: 0

            if (currentStock < quantity) {
                throw new IllegalStateException(
                    'Not enough physical copies in stock.'
                )
            }

            unitPrice =
                book.physicalSalePrice

        } else {

            if (!book.digitalAvailable) {
                throw new IllegalStateException(
                    'Digital version is not available.'
                )
            }

            if (book.digitalPurchasePrice == null) {
                throw new IllegalStateException(
                    'Digital purchase is not available for this book.'
                )
            }

            Purchase existingPurchase =
                Purchase.findByUserAndBookAndPurchaseTypeAndStatus(
                    user,
                    book,
                    'DIGITAL',
                    'COMPLETED'
                )

            DigitalAccess existingAccess =
                DigitalAccess.findByUserAndBookAndAccessTypeAndStatus(
                    user,
                    book,
                    'PURCHASE',
                    'ACTIVE'
                )

            if (existingPurchase || existingAccess) {
                throw new IllegalStateException(
                    'You already own the digital version of this book.'
                )
            }

            quantity = 1

            unitPrice =
                book.digitalPurchasePrice
        }

        BigDecimal totalAmount =
            unitPrice.multiply(
                BigDecimal.valueOf(quantity)
            )

        Purchase purchase =
            new Purchase(
                user: user,
                book: book,
                purchaseType: purchaseType,
                quantity: quantity,
                unitPrice: unitPrice,
                totalAmount: totalAmount,
                purchaseDate: new Date(),
                status: 'COMPLETED'
            )

        purchase.save(
            flush: true,
            failOnError: true
        )

        if (purchaseType == 'PHYSICAL') {

            book.physicalSaleStock =
                (book.physicalSaleStock ?: 0) -
                quantity

            book.save(
                flush: true,
                failOnError: true
            )

        } else {

            digitalAccessService
                .grantPurchaseAccess(
                    user,
                    book
                )
        }

        purchase
    }

    BigDecimal totalSales() {

        List<Purchase> purchases =
            Purchase.findAllByStatus(
                'COMPLETED'
            )

        purchases.sum {
            it.totalAmount ?: BigDecimal.ZERO
        } ?: BigDecimal.ZERO
    }

    Long countCompletedPurchases() {
        Purchase.countByStatus(
            'COMPLETED'
        )
    }
}