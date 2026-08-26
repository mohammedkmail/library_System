<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Borrowings</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Borrowings</h1>

        <g:link controller="book" action="index" class="btn btn-primary">
            Browse Books
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:if test="${borrowingList}">

        <div class="table-responsive">

            <table class="table table-striped table-hover align-middle">

                <thead>
                <tr>
                    <th>Book</th>
                    <th>Copy</th>
                    <th>Borrow Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                    <th>Late Fee</th>

                    <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <th>User</th>
                    </sec:ifAnyGranted>

                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <g:each in="${borrowingList}" var="borrowing">

                    <tr>

                        <td>
                            ${borrowing.bookCopy?.book?.title}
                        </td>

                        <td>
                            ${borrowing.bookCopy?.id}
                        </td>

                        <td>
                            <g:formatDate
                                date="${borrowing.borrowDate}"
                                format="yyyy-MM-dd"/>
                        </td>

                        <td>
                            <g:formatDate
                                date="${borrowing.dueDate}"
                                format="yyyy-MM-dd"/>
                        </td>

                        <td>
                            <g:if test="${borrowing.returnDate}">
                                <g:formatDate
                                    date="${borrowing.returnDate}"
                                    format="yyyy-MM-dd"/>
                            </g:if>

                            <g:else>
                                -
                            </g:else>
                        </td>

                        <td>
                            ${borrowing.status}
                        </td>

                        <td>
                            ${borrowing.lateFee ?: 0}
                        </td>

                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            <td>
                                ${borrowing.user?.username}
                            </td>
                        </sec:ifAnyGranted>

                        <td>

                            <g:link
                                action="show"
                                id="${borrowing.id}"
                                class="btn btn-sm btn-outline-primary">
                                View
                            </g:link>

                            <g:if test="${borrowing.status == 'ACTIVE'}">

                                <g:link
                                    action="returnBook"
                                    id="${borrowing.id}"
                                    class="btn btn-sm btn-outline-success"
                                    onclick="return confirm('Return this book?');">
                                    Return
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
            No borrowings found.
        </div>

    </g:else>

</div>

</body>
</html>