package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.testing.gorm.DomainUnitTest
import grails.testing.web.controllers.ControllerUnitTest
import grails.validation.ValidationException
import spock.lang.Specification

class AuthorControllerSpec extends Specification
        implements ControllerUnitTest<AuthorController>,
                   DomainUnitTest<Author> {

    def setup() {

        mockDomain(Book)

        controller.springSecurityService =
            Stub(SpringSecurityService) {
                getCurrentUser() >> null
            }
    }


    def populateValidParams(params) {

        assert params != null

        params.name =
            'Test Author'

        params.biography =
            'Test author biography'
    }


    void "Test the index action returns authors and count"() {

        given:

        new Author(
            name: 'George Orwell',
            biography: 'English novelist'
        ).save(flush: true)

        new Author(
            name: 'Agatha Christie',
            biography: 'Mystery writer'
        ).save(flush: true)


        when:

        controller.index(12)


        then:

        model.authorList != null

        model.authorList.size() == 2

        model.authorList*.name ==
            [
                'Agatha Christie',
                'George Orwell'
            ]

        model.authorCount == 2

        model.isAdmin == false
    }


    void "Test the create action returns a new author"() {

        when:

        controller.create()


        then:

        model.author != null

        model.author instanceof Author
    }


    void "Test the save action with a null instance redirects to index"() {

        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'POST'

        controller.save(null)


        then:

        response.redirectedUrl ==
            '/author/index'

        flash.message ==
            'Author not found.'
    }


    void "Test the save action correctly persists through service"() {

        given:

        AuthorService authorService =
            Mock(AuthorService)

        controller.authorService =
            authorService


        and:

        Author author =
            new Author(
                name: 'Test Author',
                biography: 'Biography'
            )

        author.id = 1L


        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'POST'

        controller.save(author)


        then:

        1 * authorService.save(author)


        and:

        response.redirectedUrl ==
            '/author/show/1'

        flash.message ==
            'Author created successfully.'
    }


    void "Test the save action handles validation failure"() {

        given:

        AuthorService authorService =
            Mock(AuthorService)

        controller.authorService =
            authorService


        and:

        Author author =
            new Author()


        and:

        authorService.save(author) >> {
            throw new ValidationException(
                'Invalid instance',
                author.errors
            )
        }


        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'POST'

        controller.save(author)


        then:

        view ==
            'create'

        flash.message ==
            'Author could not be created. Please fix the errors below.'
    }


    void "Test the show action with a null id redirects to index"() {

        given:

        controller.authorService =
            Mock(AuthorService) {

                1 * get(null) >> null
            }


        when:

        controller.show(null)


        then:

        response.redirectedUrl ==
            '/author/index'

        flash.message ==
            'Author not found.'
    }


    void "Test the show action returns an author"() {

        given:

        Author author =
            new Author(
                name: 'George Orwell',
                biography: 'English novelist'
            ).save(flush: true)


        and:

        controller.authorService =
            Mock(AuthorService) {

                1 * get(author.id) >> author
            }


        when:

        controller.show(author.id)


        then:

        model.author ==
            author

        model.bookList != null

        model.bookList.isEmpty()

        model.isAdmin == false
    }


    void "Test the edit action with a null id redirects to index"() {

        given:

        controller.authorService =
            Mock(AuthorService) {

                1 * get(null) >> null
            }


        when:

        controller.edit(null)


        then:

        response.redirectedUrl ==
            '/author/index'

        flash.message ==
            'Author not found.'
    }


    void "Test the edit action returns an author"() {

        given:

        Author author =
            new Author(
                name: 'Agatha Christie',
                biography: 'Mystery writer'
            ).save(flush: true)


        and:

        controller.authorService =
            Mock(AuthorService) {

                1 * get(author.id) >> author
            }


        when:

        controller.edit(author.id)


        then:

        model.author ==
            author
    }


    void "Test the update action with a null instance redirects to index"() {

        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'PUT'

        controller.update(null)


        then:

        response.redirectedUrl ==
            '/author/index'

        flash.message ==
            'Author not found.'
    }


    void "Test the update action correctly saves through service"() {

        given:

        AuthorService authorService =
            Mock(AuthorService)

        controller.authorService =
            authorService


        and:

        Author author =
            new Author(
                name: 'Updated Author',
                biography: 'Updated biography'
            )

        author.id = 1L


        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'PUT'

        controller.update(author)


        then:

        1 * authorService.save(author)


        and:

        response.redirectedUrl ==
            '/author/show/1'

        flash.message ==
            'Author updated successfully.'
    }


    void "Test the update action handles validation failure"() {

        given:

        AuthorService authorService =
            Mock(AuthorService)

        controller.authorService =
            authorService


        and:

        Author author =
            new Author()


        and:

        authorService.save(author) >> {
            throw new ValidationException(
                'Invalid instance',
                author.errors
            )
        }


        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'PUT'

        controller.update(author)


        then:

        view ==
            'edit'

        flash.message ==
            'Author could not be updated. Please fix the errors below.'
    }


    void "Test the delete action with a null id redirects to index"() {

        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'DELETE'

        controller.delete(null)


        then:

        response.redirectedUrl ==
            '/author/index'

        flash.message ==
            'Author not found.'
    }


    void "Test the delete action deletes author without books"() {

        given:

        Author author =
            new Author(
                name: 'Delete Author',
                biography: 'Temporary author'
            ).save(flush: true)


        and:

        AuthorService authorService =
            Mock(AuthorService)

        controller.authorService =
            authorService


        when:

        request.contentType =
            FORM_CONTENT_TYPE

        request.method =
            'DELETE'

        controller.delete(author.id)


        then:

        1 * authorService.get(author.id) >> author

        1 * authorService.delete(author.id)


        and:

        response.redirectedUrl ==
            '/author/index'

        flash.message ==
            'Author deleted successfully.'
    }
}
