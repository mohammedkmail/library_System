<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Borrowing Details</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Borrowing Details</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Borrowings
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
                    ${borrowing?.bookCopy?.book?.title}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Copy ID</div>
                <div class="col-md-9">
                    ${borrowing?.bookCopy?.id}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Borrow Date</div>
                <div class="col-md-9">
                    <g:formatDate
                        date="${borrowing?.borrowDate}"
                        format="yyyy-MM-dd"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Due Date</div>
                <div class="col-md-9">
                    <g:formatDate
                        date="${borrowing?.dueDate}"
                        format="yyyy-MM-dd"/>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Return Date</div>
                <div class="col-md-9">
                    <g:if test="${borrowing?.returnDate}">
                        <g:formatDate
                            date="${borrowing.returnDate}"
                            format="yyyy-MM-dd"/>
                    </g:if>

                    <g:else>
                        Not returned yet
                    </g:else>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Status</div>
                <div class="col-md-9">
                    ${borrowing?.status}
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-3 fw-bold">Late Fee</div>
                <div class="col-md-9">
                    ${borrowing?.lateFee ?: 0}
                </div>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN">
                <div class="row mb-3">
                    <div class="col-md-3 fw-bold">User</div>
                    <div class="col-md-9">
                        ${borrowing?.user?.username}
                    </div>
                </div>
            </sec:ifAnyGranted>

        </div>

        <g:if test="${borrowing?.status == 'ACTIVE'}">

            <div class="card-footer">

                <g:link
                    action="returnBook"
                    id="${borrowing?.id}"
                    class="btn btn-success"
                    onclick="return confirm('Are you sure you want to return this book?');">
                    Return Book
                </g:link>

            </div>

        </g:if>

    </div>

</div>

</body>
</html>