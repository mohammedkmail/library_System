package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.validation.ValidationException
import org.springframework.web.multipart.MultipartFile

import static org.springframework.http.HttpStatus.*

class BookController {

    BookService bookService
    DigitalAccessService digitalAccessService
    SpringSecurityService springSecurityService

    static allowedMethods = [
        save  : "POST",
        update: "PUT",
        delete: "DELETE"
    ]


    def index(Integer max) {

        params.max = Math.min(max ?: 10, 100)
        params.offset = params.int('offset') ?: 0

        String search = params.search?.trim()

        List<Book> books
        Long total

        if (search) {

            books = bookService.findAllByTitleIlike(
                "%${search}%",
                [
                    max   : params.max,
                    offset: params.offset
                ]
            )

            total = bookService.countByTitleIlike(
                "%${search}%"
            )

        } else {

            books = bookService.list([
                max   : params.max,
                offset: params.offset
            ])

            total = bookService.count()
        }

        respond books, model: [
            bookCount: total,
            search   : search
        ]
    }


    def show(Long id) {

        Book book = bookService.get(id)

        if (!book) {
            notFound()
            return
        }

        List<BookCopy> availableCopies =
            BookCopy.findAllByBookAndStatus(
                book,
                'AVAILABLE',
                [
                    sort : 'id',
                    order: 'asc'
                ]
            )

        boolean canReadDigital = false

        User currentUser =
            springSecurityService.currentUser as User

        if (
            currentUser &&
            book.digitalAvailable
        ) {

            digitalAccessService.expireOldRentals()

            canReadDigital =
                digitalAccessService.canAccessBook(
                    currentUser,
                    book
                )
        }

        respond book, model: [
            availableCopies : availableCopies,
            canReadDigital  : canReadDigital
        ]
    }


    def create() {

        respond new Book(params), model: [
            authorList  : Author.list(sort: 'name'),
            categoryList: Category.list(sort: 'name')
        ]
    }


    def save(Book book) {

        if (book == null) {
            notFound()
            return
        }

        try {

            MultipartFile coverFile =
                request.getFile('coverFile')

            if (
                coverFile &&
                !coverFile.empty
            ) {

                book.coverData =
                    coverFile.bytes

                book.coverContentType =
                    coverFile.contentType
            }

            bookService.save(book)

        } catch (ValidationException e) {

            flash.message =
                'Book could not be created. Please fix the errors below.'

            respond book.errors,
                view: 'create',
                model: [
                    authorList:
                        Author.list(sort: 'name'),

                    categoryList:
                        Category.list(sort: 'name')
                ]

            return
        }

        request.withFormat {

            form multipartForm {

                flash.message = message(
                    code: 'default.created.message',
                    args: [
                        message(
                            code: 'book.label',
                            default: 'Book'
                        ),
                        book.id
                    ]
                )

                redirect book
            }

            '*' {
                respond book, [status: CREATED]
            }
        }
    }


    def edit(Long id) {

        Book book = bookService.get(id)

        if (!book) {
            notFound()
            return
        }

        respond book, model: [
            authorList  : Author.list(sort: 'name'),
            categoryList: Category.list(sort: 'name')
        ]
    }


    def update(Book book) {

        if (book == null) {
            notFound()
            return
        }

        try {

            MultipartFile coverFile =
                request.getFile('coverFile')

            if (
                coverFile &&
                !coverFile.empty
            ) {

                book.coverData =
                    coverFile.bytes

                book.coverContentType =
                    coverFile.contentType
            }

            bookService.save(book)

        } catch (ValidationException e) {

            flash.message =
                'Book could not be updated. Please fix the errors below.'

            respond book.errors,
                view: 'edit',
                model: [
                    authorList:
                        Author.list(sort: 'name'),

                    categoryList:
                        Category.list(sort: 'name')
                ]

            return
        }

        request.withFormat {

            form multipartForm {

                flash.message = message(
                    code: 'default.updated.message',
                    args: [
                        message(
                            code: 'book.label',
                            default: 'Book'
                        ),
                        book.id
                    ]
                )

                redirect book
            }

            '*' {
                respond book, [status: OK]
            }
        }
    }


    def delete(Long id) {

        if (id == null) {
            notFound()
            return
        }

        Book book =
            bookService.get(id)

        if (!book) {
            notFound()
            return
        }

        bookService.delete(id)

        request.withFormat {

            form multipartForm {

                flash.message = message(
                    code: 'default.deleted.message',
                    args: [
                        message(
                            code: 'book.label',
                            default: 'Book'
                        ),
                        id
                    ]
                )

                redirect(
                    action: "index",
                    method: "GET"
                )
            }

            '*' {
                render status: NO_CONTENT
            }
        }
    }


    def cover(Long id) {

        Book book =
            bookService.get(id)

        if (
            !book ||
            !book.coverData
        ) {

            render status: 404
            return
        }

        response.contentType =
            book.coverContentType ?: 'image/jpeg'

        response.contentLength =
            book.coverData.length

        response.outputStream.write(
            book.coverData
        )

        response.outputStream.flush()
    }


    protected void notFound() {

        request.withFormat {

            form multipartForm {

                flash.message = message(
                    code: 'default.not.found.message',
                    args: [
                        message(
                            code: 'book.label',
                            default: 'Book'
                        ),
                        params.id
                    ]
                )

                redirect(
                    action: "index",
                    method: "GET"
                )
            }

            '*' {
                render status: NOT_FOUND
            }
        }
    }
}