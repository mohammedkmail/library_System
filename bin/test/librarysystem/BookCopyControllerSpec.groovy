package librarysystem

import grails.testing.gorm.DomainUnitTest
import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class BookCopyControllerSpec extends Specification
        implements ControllerUnitTest<BookCopyController>,
                   DomainUnitTest<BookCopy> {

    def setup() {

        mockDomain(Book)
        mockDomain(Borrowing)
        mockDomain(Reservation)
    }


    void "controller loads correctly"() {

        expect:

        controller != null
    }


    void "create returns a new book copy"() {

        when:

        controller.create()


        then:

        model.bookCopy != null
        model.bookCopy instanceof BookCopy
        model.bookList != null
    }


    void "show with missing id redirects to index"() {

        given:

        controller.bookCopyService =
            Mock(BookCopyService) {

                1 * get(null) >> null
            }


        when:

        controller.show(null)


        then:

        response.redirectedUrl ==
            '/bookCopy/index'

        flash.message ==
            'Book copy not found.'
    }


    void "edit with missing id redirects to index"() {

        given:

        controller.bookCopyService =
            Mock(BookCopyService) {

                1 * get(null) >> null
            }


        when:

        controller.edit(null)


        then:

        response.redirectedUrl ==
            '/bookCopy/index'

        flash.message ==
            'Book copy not found.'
    }


    void "delete with null id redirects to index"() {

        given:

        controller.bookCopyService =
            Mock(BookCopyService) {

                1 * get(null) >> null
            }


        when:

        request.method = 'DELETE'

        controller.delete(null)


        then:

        response.redirectedUrl ==
            '/bookCopy/index'

        flash.message ==
            'Book copy not found.'
    }
}
