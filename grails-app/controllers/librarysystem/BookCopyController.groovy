package librarysystem

import grails.validation.ValidationException
import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN'])
class BookCopyController {

    BookCopyService bookCopyService

    static allowedMethods = [
        save  : "POST",
        update: "PUT",
        delete: "DELETE"
    ]

    def index(Integer max) {

        params.max = Math.min(max ?: 10, 100)

        respond bookCopyService.list(params),
            model: [
                bookCopyCount: bookCopyService.count()
            ]
    }

    def show(Long id) {

        BookCopy bookCopy =
            bookCopyService.get(id)

        if (!bookCopy) {
            notFound()
            return
        }

        respond bookCopy
    }

    def create() {

        respond new BookCopy(params),
            model: [
                bookList: Book.list(sort: 'title')
            ]
    }

    def save(BookCopy bookCopy) {

        if (bookCopy == null) {
            notFound()
            return
        }

        try {

            bookCopyService.save(bookCopy)

        } catch (ValidationException e) {

            flash.message =
                'Book copy could not be created. Please fix the errors below.'

            respond bookCopy.errors,
                view: 'create',
                model: [
                    bookList: Book.list(sort: 'title')
                ]

            return
        }

        flash.message =
            'Book copy created successfully.'

        redirect action: 'show',
                 id: bookCopy.id
    }

    def edit(Long id) {

        BookCopy bookCopy =
            bookCopyService.get(id)

        if (!bookCopy) {
            notFound()
            return
        }

        respond bookCopy,
            model: [
                bookList: Book.list(sort: 'title')
            ]
    }

    def update(BookCopy bookCopy) {

        if (bookCopy == null) {
            notFound()
            return
        }

        try {

            bookCopyService.save(bookCopy)

        } catch (ValidationException e) {

            flash.message =
                'Book copy could not be updated. Please fix the errors below.'

            respond bookCopy.errors,
                view: 'edit',
                model: [
                    bookList: Book.list(sort: 'title')
                ]

            return
        }

        flash.message =
            'Book copy updated successfully.'

        redirect action: 'show',
                 id: bookCopy.id
    }

    def delete(Long id) {

        if (id == null) {
            notFound()
            return
        }

        BookCopy bookCopy =
            bookCopyService.get(id)

        if (!bookCopy) {
            notFound()
            return
        }

        bookCopyService.delete(id)

        flash.message =
            'Book copy deleted successfully.'

        redirect action: 'index'
    }

    protected void notFound() {

        flash.message =
            'Book copy not found.'

        redirect action: 'index'
    }
}