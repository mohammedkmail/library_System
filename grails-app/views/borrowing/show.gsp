<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>
        Borrowing Details
    </title>

</head>

<body>


<div class="container py-5">


    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">

        ← Back to Borrowings

    </g:link>



    <div class="row g-5">


        <!-- BOOK -->

        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                Physical borrowing
            </div>


            <h1 class="display-6 fw-semibold mb-2">

                ${borrowing?.bookCopy?.book?.title}

            </h1>


            <g:if test="${borrowing?.bookCopy?.book?.author}">

                <p class="lead text-muted">

                    ${borrowing.bookCopy.book.author.name}

                </p>

            </g:if>


            <g:link controller="book"
                    action="show"
                    id="${borrowing?.bookCopy?.book?.id}"
                    class="btn btn-sm btn-outline-secondary mt-2">

                View Book

            </g:link>

        </div>



        <!-- DETAILS -->

        <div class="col-lg-7">

            <div class="border-top">


                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Status
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        <g:if test="${borrowing?.status == 'ACTIVE'}">

                            <span class="badge text-bg-primary">
                                ACTIVE
                            </span>

                        </g:if>


                        <g:elseif test="${borrowing?.status == 'OVERDUE'}">

                            <span class="badge text-bg-danger">
                                OVERDUE
                            </span>

                        </g:elseif>


                        <g:else>

                            <span class="badge text-bg-secondary">
                                ${borrowing?.status}
                            </span>

                        </g:else>

                    </div>

                </div>



                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <div class="row py-3 border-bottom">

                        <div class="col-sm-4 text-muted">
                            Member
                        </div>

                        <div class="col-sm-8 fw-semibold">
                            ${borrowing?.user?.username}
                        </div>

                    </div>

                </sec:ifAnyGranted>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Physical Copy
                    </div>

                    <div class="col-sm-8 font-monospace">

                        ${borrowing?.bookCopy?.copyCode ?:
                            borrowing?.bookCopy?.id}

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Borrow Date
                    </div>

                    <div class="col-sm-8">

                        <g:formatDate
                            date="${borrowing?.borrowDate}"
                            format="MMMM d, yyyy"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Due Date
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        <g:formatDate
                            date="${borrowing?.dueDate}"
                            format="MMMM d, yyyy"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Return Date
                    </div>

                    <div class="col-sm-8">

                        <g:if test="${borrowing?.returnDate}">

                            <g:formatDate
                                date="${borrowing.returnDate}"
                                format="MMMM d, yyyy"/>

                        </g:if>

                        <g:else>
                            Not returned yet
                        </g:else>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Late Fee
                    </div>

                    <div class="col-sm-8">

                        $<g:formatNumber
                            number="${borrowing?.lateFee ?: 0}"
                            minFractionDigits="2"
                            maxFractionDigits="2"/>

                    </div>

                </div>

            </div>



            <!-- ADMIN RETURN -->

            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <g:if test="${borrowing?.status in ['ACTIVE', 'OVERDUE']}">

                    <div class="mt-4">

                        <g:form controller="borrowing"
                                action="returnBook"
                                id="${borrowing.id}"
                                method="POST">

                            <button type="submit"
                                    class="btn btn-success"
                                    onclick="return confirm('Confirm that the physical copy has been returned to the library?');">

                                Record Book Return

                            </button>

                        </g:form>

                    </div>

                </g:if>

            </sec:ifAnyGranted>


            <!-- USER EXPLANATION -->

            <sec:ifAnyGranted roles="ROLE_USER">

                <sec:ifNotGranted roles="ROLE_ADMIN">

                    <g:if test="${borrowing?.status in ['ACTIVE', 'OVERDUE']}">

                        <p class="small text-muted mt-4 mb-0">

                            Physical returns are recorded by
                            library staff when the book is
                            handed back at the library.

                        </p>

                    </g:if>

                </sec:ifNotGranted>

            </sec:ifAnyGranted>

        </div>

    </div>

</div>


</body>

</html>