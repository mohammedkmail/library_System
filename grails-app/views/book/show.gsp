<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Book Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Book Details</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Books
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <div class="card shadow-sm">

        <div class="card-body">

            <g:if test="${book?.coverData}">
                <div class="mb-4 text-center">
                    <img
                        src="${createLink(controller: 'book', action: 'cover', id: book.id)}"
                        alt="${book.title}"
                        class="img-fluid rounded shadow-sm"
                        style="max-height: 350px;"
                    />
                </div>
            </g:if>

            <h3 class="card-title mb-4">
                ${book?.title}
            </h3>

            <dl class="row">

                <dt class="col-sm-3">ISBN</dt>
                <dd class="col-sm-9">${book?.isbn}</dd>

                <dt class="col-sm-3">Author</dt>
                <dd class="col-sm-9">${book?.author?.name}</dd>

                <dt class="col-sm-3">Category</dt>
                <dd class="col-sm-9">${book?.category?.name}</dd>

                <dt class="col-sm-3">Publish Year</dt>
                <dd class="col-sm-9">${book?.publishYear ?: '-'}</dd>

                <dt class="col-sm-3">Description</dt>
                <dd class="col-sm-9">${book?.description ?: '-'}</dd>

                <dt class="col-sm-3">Physical Sale Stock</dt>
                <dd class="col-sm-9">${book?.physicalSaleStock ?: 0}</dd>

                <dt class="col-sm-3">Physical Sale Price</dt>
                <dd class="col-sm-9">
                    <g:if test="${book?.physicalSalePrice != null}">
                        ${book.physicalSalePrice}
                    </g:if>
                    <g:else>
                        -
                    </g:else>
                </dd>

                <dt class="col-sm-3">Digital Available</dt>
                <dd class="col-sm-9">
                    ${book?.digitalAvailable ? 'Yes' : 'No'}
                </dd>

                <dt class="col-sm-3">Digital Purchase Price</dt>
                <dd class="col-sm-9">
                    <g:if test="${book?.digitalPurchasePrice != null}">
                        ${book.digitalPurchasePrice}
                    </g:if>
                    <g:else>
                        -
                    </g:else>
                </dd>

                <dt class="col-sm-3">Digital Rental Price</dt>
                <dd class="col-sm-9">
                    <g:if test="${book?.digitalRentalPrice != null}">
                        ${book.digitalRentalPrice}
                    </g:if>
                    <g:else>
                        -
                    </g:else>
                </dd>

                <dt class="col-sm-3">Included With Membership</dt>
                <dd class="col-sm-9">
                    ${book?.membershipIncluded ? 'Yes' : 'No'}
                </dd>

                <dt class="col-sm-3">Active</dt>
                <dd class="col-sm-9">
                    ${book?.active ? 'Yes' : 'No'}
                </dd>

            </dl>

        </div>
    </div>


    <sec:ifAnyGranted roles="ROLE_USER,ROLE_ADMIN">

        <div class="card shadow-sm mt-4">

            <div class="card-body">

                <h4 class="mb-3">Available Actions</h4>

                <div class="d-flex flex-wrap gap-2">

                    <g:if test="${book?.physicalSaleStock > 0 && book?.physicalSalePrice != null}">

                        <g:form
                            controller="purchase"
                            action="buy"
                            method="POST"
                            class="d-inline">

                            <g:hiddenField
                                name="bookId"
                                value="${book.id}"/>

                            <g:hiddenField
                                name="purchaseType"
                                value="PHYSICAL"/>

                            <g:hiddenField
                                name="quantity"
                                value="1"/>

                            <button
                                type="submit"
                                class="btn btn-primary">

                                Buy Physical
                            </button>

                        </g:form>

                    </g:if>


                    <g:if test="${book?.digitalAvailable && book?.digitalPurchasePrice != null}">

                        <g:form
                            controller="purchase"
                            action="buy"
                            method="POST"
                            class="d-inline">

                            <g:hiddenField
                                name="bookId"
                                value="${book.id}"/>

                            <g:hiddenField
                                name="purchaseType"
                                value="DIGITAL"/>

                            <g:hiddenField
                                name="quantity"
                                value="1"/>

                            <button
                                type="submit"
                                class="btn btn-success">

                                Buy Digital
                            </button>

                        </g:form>

                    </g:if>


                    <g:if test="${book?.digitalAvailable && book?.digitalRentalPrice != null}">

                        <g:form
                            controller="digitalAccess"
                            action="rent"
                            method="POST"
                            class="d-inline">

                            <g:hiddenField
                                name="bookId"
                                value="${book.id}"/>

                            <g:hiddenField
                                name="rentalDays"
                                value="7"/>

                            <button
                                type="submit"
                                class="btn btn-outline-success">

                                Rent Digital - 7 Days
                            </button>

                        </g:form>

                    </g:if>


                    <g:if test="${book?.digitalAvailable && book?.membershipIncluded}">

                        <g:link
                            controller="digitalAccess"
                            action="read"
                            params="[bookId: book.id]"
                            class="btn btn-outline-primary">

                            Read With Membership
                        </g:link>

                    </g:if>


                    <g:if test="${availableCopies}">

                        <g:form
                            controller="borrowing"
                            action="borrow"
                            method="POST"
                            class="d-inline">

                            <g:hiddenField
                                name="bookCopyId"
                                value="${availableCopies[0].id}"/>

                            <button
                                type="submit"
                                class="btn btn-info">

                                Borrow Physical Copy
                            </button>

                        </g:form>

                    </g:if>


                    <g:if test="${!availableCopies}">

                        <g:link
                            controller="reservation"
                            action="reserve"
                            params="[bookId: book.id]"
                            class="btn btn-outline-warning">

                            Reserve Physical Book
                        </g:link>

                    </g:if>

                </div>

            </div>

        </div>

    </sec:ifAnyGranted>


    <sec:ifAnyGranted roles="ROLE_ADMIN">

        <div class="mt-4 d-flex gap-2">

            <g:link
                action="edit"
                id="${book.id}"
                class="btn btn-warning">
                Edit
            </g:link>

            <g:form
                resource="${book}"
                method="DELETE"
                class="d-inline">

                <button
                    type="submit"
                    class="btn btn-danger"
                    onclick="return confirm('Are you sure you want to delete this book?');">

                    Delete
                </button>

            </g:form>

        </div>

    </sec:ifAnyGranted>

</div>

</body>
</html>