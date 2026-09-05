package librarysystem

import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import grails.rest.RestfulController
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class BookRestController extends RestfulController<Book> {

    static responseFormats = ['json']

    BookService bookService
    SpringSecurityService springSecurityService

    BookRestController() {
        super(Book)
    }

    /*
     * GET /api/books
     *
     * Supports:
     * ?search=java
     * ?max=10
     * ?offset=0
     */
    @Override
    def index() {

        params.max = Math.min(
            params.int('max') ?: 10,
            100
        )

        params.offset =
            params.int('offset') ?: 0

        String search =
            params.search?.trim()

        User currentUser = springSecurityService.currentUser as User
        boolean admin = isAdmin(currentUser)

        List<Book> books
        Long total

        if (search) {
            if (admin) {
                books = bookService.findAllByTitleIlike(
                    "%${search}%",
                    [max: params.max, offset: params.offset]
                )
                total = bookService.countByTitleIlike("%${search}%")
            } else {
                books = Book.findAllByActiveAndTitleIlike(
                    true,
                    "%${search}%",
                    [max: params.max, offset: params.offset]
                )
                total = Book.countByActiveAndTitleIlike(true, "%${search}%")
            }
        } else if (admin) {
            books = bookService.list([max: params.max, offset: params.offset])
            total = bookService.count()
        } else {
            books = Book.findAllByActive(
                true,
                [max: params.max, offset: params.offset, sort: 'title', order: 'asc']
            )
            total = Book.countByActive(true)
        }

        List<Map> bookData =
            books.collect { Book book ->
                bookToMap(book)
            }

        render([
            total : total,
            max   : params.max,
            offset: params.offset,
            data  : bookData
        ] as JSON)
    }

    /*
     * GET /api/books/{id}
     */
    @Override
    def show() {

        Long id =
            params.long('id')

        Book book =
            bookService.get(id)

        User currentUser = springSecurityService.currentUser as User

        if (!book || (book.active != true && !isAdmin(currentUser))) {

            render(
                status: NOT_FOUND,
                contentType: 'application/json',
                text: [
                    message: 'الكتاب غير موجود'
                ] as JSON
            )

            return
        }

        render(
            bookToMap(book) as JSON
        )
    }

    /*
     * POST /api/books
     */
    @Override
    @Secured(['ROLE_ADMIN'])
    def save() {

        Book book =
            new Book()

        bindData(
            book,
            request.JSON,
            [
                exclude: [
                    'id',
                    'version',
                    'coverData',
                    'coverContentType'
                ]
            ]
        )

        try {

            bookService.save(book)

        } catch (ValidationException e) {

            render(
                status: BAD_REQUEST,
                contentType: 'application/json',
                text: [
                    message: 'فشل التحقق من بيانات الكتاب',
                    errors : book.errors.allErrors.collect {
                        message(error: it)
                    }
                ] as JSON
            )

            return
        }

        render(
            status: CREATED,
            contentType: 'application/json',
            text: bookToMap(book) as JSON
        )
    }

    /*
     * PUT /api/books/{id}
     */
    @Override
    @Secured(['ROLE_ADMIN'])
    def update() {

        Long id =
            params.long('id')

        Book book =
            bookService.get(id)

        if (!book) {

            render(
                status: NOT_FOUND,
                contentType: 'application/json',
                text: [
                    message: 'الكتاب غير موجود'
                ] as JSON
            )

            return
        }

        bindData(
            book,
            request.JSON,
            [
                exclude: [
                    'id',
                    'version',
                    'coverData',
                    'coverContentType'
                ]
            ]
        )

        try {

            bookService.save(book)

        } catch (ValidationException e) {

            render(
                status: BAD_REQUEST,
                contentType: 'application/json',
                text: [
                    message: 'فشل التحقق من بيانات الكتاب',
                    errors : book.errors.allErrors.collect {
                        message(error: it)
                    }
                ] as JSON
            )

            return
        }

        render(
            status: OK,
            contentType: 'application/json',
            text: bookToMap(book) as JSON
        )
    }

    /*
     * DELETE /api/books/{id}
     */
    @Override
    @Secured(['ROLE_ADMIN'])
    def delete() {

        Long id =
            params.long('id')

        Book book =
            bookService.get(id)

        if (!book) {

            render(
                status: NOT_FOUND,
                contentType: 'application/json',
                text: [
                    message: 'الكتاب غير موجود'
                ] as JSON
            )

            return
        }

        bookService.delete(id)

        render status: NO_CONTENT
    }

    private boolean isAdmin(User user) {
        user?.authorities*.authority?.contains('ROLE_ADMIN')
    }

    /*
     * Convert Book to clean API response.
     *
     * coverData is intentionally excluded.
     */
    private Map bookToMap(Book book) {

        [
            id                   : book.id,
            title                : book.title,
            isbn                 : book.isbn,
            description          : book.description,
            publishYear          : book.publishYear,

            author               : book.author ? [
                id  : book.author.id,
                name: book.author.name
            ] : null,

            category             : book.category ? [
                id  : book.category.id,
                name: book.category.name
            ] : null,

            physicalSaleStock    : book.physicalSaleStock,
            physicalSalePrice    : book.physicalSalePrice,

            digitalAvailable     : book.digitalAvailable,
            digitalPurchasePrice : book.digitalPurchasePrice,
            digitalRentalPrice   : book.digitalRentalPrice,
            membershipIncluded   : book.membershipIncluded,

            active               : book.active,

            coverUrl             :
                (book.coverData || book.externalCoverUrl) ?
                    createLink(
                        controller: 'book',
                        action: 'cover',
                        id: book.id
                    ) :
                    null
        ]
    }
}