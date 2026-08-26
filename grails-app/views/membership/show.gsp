<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Membership Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Membership Details</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Memberships
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
                    Start Date
                </div>

                <div class="col-md-9">
                    <g:formatDate
                        date="${membership?.startDate}"
                        format="yyyy-MM-dd"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    End Date
                </div>

                <div class="col-md-9">
                    <g:formatDate
                        date="${membership?.endDate}"
                        format="yyyy-MM-dd"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Status
                </div>

                <div class="col-md-9">
                    ${membership?.status}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">
                    Price
                </div>

                <div class="col-md-9">
                    ${membership?.price}
                </div>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="row mb-3">
                    <div class="col-md-3 fw-bold">
                        User
                    </div>

                    <div class="col-md-9">
                        ${membership?.user?.username}
                    </div>
                </div>

            </sec:ifAnyGranted>

        </div>

        <g:if test="${membership?.status == 'ACTIVE'}">

            <div class="card-footer">

                <g:link
                    action="cancel"
                    id="${membership?.id}"
                    class="btn btn-outline-danger"
                    onclick="return confirm('Are you sure you want to cancel this membership?');">
                    Cancel Membership
                </g:link>

            </div>

        </g:if>

    </div>

</div>

</body>
</html>