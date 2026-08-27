<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>${book?.title}</title>
</head>

<body>

<div class="book-detail-page">

    <div class="container">

        <!-- =========================
             BREADCRUMB / BACK
             ========================= -->

        <div class="book-detail-topbar">

            <g:link
                controller="book"
                action="index"
                class="book-back-link">

                <i class="bi bi-arrow-left"></i>
                Back to collection

            </g:link>

        </div>


        <g:if test="${flash.message}">

            <div class="alert alert-info mb-4">

                <i class="bi bi-info-circle me-2"></i>
                ${flash.message}

            </div>

        </g:if>


        <!-- =========================
             MAIN BOOK AREA
             ========================= -->

        <div class="row g-5">

            <!-- COVER -->
            <div class="col-lg-4">

                <div class="book-detail-cover-panel">

                    <div class="book-detail-cover">

                        <g:if test="${book?.coverData}">

                            <img
                                src="${createLink(
                                    controller: 'book',
                                    action: 'cover',
                                    id: book.id
                                )}"
                                alt="${book?.title}"/>

                        </g:if><g:else>

                            <div class="book-detail-no-cover">

                                <i class="bi bi-book"></i>

                                <span>
                                    No Cover Available
                                </span>

                            </div>

                        </g:else>


                        <g:if test="${book?.digitalAvailable}">

                            <span class="book-detail-digital-badge">

                                <i class="bi bi-tablet"></i>
                                Digital Edition

                            </span>

                        </g:if>

                    </div>


                    <!-- QUICK AVAILABILITY -->
                    <div class="book-availability-box">

                        <div class="availability-row">

                            <span>
                                <i class="bi bi-bag"></i>
                                Physical stock
                            </span>

                            <strong>
                                ${book?.physicalSaleStock ?: 0}
                            </strong>

                        </div>


                        <div class="availability-row">

                            <span>
                                <i class="bi bi-book"></i>
                                Borrowing copies
                            </span>

                            <strong>
                                ${availableCopies?.size() ?: 0}
                            </strong>

                        </div>


                        <div class="availability-row">

                            <span>
                                <i class="bi bi-tablet"></i>
                                Digital edition
                            </span>

                            <strong class="${book?.digitalAvailable ? 'text-success' : 'text-muted'}">

                                ${book?.digitalAvailable ? 'Available' : 'Unavailable'}

                            </strong>

                        </div>

                    </div>

                </div>

            </div>


            <!-- DETAILS -->
            <div class="col-lg-8">

                <div class="book-detail-content">

                    <div class="book-detail-category">
                        ${book?.category?.name}
                    </div>


                    <h1>
                        ${book?.title}
                    </h1>


                    <div class="book-detail-author">

                        by

                        <span>
                            ${book?.author?.name}
                        </span>

                    </div>


                    <!-- BADGES -->
                    <div class="book-detail-badges">

                        <g:if test="${book?.digitalAvailable}">

                            <span class="detail-badge">

                                <i class="bi bi-tablet"></i>
                                Digital

                            </span>

                        </g:if>


                        <g:if test="${book?.membershipIncluded}">

                            <span class="detail-badge membership">

                                <i class="bi bi-person-badge"></i>
                                Membership Included

                            </span>

                        </g:if>


                        <g:if test="${availableCopies}">

                            <span class="detail-badge available">

                                <i class="bi bi-check-circle"></i>
                                Borrowing Available

                            </span>

                        </g:if>

                    </div>


                    <!-- DESCRIPTION -->
                    <div class="book-description">

                        <h5>About this book</h5>

                        <p>
                            ${book?.description ?: 'No description has been added for this book.'}
                        </p>

                    </div>


                    <!-- META -->
                    <div class="book-meta-grid">

                        <div class="book-meta-item">

                            <span class="meta-label">
                                ISBN
                            </span>

                            <strong>
                                ${book?.isbn}
                            </strong>

                        </div>


                        <div class="book-meta-item">

                            <span class="meta-label">
                                Published
                            </span>

                            <strong>
                                ${book?.publishYear ?: '-'}
                            </strong>

                        </div>


                        <div class="book-meta-item">

                            <span class="meta-label">
                                Category
                            </span>

                            <strong>
                                ${book?.category?.name}
                            </strong>

                        </div>


                        <div class="book-meta-item">

                            <span class="meta-label">
                                Status
                            </span>

                            <strong>
                                ${book?.active ? 'Active' : 'Inactive'}
                            </strong>

                        </div>

                    </div>


                    <!-- =========================
                         PRICES
                         ========================= -->

                    <div class="book-pricing">

                        <g:if test="${book?.physicalSalePrice != null}">

                            <div class="price-card">

                                <span class="price-type">
                                    Physical
                                </span>

                                <strong>
                                    ${book.physicalSalePrice}
                                </strong>

                                <small>
                                    One-time purchase
                                </small>

                            </div>

                        </g:if>


                        <g:if test="${book?.digitalPurchasePrice != null}">

                            <div class="price-card">

                                <span class="price-type">
                                    Digital
                                </span>

                                <strong>
                                    ${book.digitalPurchasePrice}
                                </strong>

                                <small>
                                    Permanent access
                                </small>

                            </div>

                        </g:if>


                        <g:if test="${book?.digitalRentalPrice != null}">

                            <div class="price-card">

                                <span class="price-type">
                                    Rental
                                </span>

                                <strong>
                                    ${book.digitalRentalPrice}
                                </strong>

                                <small>
                                    7-day access
                                </small>

                            </div>

                        </g:if>

                    </div>


                    <!-- =========================
                         USER ACTIONS
                         ========================= -->

                    <sec:ifLoggedIn>

                        <div class="book-actions-panel">

                            <div class="book-actions-heading">

                                <div>

                                    <span>
                                        Available options
                                    </span>

                                    <h4>
                                        Choose how you want to access this book
                                    </h4>

                                </div>

                            </div>


                            <!-- READ -->
                            <g:if test="${canReadDigital}">

                                <div class="read-access-banner">

                                    <div>

                                        <span class="read-access-icon">

                                            <i class="bi bi-book-half"></i>

                                        </span>

                                        <div>

                                            <strong>
                                                Digital access active
                                            </strong>

                                            <small>
                                                You can read this book now.
                                            </small>

                                        </div>

                                    </div>


                                    <g:link
                                        controller="digitalAccess"
                                        action="read"
                                        params="[bookId: book.id]"
                                        class="btn read-book-btn">

                                        <i class="bi bi-book me-2"></i>
                                        Read Digital Book

                                    </g:link>

                                </div>

                            </g:if>


                            <div class="book-action-buttons">

                                <!-- PHYSICAL PURCHASE -->
                                <g:if test="${book?.physicalSaleStock > 0 && book?.physicalSalePrice != null}">

                                    <g:form
                                        controller="purchase"
                                        action="buy"
                                        method="POST">

                                        <g:hiddenField
                                            name="bookId"
                                            value="${book.id}"/>

                                        <g:hiddenField
                                            name="purchaseType"
                                            value="PHYSICAL"/>

                                        <g:hiddenField
                                            name="quantity"
                                            value="1"/>

                                        <button
                                            type="submit"
                                            class="btn btn-primary">

                                            <i class="bi bi-bag me-2"></i>
                                            Buy Physical

                                        </button>

                                    </g:form>

                                </g:if>


                                <!-- DIGITAL PURCHASE -->
                                <g:if test="${book?.digitalAvailable && book?.digitalPurchasePrice != null}">

                                    <g:form
                                        controller="purchase"
                                        action="buy"
                                        method="POST">

                                        <g:hiddenField
                                            name="bookId"
                                            value="${book.id}"/>

                                        <g:hiddenField
                                            name="purchaseType"
                                            value="DIGITAL"/>

                                        <g:hiddenField
                                            name="quantity"
                                            value="1"/>

                                        <button
                                            type="submit"
                                            class="btn btn-dark">

                                            <i class="bi bi-tablet me-2"></i>
                                            Buy Digital

                                        </button>

                                    </g:form>

                                </g:if>


                                <!-- DIGITAL RENT -->
                                <g:if test="${book?.digitalAvailable && book?.digitalRentalPrice != null && !canReadDigital}">

                                    <g:form
                                        controller="digitalAccess"
                                        action="rent"
                                        method="POST">

                                        <g:hiddenField
                                            name="bookId"
                                            value="${book.id}"/>

                                        <g:hiddenField
                                            name="rentalDays"
                                            value="7"/>

                                        <button
                                            type="submit"
                                            class="btn btn-outline-dark">

                                            <i class="bi bi-clock-history me-2"></i>
                                            Rent for 7 Days

                                        </button>

                                    </g:form>

                                </g:if>


                                <!-- BORROW -->
                                <g:if test="${availableCopies}">

                                    <g:form
                                        controller="borrowing"
                                        action="borrow"
                                        method="POST">

                                        <g:hiddenField
                                            name="bookCopyId"
                                            value="${availableCopies[0].id}"/>

                                        <button
                                            type="submit"
                                            class="btn btn-outline-primary">

                                            <i class="bi bi-arrow-left-right me-2"></i>
                                            Borrow Physical Copy

                                        </button>

                                    </g:form>

                                </g:if><g:else>

                                    <g:link
                                        controller="reservation"
                                        action="reserve"
                                        params="[bookId: book.id]"
                                        class="btn btn-outline-warning">

                                        <i class="bi bi-bookmark me-2"></i>
                                        Reserve Physical Book

                                    </g:link>

                                </g:else>

                            </div>


                            <g:if test="${book?.membershipIncluded}">

                                <div class="membership-note">

                                    <i class="bi bi-stars"></i>

                                    <span>
                                        This digital title is included with an active membership.
                                    </span>

                                </div>

                            </g:if>

                        </div>

                    </sec:ifLoggedIn>


                    <!-- NOT LOGGED IN -->
                    <sec:ifNotLoggedIn>

                        <div class="book-login-card">

                            <div>

                                <i class="bi bi-person-circle"></i>

                            </div>

                            <div class="flex-grow-1">

                                <strong>
                                    Want to access this book?
                                </strong>

                                <p>
                                    Sign in to borrow, purchase,
                                    rent or access digital content.
                                </p>

                            </div>


                            <g:link
                                controller="login"
                                action="auth"
                                class="btn btn-primary">

                                Sign In

                            </g:link>

                        </div>

                    </sec:ifNotLoggedIn>

                </div>

            </div>

        </div>


        <!-- =========================
             ADMIN
             ========================= -->

        <sec:ifAnyGranted roles="ROLE_ADMIN">

            <div class="book-admin-actions">

                <span>
                    Admin Controls
                </span>


                <div>

                    <g:link
                        controller="book"
                        action="edit"
                        id="${book.id}"
                        class="btn btn-outline-dark">

                        <i class="bi bi-pencil me-2"></i>
                        Edit Book

                    </g:link>


                    <g:form
                        resource="${book}"
                        method="DELETE"
                        class="d-inline">

                        <button
                            type="submit"
                            class="btn btn-outline-danger"
                            onclick="return confirm('Are you sure you want to delete this book?');">

                            <i class="bi bi-trash me-2"></i>
                            Delete

                        </button>

                    </g:form>

                </div>

            </div>

        </sec:ifAnyGranted>

    </div>

</div>

</body>
</html>