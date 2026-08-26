package librarysystem

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class StudyRoomServiceSpec extends Specification {

    StudyRoomService studyRoomService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new StudyRoom(...).save(flush: true, failOnError: true)
        //new StudyRoom(...).save(flush: true, failOnError: true)
        //StudyRoom studyRoom = new StudyRoom(...).save(flush: true, failOnError: true)
        //new StudyRoom(...).save(flush: true, failOnError: true)
        //new StudyRoom(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //studyRoom.id
    }

    void "test get"() {
        setupData()

        expect:
        studyRoomService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<StudyRoom> studyRoomList = studyRoomService.list(max: 2, offset: 2)

        then:
        studyRoomList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        studyRoomService.count() == 5
    }

    void "test delete"() {
        Long studyRoomId = setupData()

        expect:
        studyRoomService.count() == 5

        when:
        studyRoomService.delete(studyRoomId)
        sessionFactory.currentSession.flush()

        then:
        studyRoomService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        StudyRoom studyRoom = new StudyRoom()
        studyRoomService.save(studyRoom)

        then:
        studyRoom.id != null
    }
}
