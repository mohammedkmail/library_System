package librarysystem

import grails.gorm.services.Service

@Service(BookCopy)
interface BookCopyService {

    BookCopy get(Serializable id)

    List<BookCopy> list(Map args)

    Long count()

    void delete(Serializable id)

    BookCopy save(BookCopy bookCopy)

}