<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Create Membership</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Create Membership</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Memberships
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-danger">
            ${flash.message}
        </div>
    </g:if>

    <g:hasErrors bean="${membership}">
        <div class="alert alert-danger">
            Please fix the errors below.
        </div>
    </g:hasErrors>

    <g:form action="save" method="POST">

        <div class="mb-3">
            <label class="form-label">Start Date</label>

            <g:field
                type="date"
                name="startDate"
                value="${membership?.startDate?.format('yyyy-MM-dd')}"
                class="form-control"
                required="true"
            />

            <g:fieldError
                bean="${membership}"
                field="startDate"
            />
        </div>

        <div class="mb-3">
            <label class="form-label">End Date</label>

            <g:field
                type="date"
                name="endDate"
                value="${membership?.endDate?.format('yyyy-MM-dd')}"
                class="form-control"
                required="true"
            />

            <g:fieldError
                bean="${membership}"
                field="endDate"
            />
        </div>

        <div class="mb-3">
            <label class="form-label">Price</label>

            <g:field
                type="number"
                name="price"
                step="0.01"
                min="0"
                value="${membership?.price}"
                class="form-control"
                required="true"
            />

            <g:fieldError
                bean="${membership}"
                field="price"
            />
        </div>

        <button
            type="submit"
            class="btn btn-primary">
            Create Membership
        </button>

    </g:form>

</div>

</body>
</html>