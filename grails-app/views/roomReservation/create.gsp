<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Reserve Study Room</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Reserve Study Room</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Reservations
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-danger">
            ${flash.message}
        </div>
    </g:if>

    <g:form action="save" method="POST">

        <div class="mb-3">
            <label class="form-label">Study Room</label>

            <g:select
                name="studyRoom.id"
                from="${librarysystem.StudyRoom.findAllByActive(true, [sort: 'roomNumber'])}"
                optionKey="id"
                optionValue="roomNumber"
                value="${roomReservation?.studyRoom?.id}"
                noSelection="['': 'Select Room']"
                class="form-select"
            />
        </div>

        <div class="mb-3">
            <label class="form-label">Start Time</label>

            <input
                type="datetime-local"
                name="startTime"
                class="form-control"
                required
            />
        </div>

        <div class="mb-3">
            <label class="form-label">End Time</label>

            <input
                type="datetime-local"
                name="endTime"
                class="form-control"
                required
            />
        </div>

        <button type="submit" class="btn btn-primary">
            Reserve Room
        </button>

    </g:form>

</div>

</body>
</html>