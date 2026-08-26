<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Purchase Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1>Purchase Details</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Purchases
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
                <div class="col-md-3 fw-bold">Book</div>

                <div class="col-md-9">
                    ${purchase?.book?.title}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Purchase Type</div>

                <div class="col-md-9">
                    ${purchase?.purchaseType}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Quantity</div>

                <div class="col-md-9">
                    ${purchase?.quantity}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Unit Price</div>

                <div class="col-md-9">
                    ${purchase?.unitPrice}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Total Amount</div>

                <div class="col-md-9">
                    ${purchase?.totalAmount}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Purchase Date</div>

                <div class="col-md-9">
                    <g:formatDate
                        date="${purchase?.purchaseDate}"
                        format="yyyy-MM-dd HH:mm"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Status</div>

                <div class="col-md-9">
                    ${purchase?.status}
                </div>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="row mb-3">
                    <div class="col-md-3 fw-bold">User</div>

                    <div class="col-md-9">
                        ${purchase?.user?.username}
                    </div>
                </div>

            </sec:ifAnyGranted>

        </div>

        <g:if test="${purchase?.purchaseType == 'DIGITAL' && purchase?.status == 'COMPLETED'}">

            <div class="card-footer">

                <g:link
                    controller="digitalAccess"
                    action="read"
                    params="[bookId: purchase?.book?.id]"
                    class="btn btn-success">
                    Read Digital Book
                </g:link>

            </div>

        </g:if>

    </div>

</div>

</body>
</html>