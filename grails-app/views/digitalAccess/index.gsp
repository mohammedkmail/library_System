<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>

    <title>
        ${isAdmin ? 'Digital Access Management' : 'My Digital Library'}
    </title>
</head>

<body>

<div class="container py-5">


    <div class="d-flex flex-column flex-lg-row
                justify-content-between align-items-lg-end
                gap-3 mb-5">

        <div>

            <div class="text-uppercase small fw-semibold text-muted mb-2">

                ${isAdmin ? 'Digital Access' : 'My Library'}

            </div>


            <h1 class="display-6 fw-semibold mb-2">

                ${isAdmin ?
                    'Digital Access Management'
                    :
                    'My Digital Library'}

            </h1>


            <p class="text-muted mb-0">

                <g:if test="${isAdmin}">

                    Review digital purchases and rental
                    access granted to library users.

                </g:if>

                <g:else>

                    Books you own, rent, or can read
                    through your active membership.

                </g:else>

            </p>

        </div>


        <g:link controller="book"
                action="index"
                class="btn btn-outline-primary">

            Browse Books

        </g:link>

    </div>



    <!-- =====================================================
         ADMIN
    ====================================================== -->

    <g:if test="${isAdmin}">

        <g:if test="${digitalAccessList}">

            <div class="table-responsive">

                <table class="table align-middle border-top">

                    <thead>

                    <tr>

                        <th>Member</th>

                        <th>Book</th>

                        <th>Access</th>

                        <th>Started</th>

                        <th>Expires</th>

                        <th>Status</th>

                        <th class="text-end">
                            Actions
                        </th>

                    </tr>

                    </thead>


                    <tbody>

                    <g:each in="${digitalAccessList}"
                            var="access">

                        <tr>

                            <td class="fw-semibold">

                                ${access.user?.username}

                            </td>


                            <td>

                                <g:link controller="book"
                                        action="show"
                                        id="${access.book?.id}"
                                        class="text-decoration-none fw-semibold">

                                    ${access.book?.title}

                                </g:link>

                            </td>


                            <td>

                                <g:if test="${access.accessType == 'PURCHASE'}">

                                    <span class="badge text-bg-primary">
                                        PURCHASE
                                    </span>

                                </g:if>


                                <g:else>

                                    <span class="badge text-bg-light border text-dark">
                                        ${access.accessType}
                                    </span>

                                </g:else>

                            </td>


                            <td>

                                <g:formatDate
                                    date="${access.startDate}"
                                    format="MMM d, yyyy HH:mm"/>

                            </td>


                            <td>

                                <g:if test="${access.endDate}">

                                    <g:formatDate
                                        date="${access.endDate}"
                                        format="MMM d, yyyy HH:mm"/>

                                </g:if>

                                <g:else>
                                    Permanent
                                </g:else>

                            </td>


                            <td>

                                <g:if test="${access.status == 'ACTIVE'}">

                                    <span class="badge text-bg-success">
                                        ACTIVE
                                    </span>

                                </g:if>


                                <g:else>

                                    <span class="badge text-bg-secondary">
                                        ${access.status}
                                    </span>

                                </g:else>

                            </td>


                            <td class="text-end">

                                <g:link action="show"
                                        id="${access.id}"
                                        class="btn btn-sm btn-outline-secondary">

                                    View

                                </g:link>

                            </td>

                        </tr>

                    </g:each>

                    </tbody>

                </table>

            </div>

        </g:if>


        <g:else>

            <div class="py-5 text-center border-top">

                <h2 class="h4">
                    No digital access records
                </h2>

                <p class="text-muted mb-0">
                    Digital purchases and rentals will
                    appear here.
                </p>

            </div>

        </g:else>

    </g:if>



    <!-- =====================================================
         USER DIGITAL LIBRARY
    ====================================================== -->

    <g:if test="${!isAdmin}">

        <g:if test="${digitalLibraryItems}">

            <div class="book-shelf-grid">

                <g:each in="${digitalLibraryItems}"
                        var="item">

                    <article class="book-shelf-item">

                        <g:link controller="book"
                                action="show"
                                id="${item.book?.id}"
                                class="book-cover-link">

                            <div class="book-cover-frame">

                                <g:if test="${item.book?.coverData}">

                                    <img
                                        src="${createLink(
                                            controller: 'book',
                                            action: 'cover',
                                            id: item.book.id
                                        )}"
                                        alt="${item.book?.title}"
                                        class="book-cover-image"/>

                                </g:if>


                                <g:else>

                                    <div class="book-cover-placeholder">

                                        <span>
                                            ${item.book?.title}
                                        </span>

                                    </div>

                                </g:else>

                            </div>

                        </g:link>


                        <div class="book-shelf-info">

                            <div class="small text-muted mb-1">

                                ${item.book?.author?.name ?: 'Library Collection'}

                            </div>


                            <h2 class="h5 mb-2">

                                <g:link controller="book"
                                        action="show"
                                        id="${item.book?.id}"
                                        class="text-decoration-none">

                                    ${item.book?.title}

                                </g:link>

                            </h2>



                            <div class="mb-3">

                                <g:if test="${item.source == 'PURCHASE'}">

                                    <span class="badge text-bg-primary">
                                        Owned
                                    </span>

                                </g:if>


                                <g:elseif test="${item.source == 'RENTAL'}">

                                    <span class="badge text-bg-warning">
                                        Rental
                                    </span>

                                </g:elseif>


                                <g:else>

                                    <span class="badge text-bg-success">
                                        Membership
                                    </span>

                                </g:else>

                            </div>



                            <g:if test="${item.source == 'RENTAL' && item.endDate}">

                                <div class="small text-muted mb-3">

                                    Access until

                                    <strong>

                                        <g:formatDate
                                            date="${item.endDate}"
                                            format="MMM d, yyyy HH:mm"/>

                                    </strong>

                                </div>

                            </g:if>


                            <g:elseif test="${item.source == 'PURCHASE'}">

                                <div class="small text-muted mb-3">
                                    Permanent digital access
                                </div>

                            </g:elseif>


                            <g:else>

                                <div class="small text-muted mb-3">
                                    Included with active membership
                                </div>

                            </g:else>



                            <div class="d-flex gap-2 flex-wrap">

                                <g:link action="read"
                                        params="[bookId: item.book?.id]"
                                        class="btn btn-sm btn-primary">

                                    Read Book

                                </g:link>


                                <g:if test="${item.access}">

                                    <g:link action="show"
                                            id="${item.access.id}"
                                            class="btn btn-sm btn-outline-secondary">

                                        Access Details

                                    </g:link>

                                </g:if>

                            </div>

                        </div>

                    </article>

                </g:each>

            </div>

        </g:if>


        <g:else>

            <div class="py-5 border-top">

                <div class="row">

                    <div class="col-lg-7">

                        <h2 class="h3">
                            Your digital shelf is empty.
                        </h2>

                        <p class="text-muted">

                            Purchase or rent a digital title,
                            or activate a membership to read
                            books included with membership.

                        </p>

                        <g:link controller="book"
                                action="index"
                                class="btn btn-primary">

                            Explore Digital Books

                        </g:link>

                    </div>

                </div>

            </div>

        </g:else>

    </g:if>

</div>

</body>

</html>