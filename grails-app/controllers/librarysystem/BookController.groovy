package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.web.multipart.MultipartFile

import static org.springframework.http.HttpStatus.*

class BookController {

    BookService bookService
    DigitalAccessService digitalAccessService
    MembershipService membershipService
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

        String search =
            params.search?.trim()

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        List<Book> bookList
        Long bookCount

        Map queryOptions = [
            max   : pageSize,
            offset: offset,
            sort  : 'title',
            order : 'asc'
        ]


        if (admin) {

            if (search) {

                bookList =
                    Book.findAllByTitleIlike(
                        "%${search}%",
                        queryOptions
                    )

                bookCount =
                    Book.countByTitleIlike(
                        "%${search}%"
                    )

            } else {

                bookList =
                    Book.list(queryOptions)

                bookCount =
                    Book.count()
            }

        } else {

            if (search) {

                bookList =
                    Book.findAllByActiveAndTitleIlike(
                        true,
                        "%${search}%",
                        queryOptions
                    )

                bookCount =
                    Book.countByActiveAndTitleIlike(
                        true,
                        "%${search}%"
                    )

            } else {

                bookList =
                    Book.findAllByActive(
                        true,
                        queryOptions
                    )

                bookCount =
                    Book.countByActive(true)
            }
        }


        respond bookList,
            model: [
                bookCount: bookCount,
                search   : search,
                pageSize : pageSize,
                isAdmin  : admin
            ]
    }


    @Secured(['permitAll'])
    def show(Long id) {

        Book book =
            bookService.get(id)

        if (!book) {
            notFound()
            return
        }


        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        boolean libraryUser =
            currentUser &&
            !admin &&
            isLibraryUser(currentUser)


        if (
            book.active != true &&
            !admin
        ) {
            notFound()
            return
        }


        List<BookCopy> availableCopies =
            BookCopy.findAllByBookAndStatus(
                book,
                'AVAILABLE',
                [
                    sort : 'copyCode',
                    order: 'asc'
                ]
            )


        int physicalCopyCount =
            BookCopy.countByBook(book)


        boolean canReadDigital = false
        boolean ownsDigital = false
        boolean hasActiveMembership = false
        Reservation currentReservation = null


        if (libraryUser) {

            hasActiveMembership =
                membershipService
                    .hasActiveMembership(currentUser)


            currentReservation =
                Reservation.findAllByUserAndBook(
                    currentUser,
                    book,
                    [
                        sort : 'reservationDate',
                        order: 'desc'
                    ]
                ).find { Reservation reservation ->

                    reservation.status in [
                        'WAITING',
                        'READY'
                    ]
                }


            if (book.digitalAvailable) {

                digitalAccessService
                    .expireOldRentals()


                canReadDigital =
                    digitalAccessService
                        .canAccessBook(
                            currentUser,
                            book
                        )


                ownsDigital =
                    Purchase.findAllByUserAndBook(
                        currentUser,
                        book
                    ).any { Purchase purchase ->

                        purchase.purchaseType == 'DIGITAL' &&
                        purchase.status == 'COMPLETED'
                    }


                if (!ownsDigital) {

                    ownsDigital =
                        DigitalAccess
                            .findAllByUserAndBook(
                                currentUser,
                                book
                            )
                            .any { DigitalAccess access ->

                                access.accessType == 'PURCHASE' &&
                                access.status == 'ACTIVE'
                            }
                }
            }
        }


        respond book,
            model: [
                availableCopies    : availableCopies,
                physicalCopyCount  : physicalCopyCount,
                canReadDigital     : canReadDigital,
                ownsDigital        : ownsDigital,
                currentReservation : currentReservation,
                hasActiveMembership: hasActiveMembership,
                libraryUser        : libraryUser,
                isAdmin            : admin
            ]
    }


    @Secured(['ROLE_ADMIN'])
    def create() {

        respond new Book(params),
            model: [
                authorList:
                    Author.list(
                        sort: 'name',
                        order: 'asc'
                    ),

                categoryList:
                    Category.list(
                        sort: 'name',
                        order: 'asc'
                    )
            ]
    }


    @Secured(['ROLE_ADMIN'])
    def save(Book book) {

        if (!book) {
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


            render view: 'create',
                model: [
                    book: book,

                    authorList:
                        Author.list(
                            sort: 'name',
                            order: 'asc'
                        ),

                    categoryList:
                        Category.list(
                            sort: 'name',
                            order: 'asc'
                        )
                ]

            return
        }


        flash.message =
            'Book created successfully.'


        redirect action: 'show',
                 id: book.id
    }


    @Secured(['ROLE_ADMIN'])
    def edit(Long id) {

        Book book =
            bookService.get(id)

        if (!book) {
            notFound()
            return
        }


        respond book,
            model: [
                authorList:
                    Author.list(
                        sort: 'name',
                        order: 'asc'
                    ),

                categoryList:
                    Category.list(
                        sort: 'name',
                        order: 'asc'
                    )
            ]
    }


    @Secured(['ROLE_ADMIN'])
    def update(Book book) {

        if (!book) {
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


            render view: 'edit',
                model: [
                    book: book,

                    authorList:
                        Author.list(
                            sort: 'name',
                            order: 'asc'
                        ),

                    categoryList:
                        Category.list(
                            sort: 'name',
                            order: 'asc'
                        )
                ]

            return
        }


        flash.message =
            'Book updated successfully.'


        redirect action: 'show',
                 id: book.id
    }


    @Secured(['ROLE_ADMIN'])
    def delete(Long id) {

        Book book =
            bookService.get(id)

        if (!book) {
            notFound()
            return
        }


        boolean hasSystemHistory =
            BookCopy.countByBook(book) > 0 ||
            Reservation.countByBook(book) > 0 ||
            Purchase.countByBook(book) > 0 ||
            DigitalAccess.countByBook(book) > 0


        if (hasSystemHistory) {

            try {

                book.active = false

                bookService.save(book)


                flash.message =
                    'This book has system history, so it was deactivated instead of deleted.'

            } catch (ValidationException e) {

                flash.message =
                    'Book could not be deactivated.'


                redirect action: 'show',
                         id: book.id

                return
            }

        } else {

            bookService.delete(id)

            flash.message =
                'Book deleted successfully.'
        }


        redirect action: 'index'
    }


    @Secured(['permitAll'])
    def cover(Long id) {

        Book book =
            bookService.get(id)


        if (
            !book ||
            !book.coverData
        ) {

            render status: NOT_FOUND
            return
        }


        User currentUser =
            springSecurityService.currentUser as User


        if (
            book.active != true &&
            !isAdmin(currentUser)
        ) {

            render status: NOT_FOUND
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


    private boolean isAdmin(User user) {

        if (user == null) {
            return false
        }

        for (def role : user.authorities) {
            if (role.authority == 'ROLE_ADMIN') {
                return true
            }
        }

        return false
    }


    private boolean isLibraryUser(User user) {

        if (user == null) {
            return false
        }

        for (def role : user.authorities) {
            if (role.authority == 'ROLE_USER') {
                return true
            }
        }

        return false
    }


    protected void notFound() {

        request.withFormat {

            form multipartForm {

                flash.message =
                    'Book not found.'

                redirect action: 'index'
            }


            '*' {
                render status: NOT_FOUND
            }
        }
    }
}