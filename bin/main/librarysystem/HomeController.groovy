package librarysystem

import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class HomeController {

    static allowedMethods = [
        index: "GET"
    ]

    def index() {

        List<Book> featuredBooks = Book.findAllByActive(
            true,
            [
                max  : 6,
                sort : 'dateCreated',
                order: 'desc'
            ]
        )

        List<Category> featuredCategories = Category.findAllByActive(
            true,
            [
                max  : 6,
                sort : 'name',
                order: 'asc'
            ]
        )

        Long totalBooks =
            Book.countByActive(true)

        Long totalAuthors =
            Author.count()

        Long totalCategories =
            Category.countByActive(true)

        Long totalDigitalBooks =
            Book.countByActiveAndDigitalAvailable(
                true,
                true
            )

        [
            featuredBooks      : featuredBooks,
            featuredCategories : featuredCategories,
            totalBooks         : totalBooks,
            totalAuthors       : totalAuthors,
            totalCategories    : totalCategories,
            totalDigitalBooks  : totalDigitalBooks
        ]
    }
}