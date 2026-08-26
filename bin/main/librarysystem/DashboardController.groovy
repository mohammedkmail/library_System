package librarysystem

import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class DashboardController {

    BorrowingService borrowingService
    PurchaseService purchaseService
    ReservationService reservationService
    RoomReservationService roomReservationService

    def index() {

        Long totalBooks = Book.count()

        Long activeBorrowings =
            borrowingService.countActiveBorrowings()

        Long waitingReservations =
            reservationService.countWaitingReservations()

        Long completedPurchases =
            purchaseService.countCompletedPurchases()

        BigDecimal totalSales =
            purchaseService.totalSales()

        Long confirmedRoomReservations =
            roomReservationService.countConfirmedReservations()

        render view: 'index', model: [
            totalBooks               : totalBooks,
            activeBorrowings         : activeBorrowings,
            waitingReservations      : waitingReservations,
            completedPurchases       : completedPurchases,
            totalSales               : totalSales,
            confirmedRoomReservations: confirmedRoomReservations
        ]
    }
}