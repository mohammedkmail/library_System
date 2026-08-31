<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Create Book Copy</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1 class="page-title">Create Book Copy</h1>

        <g:link
            action="index"
            class="btn btn-secondary">
            Back to Book Copies
        </g:link>

    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:hasErrors bean="${bookCopy}">
        <div class="alert alert-danger">
            Please fix the errors below.
        </div>
    </g:hasErrors>

    <div class="card shadow-sm">

        <div class="card-body">

            <g:form
                resource="${bookCopy}"
                controller="bookCopy"
                method="POST">

                <fieldset class="form">

                    <f:all
                        bean="bookCopy"
                        class="row"
                        requiredClass="mb-3 required"
                        labelClass="col-sm-3 col-form-label text-sm-end"
                        divClass="col-sm-9"
                        widget-class="form-control"
                        widget-invalidClass="is-invalid"
                        widget-selectDateClass="w-auto form-select d-inline"
                        widget-checkBoxClass="form-check-input align-middle"
                    />

                </fieldset>

                <div class="mt-4">

                    <button
                        class="btn btn-primary"
                        type="submit">
                        Create Book Copy
                    </button>

                </div>

            </g:form>

        </div>

    </div>

</div>

</body>
</html>