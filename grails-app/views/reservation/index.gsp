<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Book Reservations</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Book Reservations</h1>

        <g:link controller="book" action="index" class="btn btn-primary">
            Browse Books
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:if test="${reservationList}">

        <div class="table-responsive">

            <table class="table table-striped table-hover align-middle">

                <thead>
                <tr>
                    <th>Book</th>
                    <th>Reservation Date</th>
                    <th>Status</th>
                    <th>Assigned Copy</th>
                    <th>Ready Until</th>

                    <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <th>User</th>
                    </sec:ifAnyGranted>

                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <g:each in="${reservationList}" var="reservation">

                    <tr>

                        <td>
                            ${reservation.book?.title}
                        </td>

                        <td>
                            <g:formatDate
                                date="${reservation.reservationDate}"
                                format="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>
                            ${reservation.status}
                        </td>

                        <td>
                            ${reservation.assignedCopy?.id ?: '-'}
                        </td>

                        <td>
                            <g:if test="${reservation.readyUntil}">
                                <g:formatDate
                                    date="${reservation.readyUntil}"
                                    format="yyyy-MM-dd HH:mm"/>
                            </g:if>
                            <g:else>
                                -
                            </g:else>
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

                            <g:if test="${reservation.status in ['WAITING', 'READY']}">

                                <g:link
                                    action="cancel"
                                    id="${reservation.id}"
                                    class="btn btn-sm btn-outline-danger"
                                    onclick="return confirm('Cancel this reservation?');">
                                    Cancel
                                </g:link>

                            </g:if>

                            <sec:ifAnyGranted roles="ROLE_ADMIN">

                                <g:if test="${reservation.status == 'READY'}">

                                    <g:link
                                        action="fulfill"
                                        id="${reservation.id}"
                                        class="btn btn-sm btn-success">
                                        Fulfill
                                    </g:link>

                                </g:if>

                            </sec:ifAnyGranted>

                        </td>

                    </tr>

                </g:each>

                </tbody>

            </table>

        </div>

    </g:if>

    <g:else>

        <div class="alert alert-info">
            No reservations found.
        </div>

    </g:else>

</div>

</body>
</html>