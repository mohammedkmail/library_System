<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>${book?.title}</title>
</head>

<body>

<div class="book-detail-page">

    <div class="container py-5">

        <g:link
            controller="book"
            action="index"
            class="back-link">

            ← Back to collection

        </g:link>


        <div class="row g-5 mt-1">


            <!-- =========================
                 COVER / AVAILABILITY
                 ========================= -->

            <div class="col-lg-4">

                <div class="book-detail-cover">

                    <g:if test="${book?.coverData}">

                        <img
                            src="${createLink(
                                controller: 'book',
                                action: 'cover',
                                id: book.id
                            )}"
                            alt="${book.title}"
                            class="book-cover-image"
                        />

                    </g:if>

                    <g:else>

                        <div class="book-cover-placeholder">

                            <span>
                                ${book?.title}
                            </span>

                        </div>

                    </g:else>

                </div>


                <div class="border-top mt-4">

                    <div class="d-flex justify-content-between
                                py-3 border-bottom">

                        <span class="text-muted">
                            Lending copies
                        </span>

                        <strong>
                            ${physicalCopyCount ?: 0}
                        </strong>

                    </div>


                    <div class="d-flex justify-content-between
                                py-3 border-bottom">

                        <span class="text-muted">
                            Available now
                        </span>

                        <strong>
                            ${availableCopies?.size() ?: 0}
                        </strong>

                    </div>


                    <div class="d-flex justify-content-between
                                py-3 border-bottom">

                        <span class="text-muted">
                            Physical sale stock
                        </span>

                        <strong>
                            ${book?.physicalSaleStock ?: 0}
                        </strong>

                    </div>

                </div>

            </div>



            <!-- =========================
                 BOOK INFORMATION
                 ========================= -->

            <div class="col-lg-8">

                <div class="section-eyebrow">

                    ${book?.category?.name}

                </div>


                <h1 class="display-5 fw-semibold mb-2">

                    ${book?.title}

                </h1>


                <p class="lead text-muted">

                    by

                    <g:link
                        controller="author"
                        action="show"
                        id="${book?.author?.id}"
                        class="text-decoration-none">

                        ${book?.author?.name}

                    </g:link>

                </p>



                <!-- BADGES -->

                <div class="d-flex flex-wrap gap-2 my-4">

                    <g:if test="${book?.digitalAvailable}">

                        <span class="status-badge">
                            Digital Edition
                        </span>

                    </g:if>


                    <g:if test="${book?.membershipIncluded}">

                        <span class="status-badge">
                            Membership Included
                        </span>

                    </g:if>


                    <g:if test="${availableCopies}">

                        <span class="status-badge status-active">
                            Lending Copy Available
                        </span>

                    </g:if>


                    <g:if test="${isAdmin && !book?.active}">

                        <span class="status-badge status-inactive">
                            Inactive
                        </span>

                    </g:if>

                </div>



                <!-- DESCRIPTION -->

                <div class="book-description mb-5">

                    <h2 class="h5">
                        About this book
                    </h2>

                    <p class="text-muted">

                        ${book?.description ?:
                            'No description has been added for this book.'}

                    </p>

                </div>



                <!-- META -->

                <div class="row g-3 mb-5">

                    <div class="col-sm-4">

                        <div class="small text-muted">
                            ISBN
                        </div>

                        <strong>
                            ${book?.isbn ?: '—'}
                        </strong>

                    </div>


                    <div class="col-sm-4">

                        <div class="small text-muted">
                            Published
                        </div>

                        <strong>
                            ${book?.publishYear ?: '—'}
                        </strong>

                    </div>


                    <div class="col-sm-4">

                        <div class="small text-muted">
                            Category
                        </div>

                        <strong>
                            ${book?.category?.name ?: '—'}
                        </strong>

                    </div>

                </div>



                <!-- =========================
                     PRICES
                     ========================= -->

                <div class="border-top mb-5">

                    <g:if test="${book?.physicalSalePrice != null}">

                        <div class="row py-3 border-bottom">

                            <div class="col">
                                Physical purchase
                            </div>

                            <div class="col-auto fw-semibold">

                                $<g:formatNumber
                                    number="${book.physicalSalePrice}"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"
                                />

                            </div>

                        </div>

                    </g:if>


                    <g:if test="${book?.digitalAvailable &&
                                  book?.digitalPurchasePrice != null}">

                        <div class="row py-3 border-bottom">

                            <div class="col">
                                Permanent digital purchase
                            </div>

                            <div class="col-auto fw-semibold">

                                $<g:formatNumber
                                    number="${book.digitalPurchasePrice}"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"
                                />

                            </div>

                        </div>

                    </g:if>


                    <g:if test="${book?.digitalAvailable &&
                                  book?.digitalRentalPrice != null}">

                        <div class="row py-3 border-bottom">

                            <div class="col">
                                7-day digital rental
                            </div>

                            <div class="col-auto fw-semibold">

                                $<g:formatNumber
                                    number="${book.digitalRentalPrice}"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"
                                />

                            </div>

                        </div>

                    </g:if>

                </div>



                <!-- =========================
                     USER OPTIONS
                     ========================= -->

                <g:if test="${libraryUser}">

                    <section class="border-top pt-4">

                        <div class="section-eyebrow">
                            Available Options
                        </div>


                        <h2 class="h4 mb-4">
                            Access this book
                        </h2>



                        <!-- DIGITAL READ -->

                        <g:if test="${canReadDigital}">

                            <div class="p-4 border mb-4">

                                <div class="d-flex flex-column
                                            flex-md-row
                                            justify-content-between
                                            align-items-md-center
                                            gap-3">

                                    <div>

                                        <strong class="d-block">
                                            Digital access active
                                        </strong>

                                        <span class="text-muted">
                                            You can read this book now.
                                        </span>

                                    </div>


                                    <g:link
                                        controller="digitalAccess"
                                        action="read"
                                        params="[bookId: book.id]"
                                        class="btn btn-primary">

                                        Read Digital Book

                                    </g:link>

                                </div>

                            </div>

                        </g:if>



                        <!-- PURCHASE / RENT -->

                        <div class="d-flex flex-wrap gap-2 mb-4">


                            <!-- PHYSICAL PURCHASE -->

                            <g:if test="${(book?.physicalSaleStock ?: 0) > 0 &&
                                          book?.physicalSalePrice != null}">

                                <g:form
                                    controller="purchase"
                                    action="buy"
                                    method="POST">

                                    <g:hiddenField
                                        name="bookId"
                                        value="${book.id}"
                                    />

                                    <g:hiddenField
                                        name="purchaseType"
                                        value="PHYSICAL"
                                    />

                                    <g:hiddenField
                                        name="quantity"
                                        value="1"
                                    />

                                    <button
                                        type="submit"
                                        class="btn btn-outline-dark">

                                        Buy Physical

                                    </button>

                                </g:form>

                            </g:if>



                            <!-- DIGITAL PURCHASE -->

                            <g:if test="${book?.digitalAvailable &&
                                          book?.digitalPurchasePrice != null &&
                                          !ownsDigital}">

                                <g:form
                                    controller="purchase"
                                    action="buy"
                                    method="POST">

                                    <g:hiddenField
                                        name="bookId"
                                        value="${book.id}"
                                    />

                                    <g:hiddenField
                                        name="purchaseType"
                                        value="DIGITAL"
                                    />

                                    <g:hiddenField
                                        name="quantity"
                                        value="1"
                                    />

                                    <button
                                        type="submit"
                                        class="btn btn-outline-dark">

                                        Buy Digital

                                    </button>

                                </g:form>

                            </g:if>



                            <!-- DIGITAL RENT -->

                            <g:if test="${book?.digitalAvailable &&
                                          book?.digitalRentalPrice != null &&
                                          !canReadDigital}">

                                <g:form
                                    controller="digitalAccess"
                                    action="rent"
                                    method="POST">

                                    <g:hiddenField
                                        name="bookId"
                                        value="${book.id}"
                                    />

                                    <g:hiddenField
                                        name="rentalDays"
                                        value="7"
                                    />

                                    <button
                                        type="submit"
                                        class="btn btn-outline-dark">

                                        Rent for 7 Days

                                    </button>

                                </g:form>

                            </g:if>

                        </div>



                        <!-- =========================
                             PHYSICAL RESERVATION
                             ========================= -->

                        <div class="border-top pt-4">

                            <h3 class="h5">
                                Library Lending
                            </h3>



                            <!-- ALREADY RESERVED -->

                            <g:if test="${currentReservation}">

                                <div class="p-3 border mt-3">

                                    <div class="small text-muted mb-1">
                                        Current reservation
                                    </div>

                                    <strong>
                                        ${currentReservation.status}
                                    </strong>


                                    <g:if test="${currentReservation.status == 'READY'}">

                                        <div class="small text-muted mt-1">

                                            Ready for pickup

                                            <g:if test="${currentReservation.readyUntil}">

                                                until

                                                <g:formatDate
                                                    date="${currentReservation.readyUntil}"
                                                    format="MMM d, yyyy HH:mm"
                                                />

                                            </g:if>

                                        </div>

                                    </g:if>


                                    <div class="mt-3">

                                        <g:link
                                            controller="reservation"
                                            action="show"
                                            id="${currentReservation.id}"
                                            class="btn btn-sm btn-outline-secondary">

                                            Reservation Details

                                        </g:link>

                                    </div>

                                </div>

                            </g:if>



                            <!-- CAN RESERVE -->

                            <g:if test="${!currentReservation && physicalCopyCount > 0}">

                                <g:if test="${hasActiveMembership}">

                                    <p class="text-muted">

                                        Reserve this title.
                                        Library staff will assign
                                        a physical copy and prepare
                                        it for pickup.

                                    </p>


                                    <g:form
                                        controller="reservation"
                                        action="reserve"
                                        method="POST">

                                        <g:hiddenField
                                            name="bookId"
                                            value="${book.id}"
                                        />

                                        <button
                                            type="submit"
                                            class="btn btn-primary">

                                            Reserve Physical Book

                                        </button>

                                    </g:form>

                                </g:if>



                                <!-- NO MEMBERSHIP -->

                                <g:if test="${!hasActiveMembership}">

                                    <p class="text-muted">

                                        An active membership is
                                        required to reserve and
                                        borrow physical books.

                                    </p>


                                    <g:link
                                        controller="membership"
                                        action="create"
                                        class="btn btn-outline-primary">

                                        Get Membership

                                    </g:link>

                                </g:if>

                            </g:if>



                            <!-- NO LENDING COPIES -->

                            <g:if test="${!currentReservation && physicalCopyCount <= 0}">

                                <p class="text-muted mb-0">

                                    This title currently has no
                                    library lending copies.

                                </p>

                            </g:if>

                        </div>



                        <!-- MEMBERSHIP NOTE -->

                        <g:if test="${book?.membershipIncluded}">

                            <div class="small text-muted mt-4">

                                This digital edition is included
                                while your library membership
                                remains active.

                            </div>

                        </g:if>

                    </section>

                </g:if>



                <!-- =========================
                     NOT LOGGED IN
                     ========================= -->

                <sec:ifNotLoggedIn>

                    <div class="border-top pt-4">

                        <h2 class="h5">
                            Sign in to access this book
                        </h2>

                        <p class="text-muted">

                            Sign in to reserve books,
                            purchase editions, rent digital
                            titles or read your digital library.

                        </p>

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



        <!-- =========================
             ADMIN CONTROLS
             ========================= -->

        <sec:ifAnyGranted roles="ROLE_ADMIN">

            <div class="border-top mt-5 pt-4">

                <div class="d-flex flex-column
                            flex-md-row
                            justify-content-between
                            align-items-md-center
                            gap-3">

                    <div>

                        <div class="section-eyebrow">
                            Administration
                        </div>

                        <strong>
                            Book Management
                        </strong>

                    </div>


                    <div class="d-flex gap-2">

                        <g:link
                            action="edit"
                            id="${book.id}"
                            class="btn btn-outline-dark">

                            Edit Book

                        </g:link>


                        <g:form
                            controller="book"
                            action="delete"
                            id="${book.id}"
                            method="DELETE">

                            <button
                                type="submit"
                                class="btn btn-outline-danger"
                                onclick="return confirm('Delete this book? If it has system history it will be deactivated instead.');">

                                Delete / Deactivate

                            </button>

                        </g:form>

                    </div>

                </div>

            </div>

        </sec:ifAnyGranted>

    </div>

</div>

</body>

</html>