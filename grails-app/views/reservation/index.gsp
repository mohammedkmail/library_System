<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>
        ${isAdmin ? 'Book Reservations' : 'My Reservations'}
    </title>

</head>

<body>


<div class="container py-5">


    <!-- HEADER -->

    <div class="d-flex flex-column flex-lg-row
                justify-content-between align-items-lg-end
                gap-3 mb-5">

        <div>

            <div class="text-uppercase small fw-semibold text-muted mb-2">

                ${isAdmin ?
                    'Circulation'
                    :
                    'My Library'}

            </div>

            <h1 class="display-6 fw-semibold mb-2">

                ${isAdmin ?
                    'Book Reservations'
                    :
                    'My Book Reservations'}

            </h1>


            <p class="text-muted mb-0">

                <g:if test="${isAdmin}">
                    Prepare physical copies for waiting
                    members and record collection.
                </g:if>

                <g:else>
                    Track your physical book requests
                    and pickup status.
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

        <g:if test="${reservationList}">

            <div class="table-responsive">

                <table class="table align-middle border-top">

                    <thead>

                    <tr>

                        <th>
                            Member
                        </th>

                        <th>
                            Book
                        </th>

                        <th>
                            Requested
                        </th>

                        <th>
                            Copy
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Pickup Deadline
                        </th>

                        <th class="text-end">
                            Actions
                        </th>

                    </tr>

                    </thead>


                    <tbody>

                    <g:each in="${reservationList}"
                            var="reservation">

                        <tr>

                            <td class="fw-semibold">

                                ${reservation.user?.username}

                            </td>


                            <td>

                                <g:link controller="book"
                                        action="show"
                                        id="${reservation.book?.id}"
                                        class="text-decoration-none fw-semibold">

                                    ${reservation.book?.title}

                                </g:link>

                            </td>


                            <td>

                                <g:formatDate
                                    date="${reservation.reservationDate}"
                                    format="MMM d, yyyy HH:mm"/>

                            </td>


                            <td class="font-monospace">

                                ${reservation.assignedCopy?.copyCode ?: '—'}

                            </td>


                            <td>

                                <g:if test="${reservation.status == 'WAITING'}">

                                    <span class="badge text-bg-warning">
                                        WAITING
                                    </span>

                                </g:if>


                                <g:elseif test="${reservation.status == 'READY'}">

                                    <span class="badge text-bg-success">
                                        READY
                                    </span>

                                </g:elseif>


                                <g:elseif test="${reservation.status == 'FULFILLED'}">

                                    <span class="badge text-bg-primary">
                                        FULFILLED
                                    </span>

                                </g:elseif>


                                <g:else>

                                    <span class="badge text-bg-secondary">

                                        ${reservation.status}

                                    </span>

                                </g:else>

                            </td>


                            <td>

                                <g:if test="${reservation.readyUntil}">

                                    <g:formatDate
                                        date="${reservation.readyUntil}"
                                        format="MMM d, yyyy HH:mm"/>

                                </g:if>

                                <g:else>
                                    —
                                </g:else>

                            </td>


                            <td class="text-end">

                                <div class="d-inline-flex flex-wrap gap-2 justify-content-end">

                                    <g:link action="show"
                                            id="${reservation.id}"
                                            class="btn btn-sm btn-outline-secondary">

                                        <g:if test="${reservation.status == 'WAITING'}">
                                            Prepare
                                        </g:if>

                                        <g:else>
                                            View
                                        </g:else>

                                    </g:link>


                                    <g:if test="${reservation.status == 'READY'}">

                                        <g:form controller="reservation"
                                                action="fulfill"
                                                id="${reservation.id}"
                                                method="POST"
                                                class="d-inline">

                                            <button type="submit"
                                                    class="btn btn-sm btn-success"
                                                    onclick="return confirm('Confirm that the physical book is being handed to this member?');">

                                                Hand Over

                                            </button>

                                        </g:form>

                                    </g:if>


                                    <g:if test="${reservation.status in ['WAITING', 'READY']}">

                                        <g:form controller="reservation"
                                                action="cancel"
                                                id="${reservation.id}"
                                                method="POST"
                                                class="d-inline">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('Cancel this reservation?');">

                                                Cancel

                                            </button>

                                        </g:form>

                                    </g:if>

                                </div>

                            </td>

                        </tr>

                    </g:each>

                    </tbody>

                </table>

            </div>

        </g:if>


        <g:else>

            <div class="py-5 border-top text-center">

                <h2 class="h4">
                    No reservations
                </h2>

                <p class="text-muted mb-0">
                    Book requests will appear here
                    when members create them.
                </p>

            </div>

        </g:else>

    </g:if>



    <!-- =====================================================
         USER
    ====================================================== -->

    <g:if test="${!isAdmin}">

        <g:if test="${reservationList}">

            <div class="border-top">

                <g:each in="${reservationList}"
                        var="reservation">

                    <article class="py-4 border-bottom">

                        <div class="row align-items-center gy-3">


                            <div class="col-lg-5">

                                <div class="small text-muted mb-1">

                                    ${reservation.book?.author?.name ?: 'Library collection'}

                                </div>

                                <h2 class="h5 mb-1">

                                    <g:link controller="book"
                                            action="show"
                                            id="${reservation.book?.id}"
                                            class="text-decoration-none">

                                        ${reservation.book?.title}

                                    </g:link>

                                </h2>


                                <span class="small text-muted">

                                    Requested
                                    <g:formatDate
                                        date="${reservation.reservationDate}"
                                        format="MMM d, yyyy"/>

                                </span>

                            </div>


                            <div class="col-lg-3">

                                <div class="small text-muted mb-1">
                                    Status
                                </div>


                                <g:if test="${reservation.status == 'WAITING'}">

                                    <span class="badge text-bg-warning">
                                        Waiting
                                    </span>

                                </g:if>


                                <g:elseif test="${reservation.status == 'READY'}">

                                    <span class="badge text-bg-success">
                                        Ready for Pickup
                                    </span>

                                </g:elseif>


                                <g:elseif test="${reservation.status == 'FULFILLED'}">

                                    <span class="badge text-bg-primary">
                                        Collected
                                    </span>

                                </g:elseif>


                                <g:else>

                                    <span class="badge text-bg-secondary">

                                        ${reservation.status}

                                    </span>

                                </g:else>

                            </div>


                            <div class="col-lg-4 text-lg-end">

                                <div class="d-inline-flex gap-2">

                                    <g:link action="show"
                                            id="${reservation.id}"
                                            class="btn btn-sm btn-outline-secondary">

                                        View Details

                                    </g:link>


                                    <g:if test="${reservation.status in ['WAITING', 'READY']}">

                                        <g:form controller="reservation"
                                                action="cancel"
                                                id="${reservation.id}"
                                                method="POST"
                                                class="d-inline">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('Cancel this reservation?');">

                                                Cancel

                                            </button>

                                        </g:form>

                                    </g:if>

                                </div>

                            </div>

                        </div>


                        <g:if test="${reservation.status == 'READY' && reservation.readyUntil}">

                            <div class="mt-3 small">

                                <strong>
                                    Pickup before:
                                </strong>

                                <g:formatDate
                                    date="${reservation.readyUntil}"
                                    format="MMM d, yyyy HH:mm"/>

                            </div>

                        </g:if>

                    </article>

                </g:each>

            </div>

        </g:if>


        <g:else>

            <div class="py-5 border-top">

                <h2 class="h4">
                    No book reservations yet.
                </h2>

                <p class="text-muted">

                    When you reserve a physical book,
                    its preparation and pickup status
                    will appear here.

                </p>

                <g:link controller="book"
                        action="index"
                        class="btn btn-primary">

                    Browse Books

                </g:link>

            </div>

        </g:else>

    </g:if>

</div>


</body>

</html>