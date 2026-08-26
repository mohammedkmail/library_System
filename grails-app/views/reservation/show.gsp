<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reservation Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1>Reservation Details</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Reservations
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
                <div class="col-md-3 fw-bold">Book</div>

                <div class="col-md-9">
                    ${reservation?.book?.title}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Reservation Date</div>

                <div class="col-md-9">
                    <g:formatDate
                        date="${reservation?.reservationDate}"
                        format="yyyy-MM-dd HH:mm"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Status</div>

                <div class="col-md-9">
                    ${reservation?.status}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Assigned Copy</div>

                <div class="col-md-9">
                    ${reservation?.assignedCopy?.id ?: 'Not assigned yet'}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Ready Until</div>

                <div class="col-md-9">

                    <g:if test="${reservation?.readyUntil}">

                        <g:formatDate
                            date="${reservation.readyUntil}"
                            format="yyyy-MM-dd HH:mm"/>

                    </g:if>

                    <g:else>
                        -
                    </g:else>

                </div>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="row mb-3">
                    <div class="col-md-3 fw-bold">User</div>

                    <div class="col-md-9">
                        ${reservation?.user?.username}
                    </div>
                </div>

            </sec:ifAnyGranted>

        </div>

        <g:if test="${reservation?.status in ['WAITING', 'READY']}">

            <div class="card-footer">

                <g:link
                    action="cancel"
                    id="${reservation?.id}"
                    class="btn btn-outline-danger"
                    onclick="return confirm('Are you sure you want to cancel this reservation?');">
                    Cancel Reservation
                </g:link>

                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <g:if test="${reservation?.status == 'READY'}">

                        <g:link
                            action="fulfill"
                            id="${reservation?.id}"
                            class="btn btn-success">
                            Fulfill Reservation
                        </g:link>

                    </g:if>

                </sec:ifAnyGranted>

            </div>

        </g:if>

    </div>

</div>

</body>
</html>