<!doctype html>
<html lang="en">
<head>

    <meta http-equiv="Content-Type"
          content="text/html; charset=UTF-8"/>

    <meta http-equiv="X-UA-Compatible"
          content="IE=edge"/>

    <meta name="viewport"
          content="width=device-width, initial-scale=1"/>

    <title>
        <g:layoutTitle default="Smart Library"/>
    </title>

    <asset:link rel="icon"
                href="favicon.ico"
                type="image/x-ico"/>

    <asset:stylesheet src="application.css"/>

    <g:layoutHead/>

</head>

<body>

<!-- =====================================================
     NAVIGATION
===================================================== -->

<nav class="navbar navbar-expand-lg navbar-dark library-navbar sticky-top">

    <div class="container">

        <!-- Brand -->
        <a class="navbar-brand"
           href="${createLink(uri: '/')}">

            <span class="library-brand-name">
                Smart<span class="brand-highlight">Library</span>
            </span>

        </a>


        <!-- Mobile Toggle -->
        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#mainNavbar"
                aria-controls="mainNavbar"
                aria-expanded="false"
                aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>

        </button>


        <div class="collapse navbar-collapse"
             id="mainNavbar">


            <!-- =================================================
                 MAIN PUBLIC NAVIGATION
            ================================================== -->

            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <li class="nav-item">

                    <a class="nav-link"
                       href="${createLink(uri: '/')}">

                        Home

                    </a>

                </li>


                <li class="nav-item">

                    <g:link controller="book"
                            action="index"
                            class="nav-link">

                        Books

                    </g:link>

                </li>


                <li class="nav-item">

                    <g:link controller="category"
                            action="index"
                            class="nav-link">

                        Categories

                    </g:link>

                </li>


                <li class="nav-item">

                    <g:link controller="author"
                            action="index"
                            class="nav-link">

                        Authors

                    </g:link>

                </li>


                <!-- =================================================
                     LOGGED-IN AREA
                ================================================== -->

                <sec:ifLoggedIn>

                    <li class="nav-item">

                        <g:link controller="dashboard"
                                action="index"
                                class="nav-link">

                            Dashboard

                        </g:link>

                    </li>

                </sec:ifLoggedIn>


                <!-- =================================================
                     USER LIBRARY
                ================================================== -->

                <sec:ifAnyGranted roles="ROLE_USER">

                    <li class="nav-item dropdown">

                        <a class="nav-link dropdown-toggle"
                           href="#"
                           id="myLibraryDropdown"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">

                            My Library

                        </a>


                        <ul class="dropdown-menu library-dropdown"
                            aria-labelledby="myLibraryDropdown">


                            <li class="dropdown-header">
                                Account
                            </li>


                            <li>

                                <g:link controller="membership"
                                        action="index"
                                        class="dropdown-item">

                                    Membership

                                </g:link>

                            </li>


                            <li>
                                <hr class="dropdown-divider"/>
                            </li>


                            <li class="dropdown-header">
                                Books
                            </li>


                            <li>

                                <g:link controller="borrowing"
                                        action="index"
                                        class="dropdown-item">

                                    My Borrowings

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="reservation"
                                        action="index"
                                        class="dropdown-item">

                                    Book Reservations

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="purchase"
                                        action="index"
                                        class="dropdown-item">

                                    My Purchases

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="digitalAccess"
                                        action="index"
                                        class="dropdown-item">

                                    Digital Library

                                </g:link>

                            </li>


                            <li>
                                <hr class="dropdown-divider"/>
                            </li>


                            <li class="dropdown-header">
                                Study Rooms
                            </li>


                            <li>

                                <g:link controller="roomReservation"
                                        action="create"
                                        class="dropdown-item">

                                    Reserve a Room

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="roomReservation"
                                        action="index"
                                        class="dropdown-item">

                                    My Room Reservations

                                </g:link>

                            </li>

                        </ul>

                    </li>

                </sec:ifAnyGranted>


                <!-- =================================================
                     ADMIN MANAGEMENT
                ================================================== -->

                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <li class="nav-item dropdown">

                        <a class="nav-link dropdown-toggle"
                           href="#"
                           id="adminDropdown"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">

                            Administration

                        </a>


                        <ul class="dropdown-menu library-dropdown"
                            aria-labelledby="adminDropdown">


                            <!-- CATALOG -->

                            <li class="dropdown-header">
                                Catalog
                            </li>


                            <li>

                                <g:link controller="book"
                                        action="index"
                                        class="dropdown-item">

                                    Books

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="book"
                                        action="create"
                                        class="dropdown-item">

                                    Add Book

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="author"
                                        action="index"
                                        class="dropdown-item">

                                    Authors

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="category"
                                        action="index"
                                        class="dropdown-item">

                                    Categories

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="bookCopy"
                                        action="index"
                                        class="dropdown-item">

                                    Book Copies

                                </g:link>

                            </li>


                            <li>
                                <hr class="dropdown-divider"/>
                            </li>


                            <!-- CIRCULATION -->

                            <li class="dropdown-header">
                                Circulation
                            </li>


                            <li>

                                <g:link controller="borrowing"
                                        action="index"
                                        class="dropdown-item">

                                    Borrowings

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="reservation"
                                        action="index"
                                        class="dropdown-item">

                                    Book Reservations

                                </g:link>

                            </li>


                            <li>
                                <hr class="dropdown-divider"/>
                            </li>


                            <!-- SALES / MEMBERS -->

                            <li class="dropdown-header">
                                Accounts & Sales
                            </li>


                            <li>

                                <g:link controller="purchase"
                                        action="index"
                                        class="dropdown-item">

                                    Purchases

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="membership"
                                        action="index"
                                        class="dropdown-item">

                                    Memberships

                                </g:link>

                            </li>


                            <li>
                                <hr class="dropdown-divider"/>
                            </li>


                            <!-- ROOMS -->

                            <li class="dropdown-header">
                                Study Rooms
                            </li>


                            <li>

                                <g:link controller="studyRoom"
                                        action="index"
                                        class="dropdown-item">

                                    Manage Rooms

                                </g:link>

                            </li>


                            <li>

                                <g:link controller="roomReservation"
                                        action="index"
                                        class="dropdown-item">

                                    Room Reservations

                                </g:link>

                            </li>

                        </ul>

                    </li>

                </sec:ifAnyGranted>

            </ul>


            <!-- =================================================
                 ACCOUNT
            ================================================== -->

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

                            Login

                        </g:link>

                    </li>

                </sec:ifNotLoggedIn>

            </ul>

        </div>

    </div>

</nav>



<!-- =====================================================
     PAGE CONTENT
===================================================== -->

<main class="library-main">

    <g:if test="${flash.message}">

        <div class="container pt-3">

            <div class="alert alert-info alert-dismissible fade show"
                 role="alert">

                ${flash.message}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Close">
                </button>

            </div>

        </div>

    </g:if>

    <g:layoutBody/>

</main>



<!-- =====================================================
     FOOTER
===================================================== -->

<footer class="library-footer">

    <div class="container">

        <div class="row align-items-end gy-4">

            <div class="col-md-7">

                <div class="footer-brand">
                    Smart Library
                </div>

                <p class="footer-description mb-0">

                    Physical collections, digital reading
                    and study spaces in one library experience.

                </p>

            </div>


            <div class="col-md-5 text-md-end">

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



<!-- =====================================================
     LOADING INDICATOR
===================================================== -->

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