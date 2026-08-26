package librarysystem

class Category {

    String name
    String description
    Boolean active = true

    static hasMany = [books: Book]

    static constraints = {
        name nullable: false, blank: false, unique: true
        description nullable: true, blank: true
        active nullable: false
    }
}