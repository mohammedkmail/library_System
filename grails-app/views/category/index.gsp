<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Categories</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1 class="page-title">Categories</h1>

        <g:link
            action="create"
            class="btn btn-primary">
            Add Category
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
                controller="category"
                collection="${categoryList}"
            />

        </div>

    </div>

    <g:if test="${categoryCount > params.int('max')}">

        <div class="mt-3">

            <g:paginate
                total="${categoryCount ?: 0}"
            />

        </div>

    </g:if>

</div>

</body>
</html>