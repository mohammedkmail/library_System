<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>
        ${isAdmin ? 'Borrowing Management' : 'My Borrowings'}
    </title>

</head>

<body>


<div class="container py-5">


    <!-- =====================================================
         HEADER
    ====================================================== -->

    <div class="d-flex flex-column flex-lg-row
                justify-content-between align-items-lg-end
                gap-3 mb-5">

        <div>

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                ${isAdmin ? 'Circulation' : 'My Library'}
            </div>

            <h1 class="display-6 fw-semibold mb-2">

                ${isAdmin ?
                    'Borrowing Management'
                    :
                    'My Borrowings'}

            </h1>

            <p class="text-muted mb-0">

                <g:if test="${isAdmin}">
                    Manage physical book checkouts,
                    due dates and returns.
                </g:if>

                <g:else>
                    Track the books you currently have
                    and review your borrowing history.
                </g:else>

            </p>

        </div>


        <g:link controller="book"
                action="index"
                class="btn btn-outline-primary">

            Browse Books

        </g:link>

    </div>



    <!-- =====================================================
         ADMIN MANUAL CHECKOUT
    ====================================================== -->

    <g:if test="${isAdmin}">

        <section class="border-top border-bottom py-4 mb-5">

            <div class="row align-items-start">

                <div class="col-lg-4 mb-4 mb-lg-0">

                    <div class="text-uppercase small fw-semibold text-muted mb-2">
                        Walk-in checkout
                    </div>

                    <h2 class="h4 mb-2">
                        Record a Borrowing
                    </h2>

                    <p class="text-muted mb-0">
                        Use this when a member borrows an
                        available physical copy directly
                        from the library desk.
                    </p>

                </div>


                <div class="col-lg-8">

                    <g:if test="${userList && availableCopyList}">

                        <g:form controller="borrowing"
                                action="borrow"
                                method="POST">

                            <div class="row g-3">


                                <div class="col-md-5">

                                    <label for="userId"
                                           class="form-label fw-semibold">

                                        Member

                                    </label>

                                    <g:select name="userId"
                                              id="userId"
                                              from="${userList}"
                                              optionKey="id"
                                              optionValue="username"
                                              noSelection="${['': 'Select member']}"
                                              class="form-select"
                                              required="required"/>

                                </div>


                                <div class="col-md-5">

                                    <label for="bookCopyId"
                                           class="form-label fw-semibold">

                                        Available Copy

                                    </label>

                                    <select name="bookCopyId"
                                            id="bookCopyId"
                                            class="form-select"
                                            required>

                                        <option value="">
                                            Select physical copy
                                        </option>

                                        <g:each in="${availableCopyList}"
                                                var="copy">

                                            <option value="${copy.id}">

                                                ${copy.copyCode}
                                                —
                                                ${copy.book?.title}

                                            </option>

                                        </g:each>

                                    </select>

                                </div>


                                <div class="col-md-2 d-flex align-items-end">

                                    <button type="submit"
                                            class="btn btn-primary w-100">

                                        Check Out

                                    </button>

                                </div>

                            </div>

                        </g:form>

                    </g:if>


                    <g:elseif test="${!userList}">

                        <div class="alert alert-warning mb-0">

                            No library users are available
                            for borrowing.

                        </div>

                    </g:elseif>


                    <g:else>

                        <div class="alert alert-info mb-0">

                            There are currently no AVAILABLE
                            physical book copies.

                        </div>

                    </g:else>

                </div>

            </div>

        </section>

    </g:if>



    <!-- =====================================================
         ADMIN VIEW
    ====================================================== -->

    <g:if test="${isAdmin}">

        <div class="d-flex justify-content-between
                    align-items-center mb-3">

            <h2 class="h4 mb-0">
                All Borrowings
            </h2>

            <span class="text-muted small">
                ${borrowingList?.size() ?: 0} records
            </span>

        </div>


        <g:if test="${borrowingList}">

            <div class="table-responsive">

                <table class="table align-middle border-top">

                    <thead>

                    <tr>

                        <th>
                            Member
                        </th>

                        <th>
                            Book
                        </th>

                        <th>
                            Copy
                        </th>

                        <th>
                            Borrowed
                        </th>

                        <th>
                            Due
                        </th>

                        <th>
                            Status
                        </th>

                        <th class="text-end">
                            Actions
                        </th>

                    </tr>

                    </thead>


                    <tbody>

                    <g:each in="${borrowingList}"
                            var="borrowing">

                        <tr>

                            <td>

                                <strong>
                                    ${borrowing.user?.username}
                                </strong>

                            </td>


                            <td>

                                <g:link controller="book"
                                        action="show"
                                        id="${borrowing.bookCopy?.book?.id}"
                                        class="text-decoration-none fw-semibold">

                                    ${borrowing.bookCopy?.book?.title}

                                </g:link>

                            </td>


                            <td>

                                <span class="font-monospace">

                                    ${borrowing.bookCopy?.copyCode ?:
                                        borrowing.bookCopy?.id}

                                </span>

                            </td>


                            <td>

                                <g:formatDate
                                    date="${borrowing.borrowDate}"
                                    format="MMM d, yyyy"/>

                            </td>


                            <td>

                                <g:formatDate
                                    date="${borrowing.dueDate}"
                                    format="MMM d, yyyy"/>

                            </td>


                            <td>

                                <g:if test="${borrowing.status == 'ACTIVE'}">

                                    <span class="badge text-bg-primary">
                                        ACTIVE
                                    </span>

                                </g:if>


                                <g:elseif test="${borrowing.status == 'OVERDUE'}">

                                    <span class="badge text-bg-danger">
                                        OVERDUE
                                    </span>

                                </g:elseif>


                                <g:else>

                                    <span class="badge text-bg-secondary">
                                        ${borrowing.status}
                                    </span>

                                </g:else>

                            </td>


                            <td class="text-end">

                                <div class="d-inline-flex gap-2">

                                    <g:link action="show"
                                            id="${borrowing.id}"
                                            class="btn btn-sm btn-outline-secondary">

                                        View

                                    </g:link>


                                    <g:if test="${borrowing.status in ['ACTIVE', 'OVERDUE']}">

                                        <g:form controller="borrowing"
                                                action="returnBook"
                                                id="${borrowing.id}"
                                                method="POST"
                                                class="d-inline">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-success"
                                                    onclick="return confirm('Confirm that this physical book has been returned?');">

                                                Return

                                            </button>

                                        </g:form>

                                    </g:if>

                                </div>

                            </td>

                        </tr>

                    </g:each>

                    </tbody>

                </table>

            </div>

        </g:if>


        <g:else>

            <div class="py-5 text-center border-top">

                <h3 class="h5">
                    No borrowing records
                </h3>

                <p class="text-muted mb-0">
                    Borrowings will appear here after
                    books are checked out.
                </p>

            </div>

        </g:else>

    </g:if>



    <!-- =====================================================
         USER VIEW
    ====================================================== -->

    <g:else>

        <g:if test="${borrowingList}">

            <div class="border-top">

                <g:each in="${borrowingList}"
                        var="borrowing">

                    <article class="py-4 border-bottom">

                        <div class="row align-items-center gy-3">


                            <div class="col-lg-5">

                                <div class="small text-muted mb-1">

                                    ${borrowing.bookCopy?.book?.author?.name ?: 'Library book'}

                                </div>

                                <h2 class="h5 mb-1">

                                    <g:link controller="book"
                                            action="show"
                                            id="${borrowing.bookCopy?.book?.id}"
                                            class="text-decoration-none">

                                        ${borrowing.bookCopy?.book?.title}

                                    </g:link>

                                </h2>


                                <div class="small text-muted">

                                    Borrowed
                                    <g:formatDate
                                        date="${borrowing.borrowDate}"
                                        format="MMM d, yyyy"/>

                                </div>

                            </div>


                            <div class="col-6 col-lg-2">

                                <div class="small text-muted">
                                    Due date
                                </div>

                                <div class="fw-semibold">

                                    <g:formatDate
                                        date="${borrowing.dueDate}"
                                        format="MMM d, yyyy"/>

                                </div>

                            </div>


                            <div class="col-6 col-lg-2">

                                <div class="small text-muted mb-1">
                                    Status
                                </div>


                                <g:if test="${borrowing.status == 'ACTIVE'}">

                                    <span class="badge text-bg-primary">
                                        Active
                                    </span>

                                </g:if>


                                <g:elseif test="${borrowing.status == 'OVERDUE'}">

                                    <span class="badge text-bg-danger">
                                        Overdue
                                    </span>

                                </g:elseif>


                                <g:else>

                                    <span class="badge text-bg-secondary">
                                        ${borrowing.status}
                                    </span>

                                </g:else>

                            </div>


                            <div class="col-lg-3 text-lg-end">

                                <g:link action="show"
                                        id="${borrowing.id}"
                                        class="btn btn-sm btn-outline-secondary">

                                    View Details

                                </g:link>

                            </div>

                        </div>

                    </article>

                </g:each>

            </div>

        </g:if>


        <g:else>

            <div class="py-5 border-top">

                <h2 class="h4">
                    You have no borrowing history yet.
                </h2>

                <p class="text-muted">
                    Browse the collection and reserve a
                    physical book when you find something
                    you would like to read.
                </p>

                <g:link controller="book"
                        action="index"
                        class="btn btn-primary">

                    Explore Books

                </g:link>

            </div>

        </g:else>

    </g:else>

</div>


</body>

</html>