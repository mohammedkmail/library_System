<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Purchases</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Purchases</h1>

        <g:link controller="book" action="index" class="btn btn-primary">
            Browse Books
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:if test="${purchaseList}">

        <div class="table-responsive">

            <table class="table table-striped table-hover align-middle">

                <thead>
                <tr>
                    <th>Book</th>
                    <th>Type</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Total</th>
                    <th>Date</th>
                    <th>Status</th>

                    <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <th>User</th>
                    </sec:ifAnyGranted>

                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <g:each in="${purchaseList}" var="purchase">

                    <tr>

                        <td>
                            ${purchase.book?.title}
                        </td>

                        <td>
                            ${purchase.purchaseType}
                        </td>

                        <td>
                            ${purchase.quantity}
                        </td>

                        <td>
                            ${purchase.unitPrice}
                        </td>

                        <td>
                            ${purchase.totalAmount}
                        </td>

                        <td>
                            <g:formatDate
                                date="${purchase.purchaseDate}"
                                format="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>
                            ${purchase.status}
                        </td>

                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            <td>
                                ${purchase.user?.username}
                            </td>
                        </sec:ifAnyGranted>

                        <td>
                            <g:link
                                action="show"
                                id="${purchase.id}"
                                class="btn btn-sm btn-outline-primary">
                                View
                            </g:link>

                            <g:if test="${purchase.purchaseType == 'DIGITAL' && purchase.status == 'COMPLETED'}">

                                <g:link
                                    controller="digitalAccess"
                                    action="read"
                                    params="[bookId: purchase.book?.id]"
                                    class="btn btn-sm btn-outline-success">
                                    Read
                                </g:link>

                            </g:if>
                        </td>

                    </tr>

                </g:each>

                </tbody>

            </table>

        </div>

    </g:if>

    <g:else>

        <div class="alert alert-info">
            No purchases found.
        </div>

    </g:else>

</div>

</body>
</html>