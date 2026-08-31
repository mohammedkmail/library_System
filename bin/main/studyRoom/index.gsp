<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Study Rooms</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1 class="page-title">Study Rooms</h1>

        <g:link
            action="create"
            class="btn btn-primary">
            Add Study Room
        </g:link>

    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <div class="card shadow-sm">

        <div class="card-body">

            <f:table
                class="table table-striped table-hover align-middle"
                controller="studyRoom"
                collection="${studyRoomList}"
            />

        </div>

    </div>

    <g:if test="${studyRoomCount > params.int('max')}">

        <div class="mt-3">

            <g:paginate
                total="${studyRoomCount ?: 0}"
            />

        </div>

    </g:if>

</div>

</body>
</html>