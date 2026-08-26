<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Room Reservation Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1>Room Reservation Details</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Room Reservations
        </g:link>

    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <div class="card shadow-sm">

        <div class="card-body">

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Study Room
                </div>

                <div class="col-md-9">
                    ${roomReservation?.studyRoom?.roomNumber}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Start Time
                </div>

                <div class="col-md-9">
                    <g:formatDate
                        date="${roomReservation?.startTime}"
                        format="yyyy-MM-dd HH:mm"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    End Time
                </div>

                <div class="col-md-9">
                    <g:formatDate
                        date="${roomReservation?.endTime}"
                        format="yyyy-MM-dd HH:mm"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Total Price
                </div>

                <div class="col-md-9">
                    ${roomReservation?.totalPrice}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Status
                </div>

                <div class="col-md-9">
                    ${roomReservation?.status}
                </div>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="row mb-3">
                    <div class="col-md-3 fw-bold">
                        User
                    </div>

                    <div class="col-md-9">
                        ${roomReservation?.user?.username}
                    </div>
                </div>

            </sec:ifAnyGranted>

        </div>

        <g:if test="${roomReservation?.status in ['PENDING', 'CONFIRMED']}">

            <div class="card-footer">

                <g:link
                    action="cancel"
                    id="${roomReservation?.id}"
                    class="btn btn-outline-danger"
                    onclick="return confirm('Are you sure you want to cancel this room reservation?');">
                    Cancel Reservation
                </g:link>

            </div>

        </g:if>

    </div>

</div>

</body>
</html>