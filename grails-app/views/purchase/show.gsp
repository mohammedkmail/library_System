<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Purchase Details</title>
</head>

<body>

<div class="container py-5">

    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">
        ← Back to Purchases
    </g:link>

    <div class="row g-5">

        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                ${purchase?.purchaseType == 'DIGITAL'
                    ? 'Digital Purchase'
                    : 'Physical Purchase'}
            </div>

            <h1 class="display-6 fw-semibold mb-2">
                ${purchase?.book?.title}
            </h1>

            <g:if test="${purchase?.book?.author}">

                <p class="lead text-muted">
                    ${purchase.book.author.name}
                </p>

            </g:if>

            <g:if test="${purchase?.status == 'COMPLETED'}">

                <span class="badge text-bg-success">
                    COMPLETED
                </span>

            </g:if>

            <g:else>

                <span class="badge text-bg-secondary">
                    ${purchase?.status}
                </span>

            </g:else>

            <div class="mt-4">

                <g:link controller="book"
                        action="show"
                        id="${purchase?.book?.id}"
                        class="btn btn-sm btn-outline-secondary">
                    View Book
                </g:link>

            </div>

        </div>

        <div class="col-lg-7">

            <div class="border-top">

                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <div class="row py-3 border-bottom">

                        <div class="col-sm-4 text-muted">
                            Member
                        </div>

                        <div class="col-sm-8 fw-semibold">
                            ${purchase?.user?.username}
                        </div>

                    </div>

                </sec:ifAnyGranted>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Purchase Type
                    </div>

                    <div class="col-sm-8 fw-semibold">
                        ${purchase?.purchaseType}
                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Quantity
                    </div>

                    <div class="col-sm-8">
                        ${purchase?.quantity}
                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Unit Price
                    </div>

                    <div class="col-sm-8">
                        $<g:formatNumber
                            number="${purchase?.unitPrice ?: 0}"
                            minFractionDigits="2"
                            maxFractionDigits="2"/>
                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Total Amount
                    </div>

                    <div class="col-sm-8 fw-semibold">
                        $<g:formatNumber
                            number="${purchase?.totalAmount ?: 0}"
                            minFractionDigits="2"
                            maxFractionDigits="2"/>
                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Purchase Date
                    </div>

                    <div class="col-sm-8">

                        <g:formatDate
                            date="${purchase?.purchaseDate}"
                            format="MMMM d, yyyy HH:mm"/>

                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Status
                    </div>

                    <div class="col-sm-8 fw-semibold">
                        ${purchase?.status}
                    </div>

                </div>

            </div>

            <sec:ifNotGranted roles="ROLE_ADMIN">

                <g:if test="${purchase?.purchaseType == 'DIGITAL' &&
                              purchase?.status == 'COMPLETED'}">

                    <div class="mt-4">

                        <g:link controller="digitalAccess"
                                action="read"
                                params="[bookId: purchase.book?.id]"
                                class="btn btn-primary">
                            Read Digital Book
                        </g:link>

                    </div>

                </g:if>

            </sec:ifNotGranted>

        </div>

    </div>

</div>

</body>
</html>