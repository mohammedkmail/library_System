package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class RoomReservationService {

    MembershipService membershipService

    RoomReservation get(Serializable id) {
        RoomReservation.get(id)
    }

    List<RoomReservation> list(Map params = [:]) {
        RoomReservation.list(params)
    }

    Long count() {
        RoomReservation.count()
    }

    RoomReservation createReservation(
        User user,
        StudyRoom studyRoom,
        Date startTime,
        Date endTime
    ) {

        if (!user) {
            throw new IllegalArgumentException(
                'User is required.'
            )
        }

        if (!studyRoom) {
            throw new IllegalArgumentException(
                'Study room is required.'
            )
        }

        if (!membershipService.hasActiveMembership(user)) {
            throw new IllegalStateException(
                'An active membership is required to reserve a study room.'
            )
        }

        if (!studyRoom.active) {
            throw new IllegalStateException(
                'This study room is not currently available.'
            )
        }

        if (!startTime || !endTime) {
            throw new IllegalArgumentException(
                'Start time and end time are required.'
            )
        }

        if (endTime <= startTime) {
            throw new IllegalArgumentException(
                'End time must be after start time.'
            )
        }

        boolean overlappingReservation =
            RoomReservation.findAllByStudyRoomAndStatusInList(
                studyRoom,
                ['PENDING', 'CONFIRMED']
            ).any { RoomReservation reservation ->

                startTime < reservation.endTime &&
                endTime > reservation.startTime
            }

        if (overlappingReservation) {
            throw new IllegalStateException(
                'The study room is already reserved during this time.'
            )
        }

        long milliseconds =
            endTime.time - startTime.time

        BigDecimal hours =
            new BigDecimal(milliseconds)
                .divide(
                    new BigDecimal(1000 * 60 * 60),
                    2,
                    BigDecimal.ROUND_UP
                )

        BigDecimal totalPrice =
            studyRoom.pricePerHour * hours

        RoomReservation reservation =
            new RoomReservation(
                user: user,
                studyRoom: studyRoom,
                startTime: startTime,
                endTime: endTime,
                totalPrice: totalPrice,
                status: 'CONFIRMED'
            )

        reservation.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    RoomReservation cancelReservation(Long id) {

        RoomReservation reservation =
            RoomReservation.get(id)

        if (!reservation) {
            return null
        }

        if (reservation.status in [
            'COMPLETED',
            'CANCELLED'
        ]) {
            throw new IllegalStateException(
                'This room reservation cannot be cancelled.'
            )
        }

        reservation.status = 'CANCELLED'

        reservation.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    Long countConfirmedReservations() {
        RoomReservation.countByStatus('CONFIRMED')
    }
}