package librarysystem

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

@Secured(['ROLE_ADMIN'])
class BookCopyController {

    BookCopyService bookCopyService

    static allowedMethods = [
        save  : 'POST',
        update: 'PUT',
        delete: 'DELETE'
    ]


    def index(Integer max) {

        int pageSize =
            Math.min(max ?: 20, 100)

        int offset =
            params.int('offset') ?: 0

        List<BookCopy> bookCopyList =
            bookCopyService.list(
                [
                    max   : pageSize,
                    offset: offset,
                    sort  : 'copyCode',
                    order : 'asc'
                ]
            )

        respond bookCopyList,
            model: [
                bookCopyCount:
                    bookCopyService.count(),

                pageSize:
                    pageSize
            ]
    }


    def show(Long id) {

        BookCopy bookCopy =
            bookCopyService.get(id)

        if (!bookCopy) {
            notFound()
            return
        }

        int borrowingCount =
            Borrowing.countByBookCopy(bookCopy)

        int reservationCount =
            Reservation.countByAssignedCopy(bookCopy)

        boolean hasHistory =
            borrowingCount > 0 ||
            reservationCount > 0

        boolean operationallyLocked =
            bookCopy.status in [
                'BORROWED',
                'RESERVED'
            ]

        respond bookCopy,
            model: [
                borrowingCount   : borrowingCount,
                reservationCount : reservationCount,
                hasHistory       : hasHistory,
                canDelete        :
                    !hasHistory &&
                    !operationallyLocked
            ]
    }


    def create() {

        BookCopy bookCopy =
            new BookCopy(params)

        bookCopy.status =
            'AVAILABLE'

        respond bookCopy,
            model: [
                bookList:
                    activeBookList()
            ]
    }


    def save(BookCopy bookCopy) {

        if (!bookCopy) {
            notFound()
            return
        }

        /*
         * New physical copies always start AVAILABLE.
         *
         * BORROWED and RESERVED are controlled by
         * the circulation workflow.
         */
        bookCopy.status =
            'AVAILABLE'

        try {

            bookCopyService.save(bookCopy)

        } catch (ValidationException e) {

            flash.message =
                'Book copy could not be created. Please fix the errors below.'

            render view: 'create',
                model: [
                    bookCopy:
                        bookCopy,

                    bookList:
                        activeBookList()
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

        render view: 'edit',
            model: editModel(bookCopy)
    }


    def update(Long id) {

        BookCopy bookCopy =
            bookCopyService.get(id)

        if (!bookCopy) {
            notFound()
            return
        }

        Long submittedVersion =
            params.long('version')

        if (
            submittedVersion != null &&
            bookCopy.version > submittedVersion
        ) {

            bookCopy.errors.rejectValue(
                'version',
                'default.optimistic.locking.failure',
                [
                    message(
                        code: 'bookCopy.label',
                        default: 'Book Copy'
                    )
                ] as Object[],
                'Another user has updated this book copy.'
            )

            render view: 'edit',
                model: editModel(bookCopy)

            return
        }


        boolean history =
            hasHistory(bookCopy)

        boolean canChangeBook =
            !history &&
            bookCopy.status == 'AVAILABLE'

        boolean operationallyLocked =
            bookCopy.status in [
                'BORROWED',
                'RESERVED'
            ]


        bookCopy.copyCode =
            params.copyCode
                ?.toString()
                ?.trim()


        /*
         * The book association can only be changed
         * before the physical copy has circulation history.
         */
        if (canChangeBook) {

            Long requestedBookId =
                params.long('book.id')

            Book requestedBook =
                requestedBookId
                    ? Book.get(requestedBookId)
                    : null

            bookCopy.book =
                requestedBook
        }


        String requestedStatus =
            params.status
                ?.toString()
                ?.trim()


        /*
         * BORROWED and RESERVED cannot be overridden
         * manually. They are controlled by borrowing
         * and reservation workflows.
         */
        if (operationallyLocked) {

            if (
                requestedStatus &&
                requestedStatus != bookCopy.status
            ) {

                flash.message =
                    'BORROWED and RESERVED statuses are controlled by the borrowing and reservation workflow.'

                render view: 'edit',
                    model: editModel(bookCopy)

                return
            }

        } else if (requestedStatus) {

            List<String> allowedManualStatuses = [
                'AVAILABLE',
                'LOST',
                'DAMAGED'
            ]

            if (
                !allowedManualStatuses
                    .contains(requestedStatus)
            ) {

                flash.message =
                    'Invalid book copy status.'

                render view: 'edit',
                    model: editModel(bookCopy)

                return
            }

            bookCopy.status =
                requestedStatus
        }


        try {

            bookCopyService.save(bookCopy)

        } catch (ValidationException e) {

            flash.message =
                'Book copy could not be updated. Please fix the errors below.'

            render view: 'edit',
                model: editModel(bookCopy)

            return
        }

        flash.message =
            'Book copy updated successfully.'

        redirect action: 'show',
                 id: bookCopy.id
    }


    def delete(Long id) {

        BookCopy bookCopy =
            bookCopyService.get(id)

        if (!bookCopy) {
            notFound()
            return
        }

        if (
            hasHistory(bookCopy) ||
            bookCopy.status in [
                'BORROWED',
                'RESERVED'
            ]
        ) {

            flash.message =
                'This physical copy cannot be deleted because it is used by the circulation history.'

            redirect action: 'show',
                     id: bookCopy.id

            return
        }

        bookCopyService.delete(id)

        flash.message =
            'Book copy deleted successfully.'

        redirect action: 'index'
    }


    private boolean hasHistory(
        BookCopy bookCopy
    ) {

        Borrowing.countByBookCopy(bookCopy) > 0 ||
        Reservation.countByAssignedCopy(bookCopy) > 0
    }


    private List<Book> activeBookList() {

        Book.findAllByActive(
            true,
            [
                sort : 'title',
                order: 'asc'
            ]
        )
    }


    private Map editModel(
        BookCopy bookCopy
    ) {

        boolean history =
            hasHistory(bookCopy)

        boolean operationallyLocked =
            bookCopy.status in [
                'BORROWED',
                'RESERVED'
            ]

        List<Book> books =
            activeBookList()

        if (
            bookCopy.book &&
            !books*.id.contains(bookCopy.book.id)
        ) {

            books.add(bookCopy.book)

            books =
                books.sort {
                    it.title?.toLowerCase()
                }
        }

        [
            bookCopy:
                bookCopy,

            bookList:
                books,

            canChangeBook:
                !history &&
                bookCopy.status == 'AVAILABLE',

            statusEditable:
                !operationallyLocked,

            statusOptions: [
                'AVAILABLE',
                'LOST',
                'DAMAGED'
            ]
        ]
    }


    protected void notFound() {

        flash.message =
            'Book copy not found.'

        redirect action: 'index'
    }
}