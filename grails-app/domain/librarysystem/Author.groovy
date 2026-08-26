package librarysystem

class Author {

    String name
    String biography

    static hasMany = [books: Book]

    static constraints = {
        name nullable: false, blank: false
        biography nullable: true, blank: true
    }
}