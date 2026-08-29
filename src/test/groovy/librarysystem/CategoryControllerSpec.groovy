package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.testing.gorm.DomainUnitTest
import grails.testing.web.controllers.ControllerUnitTest
import grails.validation.ValidationException
import spock.lang.Specification

class CategoryControllerSpec extends Specification
        implements ControllerUnitTest<CategoryController>,
                   DomainUnitTest<Category> {

    def setup() {

        mockDomain(Book)

        controller.springSecurityService =
            Stub(SpringSecurityService) {
                getCurrentUser() >> null
            }
    }


    void "controller loads correctly"() {

        expect:

        controller != null
    }


    void "index returns categories and count"() {

        given:

        new Category(
            name: 'Programming',
            active: true
        ).save(
            validate: false,
            flush: true
        )

        new Category(
            name: 'History',
            active: true
        ).save(
            validate: false,
            flush: true
        )


        when:

        controller.index(12)


        then:

        model.categoryList != null

        model.categoryList.size() == 2

        model.categoryCount == 2

        model.isAdmin == false
    }


    void "create returns a new category"() {

        when:

        controller.create()


        then:

        model.category != null

        model.category instanceof Category
    }


    void "save with null category redirects to index"() {

        when:

        request.method = 'POST'

        controller.save(null)


        then:

        response.redirectedUrl ==
            '/category/index'

        flash.message != null
    }


    void "save handles validation failure"() {

        given:

        CategoryService categoryService =
            Mock(CategoryService)

        controller.categoryService =
            categoryService


        and:

        Category category =
            new Category()


        and:

        categoryService.save(category) >> {
            throw new ValidationException(
                'Invalid instance',
                category.errors
            )
        }


        when:

        request.method = 'POST'

        controller.save(category)


        then:

        view == 'create'

        flash.message != null
    }


    void "show with null id redirects to index"() {

        given:

        controller.categoryService =
            Mock(CategoryService) {

                1 * get(null) >> null
            }


        when:

        controller.show(null)


        then:

        response.redirectedUrl ==
            '/category/index'

        flash.message != null
    }


    void "edit with null id redirects to index"() {

        given:

        controller.categoryService =
            Mock(CategoryService) {

                1 * get(null) >> null
            }


        when:

        controller.edit(null)


        then:

        response.redirectedUrl ==
            '/category/index'

        flash.message != null
    }


    void "update with null category redirects to index"() {

        when:

        request.method = 'PUT'

        controller.update(null)


        then:

        response.redirectedUrl ==
            '/category/index'

        flash.message != null
    }


    void "delete with null id redirects to index"() {

        when:

        request.method = 'DELETE'

        controller.delete(null)


        then:

        response.redirectedUrl ==
            '/category/index'

        flash.message != null
    }
}
