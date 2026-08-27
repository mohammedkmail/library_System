<!doctype html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <title>
        <g:layoutTitle default="Library System"/>
    </title>

    <asset:link rel="icon"
                href="favicon.ico"
                type="image/x-ico"/>

    <asset:stylesheet src="application.css"/>

    <g:layoutHead/>
</head>

<body>

<!-- ==================== NAVBAR ==================== -->
<nav class="navbar navbar-expand-lg navbar-dark library-navbar sticky-top">

    <div class="container">

        <!-- Brand -->
        <a class="navbar-brand d-flex align-items-center gap-2"
           href="${createLink(uri: '/')}">

            <span class="brand-icon">
                <i class="bi bi-book-half"></i>
            </span>

            <span>
                Smart<span class="brand-highlight">Library</span>
            </span>

        </a>

        <!-- Mobile button -->
        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#mainNavbar"
                aria-controls="mainNavbar"
                aria-expanded="false"
                aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>

        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">

            <!-- LEFT SIDE -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <li class="nav-item">
                    <a class="nav-link"
                       href="${createLink(uri: '/')}">

                        <i class="bi bi-house-door me-1"></i>
                        Home

                    </a>
                </li>

                <li class="nav-item">

                    <g:link controller="book"
                            action="index"
                            class="nav-link">

                        <i class="bi bi-bookshelf me-1"></i>
                        Books

                    </g:link>

                </li>


                <!-- LOGGED IN USER -->
                <sec:ifLoggedIn>

                    <li class="nav-item">

                        <g:link controller="dashboard"
                                action="index"
                                class="nav-link">

                            <i class="bi bi-grid me-1"></i>
                            Dashboard

                        </g:link>

                    </li>


                    <!-- MY LIBRARY -->
                    <li class="nav-item dropdown">

                        <a class="nav-link dropdown-toggle"
                           href="#"
                           id="myLibraryDropdown"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">

                            <i class="bi bi-collection me-1"></i>
                            My Library

                        </a>

                        <ul class="dropdown-menu library-dropdown"
                            aria-labelledby="myLibraryDropdown">

                            <li class="dropdown-header">
                                Library Activity
                            </li>

                            <li>
                                <g:link controller="membership"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-person-badge me-2"></i>
                                    Memberships

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="borrowing"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-arrow-left-right me-2"></i>
                                    Borrowings

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="reservation"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-bookmark me-2"></i>
                                    Book Reservations

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="purchase"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-bag me-2"></i>
                                    Purchases

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="digitalAccess"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-tablet me-2"></i>
                                    Digital Books

                                </g:link>
                            </li>

                            <li>
                                <hr class="dropdown-divider"/>
                            </li>

                            <li>
                                <g:link controller="roomReservation"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-calendar-check me-2"></i>
                                    Room Reservations

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="roomReservation"
                                        action="create"
                                        class="dropdown-item">

                                    <i class="bi bi-plus-circle me-2"></i>
                                    Reserve Study Room

                                </g:link>
                            </li>

                        </ul>

                    </li>

                </sec:ifLoggedIn>


                <!-- ADMIN -->
                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <li class="nav-item dropdown">

                        <a class="nav-link dropdown-toggle"
                           href="#"
                           id="adminDropdown"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">

                            <i class="bi bi-gear me-1"></i>
                            Manage

                        </a>

                        <ul class="dropdown-menu library-dropdown"
                            aria-labelledby="adminDropdown">

                            <li class="dropdown-header">
                                Catalog
                            </li>

                            <li>
                                <g:link controller="book"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-book me-2"></i>
                                    Books

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="book"
                                        action="create"
                                        class="dropdown-item">

                                    <i class="bi bi-plus-circle me-2"></i>
                                    Add Book

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="author"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-person me-2"></i>
                                    Authors

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="category"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-tags me-2"></i>
                                    Categories

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="bookCopy"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-copy me-2"></i>
                                    Book Copies

                                </g:link>
                            </li>

                            <li>
                                <hr class="dropdown-divider"/>
                            </li>

                            <li class="dropdown-header">
                                Library Management
                            </li>

                            <li>
                                <g:link controller="studyRoom"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-door-open me-2"></i>
                                    Study Rooms

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="borrowing"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-arrow-left-right me-2"></i>
                                    All Borrowings

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="reservation"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-bookmark me-2"></i>
                                    All Reservations

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="purchase"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-bag me-2"></i>
                                    All Purchases

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="membership"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-people me-2"></i>
                                    All Memberships

                                </g:link>
                            </li>

                            <li>
                                <g:link controller="roomReservation"
                                        action="index"
                                        class="dropdown-item">

                                    <i class="bi bi-calendar3 me-2"></i>
                                    All Room Reservations

                                </g:link>
                            </li>

                        </ul>

                    </li>

                </sec:ifAnyGranted>

            </ul>


            <!-- RIGHT SIDE -->
            <ul class="navbar-nav ms-auto align-items-lg-center">

                <sec:ifLoggedIn>

                    <li class="nav-item">

                        <span class="nav-link user-welcome">

                            <span class="user-avatar">
                                <i class="bi bi-person-fill"></i>
                            </span>

                            <span class="d-none d-xl-inline">
                                <sec:loggedInUserInfo field="username"/>
                            </span>

                        </span>

                    </li>

                    <li class="nav-item ms-lg-2">

                        <form action="${createLink(controller: 'logout')}"
                              method="POST"
                              class="d-inline">

                            <button type="submit"
                                    class="btn btn-outline-light btn-sm logout-btn">

                                <i class="bi bi-box-arrow-right me-1"></i>
                                Logout

                            </button>

                        </form>

                    </li>

                </sec:ifLoggedIn>


                <sec:ifNotLoggedIn>

                    <li class="nav-item">

                        <g:link controller="login"
                                action="auth"
                                class="btn btn-light login-btn">

                            <i class="bi bi-person me-1"></i>
                            Login

                        </g:link>

                    </li>

                </sec:ifNotLoggedIn>

            </ul>

        </div>

    </div>

</nav>


<!-- ==================== PAGE CONTENT ==================== -->
<main class="library-main">

    <g:layoutBody/>

</main>


<!-- ==================== FOOTER ==================== -->
<footer class="library-footer">

    <div class="container">

        <div class="row align-items-center gy-4">

            <div class="col-md-6">

                <div class="footer-brand">

                    <i class="bi bi-book-half me-2"></i>
                    Smart Library

                </div>

                <p class="footer-description mb-0">
                    A modern hybrid library management system for
                    physical and digital resources.
                </p>

            </div>

            <div class="col-md-6 text-md-end">

                <p class="mb-1">
                    UBS Java Intern Training Project
                </p>

                <small>
                    Library Management System
                </small>

            </div>

        </div>

    </div>

</footer>


<!-- Loading Spinner -->
<div id="spinner"
     class="position-fixed top-0 end-0 p-3"
     style="display:none; z-index:2000;">

    <div class="spinner-border spinner-border-sm"
         role="status">

        <span class="visually-hidden">
            Loading...
        </span>

    </div>

</div>


<asset:javascript src="application.js"/>

</body>
</html>