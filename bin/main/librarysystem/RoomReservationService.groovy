package librarysystem

import grails.gorm.transactions.Transactional

import java.math.RoundingMode

@Transactional
class RoomReservationService {

    /** Retrieves a room reservation by ID. */
    RoomReservation get(Serializable id) {
        RoomReservation.get(id)
    }

    /** Returns a list of room reservations based on the provided options. */
    List<RoomReservation> list(Map params = [:]) {
        RoomReservation.list(params)
    }

    /** Returns the total number of room reservations. */
    Long count() {
        RoomReservation.count()
    }

    /** Creates a study room reservation and calculates its total price. */
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

        if (studyRoom.active != true) {
            throw new IllegalStateException(
                'This study room is not currently available.'
            )
        }

        if (!startTime || !endTime) {
            throw new IllegalArgumentException(
                'Start time and end time are required.'
            )
        }

        Date now = new Date()

        if (startTime <= now) {
            throw new IllegalArgumentException(
                'Start time must be in the future.'
            )
        }

        if (endTime <= startTime) {
            throw new IllegalArgumentException(
                'End time must be after start time.'
            )
        }

        boolean overlappingReservation =
            RoomReservation
                .findAllByStudyRoomAndStatusInList(
                    studyRoom,
                    ['PENDING', 'CONFIRMED']
                )
                .any {
                    RoomReservation reservation ->

                    startTime < reservation.endTime &&
                    endTime > reservation.startTime
                }

        if (overlappingReservation) {
            throw new IllegalStateException(
                'The study room is already reserved during this time.'
            )
        }

        long durationMilliseconds =
            endTime.time - startTime.time

        long durationMinutes =
            Math.ceil(
                durationMilliseconds /
                (1000.0 * 60)
            ) as long

        BigDecimal hours =
            BigDecimal.valueOf(durationMinutes)
                .divide(
                    BigDecimal.valueOf(60),
                    4,
                    RoundingMode.HALF_UP
                )

        BigDecimal totalPrice =
            studyRoom.pricePerHour
                .multiply(hours)
                .setScale(
                    2,
                    RoundingMode.HALF_UP
                )

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

    /** Cancels a room reservation before its start time. */
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

        Date now = new Date()

        if (reservation.startTime <= now) {
            throw new IllegalStateException(
                'A reservation cannot be cancelled after its start time.'
            )
        }

        reservation.status =
            'CANCELLED'

        reservation.save(
            flush: true,
            failOnError: true
        )

        reservation
    }

    /** Marks finished room reservations as completed. */
    void updateCompletedReservations() {

        Date now = new Date()

        List<RoomReservation> completedReservations =
            RoomReservation
                .findAllByStatusAndEndTimeLessThan(
                    'CONFIRMED',
                    now
                )

        completedReservations.each {
            RoomReservation reservation ->

            reservation.status =
                'COMPLETED'

            reservation.save(
                flush: true,
                failOnError: true
            )
        }
    }

    /** Returns the number of currently confirmed room reservations. */
    Long countConfirmedReservations() {

        updateCompletedReservations()

        RoomReservation.countByStatus(
            'CONFIRMED'
        )
    }
}