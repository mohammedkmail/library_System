package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class RoomReservationController {

    SpringSecurityService springSecurityService
    RoomReservationService roomReservationService

    def index() {

        User currentUser =
            springSecurityService.currentUser as User

        List<RoomReservation> reservations

        if (isAdmin(currentUser)) {

            reservations = RoomReservation.list(
                sort: 'startTime',
                order: 'desc'
            )

        } else {

            reservations = RoomReservation.findAllByUser(
                currentUser,
                [
                    sort : 'startTime',
                    order: 'desc'
                ]
            )
        }

        respond reservations
    }

    def show(Long id) {

        RoomReservation reservation =
            roomReservationService.get(id)

        if (!reservation) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            reservation.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        respond reservation
    }

    def create() {

        User currentUser =
            springSecurityService.currentUser as User

        if (isAdmin(currentUser)) {
            render status: 403
            return
        }

        List<StudyRoom> activeRooms =
            StudyRoom.findAllByActive(
                true,
                [
                    sort : 'roomNumber',
                    order: 'asc'
                ]
            )

        respond new RoomReservation(),
            model: [
                activeRooms: activeRooms
            ]
    }

    def save() {

        User currentUser =
            springSecurityService.currentUser as User

        if (isAdmin(currentUser)) {
            render status: 403
            return
        }

        StudyRoom studyRoom =
            StudyRoom.get(
                params.long('studyRoom.id')
            )

        Date startTime =
            params.date(
                'startTime',
                "yyyy-MM-dd'T'HH:mm"
            )

        Date endTime =
            params.date(
                'endTime',
                "yyyy-MM-dd'T'HH:mm"
            )

        try {

            RoomReservation reservation =
                roomReservationService.createReservation(
                    currentUser,
                    studyRoom,
                    startTime,
                    endTime
                )

            flash.message =
                'Room reserved successfully.'

            redirect action: 'show',
                     id: reservation.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message = e.message

            List<StudyRoom> activeRooms =
                StudyRoom.findAllByActive(
                    true,
                    [
                        sort : 'roomNumber',
                        order: 'asc'
                    ]
                )

            respond new RoomReservation(
                user: currentUser,
                studyRoom: studyRoom,
                startTime: startTime,
                endTime: endTime
            ),
            view: 'create',
            model: [
                activeRooms: activeRooms
            ]
        }
    }

    def cancel(Long id) {

        RoomReservation reservation =
            roomReservationService.get(id)

        if (!reservation) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            reservation.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        try {

            roomReservationService.cancelReservation(id)

            flash.message =
                'Room reservation cancelled successfully.'

            redirect action: 'index'

        } catch (IllegalStateException e) {

            flash.message = e.message

            redirect action: 'show',
                     id: id
        }
    }

    private boolean isAdmin(User user) {

        user.authorities*.authority
            .contains('ROLE_ADMIN')
    }

    protected void notFound() {

        render status: 404
    }
}