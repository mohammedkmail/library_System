package librarysystem

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class BookCopyServiceSpec extends Specification {

    BookCopyService bookCopyService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new BookCopy(...).save(flush: true, failOnError: true)
        //new BookCopy(...).save(flush: true, failOnError: true)
        //BookCopy bookCopy = new BookCopy(...).save(flush: true, failOnError: true)
        //new BookCopy(...).save(flush: true, failOnError: true)
        //new BookCopy(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //bookCopy.id
    }

    void "test get"() {
        setupData()

        expect:
        bookCopyService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<BookCopy> bookCopyList = bookCopyService.list(max: 2, offset: 2)

        then:
        bookCopyList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        bookCopyService.count() == 5
    }

    void "test delete"() {
        Long bookCopyId = setupData()

        expect:
        bookCopyService.count() == 5

        when:
        bookCopyService.delete(bookCopyId)
        sessionFactory.currentSession.flush()

        then:
        bookCopyService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        BookCopy bookCopy = new BookCopy()
        bookCopyService.save(bookCopy)

        then:
        bookCopy.id != null
    }
}
