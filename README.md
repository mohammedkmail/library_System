# LibrarySystem

## Project Title
Smart Hybrid Library Management System

## Project Description
LibrarySystem is a Grails-based library management application that combines physical library services with digital book access.

The system allows users to browse books, borrow physical copies, reserve unavailable books, purchase physical or digital books, rent digital books, access membership-included digital content, manage memberships, and reserve study rooms.

Administrators can manage books, authors, categories, book copies, study rooms, and view user activity across the system.

## Target Users

### Regular Users
Regular users can:

- Browse available books
- View book details
- Search books
- Borrow available physical book copies
- Reserve unavailable physical books
- Purchase physical books
- Purchase digital books
- Rent digital books
- Read digital books when access is available
- Use membership-included digital books
- Create and manage memberships
- View their borrowings
- View their reservations
- View their purchases
- View their digital access
- Reserve study rooms

### Administrators
Administrators can:

- Perform all regular user operations
- Create, update, and delete books
- Manage authors
- Manage categories
- Manage book copies
- Manage study rooms
- View all memberships
- View all borrowings
- View all reservations
- View all purchases
- View all room reservations

## Main Features

- Book CRUD operations
- Book search and pagination
- Author and category management
- Physical book copy management
- Book cover upload and storage using byte arrays
- MySQL LONGBLOB image storage
- Physical book borrowing
- Automatic borrowing due dates
- Late fee calculation
- Book reservation queue
- Membership management
- Physical book purchasing
- Digital book purchasing
- Digital book renting
- Digital book access control
- Membership-based digital access
- Study room reservation
- Room reservation conflict prevention
- Automatic room price calculation
- Dashboard statistics
- Role-based access control
- REST API for book CRUD operations
- API filtering and pagination
- Bootstrap-based responsive interface

## Technology Stack

- Java 17
- Groovy
- Grails 7
- GORM / Hibernate
- Spring Security Core
- MySQL
- H2
- Bootstrap
- GSP
- REST API
- Postman
- Gradle

## Database

Development database:

```text
library_system