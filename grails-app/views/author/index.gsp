<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Authors</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">Authors</h1>

        <g:link
            action="create"
            class="btn btn-primary">
            Add Author
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
                controller="author"
                collection="${authorList}"
            />

        </div>

    </div>

    <g:if test="${authorCount > params.int('max')}">

        <div class="mt-3">

            <g:paginate
                total="${authorCount ?: 0}"
            />

        </div>

    </g:if>

</div>

</body>
</html>