<!doctype html>
<html lang="en">

<head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>

    <title>
        <g:layoutTitle default="Library System"/>
    </title>

    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <asset:link
        rel="icon"
        href="favicon.ico"
        type="image/x-ico"/>

    <asset:stylesheet src="application.css"/>

    <g:layoutHead/>

</head>

<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">

    <div class="container">

        <!-- Brand -->
        <a
            class="navbar-brand fw-bold"
            href="${createLink(uri: '/')}">

            Library System

        </a>

        <!-- Mobile Menu Button -->
        <button
            class="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#mainNavbar"
            aria-controls="mainNavbar"
            aria-expanded="false"
            aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>

        </button>

        <div
            class="collapse navbar-collapse"
            id="mainNavbar">

            <!-- LEFT SIDE -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <!-- Public Books -->
                <li class="nav-item">

                    <g:link
                        controller="book"
                        action="index"
                        class="nav-link">

                        Books

                    </g:link>

                </li>


                <!-- Logged-in User Links -->
                <sec:ifLoggedIn>

                    <li class="nav-item">

                        <g:link
                            controller="dashboard"
                            action="index"
                            class="nav-link">

                            Dashboard

                        </g:link>

                    </li>


                    <!-- My Library Dropdown -->
                    <li class="nav-item dropdown">

                        <a
                            class="nav-link dropdown-toggle"
                            href="#"
                            id="myLibraryDropdown"
                            role="button"
                            data-bs-toggle="dropdown"
                            aria-expanded="false">

                            My Library

                        </a>

                        <ul
                            class="dropdown-menu"
                            aria-labelledby="myLibraryDropdown">

                            <li>

                                <g:link
                                    controller="membership"
                                    action="index"
                                    class="dropdown-item">

                                    Memberships

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="borrowing"
                                    action="index"
                                    class="dropdown-item">

                                    Borrowings

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="reservation"
                                    action="index"
                                    class="dropdown-item">

                                    Book Reservations

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="purchase"
                                    action="index"
                                    class="dropdown-item">

                                    Purchases

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="digitalAccess"
                                    action="index"
                                    class="dropdown-item">

                                    Digital Books

                                </g:link>

                            </li>

                            <li>
                                <hr class="dropdown-divider"/>
                            </li>

                            <li>

                                <g:link
                                    controller="roomReservation"
                                    action="index"
                                    class="dropdown-item">

                                    Room Reservations

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="roomReservation"
                                    action="create"
                                    class="dropdown-item">

                                    Reserve Study Room

                                </g:link>

                            </li>

                        </ul>

                    </li>

                </sec:ifLoggedIn>


                <!-- ADMIN MENU -->
                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <li class="nav-item dropdown">

                        <a
                            class="nav-link dropdown-toggle"
                            href="#"
                            id="adminDropdown"
                            role="button"
                            data-bs-toggle="dropdown"
                            aria-expanded="false">

                            Manage

                        </a>

                        <ul
                            class="dropdown-menu"
                            aria-labelledby="adminDropdown">

                            <li>

                                <g:link
                                    controller="book"
                                    action="index"
                                    class="dropdown-item">

                                    Books

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="book"
                                    action="create"
                                    class="dropdown-item">

                                    Add Book

                                </g:link>

                            </li>

                            <li>
                                <hr class="dropdown-divider"/>
                            </li>

                            <li>

                                <g:link
                                    controller="author"
                                    action="index"
                                    class="dropdown-item">

                                    Authors

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="category"
                                    action="index"
                                    class="dropdown-item">

                                    Categories

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="bookCopy"
                                    action="index"
                                    class="dropdown-item">

                                    Book Copies

                                </g:link>

                            </li>

                            <li>
                                <hr class="dropdown-divider"/>
                            </li>

                            <li>

                                <g:link
                                    controller="studyRoom"
                                    action="index"
                                    class="dropdown-item">

                                    Study Rooms

                                </g:link>

                            </li>

                            <li>
                                <hr class="dropdown-divider"/>
                            </li>

                            <li>

                                <g:link
                                    controller="borrowing"
                                    action="index"
                                    class="dropdown-item">

                                    All Borrowings

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="reservation"
                                    action="index"
                                    class="dropdown-item">

                                    All Reservations

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="purchase"
                                    action="index"
                                    class="dropdown-item">

                                    All Purchases

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="membership"
                                    action="index"
                                    class="dropdown-item">

                                    All Memberships

                                </g:link>

                            </li>

                            <li>

                                <g:link
                                    controller="roomReservation"
                                    action="index"
                                    class="dropdown-item">

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

                        <span class="nav-link">

                            Welcome,
                            <strong>
                                <sec:loggedInUserInfo field="username"/>
                            </strong>

                        </span>

                    </li>

                    <li class="nav-item ms-lg-2">

                        <form
                            action="${createLink(controller: 'logout')}"
                            method="POST"
                            class="d-inline">

                            <button
                                type="submit"
                                class="btn btn-outline-light btn-sm">

                                Logout

                            </button>

                        </form>

                    </li>

                </sec:ifLoggedIn>


                <sec:ifNotLoggedIn>

                    <li class="nav-item">

                        <g:link
                            controller="login"
                            action="auth"
                            class="nav-link">

                            Login

                        </g:link>

                    </li>

                </sec:ifNotLoggedIn>

            </ul>

        </div>

    </div>

</nav>


<!-- PAGE CONTENT -->
<main class="min-vh-100">

    <g:layoutBody/>

</main>


<!-- FOOTER -->
<footer class="bg-dark text-light py-4 mt-5">

    <div class="container text-center">

        <p class="mb-1 fw-semibold">
            Smart Hybrid Library Management System
        </p>

        <small class="text-secondary">
            UBS Java Intern Training Project
        </small>

    </div>

</footer>


<!-- Loading Spinner -->
<div
    id="spinner"
    class="position-absolute top-0 end-0 p-2"
    style="display:none;">

    <div
        class="spinner-border spinner-border-sm"
        role="status">

        <span class="visually-hidden">
            Loading...
        </span>

    </div>

</div>


<asset:javascript src="application.js"/>

</body>

</html>