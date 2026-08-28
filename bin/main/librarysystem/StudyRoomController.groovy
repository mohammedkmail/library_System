package librarysystem

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

@Secured(['ROLE_ADMIN'])
class StudyRoomController {

    StudyRoomService studyRoomService

    static allowedMethods = [
        save  : 'POST',
        update: 'PUT',
        delete: 'DELETE'
    ]

    def index(Integer max) {

        params.max =
            Math.min(max ?: 10, 100)

        respond studyRoomService.list(params),
            model: [
                studyRoomCount: studyRoomService.count()
            ]
    }

    def show(Long id) {

        StudyRoom studyRoom =
            studyRoomService.get(id)

        if (!studyRoom) {
            notFound()
            return
        }

        respond studyRoom
    }

    def create() {

        respond new StudyRoom(params)
    }

    def save(StudyRoom studyRoom) {

        if (!studyRoom) {
            notFound()
            return
        }

        try {

            studyRoomService.save(studyRoom)

        } catch (ValidationException e) {

            flash.message =
                'Study room could not be created. Please fix the errors below.'

            respond studyRoom.errors,
                view: 'create'

            return
        }

        flash.message =
            'Study room created successfully.'

        redirect action: 'show',
                 id: studyRoom.id
    }

    def edit(Long id) {

        StudyRoom studyRoom =
            studyRoomService.get(id)

        if (!studyRoom) {
            notFound()
            return
        }

        respond studyRoom
    }

    def update(StudyRoom studyRoom) {

        if (!studyRoom) {
            notFound()
            return
        }

        try {

            studyRoomService.save(studyRoom)

        } catch (ValidationException e) {

            flash.message =
                'Study room could not be updated. Please fix the errors below.'

            respond studyRoom.errors,
                view: 'edit'

            return
        }

        flash.message =
            'Study room updated successfully.'

        redirect action: 'show',
                 id: studyRoom.id
    }

    def delete(Long id) {

        if (!id) {
            notFound()
            return
        }

        StudyRoom studyRoom =
            studyRoomService.get(id)

        if (!studyRoom) {
            notFound()
            return
        }

        Long reservationCount =
            RoomReservation.countByStudyRoom(
                studyRoom
            )

        if (reservationCount > 0) {

            studyRoom.active = false

            studyRoomService.save(
                studyRoom
            )

            flash.message =
                'This study room has reservation history, so it was deactivated instead of deleted.'

            redirect action: 'show',
                     id: studyRoom.id

            return
        }

        studyRoomService.delete(id)

        flash.message =
            'Study room deleted successfully.'

        redirect action: 'index'
    }

    protected void notFound() {

        flash.message =
            'Study room not found.'

        redirect action: 'index'
    }
}