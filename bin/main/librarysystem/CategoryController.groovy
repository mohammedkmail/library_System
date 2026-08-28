package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

class CategoryController {

    CategoryService categoryService
    SpringSecurityService springSecurityService

    static allowedMethods = [
        save  : 'POST',
        update: 'PUT',
        delete: 'DELETE'
    ]

    @Secured(['permitAll'])
    def index(Integer max) {

        int pageSize = Math.min(max ?: 12, 100)
        int offset = params.int('offset') ?: 0

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        List<Category> categoryList
        Long categoryCount

        if (admin) {

            categoryList =
                Category.list(
                    max: pageSize,
                    offset: offset,
                    sort: 'name',
                    order: 'asc'
                )

            categoryCount =
                Category.count()

        } else {

            categoryList =
                Category.findAllByActive(
                    true,
                    [
                        max   : pageSize,
                        offset: offset,
                        sort  : 'name',
                        order : 'asc'
                    ]
                )

            categoryCount =
                Category.countByActive(true)
        }

        respond categoryList,
            model: [
                categoryCount: categoryCount,
                isAdmin      : admin
            ]
    }

    @Secured(['permitAll'])
    def show(Long id) {

        Category category =
            categoryService.get(id)

        if (!category) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        boolean admin =
            isAdmin(currentUser)

        /*
         * Inactive categories remain visible
         * to admins for management/history,
         * but not to normal visitors.
         */
        if (
            category.active != true &&
            !admin
        ) {
            notFound()
            return
        }

        List<Book> bookList

        if (admin) {

            bookList =
                Book.findAllByCategory(
                    category,
                    [
                        sort : 'title',
                        order: 'asc'
                    ]
                )

        } else {

            bookList =
                Book.findAllByCategoryAndActive(
                    category,
                    true,
                    [
                        sort : 'title',
                        order: 'asc'
                    ]
                )
        }

        respond category,
            model: [
                bookList: bookList,
                isAdmin : admin
            ]
    }

    @Secured(['ROLE_ADMIN'])
    def create() {

        respond new Category(params)
    }

    @Secured(['ROLE_ADMIN'])
    def save(Category category) {

        if (!category) {
            notFound()
            return
        }

        try {

            categoryService.save(category)

        } catch (ValidationException e) {

            flash.message =
                'Category could not be created. Please fix the errors below.'

            respond category.errors,
                view: 'create'

            return
        }

        flash.message =
            'Category created successfully.'

        redirect action: 'show',
                 id: category.id
    }

    @Secured(['ROLE_ADMIN'])
    def edit(Long id) {

        Category category =
            categoryService.get(id)

        if (!category) {
            notFound()
            return
        }

        respond category
    }

    @Secured(['ROLE_ADMIN'])
    def update(Category category) {

        if (!category) {
            notFound()
            return
        }

        try {

            categoryService.save(category)

        } catch (ValidationException e) {

            flash.message =
                'Category could not be updated. Please fix the errors below.'

            respond category.errors,
                view: 'edit'

            return
        }

        flash.message =
            'Category updated successfully.'

        redirect action: 'show',
                 id: category.id
    }

    @Secured(['ROLE_ADMIN'])
    def delete(Long id) {

        if (!id) {
            notFound()
            return
        }

        Category category =
            categoryService.get(id)

        if (!category) {
            notFound()
            return
        }

        Long bookCount =
            Book.countByCategory(category)

        /*
         * Preserve category history when books
         * are already associated with it.
         */
        if (bookCount > 0) {

            category.active = false

            categoryService.save(category)

            flash.message =
                'Category is used by existing books, so it was deactivated instead of deleted.'

            redirect action: 'index'
            return
        }

        categoryService.delete(id)

        flash.message =
            'Category deleted successfully.'

        redirect action: 'index'
    }

    private boolean isAdmin(User user) {

        user?.authorities
            *.authority
            .contains('ROLE_ADMIN')
    }

    protected void notFound() {

        flash.message =
            'Category not found.'

        redirect action: 'index'
    }
}