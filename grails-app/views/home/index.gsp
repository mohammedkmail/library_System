<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Smart Library</title>
</head>

<body>

<div class="sl-home">

    <!-- =========================================
         HERO
         ========================================= -->
    <section class="sl-hero">

        <div class="container">

            <div class="row align-items-center g-5">

                <!-- HERO CONTENT -->
                <div class="col-lg-7">

                    <div class="sl-hero-copy">

                        <span class="sl-kicker">
                            <i class="bi bi-stars"></i>
                            Your modern library experience
                        </span>

                        <h1 class="sl-hero-title">
                            Find your next
                            <span>great story.</span>
                        </h1>

                        <p class="sl-hero-description">
                            Discover physical and digital books,
                            manage your library activity and enjoy
                            everything your library offers from one place.
                        </p>


                        <!-- SEARCH -->
                        <g:form
                            controller="book"
                            action="index"
                            method="GET"
                            class="sl-hero-search">

                            <div class="sl-search-icon">
                                <i class="bi bi-search"></i>
                            </div>

                            <input
                                type="text"
                                name="search"
                                class="sl-search-input"
                                placeholder="Search by book title..."
                                autocomplete="off"/>

                            <button
                                type="submit"
                                class="sl-search-btn">

                                Search

                            </button>

                        </g:form>


                        <!-- HERO ACTIONS -->
                        <div class="sl-hero-actions">

                            <g:link
                                controller="book"
                                action="index"
                                class="btn sl-btn-primary">

                                Browse Collection
                                <i class="bi bi-arrow-right ms-2"></i>

                            </g:link>


                            <sec:ifLoggedIn>

                                <g:link
                                    controller="dashboard"
                                    action="index"
                                    class="btn sl-btn-secondary">

                                    <i class="bi bi-grid me-2"></i>
                                    My Dashboard

                                </g:link>

                            </sec:ifLoggedIn>


                            <sec:ifNotLoggedIn>

                                <g:link
                                    controller="login"
                                    action="auth"
                                    class="btn sl-btn-secondary">

                                    <i class="bi bi-person me-2"></i>
                                    Sign In

                                </g:link>

                            </sec:ifNotLoggedIn>

                        </div>


                        <!-- HERO TRUST POINTS -->
                        <div class="sl-hero-points">

                            <span>
                                <i class="bi bi-check-circle-fill"></i>
                                Physical Books
                            </span>

                            <span>
                                <i class="bi bi-check-circle-fill"></i>
                                Digital Access
                            </span>

                            <span>
                                <i class="bi bi-check-circle-fill"></i>
                                Study Spaces
                            </span>

                        </div>

                    </div>

                </div>


                <!-- HERO VISUAL -->
                <div class="col-lg-5">

                    <div class="sl-hero-visual">

                        <div class="sl-visual-glow"></div>


                        <div class="sl-featured-stack">

                            <g:if test="${featuredBooks}">

                                <g:each
                                    in="${featuredBooks.take(Math.min(3, featuredBooks.size()))}"
                                    var="book"
                                    status="i">

                                    <g:link
                                        controller="book"
                                        action="show"
                                        id="${book.id}"
                                        class="sl-stack-book sl-stack-book-${i + 1}">

                                        <g:if test="${book.coverData}">

                                            <img
                                                src="${createLink(
                                                    controller: 'book',
                                                    action: 'cover',
                                                    id: book.id
                                                )}"
                                                alt="${book.title}"/>

                                        </g:if><g:else>

                                            <div class="sl-stack-placeholder">

                                                <i class="bi bi-book"></i>

                                                <span>
                                                    ${book.title}
                                                </span>

                                            </div>

                                        </g:else>

                                    </g:link>

                                </g:each>

                            </g:if><g:else>

                                <div class="sl-empty-stack">

                                    <i class="bi bi-bookshelf"></i>

                                    <span>
                                        Your collection starts here
                                    </span>

                                </div>

                            </g:else>

                        </div>


                        <div class="sl-floating-note sl-note-one">

                            <span class="sl-note-icon">
                                <i class="bi bi-book-half"></i>
                            </span>

                            <div>
                                <strong>${totalBooks ?: 0}</strong>
                                <small>Books</small>
                            </div>

                        </div>


                        <div class="sl-floating-note sl-note-two">

                            <span class="sl-note-icon">
                                <i class="bi bi-tablet"></i>
                            </span>

                            <div>
                                <strong>${totalDigitalBooks ?: 0}</strong>
                                <small>Digital</small>
                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </section>



    <!-- =========================================
         FEATURED BOOKS
         ========================================= -->
    <section class="sl-section sl-books-section">

        <div class="container">

            <div class="sl-section-header">

                <div>

                    <span class="sl-section-label">
                        New Arrivals
                    </span>

                    <h2>
                        Discover something new
                    </h2>

                    <p>
                        Explore some of the latest titles
                        available in our collection.
                    </p>

                </div>


                <g:link
                    controller="book"
                    action="index"
                    class="sl-text-link">

                    View all books
                    <i class="bi bi-arrow-up-right"></i>

                </g:link>

            </div>


            <g:if test="${featuredBooks}">

                <div class="row g-4">

                    <g:each
                        in="${featuredBooks}"
                        var="book">

                        <div class="col-sm-6 col-lg-4 col-xl-2">

                            <g:link
                                controller="book"
                                action="show"
                                id="${book.id}"
                                class="sl-book-card">

                                <!-- COVER -->
                                <div class="sl-book-cover">

                                    <g:if test="${book.coverData}">

                                        <img
                                            src="${createLink(
                                                controller: 'book',
                                                action: 'cover',
                                                id: book.id
                                            )}"
                                            alt="${book.title}"/>

                                    </g:if><g:else>

                                        <div class="sl-book-no-cover">

                                            <i class="bi bi-book"></i>

                                            <span>
                                                No Cover
                                            </span>

                                        </div>

                                    </g:else>


                                    <div class="sl-book-overlay">

                                        <span>
                                            View Book
                                            <i class="bi bi-arrow-right"></i>
                                        </span>

                                    </div>


                                    <g:if test="${book.digitalAvailable}">

                                        <span class="sl-digital-badge">
                                            <i class="bi bi-tablet"></i>
                                            Digital
                                        </span>

                                    </g:if>

                                </div>


                                <!-- INFO -->
                                <div class="sl-book-info">

                                    <span class="sl-book-category">
                                        ${book.category?.name}
                                    </span>

                                    <h3>
                                        ${book.title}
                                    </h3>

                                    <p class="sl-book-author">
                                        ${book.author?.name}
                                    </p>


                                    <div class="sl-book-bottom">

                                        <g:if test="${book.publishYear}">
                                            <span>
                                                ${book.publishYear}
                                            </span>
                                        </g:if>


                                        <g:if test="${book.physicalSaleStock > 0}">

                                            <span class="sl-stock available">
                                                Available
                                            </span>

                                        </g:if><g:else>

                                            <span class="sl-stock unavailable">
                                                Out of stock
                                            </span>

                                        </g:else>

                                    </div>

                                </div>

                            </g:link>

                        </div>

                    </g:each>

                </div>

            </g:if><g:else>

                <div class="sl-home-empty">

                    <div class="sl-home-empty-icon">
                        <i class="bi bi-bookshelf"></i>
                    </div>

                    <h3>No books added yet</h3>

                    <p>
                        Books added to the library will appear here.
                    </p>


                    <sec:ifAnyGranted roles="ROLE_ADMIN">

                        <g:link
                            controller="book"
                            action="create"
                            class="btn sl-btn-primary">

                            <i class="bi bi-plus-lg me-2"></i>
                            Add First Book

                        </g:link>

                    </sec:ifAnyGranted>

                </div>

            </g:else>

        </div>

    </section>



    <!-- =========================================
         CATEGORIES
         ========================================= -->
    <section class="sl-section sl-category-section">

        <div class="container">

            <div class="row align-items-end g-4">

                <div class="col-lg-5">

                    <span class="sl-section-label">
                        Browse the Collection
                    </span>

                    <h2 class="sl-category-title">
                        Explore books across
                        different interests.
                    </h2>

                </div>


                <div class="col-lg-7">

                    <p class="sl-category-description">
                        From timeless classics to technology,
                        science and modern literature, discover
                        content organized around the topics you enjoy.
                    </p>

                </div>

            </div>


            <div class="sl-category-list">

                <g:if test="${featuredCategories}">

                    <g:each
                        in="${featuredCategories}"
                        var="category"
                        status="i">

                        <div class="sl-category-pill">

                            <span class="sl-category-number">
                                ${String.format('%02d', i + 1)}
                            </span>

                            <span class="sl-category-name">
                                ${category.name}
                            </span>

                            <i class="bi bi-book"></i>

                        </div>

                    </g:each>

                </g:if><g:else>

                    <div class="sl-category-pill">

                        <span class="sl-category-number">
                            01
                        </span>

                        <span class="sl-category-name">
                            Explore our collection
                        </span>

                        <i class="bi bi-book"></i>

                    </div>

                </g:else>

            </div>

        </div>

    </section>



    <!-- =========================================
         SERVICES / EXPERIENCE
         ========================================= -->
    <section class="sl-section sl-experience-section">

        <div class="container">

            <div class="sl-section-header">

                <div>

                    <span class="sl-section-label">
                        More Than Books
                    </span>

                    <h2>
                        One library. Every experience.
                    </h2>

                    <p>
                        Read, borrow, reserve and manage
                        your library activity from a single platform.
                    </p>

                </div>

            </div>


            <div class="row g-4">

                <!-- PHYSICAL -->
                <div class="col-md-6 col-xl-3">

                    <g:link
                        controller="book"
                        action="index"
                        class="sl-service-card">

                        <div class="sl-service-top">

                            <span class="sl-service-icon">
                                <i class="bi bi-book"></i>
                            </span>

                            <span class="sl-service-arrow">
                                <i class="bi bi-arrow-up-right"></i>
                            </span>

                        </div>

                        <span class="sl-service-index">
                            01
                        </span>

                        <h3>Physical Library</h3>

                        <p>
                            Discover available books and physical
                            copies across the library collection.
                        </p>

                    </g:link>

                </div>


                <!-- DIGITAL -->
                <div class="col-md-6 col-xl-3">

                    <sec:ifLoggedIn>

                        <g:link
                            controller="digitalAccess"
                            action="index"
                            class="sl-service-card">

                            <div class="sl-service-top">

                                <span class="sl-service-icon">
                                    <i class="bi bi-tablet"></i>
                                </span>

                                <span class="sl-service-arrow">
                                    <i class="bi bi-arrow-up-right"></i>
                                </span>

                            </div>

                            <span class="sl-service-index">
                                02
                            </span>

                            <h3>Digital Library</h3>

                            <p>
                                Access your purchased, rented
                                and membership digital titles.
                            </p>

                        </g:link>

                    </sec:ifLoggedIn>


                    <sec:ifNotLoggedIn>

                        <g:link
                            controller="login"
                            action="auth"
                            class="sl-service-card">

                            <div class="sl-service-top">

                                <span class="sl-service-icon">
                                    <i class="bi bi-tablet"></i>
                                </span>

                                <span class="sl-service-arrow">
                                    <i class="bi bi-arrow-up-right"></i>
                                </span>

                            </div>

                            <span class="sl-service-index">
                                02
                            </span>

                            <h3>Digital Library</h3>

                            <p>
                                Sign in to access digital books
                                available through your account.
                            </p>

                        </g:link>

                    </sec:ifNotLoggedIn>

                </div>


                <!-- BORROWING -->
                <div class="col-md-6 col-xl-3">

                    <sec:ifLoggedIn>

                        <g:link
                            controller="borrowing"
                            action="index"
                            class="sl-service-card">

                            <div class="sl-service-top">

                                <span class="sl-service-icon">
                                    <i class="bi bi-arrow-left-right"></i>
                                </span>

                                <span class="sl-service-arrow">
                                    <i class="bi bi-arrow-up-right"></i>
                                </span>

                            </div>

                            <span class="sl-service-index">
                                03
                            </span>

                            <h3>Borrowing</h3>

                            <p>
                                Keep track of borrowed books,
                                availability and due dates.
                            </p>

                        </g:link>

                    </sec:ifLoggedIn>


                    <sec:ifNotLoggedIn>

                        <g:link
                            controller="login"
                            action="auth"
                            class="sl-service-card">

                            <div class="sl-service-top">

                                <span class="sl-service-icon">
                                    <i class="bi bi-arrow-left-right"></i>
                                </span>

                                <span class="sl-service-arrow">
                                    <i class="bi bi-arrow-up-right"></i>
                                </span>

                            </div>

                            <span class="sl-service-index">
                                03
                            </span>

                            <h3>Borrowing</h3>

                            <p>
                                Sign in to manage your physical
                                book borrowing activity.
                            </p>

                        </g:link>

                    </sec:ifNotLoggedIn>

                </div>


                <!-- ROOMS -->
                <div class="col-md-6 col-xl-3">

                    <sec:ifLoggedIn>

                        <g:link
                            controller="roomReservation"
                            action="create"
                            class="sl-service-card">

                            <div class="sl-service-top">

                                <span class="sl-service-icon">
                                    <i class="bi bi-door-open"></i>
                                </span>

                                <span class="sl-service-arrow">
                                    <i class="bi bi-arrow-up-right"></i>
                                </span>

                            </div>

                            <span class="sl-service-index">
                                04
                            </span>

                            <h3>Study Rooms</h3>

                            <p>
                                Reserve a quiet study space
                                directly through the library.
                            </p>

                        </g:link>

                    </sec:ifLoggedIn>


                    <sec:ifNotLoggedIn>

                        <g:link
                            controller="login"
                            action="auth"
                            class="sl-service-card">

                            <div class="sl-service-top">

                                <span class="sl-service-icon">
                                    <i class="bi bi-door-open"></i>
                                </span>

                                <span class="sl-service-arrow">
                                    <i class="bi bi-arrow-up-right"></i>
                                </span>

                            </div>

                            <span class="sl-service-index">
                                04
                            </span>

                            <h3>Study Rooms</h3>

                            <p>
                                Sign in to find and reserve
                                a study room when you need one.
                            </p>

                        </g:link>

                    </sec:ifNotLoggedIn>

                </div>

            </div>

        </div>

    </section>



    <!-- =========================================
         STATISTICS
         ========================================= -->
    <section class="sl-stats-section">

        <div class="container">

            <div class="sl-stats-box">

                <div class="sl-stat">

                    <span class="sl-stat-value">
                        ${totalBooks ?: 0}
                    </span>

                    <span class="sl-stat-label">
                        Books
                    </span>

                </div>


                <div class="sl-stat">

                    <span class="sl-stat-value">
                        ${totalAuthors ?: 0}
                    </span>

                    <span class="sl-stat-label">
                        Authors
                    </span>

                </div>


                <div class="sl-stat">

                    <span class="sl-stat-value">
                        ${totalCategories ?: 0}
                    </span>

                    <span class="sl-stat-label">
                        Categories
                    </span>

                </div>


                <div class="sl-stat">

                    <span class="sl-stat-value">
                        ${totalDigitalBooks ?: 0}
                    </span>

                    <span class="sl-stat-label">
                        Digital Titles
                    </span>

                </div>

            </div>

        </div>

    </section>



    <!-- =========================================
         FINAL CTA
         ========================================= -->
    <section class="sl-final-section">

        <div class="container">

            <div class="sl-final-card">

                <div class="sl-final-decoration">
                    <i class="bi bi-book-half"></i>
                </div>


                <div class="sl-final-content">

                    <span class="sl-final-label">
                        Start exploring today
                    </span>

                    <h2>
                        Your next book is
                        already waiting.
                    </h2>

                    <p>
                        Search the collection, discover new titles
                        and make the most of your library.
                    </p>


                    <div class="sl-final-actions">

                        <g:link
                            controller="book"
                            action="index"
                            class="btn sl-final-primary">

                            Explore Books
                            <i class="bi bi-arrow-right ms-2"></i>

                        </g:link>


                        <sec:ifNotLoggedIn>

                            <g:link
                                controller="login"
                                action="auth"
                                class="btn sl-final-secondary">

                                Sign In

                            </g:link>

                        </sec:ifNotLoggedIn>

                    </div>

                </div>

            </div>

        </div>

    </section>

</div>

</body>
</html>