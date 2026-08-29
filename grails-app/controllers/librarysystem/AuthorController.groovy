package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

class AuthorController {

    AuthorService authorService
    SpringSecurityService springSecurityService

    static allowedMethods = [
        save  : 'POST',
        update: 'PUT',
        delete: 'DELETE'
    ]

    @Secured(['permitAll'])
    def index(Integer max) {

        int pageSize =
            Math.min(max ?: 12, 100)

        int offset =
            params.int('offset') ?: 0

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        List<Author> authorList =
            Author.list(
                max: pageSize,
                offset: offset,
                sort: 'name',
                order: 'asc'
            )

        Long authorCount =
            Author.count()

        respond authorList,
            model: [
                authorCount: authorCount,
                isAdmin    : admin
            ]
    }

    @Secured(['permitAll'])
    def show(Long id) {

        Author author =
            authorService.get(id)

        if (!author) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        /*
         * Visitors should only browse active books.
         * Admin can still see inactive books attached
         * to the author for management purposes.
         */
        List<Book> bookList

        if (admin) {

            bookList =
                Book.findAllByAuthor(
                    author,
                    [
                        sort : 'title',
                        order: 'asc'
                    ]
                )

        } else {

            bookList =
                Book.findAllByAuthorAndActive(
                    author,
                    true,
                    [
                        sort : 'title',
                        order: 'asc'
                    ]
                )
        }

        respond author,
            model: [
                bookList: bookList,
                isAdmin : admin
            ]
    }

    @Secured(['ROLE_ADMIN'])
    def create() {

        respond new Author(params)
    }

    @Secured(['ROLE_ADMIN'])
    def save(Author author) {

        if (!author) {
            notFound()
            return
        }

        try {

            authorService.save(author)

        } catch (ValidationException e) {

            flash.message =
                'Author could not be created. Please fix the errors below.'

            respond author.errors,
                view: 'create'

            return
        }

        flash.message =
            'Author created successfully.'

        redirect action: 'show',
                 id: author.id
    }

    @Secured(['ROLE_ADMIN'])
    def edit(Long id) {

        Author author =
            authorService.get(id)

        if (!author) {
            notFound()
            return
        }

        respond author
    }

    @Secured(['ROLE_ADMIN'])
    def update(Author author) {

        if (!author) {
            notFound()
            return
        }

        try {

            authorService.save(author)

        } catch (ValidationException e) {

            flash.message =
                'Author could not be updated. Please fix the errors below.'

            respond author.errors,
                view: 'edit'

            return
        }

        flash.message =
            'Author updated successfully.'

        redirect action: 'show',
                 id: author.id
    }

    @Secured(['ROLE_ADMIN'])
    def delete(Long id) {

        if (!id) {
            notFound()
            return
        }

        Author author =
            authorService.get(id)

        if (!author) {
            notFound()
            return
        }

        Long bookCount =
            Book.countByAuthor(author)

        if (bookCount > 0) {

            flash.message =
                'This author cannot be deleted because books are associated with this author.'

            redirect action: 'show',
                     id: author.id

            return
        }

        authorService.delete(id)

        flash.message =
            'Author deleted successfully.'

        redirect action: 'index'
    }

    private boolean isAdmin(User user) {

    if (!user) {
        return false
    }

    return user.authorities?.any {
        it.authority == 'ROLE_ADMIN'
    } ?: false
    }

    protected void notFound() {

        flash.message =
            'Author not found.'

        redirect action: 'index'
    }
}