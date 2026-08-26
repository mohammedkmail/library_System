<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Book Copies</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1 class="page-title">Book Copies</h1>

        <g:link
            action="create"
            class="btn btn-primary">
            Add Book Copy
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
                controller="bookCopy"
                collection="${bookCopyList}"
            />

        </div>

    </div>

    <g:if test="${bookCopyCount > params.int('max')}">

        <div class="mt-3">

            <g:paginate
                total="${bookCopyCount ?: 0}"
            />

        </div>

    </g:if>

</div>

</body>
</html>