package librarysystem

class BootStrap {

    def init = { servletContext ->

        User.withTransaction {

            // =====================================================
            // ROLES
            // =====================================================

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


            // =====================================================
            // USERS
            // =====================================================

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


            // =====================================================
            // CATEGORIES
            // =====================================================

            Category programming =
                Category.findByName('Programming')

            if (!programming) {
                programming = new Category(
                    name: 'Programming',
                    description: 'Software development, programming languages and software engineering.',
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
                    description: 'Science, physics, technology and scientific discovery.',
                    active: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            Category fiction =
                Category.findByName('Fiction')

            if (!fiction) {
                fiction = new Category(
                    name: 'Fiction',
                    description: 'Novels and imaginative literary works.',
                    active: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            Category classics =
                Category.findByName('Classics')

            if (!classics) {
                classics = new Category(
                    name: 'Classics',
                    description: 'Classic literature and influential historical works.',
                    active: true
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // AUTHORS
            // =====================================================

            Author robertMartin =
                findOrCreateAuthor(
                    'Robert C. Martin',
                    'American software engineer and author known for his work on software craftsmanship and clean code.'
                )


            Author joshuaBloch =
                findOrCreateAuthor(
                    'Joshua Bloch',
                    'Software engineer and author known for his contributions to the Java platform.'
                )


            Author andrewHunt =
                findOrCreateAuthor(
                    'Andrew Hunt',
                    'Software developer and author, best known as a co-author of The Pragmatic Programmer.'
                )


            Author erichGamma =
                findOrCreateAuthor(
                    'Erich Gamma',
                    'Swiss computer scientist and software engineer known for his work on software design patterns.'
                )


            Author martinFowler =
                findOrCreateAuthor(
                    'Martin Fowler',
                    'British software developer, author and speaker known for software architecture and refactoring.'
                )


            Author georgeOrwell =
                findOrCreateAuthor(
                    'George Orwell',
                    'English novelist and essayist known for political and social commentary.'
                )


            Author fitzgerald =
                findOrCreateAuthor(
                    'F. Scott Fitzgerald',
                    'American novelist and writer associated with the Jazz Age.'
                )


            Author janeAusten =
                findOrCreateAuthor(
                    'Jane Austen',
                    'English novelist known for works exploring society, relationships and social class.'
                )


            Author maryShelley =
                findOrCreateAuthor(
                    'Mary Shelley',
                    'English novelist best known for the novel Frankenstein.'
                )


            Author stephenHawking =
                findOrCreateAuthor(
                    'Stephen Hawking',
                    'British theoretical physicist and cosmologist known for his work on black holes and cosmology.'
                )


            // =====================================================
            // BOOK 1 - CLEAN CODE
            // =====================================================

            Book cleanCode = Book.findByIsbn('9780132350884')

            if (!cleanCode) {

                cleanCode = new Book(
                    title: 'Clean Code',
                    isbn: '9780132350884',

                    description:
                        'A practical software engineering book focused on writing readable, maintainable and professional code.',

                    publishYear: 2008,

                    physicalSaleStock: 10,
                    physicalSalePrice: 25.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 15.00,
                    digitalRentalPrice: 5.00,

                    membershipIncluded: true,

                    digitalContent: '''
Clean Code

Digital Preview

Good software is not only software that works.
It should also be understandable, maintainable and easy
for other developers to improve.

This training page represents protected digital book content.
''',

                    active: true,

                    category: programming,
                    author: robertMartin
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 2 - EFFECTIVE JAVA
            // =====================================================

            Book effectiveJava = Book.findByIsbn('9780134685991')

            if (!effectiveJava) {

                effectiveJava = new Book(
                    title: 'Effective Java',
                    isbn: '9780134685991',

                    description:
                        'A guide to Java programming practices, APIs, object design and effective use of the Java language.',

                    publishYear: 2018,

                    physicalSaleStock: 8,
                    physicalSalePrice: 30.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 18.00,
                    digitalRentalPrice: 6.00,

                    membershipIncluded: false,

                    digitalContent: '''
Effective Java

Digital Preview

This training version represents a digital title available
through the Smart Library digital access system.

Access to this content is controlled by the application.
''',

                    active: true,

                    category: programming,
                    author: joshuaBloch
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 3 - THE PRAGMATIC PROGRAMMER
            // =====================================================

            Book pragmaticProgrammer =
                Book.findByIsbn('9780135957059')

            if (!pragmaticProgrammer) {

                pragmaticProgrammer = new Book(
                    title: 'The Pragmatic Programmer',
                    isbn: '9780135957059',

                    description:
                        'A software development book about practical thinking, professional habits and building maintainable software.',

                    publishYear: 2019,

                    physicalSaleStock: 6,
                    physicalSalePrice: 32.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 20.00,
                    digitalRentalPrice: 7.00,

                    membershipIncluded: true,

                    digitalContent: '''
The Pragmatic Programmer

Digital Preview

Software development involves more than writing syntax.
Professional developers continuously improve their tools,
skills and approach to solving problems.
''',

                    active: true,

                    category: programming,
                    author: andrewHunt
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 4 - DESIGN PATTERNS
            // =====================================================

            Book designPatterns =
                Book.findByIsbn('9780201633610')

            if (!designPatterns) {

                designPatterns = new Book(
                    title: 'Design Patterns',
                    isbn: '9780201633610',

                    description:
                        'A foundational software engineering book describing reusable solutions to common object-oriented design problems.',

                    publishYear: 1994,

                    physicalSaleStock: 5,
                    physicalSalePrice: 35.00,

                    digitalAvailable: false,

                    digitalPurchasePrice: null,
                    digitalRentalPrice: null,

                    membershipIncluded: false,
                    digitalContent: null,

                    active: true,

                    category: programming,
                    author: erichGamma
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 5 - REFACTORING
            // =====================================================

            Book refactoring =
                Book.findByIsbn('9780134757599')

            if (!refactoring) {

                refactoring = new Book(
                    title: 'Refactoring',
                    isbn: '9780134757599',

                    description:
                        'A software engineering book focused on improving the internal structure of existing code without changing its behavior.',

                    publishYear: 2018,

                    physicalSaleStock: 7,
                    physicalSalePrice: 34.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 19.00,
                    digitalRentalPrice: 6.50,

                    membershipIncluded: true,

                    digitalContent: '''
Refactoring

Digital Preview

Refactoring improves the internal design of software
while preserving its observable behavior.

This sample page is used by the training application.
''',

                    active: true,

                    category: programming,
                    author: martinFowler
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 6 - 1984
            // =====================================================

            Book nineteenEightyFour =
                Book.findByIsbn('9780451524935')

            if (!nineteenEightyFour) {

                nineteenEightyFour = new Book(
                    title: '1984',
                    isbn: '9780451524935',

                    description:
                        'George Orwell\'s dystopian novel about surveillance, authoritarianism, truth and individual freedom.',

                    publishYear: 1949,

                    physicalSaleStock: 12,
                    physicalSalePrice: 14.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 8.00,
                    digitalRentalPrice: 3.00,

                    membershipIncluded: true,

                    digitalContent: '''
1984

Digital Library Demonstration

This page is a demonstration of how literary digital content
can be presented inside the Smart Library reader.

The application controls access before displaying this page.
''',

                    active: true,

                    category: fiction,
                    author: georgeOrwell
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 7 - THE GREAT GATSBY
            // =====================================================

            Book greatGatsby =
                Book.findByIsbn('9780743273565')

            if (!greatGatsby) {

                greatGatsby = new Book(
                    title: 'The Great Gatsby',
                    isbn: '9780743273565',

                    description:
                        'A classic American novel exploring ambition, wealth, relationships and the American Dream.',

                    publishYear: 1925,

                    physicalSaleStock: 9,
                    physicalSalePrice: 13.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 7.00,
                    digitalRentalPrice: 2.50,

                    membershipIncluded: true,

                    digitalContent: '''
The Great Gatsby

Digital Library Demonstration

This training content represents an electronic reading page.
The final reader will display the content only to an
authorized library user.
''',

                    active: true,

                    category: classics,
                    author: fitzgerald
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 8 - PRIDE AND PREJUDICE
            // =====================================================

            Book prideAndPrejudice =
                Book.findByIsbn('9780141439518')

            if (!prideAndPrejudice) {

                prideAndPrejudice = new Book(
                    title: 'Pride and Prejudice',
                    isbn: '9780141439518',

                    description:
                        'Jane Austen\'s classic novel of family, society, relationships and social expectations.',

                    publishYear: 1813,

                    physicalSaleStock: 10,
                    physicalSalePrice: 12.00,

                    digitalAvailable: true,
                    digitalPurchasePrice: 6.00,
                    digitalRentalPrice: 2.00,

                    membershipIncluded: true,

                    digitalContent: '''
Pride and Prejudice

Digital Library Demonstration

Welcome to the Smart Library digital reader.

This page demonstrates how a book can later be divided
into chapters and formatted for comfortable online reading.
''',

                    active: true,

                    category: classics,
                    author: janeAusten
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 9 - FRANKENSTEIN
            // =====================================================

            Book frankenstein =
                Book.findByIsbn('9780141439471')

            if (!frankenstein) {

                frankenstein = new Book(
                    title: 'Frankenstein',
                    isbn: '9780141439471',

                    description:
                        'Mary Shelley\'s influential novel exploring science, responsibility, creation and human nature.',

                    publishYear: 1818,

                    physicalSaleStock: 8,
                    physicalSalePrice: 12.50,

                    digitalAvailable: true,
                    digitalPurchasePrice: 6.00,
                    digitalRentalPrice: 2.00,

                    membershipIncluded: true,

                    digitalContent: '''
Frankenstein

Digital Library Demonstration

This is sample digital content for the library application.

When the reader feature is completed, access will depend
on the current user's DigitalAccess record.
''',

                    active: true,

                    category: classics,
                    author: maryShelley
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BOOK 10 - A BRIEF HISTORY OF TIME
            // =====================================================

            Book briefHistoryOfTime =
                Book.findByIsbn('9780553380163')

            if (!briefHistoryOfTime) {

                briefHistoryOfTime = new Book(
                    title: 'A Brief History of Time',
                    isbn: '9780553380163',

                    description:
                        'A popular science book introducing major ideas in cosmology, space, time and the universe.',

                    publishYear: 1988,

                    physicalSaleStock: 6,
                    physicalSalePrice: 20.00,

                    digitalAvailable: false,

                    digitalPurchasePrice: null,
                    digitalRentalPrice: null,

                    membershipIncluded: false,
                    digitalContent: null,

                    active: true,

                    category: science,
                    author: stephenHawking
                ).save(
                    flush: true,
                    failOnError: true
                )
            }


            // =====================================================
            // BORROWING COPIES
            // =====================================================

            createCopy('CC-001', cleanCode)
            createCopy('CC-002', cleanCode)

            createCopy('EJ-001', effectiveJava)
            createCopy('EJ-002', effectiveJava)

            createCopy('PP-001', pragmaticProgrammer)
            createCopy('PP-002', pragmaticProgrammer)

            createCopy('DP-001', designPatterns)

            createCopy('RF-001', refactoring)
            createCopy('RF-002', refactoring)

            createCopy('1984-001', nineteenEightyFour)
            createCopy('1984-002', nineteenEightyFour)

            createCopy('GG-001', greatGatsby)

            createCopy('PPJ-001', prideAndPrejudice)
            createCopy('PPJ-002', prideAndPrejudice)

            createCopy('FR-001', frankenstein)
            createCopy('FR-002', frankenstein)

            createCopy('BHT-001', briefHistoryOfTime)


            // =====================================================
            // STUDY ROOMS
            // =====================================================

            createStudyRoom(
                'ROOM-101',
                4,
                5.00
            )

            createStudyRoom(
                'ROOM-102',
                6,
                7.00
            )

            createStudyRoom(
                'ROOM-201',
                8,
                9.00
            )

            createStudyRoom(
                'ROOM-202',
                12,
                12.00
            )
        }
    }


    // =========================================================
    // AUTHOR HELPER
    // =========================================================

    private Author findOrCreateAuthor(
        String name,
        String biography
    ) {

        Author author =
            Author.findByName(name)

        if (!author) {

            author = new Author(
                name: name,
                biography: biography
            ).save(
                flush: true,
                failOnError: true
            )
        }

        author
    }


    // =========================================================
    // BOOK COPY HELPER
    // =========================================================

    private void createCopy(
        String copyCode,
        Book book
    ) {

        if (!BookCopy.findByCopyCode(copyCode)) {

            new BookCopy(
                copyCode: copyCode,
                status: 'AVAILABLE',
                book: book
            ).save(
                flush: true,
                failOnError: true
            )
        }
    }


    // =========================================================
    // STUDY ROOM HELPER
    // =========================================================

    private void createStudyRoom(
        String roomNumber,
        Integer capacity,
        BigDecimal pricePerHour
    ) {

        if (!StudyRoom.findByRoomNumber(roomNumber)) {

            new StudyRoom(
                roomNumber: roomNumber,
                capacity: capacity,
                pricePerHour: pricePerHour,
                active: true
            ).save(
                flush: true,
                failOnError: true
            )
        }
    }


    def destroy = {
    }
}