<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Digital Access Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1>Digital Access Details</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Digital Access
        </g:link>

    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <div class="card shadow-sm">

        <div class="card-body">

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Book
                </div>

                <div class="col-md-9">
                    ${digitalAccess?.book?.title}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Access Type
                </div>

                <div class="col-md-9">
                    ${digitalAccess?.accessType}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Start Date
                </div>

                <div class="col-md-9">
                    <g:formatDate
                        date="${digitalAccess?.startDate}"
                        format="yyyy-MM-dd HH:mm"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    End Date
                </div>

                <div class="col-md-9">

                    <g:if test="${digitalAccess?.endDate}">

                        <g:formatDate
                            date="${digitalAccess.endDate}"
                            format="yyyy-MM-dd HH:mm"/>

                    </g:if>

                    <g:else>
                        Permanent Access
                    </g:else>

                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Status
                </div>

                <div class="col-md-9">
                    ${digitalAccess?.status}
                </div>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="row mb-3">
                    <div class="col-md-3 fw-bold">
                        User
                    </div>

                    <div class="col-md-9">
                        ${digitalAccess?.user?.username}
                    </div>
                </div>

            </sec:ifAnyGranted>

        </div>

        <g:if test="${digitalAccess?.status == 'ACTIVE'}">

            <div class="card-footer">

                <g:link
                    action="read"
                    params="[bookId: digitalAccess?.book?.id]"
                    class="btn btn-success">
                    Read Digital Book
                </g:link>

            </div>

        </g:if>

    </div>

</div>

</body>
</html>