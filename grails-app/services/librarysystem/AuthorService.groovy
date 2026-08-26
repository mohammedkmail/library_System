package librarysystem

import grails.gorm.services.Service

@Service(Author)
interface AuthorService {

    Author get(Serializable id)

    List<Author> list(Map args)

    Long count()

    void delete(Serializable id)

    Author save(Author author)

}