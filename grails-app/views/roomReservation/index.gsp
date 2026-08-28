<!DOCTYPE html>
<html>

<head>

    <meta name="layout" content="main"/>

    <title>
        Room Reservations
    </title>

</head>

<body>

<div class="container py-5">


    <div class="d-flex flex-column flex-lg-row
                justify-content-between align-items-lg-end
                gap-3 mb-5">

        <div>

            <div class="text-uppercase small fw-semibold text-muted mb-2">

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Study Rooms
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    My Library
                </sec:ifNotGranted>

            </div>


            <h1 class="display-6 fw-semibold mb-2">

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Room Reservations
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    My Room Reservations
                </sec:ifNotGranted>

            </h1>


            <p class="text-muted mb-0">

                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    Review study room bookings,
                    schedules and reservation status.

                </sec:ifAnyGranted>


                <sec:ifNotGranted roles="ROLE_ADMIN">

                    Manage your upcoming study sessions
                    and review previous room reservations.

                </sec:ifNotGranted>

            </p>

        </div>


        <sec:ifNotGranted roles="ROLE_ADMIN">

            <g:link action="create"
                    class="btn btn-primary">

                Reserve Study Room

            </g:link>

        </sec:ifNotGranted>

    </div>



    <!-- =====================================================
         ADMIN
    ====================================================== -->

    <sec:ifAnyGranted roles="ROLE_ADMIN">

        <g:if test="${roomReservationList}">

            <div class="table-responsive">

                <table class="table align-middle border-top">

                    <thead>

                    <tr>

                        <th>Member</th>

                        <th>Room</th>

                        <th>Start</th>

                        <th>End</th>

                        <th>Total</th>

                        <th>Status</th>

                        <th class="text-end">
                            Actions
                        </th>

                    </tr>

                    </thead>


                    <tbody>

                    <g:each in="${roomReservationList}"
                            var="reservation">

                        <tr>

                            <td class="fw-semibold">

                                ${reservation.user?.username}

                            </td>


                            <td>

                                Room ${reservation.studyRoom?.roomNumber}

                            </td>


                            <td>

                                <g:formatDate
                                    date="${reservation.startTime}"
                                    format="MMM d, yyyy HH:mm"/>

                            </td>


                            <td>

                                <g:formatDate
                                    date="${reservation.endTime}"
                                    format="MMM d, yyyy HH:mm"/>

                            </td>


                            <td class="fw-semibold">

                                $<g:formatNumber
                                    number="${reservation.totalPrice ?: 0}"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"/>

                            </td>


                            <td>

                                <g:if test="${reservation.status == 'CONFIRMED'}">

                                    <span class="badge text-bg-success">
                                        CONFIRMED
                                    </span>

                                </g:if>


                                <g:elseif test="${reservation.status == 'COMPLETED'}">

                                    <span class="badge text-bg-secondary">
                                        COMPLETED
                                    </span>

                                </g:elseif>


                                <g:elseif test="${reservation.status == 'CANCELLED'}">

                                    <span class="badge text-bg-dark">
                                        CANCELLED
                                    </span>

                                </g:elseif>


                                <g:else>

                                    <span class="badge text-bg-warning">
                                        ${reservation.status}
                                    </span>

                                </g:else>

                            </td>


                            <td class="text-end">

                                <g:link action="show"
                                        id="${reservation.id}"
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
                    No room reservations
                </h2>

                <p class="text-muted mb-0">
                    Study room bookings will appear here.
                </p>

            </div>

        </g:else>

    </sec:ifAnyGranted>



    <!-- =====================================================
         USER
    ====================================================== -->

    <sec:ifNotGranted roles="ROLE_ADMIN">

        <g:if test="${roomReservationList}">

            <div class="border-top">

                <g:each in="${roomReservationList}"
                        var="reservation">

                    <article class="py-4 border-bottom">

                        <div class="row align-items-center gy-3">


                            <div class="col-lg-3">

                                <div class="small text-muted mb-1">
                                    Study Room
                                </div>

                                <h2 class="h5 mb-0">

                                    Room ${reservation.studyRoom?.roomNumber}

                                </h2>

                                <g:if test="${reservation.studyRoom?.capacity}">

                                    <div class="small text-muted mt-1">

                                        Capacity:
                                        ${reservation.studyRoom.capacity}

                                    </div>

                                </g:if>

                            </div>


                            <div class="col-lg-3">

                                <div class="small text-muted">
                                    Start
                                </div>

                                <div class="fw-semibold">

                                    <g:formatDate
                                        date="${reservation.startTime}"
                                        format="MMM d, yyyy HH:mm"/>

                                </div>

                            </div>


                            <div class="col-lg-2">

                                <div class="small text-muted">
                                    Price
                                </div>

                                <div class="fw-semibold">

                                    $<g:formatNumber
                                        number="${reservation.totalPrice ?: 0}"
                                        minFractionDigits="2"
                                        maxFractionDigits="2"/>

                                </div>

                            </div>


                            <div class="col-lg-2">

                                <div class="small text-muted mb-1">
                                    Status
                                </div>


                                <g:if test="${reservation.status == 'CONFIRMED'}">

                                    <span class="badge text-bg-success">
                                        Confirmed
                                    </span>

                                </g:if>


                                <g:elseif test="${reservation.status == 'COMPLETED'}">

                                    <span class="badge text-bg-secondary">
                                        Completed
                                    </span>

                                </g:elseif>


                                <g:else>

                                    <span class="badge text-bg-dark">
                                        ${reservation.status}
                                    </span>

                                </g:else>

                            </div>


                            <div class="col-lg-2 text-lg-end">

                                <div class="d-inline-flex gap-2">

                                    <g:link action="show"
                                            id="${reservation.id}"
                                            class="btn btn-sm btn-outline-secondary">

                                        Details

                                    </g:link>


                                    <g:if test="${reservation.status in ['PENDING', 'CONFIRMED'] &&
                                                  reservation.startTime?.after(new Date())}">

                                        <g:form controller="roomReservation"
                                                action="cancel"
                                                id="${reservation.id}"
                                                method="POST"
                                                class="d-inline">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('Cancel this room reservation?');">

                                                Cancel

                                            </button>

                                        </g:form>

                                    </g:if>

                                </div>

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
                            Plan your next study session.
                        </h2>

                        <p class="text-muted">

                            Reserve an available library
                            study room for the time period
                            you need.

                        </p>

                        <g:link action="create"
                                class="btn btn-primary">

                            Reserve a Room

                        </g:link>

                    </div>

                </div>

            </div>

        </g:else>

    </sec:ifNotGranted>

</div>

</body>

</html>