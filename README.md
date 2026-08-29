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
- Apache Tomcat 10.1

## Database

### Development

The development environment uses MySQL.

Database:

```text
library_system
```

### Test

The test environment uses an in-memory H2 database.

```text
jdbc:h2:mem:testDb
```

The test database is automatically created and removed during test execution.

### Production

The production environment uses MySQL.

Production schema:

```text
ubs_training
```

Production database configuration is located in:

```text
grails-app/conf/application.yml
```

The production datasource supports the following environment variables:

```text
DB_USERNAME
DB_PASSWORD
DB_URL
```

Default production database URL:

```text
jdbc:mysql://localhost:3306/ubs_training?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
```

## Running Tests

Run the automated test suite with:

```bash
./gradlew test
```

A successful test run should finish with:

```text
BUILD SUCCESSFUL
```

## REST API

The application provides REST endpoints for accessing book data.

### Get Books

```http
GET /api/books
```

Supports filtering and pagination.

### Get Book

```http
GET /api/books/{id}
```

### Create Book

```http
POST /api/books
```

### Update Book

```http
PUT /api/books/{id}
```

### Delete Book

```http
DELETE /api/books/{id}
```

The REST API is protected by Spring Security where authentication is required.

---

# Deployment

## Prerequisites

Before deploying the application, make sure the following software is installed:

- Java 17
- Grails 7
- Gradle
- MySQL 8
- Apache Tomcat 10.1
- Git

> Grails 7 uses Jakarta Servlet APIs and therefore requires a compatible servlet container. Tomcat 10.1 is used instead of Tomcat 9.

## Production Database Configuration

Create the production MySQL schema:

```sql
CREATE DATABASE IF NOT EXISTS ubs_training
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

Grant the application database user access to the schema:

```sql
GRANT ALL PRIVILEGES ON ubs_training.* TO 'libraryuser'@'localhost';
FLUSH PRIVILEGES;
```

The production datasource is configured in:

```text
grails-app/conf/application.yml
```

Production configuration:

```yaml
production:
    dataSource:
        dbCreate: none
        driverClassName: com.mysql.cj.jdbc.Driver
        username: '${DB_USERNAME:libraryuser}'
        password: '${DB_PASSWORD:}'
        url: '${DB_URL:jdbc:mysql://localhost:3306/ubs_training?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC}'
```

Environment variables can be supplied when deploying to another environment:

```bash
export DB_USERNAME=libraryuser
export DB_PASSWORD=your_password
export DB_URL='jdbc:mysql://localhost:3306/ubs_training?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC'
```

Passwords should not be committed to the repository.

## Build the WAR File

From the project root directory run:

```bash
grails war
```

The production WAR file is generated in:

```text
build/libs/
```

The deployable WAR is:

```text
build/libs/LibrarySystem-0.1.war
```

A successful build should display:

```text
BUILD SUCCESSFUL
Built application to build/libs using environment: production
```

## Deploy to Tomcat

Copy the generated WAR file into the Tomcat webapps directory:

```bash
cp build/libs/LibrarySystem-0.1.war /var/lib/tomcat10/webapps/LibrarySystem.war
```

Restart Tomcat:

```bash
systemctl restart tomcat10
```

Check the Tomcat service:

```bash
systemctl status tomcat10 --no-pager
```

The service should show:

```text
Active: active (running)
```

## Application URL

After deployment, the application is available at:

```text
http://localhost:8080/LibrarySystem/
```

Login page:

```text
http://localhost:8080/LibrarySystem/login/auth
```

Example REST API endpoint:

```text
http://localhost:8080/LibrarySystem/api/books
```

## Context Path and Static Resources

The application is deployed using the following context path:

```text
/LibrarySystem
```

Grails link tags, `createLink`, and the Asset Pipeline are used so links, CSS, JavaScript, images, and other static resources work correctly when the application is deployed under a servlet container context path.

## Deployment Verification

After deployment, perform a smoke test to verify that the production application works correctly.

Verify the following:

- Login works successfully
- A new record can be created
- The dashboard loads correctly
- REST API requests return valid responses
- Database operations use the production MySQL schema
- Navigation links work correctly
- Book cover resources load correctly
- CSS and JavaScript assets load correctly
- The application works under the `/LibrarySystem` context path

## Deployment Workflow

Typical production deployment workflow:

```bash
./gradlew test
grails war
cp build/libs/LibrarySystem-0.1.war /var/lib/tomcat10/webapps/LibrarySystem.war
systemctl restart tomcat10
systemctl status tomcat10 --no-pager
```

Then open:

```text
http://localhost:8080/LibrarySystem/
```

and perform the deployment smoke test.

---

## Project Purpose

This project was developed as part of the UBS Java Intern Training Program to demonstrate the use of Java, Groovy, Grails, GORM, Spring Security, REST APIs, MySQL, testing, and production WAR deployment.