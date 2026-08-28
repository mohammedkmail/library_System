<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Purchases</title>
</head>

<body>

<div class="container py-5">

    <div class="d-flex flex-column flex-lg-row
                justify-content-between align-items-lg-end
                gap-3 mb-5">

        <div>

            <div class="text-uppercase small fw-semibold text-muted mb-2">

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Sales
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    My Library
                </sec:ifNotGranted>

            </div>

            <h1 class="display-6 fw-semibold mb-2">

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Purchases
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    My Purchases
                </sec:ifNotGranted>

            </h1>

            <p class="text-muted mb-0">

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Review physical and digital sales
                    recorded by the library.
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    Review your physical purchases and
                    digital books you own.
                </sec:ifNotGranted>

            </p>

        </div>

        <g:link controller="book"
                action="index"
                class="btn btn-outline-primary">
            Browse Books
        </g:link>

    </div>


    <sec:ifAnyGranted roles="ROLE_ADMIN">

        <g:if test="${purchaseList}">

            <div class="table-responsive">

                <table class="table align-middle border-top">

                    <thead>

                    <tr>
                        <th>Member</th>
                        <th>Book</th>
                        <th>Type</th>
                        <th>Qty</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>

                    </thead>

                    <tbody>

                    <g:each in="${purchaseList}" var="purchase">

                        <tr>

                            <td class="fw-semibold">
                                ${purchase.user?.username}
                            </td>

                            <td>

                                <g:link controller="book"
                                        action="show"
                                        id="${purchase.book?.id}"
                                        class="text-decoration-none fw-semibold">
                                    ${purchase.book?.title}
                                </g:link>

                            </td>

                            <td>

                                <g:if test="${purchase.purchaseType == 'DIGITAL'}">

                                    <span class="badge text-bg-primary">
                                        DIGITAL
                                    </span>

                                </g:if>

                                <g:else>

                                    <span class="badge text-bg-light border text-dark">
                                        PHYSICAL
                                    </span>

                                </g:else>

                            </td>

                            <td>
                                ${purchase.quantity}
                            </td>

                            <td>
                                $<g:formatNumber
                                    number="${purchase.unitPrice ?: 0}"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"/>
                            </td>

                            <td class="fw-semibold">
                                $<g:formatNumber
                                    number="${purchase.totalAmount ?: 0}"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"/>
                            </td>

                            <td>
                                <g:formatDate
                                    date="${purchase.purchaseDate}"
                                    format="MMM d, yyyy HH:mm"/>
                            </td>

                            <td>

                                <g:if test="${purchase.status == 'COMPLETED'}">

                                    <span class="badge text-bg-success">
                                        COMPLETED
                                    </span>

                                </g:if>

                                <g:else>

                                    <span class="badge text-bg-secondary">
                                        ${purchase.status}
                                    </span>

                                </g:else>

                            </td>

                            <td class="text-end">

                                <g:link action="show"
                                        id="${purchase.id}"
                                        class="btn btn-sm btn-outline-secondary">
                                    View
                                </g:link>

                            </td>

                        </tr>

                    </g:each>

                    </tbody>

                </table>

            </div>

        </g:if>

        <g:else>

            <div class="py-5 text-center border-top">

                <h2 class="h4">
                    No purchases found
                </h2>

                <p class="text-muted mb-0">
                    Completed purchases will appear here.
                </p>

            </div>

        </g:else>

    </sec:ifAnyGranted>


    <sec:ifNotGranted roles="ROLE_ADMIN">

        <g:if test="${purchaseList}">

            <div class="border-top">

                <g:each in="${purchaseList}" var="purchase">

                    <article class="py-4 border-bottom">

                        <div class="row align-items-center gy-3">

                            <div class="col-lg-4">

                                <div class="small text-muted mb-1">
                                    ${purchase.book?.author?.name ?: 'Library collection'}
                                </div>

                                <h2 class="h5 mb-1">

                                    <g:link controller="book"
                                            action="show"
                                            id="${purchase.book?.id}"
                                            class="text-decoration-none">
                                        ${purchase.book?.title}
                                    </g:link>

                                </h2>

                                <span class="small text-muted">

                                    Purchased
                                    <g:formatDate
                                        date="${purchase.purchaseDate}"
                                        format="MMM d, yyyy"/>

                                </span>

                            </div>

                            <div class="col-4 col-lg-2">

                                <div class="small text-muted mb-1">
                                    Type
                                </div>

                                <g:if test="${purchase.purchaseType == 'DIGITAL'}">

                                    <span class="badge text-bg-primary">
                                        Digital
                                    </span>

                                </g:if>

                                <g:else>

                                    <span class="badge text-bg-light border text-dark">
                                        Physical
                                    </span>

                                </g:else>

                            </div>

                            <div class="col-4 col-lg-2">

                                <div class="small text-muted">
                                    Total
                                </div>

                                <div class="fw-semibold">
                                    $<g:formatNumber
                                        number="${purchase.totalAmount ?: 0}"
                                        minFractionDigits="2"
                                        maxFractionDigits="2"/>
                                </div>

                            </div>

                            <div class="col-4 col-lg-1">

                                <div class="small text-muted">
                                    Qty
                                </div>

                                <div>
                                    ${purchase.quantity}
                                </div>

                            </div>

                            <div class="col-lg-3 text-lg-end">

                                <div class="d-inline-flex gap-2">

                                    <g:link action="show"
                                            id="${purchase.id}"
                                            class="btn btn-sm btn-outline-secondary">
                                        Details
                                    </g:link>

                                    <g:if test="${purchase.purchaseType == 'DIGITAL' &&
                                                  purchase.status == 'COMPLETED'}">

                                        <g:link controller="digitalAccess"
                                                action="read"
                                                params="[bookId: purchase.book?.id]"
                                                class="btn btn-sm btn-primary">
                                            Read
                                        </g:link>

                                    </g:if>

                                </div>

                            </div>

                        </div>

                    </article>

                </g:each>

            </div>

        </g:if>

        <g:else>

            <div class="py-5 border-top">

                <h2 class="h4">
                    No purchases yet.
                </h2>

                <p class="text-muted">
                    Browse the catalog to purchase physical
                    or digital books.
                </p>

                <g:link controller="book"
                        action="index"
                        class="btn btn-primary">
                    Explore Books
                </g:link>

            </div>

        </g:else>

    </sec:ifNotGranted>

</div>

</body>
</html>