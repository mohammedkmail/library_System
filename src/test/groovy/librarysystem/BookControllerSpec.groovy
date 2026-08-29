package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.testing.gorm.DomainUnitTest
import grails.testing.web.controllers.ControllerUnitTest
import spock.lang.Specification

class BookControllerSpec extends Specification
        implements ControllerUnitTest<BookController>,
                   DomainUnitTest<Book> {

    def setup() {

        mockDomain(Author)
        mockDomain(Category)
        mockDomain(BookCopy)
        mockDomain(Reservation)
        mockDomain(Purchase)
        mockDomain(DigitalAccess)
        mockDomain(Membership)

        controller.springSecurityService =
            Stub(SpringSecurityService) {
                getCurrentUser() >> null
            }
    }


    void "controller loads correctly"() {

        expect:

        controller != null
    }


    void "index returns an empty public catalog when there are no books"() {

        when:

        controller.index(12)


        then:

        model.bookCount == 0
        model.isAdmin == false
    }


    void "create returns a new book and selection lists"() {

        when:

        controller.create()


        then:

        model.book != null
        model.book instanceof Book
        model.authorList != null
        model.categoryList != null
    }


    void "cover returns 404 when book does not exist"() {

        given:

        controller.bookService =
            Mock(BookService) {
                1 * get(999L) >> null
            }


        when:

        controller.cover(999L)


        then:

        response.status == 404
    }
}
