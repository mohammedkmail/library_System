<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Category Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1 class="page-title">Category Details</h1>

        <g:link
            action="index"
            class="btn btn-secondary">
            Back to Categories
        </g:link>

    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-success">
            ${flash.message}
        </div>
    </g:if>

    <div class="card shadow-sm">

        <div class="card-body">

            <f:display
                bean="category"
                listClass="container"
                listItemClass="row mb-3"
                labelClass="form-label col-sm-3 text-sm-end fw-semibold"
                valueClass="col-sm-9"
            />

        </div>

    </div>

    <sec:ifAnyGranted roles="ROLE_ADMIN">

        <div class="mt-4 d-flex gap-2">

            <g:link
                action="edit"
                id="${category.id}"
                class="btn btn-warning">
                Edit
            </g:link>

            <g:form
                resource="${category}"
                controller="category"
                method="DELETE"
                class="d-inline">

                <button
                    class="btn btn-danger"
                    type="submit"
                    onclick="return confirm('Are you sure you want to delete this category?');">
                    Delete
                </button>

            </g:form>

        </div>

    </sec:ifAnyGranted>

</div>

</body>
</html>