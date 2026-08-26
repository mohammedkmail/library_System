<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Room Reservations</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Room Reservations</h1>

        <g:link action="create" class="btn btn-primary">
            Reserve Study Room
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:if test="${roomReservationList}">

        <div class="table-responsive">

            <table class="table table-striped table-hover align-middle">

                <thead>
                <tr>
                    <th>Study Room</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Total Price</th>
                    <th>Status</th>

                    <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <th>User</th>
                    </sec:ifAnyGranted>

                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <g:each in="${roomReservationList}" var="reservation">

                    <tr>

                        <td>
                            ${reservation.studyRoom?.roomNumber}
                        </td>

                        <td>
                            <g:formatDate
                                date="${reservation.startTime}"
                                format="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>
                            <g:formatDate
                                date="${reservation.endTime}"
                                format="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>
                            ${reservation.totalPrice}
                        </td>

                        <td>
                            ${reservation.status}
                        </td>

                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            <td>
                                ${reservation.user?.username}
                            </td>
                        </sec:ifAnyGranted>

                        <td>

                            <g:link
                                action="show"
                                id="${reservation.id}"
                                class="btn btn-sm btn-outline-primary">
                                View
                            </g:link>

                            <g:if test="${reservation.status in ['PENDING', 'CONFIRMED']}">

                                <g:link
                                    action="cancel"
                                    id="${reservation.id}"
                                    class="btn btn-sm btn-outline-danger"
                                    onclick="return confirm('Cancel this room reservation?');">
                                    Cancel
                                </g:link>

                            </g:if>

                        </td>

                    </tr>

                </g:each>

                </tbody>

            </table>

        </div>

    </g:if>

    <g:else>

        <div class="alert alert-info">
            No room reservations found.
        </div>

    </g:else>

</div>

</body>
</html>