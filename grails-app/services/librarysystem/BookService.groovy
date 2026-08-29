package librarysystem

import grails.gorm.transactions.Transactional
import grails.validation.ValidationException

@Transactional
class BookService {

    /** Retrieves a book by ID. */
    Book get(Serializable id) {
        Book.get(id)
    }

    /** Returns a list of books based on the provided options. */
    List<Book> list(Map args) {
        Book.list(args)
    }

    /** Returns the total number of books. */
    Long count() {
        Book.count()
    }

    /** Finds books with titles matching the provided value. */
    List<Book> findAllByTitleIlike(String title, Map args) {
        Book.findAllByTitleIlike(title, args)
    }

    /** Counts books with titles matching the provided value. */
    Long countByTitleIlike(String title) {
        Book.countByTitleIlike(title)
    }

    /** Saves or updates a book after validating business rules. */
    Book save(Book book) {

        validateBusinessRules(book)

        if (book.hasErrors()) {
            throw new ValidationException(
                "Book validation failed",
                book.errors
            )
        }

        book.save(flush: true, failOnError: true)

        book
    }

    /** Deletes a book by ID if it exists. */
    void delete(Serializable id) {

        Book book = Book.get(id)

        if (book) {
            book.delete(flush: true)
        }
    }

    /** Validates business rules related to digital book options. */
    private void validateBusinessRules(Book book) {

        if (!book.digitalAvailable) {

            if (book.digitalPurchasePrice != null) {
                book.errors.rejectValue(
                    'digitalPurchasePrice',
                    'book.digitalPurchasePrice.invalid',
                    'Digital purchase price requires a digital version.'
                )
            }

            if (book.digitalRentalPrice != null) {
                book.errors.rejectValue(
                    'digitalRentalPrice',
                    'book.digitalRentalPrice.invalid',
                    'Digital rental price requires a digital version.'
                )
            }

            if (book.membershipIncluded) {
                book.errors.rejectValue(
                    'membershipIncluded',
                    'book.membershipIncluded.invalid',
                    'Membership access requires a digital version.'
                )
            }

            if (book.digitalContent) {
                book.errors.rejectValue(
                    'digitalContent',
                    'book.digitalContent.invalid',
                    'Digital content requires a digital version.'
                )
            }
        }
    }
}