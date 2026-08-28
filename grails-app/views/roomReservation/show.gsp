<!DOCTYPE html>
<html>

<head>

    <meta name="layout" content="main"/>

    <title>
        Room Reservation Details
    </title>

</head>

<body>

<div class="container py-5">


    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">

        ← Back to Room Reservations

    </g:link>


    <div class="row g-5">


        <!-- =================================================
             ROOM
        ================================================== -->

        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                Study Room
            </div>


            <h1 class="display-6 fw-semibold mb-2">

                Room ${roomReservation?.studyRoom?.roomNumber}

            </h1>


            <g:if test="${roomReservation?.studyRoom?.capacity}">

                <p class="lead text-muted">

                    Capacity:
                    ${roomReservation.studyRoom.capacity}
                    people

                </p>

            </g:if>



            <g:if test="${roomReservation?.status == 'CONFIRMED'}">

                <span class="badge text-bg-success">
                    CONFIRMED
                </span>

            </g:if>


            <g:elseif test="${roomReservation?.status == 'COMPLETED'}">

                <span class="badge text-bg-secondary">
                    COMPLETED
                </span>

            </g:elseif>


            <g:elseif test="${roomReservation?.status == 'CANCELLED'}">

                <span class="badge text-bg-dark">
                    CANCELLED
                </span>

            </g:elseif>


            <g:else>

                <span class="badge text-bg-warning">
                    ${roomReservation?.status}
                </span>

            </g:else>


            <g:if test="${roomReservation?.status == 'CONFIRMED'}">

                <p class="text-muted mt-4">

                    Your room is reserved for the
                    scheduled period shown here.

                </p>

            </g:if>


            <g:elseif test="${roomReservation?.status == 'COMPLETED'}">

                <p class="text-muted mt-4">

                    This study room reservation
                    has already been completed.

                </p>

            </g:elseif>

        </div>



        <!-- =================================================
             DETAILS
        ================================================== -->

        <div class="col-lg-7">

            <div class="border-top">


                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <div class="row py-3 border-bottom">

                        <div class="col-sm-4 text-muted">
                            Member
                        </div>

                        <div class="col-sm-8 fw-semibold">

                            ${roomReservation?.user?.username}

                        </div>

                    </div>

                </sec:ifAnyGranted>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Study Room
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        Room ${roomReservation?.studyRoom?.roomNumber}

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Capacity
                    </div>

                    <div class="col-sm-8">

                        ${roomReservation?.studyRoom?.capacity}

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Start Time
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        <g:formatDate
                            date="${roomReservation?.startTime}"
                            format="MMMM d, yyyy HH:mm"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        End Time
                    </div>

                    <div class="col-sm-8">

                        <g:formatDate
                            date="${roomReservation?.endTime}"
                            format="MMMM d, yyyy HH:mm"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Hourly Rate
                    </div>

                    <div class="col-sm-8">

                        $<g:formatNumber
                            number="${roomReservation?.studyRoom?.pricePerHour ?: 0}"
                            minFractionDigits="2"
                            maxFractionDigits="2"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Total Price
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        $<g:formatNumber
                            number="${roomReservation?.totalPrice ?: 0}"
                            minFractionDigits="2"
                            maxFractionDigits="2"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Status
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        ${roomReservation?.status}

                    </div>

                </div>

            </div>



            <g:if test="${roomReservation?.status in ['PENDING', 'CONFIRMED'] &&
                          roomReservation?.startTime?.after(new Date())}">

                <div class="mt-4">

                    <g:form controller="roomReservation"
                            action="cancel"
                            id="${roomReservation.id}"
                            method="POST">

                        <button type="submit"
                                class="btn btn-outline-danger"
                                onclick="return confirm('Are you sure you want to cancel this room reservation?');">

                            Cancel Reservation

                        </button>

                    </g:form>

                </div>

            </g:if>

        </div>

    </div>

</div>

</body>

</html>