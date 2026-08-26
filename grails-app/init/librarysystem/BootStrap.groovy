package librarysystem

class BootStrap {

    def init = { servletContext ->

        User.withTransaction {

            // =========================
            // Roles
            // =========================

            Role adminRole = Role.findByAuthority('ROLE_ADMIN')

            if (!adminRole) {
                adminRole = new Role(
                    authority: 'ROLE_ADMIN'
                ).save(
                    flush: true,
                    failOnError: true
                )
            }

            Role userRole = Role.findByAuthority('ROLE_USER')

            if (!userRole) {
                userRole = new Role(
                    authority: 'ROLE_USER'
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =========================
            // Users
            // =========================

            User admin =
                User.findByUsername('mohammad@library.com')

            if (!admin) {
                admin = new User(
                    username: 'mohammad@library.com',
                    password: '123456',
                    enabled: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }

            if (!UserRole.exists(admin.id, adminRole.id)) {
                UserRole.create(
                    admin,
                    adminRole,
                    true
                )
            }


            User regularUser =
                User.findByUsername('ahmad@library.com')

            if (!regularUser) {
                regularUser = new User(
                    username: 'ahmad@library.com',
                    password: '123456',
                    enabled: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }

            if (!UserRole.exists(regularUser.id, userRole.id)) {
                UserRole.create(
                    regularUser,
                    userRole,
                    true
                )
            }


            // =========================
            // Categories
            // =========================

            Category programming =
                Category.findByName('Programming')

            if (!programming) {
                programming = new Category(
                    name: 'Programming',
                    description: 'Programming and software development books',
                    active: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            Category science =
                Category.findByName('Science')

            if (!science) {
                science = new Category(
                    name: 'Science',
                    description: 'Science and technology books',
                    active: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =========================
            // Authors
            // =========================

            Author robertMartin =
                Author.findByName('Robert C. Martin')

            if (!robertMartin) {
                robertMartin = new Author(
                    name: 'Robert C. Martin',
                    biography: 'Software engineering author'
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            Author joshuaBloch =
                Author.findByName('Joshua Bloch')

            if (!joshuaBloch) {
                joshuaBloch = new Author(
                    name: 'Joshua Bloch',
                    biography: 'Software engineer and Java author'
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =========================
            // Books
            // =========================

            Book cleanCode =
                Book.findByIsbn('9780132350884')

            if (!cleanCode) {
                cleanCode = new Book(
                    title: 'Clean Code',
                    isbn: '9780132350884',
                    description: 'A practical book about writing clean and maintainable code.',
                    publishYear: 2008,

                    physicalSaleStock: 10,
                    physicalSalePrice: 25.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 15.00,
                    digitalRentalPrice: 5.00,
                    membershipIncluded: true,

                    digitalContent: '''
Clean Code - Demo Digital Content

This is sample protected digital content used for the training project.

The full application checks whether the current user has permission to read this page through a digital purchase, digital rental, or active membership.
''',

                    active: true,
                    category: programming,
                    author: robertMartin
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            Book effectiveJava =
                Book.findByIsbn('9780134685991')

            if (!effectiveJava) {
                effectiveJava = new Book(
                    title: 'Effective Java',
                    isbn: '9780134685991',
                    description: 'Best practices for writing effective Java applications.',
                    publishYear: 2018,

                    physicalSaleStock: 7,
                    physicalSalePrice: 30.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 18.00,
                    digitalRentalPrice: 6.00,
                    membershipIncluded: false,

                    digitalContent: '''
Effective Java - Demo Digital Content

This page represents the protected digital version of the book in the training application.
''',

                    active: true,
                    category: programming,
                    author: joshuaBloch
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =========================
            // Borrowing Copies
            // =========================

            if (!BookCopy.findByCopyCode('CC-001')) {
                new BookCopy(
                    copyCode: 'CC-001',
                    status: 'AVAILABLE',
                    book: cleanCode
                ).save(
                    flush: true,
                    failOnError: true
                )
            }

            if (!BookCopy.findByCopyCode('CC-002')) {
                new BookCopy(
                    copyCode: 'CC-002',
                    status: 'AVAILABLE',
                    book: cleanCode
                ).save(
                    flush: true,
                    failOnError: true
                )
            }

            if (!BookCopy.findByCopyCode('EJ-001')) {
                new BookCopy(
                    copyCode: 'EJ-001',
                    status: 'AVAILABLE',
                    book: effectiveJava
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =========================
            // Study Rooms
            // =========================

            if (!StudyRoom.findByRoomNumber('ROOM-101')) {
                new StudyRoom(
                    roomNumber: 'ROOM-101',
                    capacity: 4,
                    pricePerHour: 5.00,
                    active: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }

            if (!StudyRoom.findByRoomNumber('ROOM-102')) {
                new StudyRoom(
                    roomNumber: 'ROOM-102',
                    capacity: 8,
                    pricePerHour: 8.00,
                    active: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }
        }
    }

    def destroy = {
    }
}