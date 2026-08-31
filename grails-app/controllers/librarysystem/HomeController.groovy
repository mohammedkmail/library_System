package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class HomeController {

    SpringSecurityService springSecurityService
    MembershipService membershipService

    static allowedMethods = [
        index: 'GET'
    ]

    def index() {

        Date now = new Date()

        User currentUser =
            springSecurityService.currentUser as User

        boolean loggedIn =
            currentUser != null

        boolean isAdmin =
            hasRole(currentUser, 'ROLE_ADMIN')

        boolean isLibraryUser =
            hasRole(currentUser, 'ROLE_USER')


        /* =========================================================
           PUBLIC COLLECTION DATA
           ========================================================= */

        List<Book> featuredBooks =
            Book.findAllByActive(
                true,
                [
                    max  : 6,
                    sort : 'dateCreated',
                    order: 'desc'
                ]
            )

        Long totalBooks =
            Book.countByActive(true)

        Long totalAuthors =
            Author.count()

        Long totalCategories =
            Category.countByActive(true)

        Long totalDigitalBooks =
            Book.countByActiveAndDigitalAvailable(
                true,
                true
            )

        Long totalCopies =
            BookCopy.count()

        Long availableCopies =
            BookCopy.countByStatus('AVAILABLE')


        Role memberRole =
            Role.findByAuthority('ROLE_USER')

        Long totalMembers =
            memberRole ?
                UserRole.countByRole(memberRole) :
                0L


        /* =========================================================
           FEATURED CATEGORIES
           ========================================================= */

        List<Map> featuredCategories =
            Category.findAllByActive(
                true,
                [
                    sort : 'name',
                    order: 'asc'
                ]
            ).collect { Category category ->

                [
                    category : category,
                    bookCount:
                        Book.countByCategoryAndActive(
                            category,
                            true
                        )
                ]

            }.sort { Map first, Map second ->

                int byCount =
                    (second.bookCount as Long) <=>
                    (first.bookCount as Long)

                byCount ?: (
                    first.category.name <=>
                    second.category.name
                )

            }.take(8)


        /* =========================================================
           MOST BORROWED BOOKS
           ========================================================= */

        Map<Long, Integer> borrowCountByBookId =
            [:].withDefault { 0 }

        Borrowing.list().each { Borrowing borrowing ->

            Book borrowedBook =
                borrowing.bookCopy?.book

            if (borrowedBook?.active) {
                borrowCountByBookId[borrowedBook.id] =
                    borrowCountByBookId[borrowedBook.id] + 1
            }
        }

        List<Book> popularBooks =
            borrowCountByBookId
                .entrySet()
                .sort { Map.Entry<Long, Integer> first, Map.Entry<Long, Integer> second ->
                    second.value <=> first.value
                }
                .collect { Map.Entry<Long, Integer> entry ->
                    Book.get(entry.key)
                }
                .findAll { Book book ->
                    book?.active
                }
                .take(6)

        if (popularBooks.size() < 6) {

            featuredBooks.each { Book book ->

                if (
                    popularBooks.size() < 6 &&
                    !popularBooks*.id.contains(book.id)
                ) {
                    popularBooks << book
                }
            }
        }


        /* =========================================================
           POPULAR AUTHORS
           ========================================================= */

        List<Map> popularAuthors =
            Author.list(
                sort: 'name',
                order: 'asc'
            ).collect { Author author ->

                [
                    author   : author,
                    bookCount:
                        Book.countByAuthorAndActive(
                            author,
                            true
                        )
                ]

            }.findAll { Map authorData ->

                (authorData.bookCount as Long) > 0

            }.sort { Map first, Map second ->

                int byCount =
                    (second.bookCount as Long) <=>
                    (first.bookCount as Long)

                byCount ?: (
                    first.author.name <=>
                    second.author.name
                )

            }.take(6)


        /* =========================================================
           USER DASHBOARD DATA
           ========================================================= */

        List<Borrowing> userBorrowings = []
        List<Reservation> userReservations = []
        List<RoomReservation> userRoomReservations = []

        Membership currentMembership = null
        boolean hasActiveMembership = false


        if (loggedIn && isLibraryUser && !isAdmin) {

            userBorrowings =
                Borrowing.findAllByUser(
                    currentUser,
                    [
                        sort : 'dueDate',
                        order: 'asc'
                    ]
                ).findAll { Borrowing borrowing ->

                    borrowing.status in [
                        'ACTIVE',
                        'OVERDUE'
                    ]

                }.take(4)


            userReservations =
                Reservation.findAllByUser(
                    currentUser,
                    [
                        sort : 'reservationDate',
                        order: 'desc'
                    ]
                ).findAll { Reservation reservation ->

                    reservation.status in [
                        'WAITING',
                        'READY'
                    ]

                }.take(4)


            userRoomReservations =
                RoomReservation.findAllByUser(
                    currentUser,
                    [
                        sort : 'startTime',
                        order: 'asc'
                    ]
                ).findAll { RoomReservation reservation ->

                    reservation.status in [
                        'PENDING',
                        'CONFIRMED'
                    ] &&
                    reservation.endTime &&
                    reservation.endTime.after(now)

                }.take(3)


            hasActiveMembership =
                membershipService
                    .hasActiveMembership(currentUser)

            if (hasActiveMembership) {

                currentMembership =
                    Membership.findByUserAndStatus(
                        currentUser,
                        'ACTIVE'
                    )
            }
        }


        /* =========================================================
           ADMIN DASHBOARD DATA
           ========================================================= */

        Long activeBorrowingCount = 0L
        Long overdueBorrowingCount = 0L
        Long waitingReservationCount = 0L
        Long readyReservationCount = 0L
        Long pendingRoomReservationCount = 0L

        List<Borrowing> urgentBorrowings = []


        if (loggedIn && isAdmin) {

            List<Borrowing> openBorrowings =
                Borrowing.list(
                    sort: 'dueDate',
                    order: 'asc'
                ).findAll { Borrowing borrowing ->

                    borrowing.status in [
                        'ACTIVE',
                        'OVERDUE'
                    ]
                }


            overdueBorrowingCount =
                openBorrowings.count { Borrowing borrowing ->

                    borrowing.status == 'OVERDUE' ||
                    (
                        borrowing.status == 'ACTIVE' &&
                        borrowing.dueDate &&
                        borrowing.dueDate.before(now)
                    )
                } as Long


            activeBorrowingCount =
                (openBorrowings.size() as Long) -
                overdueBorrowingCount


            waitingReservationCount =
                Reservation.countByStatus('WAITING')


            readyReservationCount =
                Reservation.findAllByStatus('READY')
                    .count { Reservation reservation ->

                        !reservation.readyUntil ||
                        !reservation.readyUntil.before(now)
                    } as Long


            pendingRoomReservationCount =
                RoomReservation.countByStatus('PENDING')


            urgentBorrowings =
                openBorrowings.findAll { Borrowing borrowing ->

                    borrowing.status == 'OVERDUE' ||
                    (
                        borrowing.status == 'ACTIVE' &&
                        borrowing.dueDate &&
                        borrowing.dueDate.before(now)
                    )

                }.take(4)
        }


        /* =========================================================
           VIEW MODEL
           ========================================================= */

        [
            currentUser                 : currentUser,
            loggedIn                   : loggedIn,
            isAdmin                    : isAdmin,
            isLibraryUser              : isLibraryUser,

            featuredBooks              : featuredBooks,
            featuredCategories         : featuredCategories,
            popularBooks               : popularBooks,
            popularAuthors             : popularAuthors,
            borrowCountByBookId         : borrowCountByBookId,

            totalBooks                 : totalBooks,
            totalAuthors               : totalAuthors,
            totalCategories            : totalCategories,
            totalDigitalBooks          : totalDigitalBooks,
            totalCopies                : totalCopies,
            availableCopies            : availableCopies,
            totalMembers               : totalMembers,

            userBorrowings             : userBorrowings,
            userReservations           : userReservations,
            userRoomReservations       : userRoomReservations,
            currentMembership          : currentMembership,
            hasActiveMembership        : hasActiveMembership,

            activeBorrowingCount       : activeBorrowingCount,
            overdueBorrowingCount      : overdueBorrowingCount,
            waitingReservationCount    : waitingReservationCount,
            readyReservationCount      : readyReservationCount,
            pendingRoomReservationCount: pendingRoomReservationCount,
            urgentBorrowings           : urgentBorrowings,

            membershipPricePerDay      :
                membershipService.getPricePerDay()
        ]
    }


    private boolean hasRole(
        User user,
        String authority
    ) {

        if (!user) {
            return false
        }

        user.authorities.any { Role role ->
            role.authority == authority
        }
    }
}
