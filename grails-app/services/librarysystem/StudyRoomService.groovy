package librarysystem

import grails.gorm.services.Service

@Service(StudyRoom)
interface StudyRoomService {

    StudyRoom get(Serializable id)

    List<StudyRoom> list(Map args)

    Long count()

    void delete(Serializable id)

    StudyRoom save(StudyRoom studyRoom)

}