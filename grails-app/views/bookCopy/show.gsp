<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Book Copy Details</title>
</head>

<body>

<div class="container py-5">

    <g:link
        action="index"
        class="back-link">

        ← Back to Book Copies

    </g:link>


    <div class="row g-5 mt-1">


        <div class="col-lg-5">

            <div class="section-eyebrow">
                Physical Lending Copy
            </div>

            <h1 class="display-6 fw-semibold">
                ${bookCopy?.copyCode}
            </h1>

            <p class="lead text-muted">
                ${bookCopy?.book?.title}
            </p>


            <g:if test="${bookCopy?.status == 'AVAILABLE'}">

                <span class="status-badge status-active">
                    AVAILABLE
                </span>

            </g:if>


            <g:elseif test="${bookCopy?.status in ['BORROWED', 'RESERVED']}">

                <span class="status-badge">
                    ${bookCopy.status}
                </span>

            </g:elseif>


            <g:else>

                <span class="status-badge status-inactive">
                    ${bookCopy?.status}
                </span>

            </g:else>

        </div>



        <div class="col-lg-7">

            <div class="border-top">

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Copy Code
                    </div>

                    <div class="col-sm-8 font-monospace fw-semibold">
                        ${bookCopy?.copyCode}
                    </div>

                </div>


                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Book
                    </div>

                    <div class="col-sm-8">

                        <g:link
                            controller="book"
                            action="show"
                            id="${bookCopy?.book?.id}">

                            ${bookCopy?.book?.title}

                        </g:link>

                    </div>

                </div>


                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Status
                    </div>

                    <div class="col-sm-8 fw-semibold">
                        ${bookCopy?.status}
                    </div>

                </div>


                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Borrowing Records
                    </div>

                    <div class="col-sm-8">
                        ${borrowingCount ?: 0}
                    </div>

                </div>


                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Reservation Records
                    </div>

                    <div class="col-sm-8">
                        ${reservationCount ?: 0}
                    </div>

                </div>

            </div>



            <div class="mt-4 d-flex flex-wrap gap-2">

                <g:link
                    action="edit"
                    id="${bookCopy.id}"
                    class="btn btn-outline-dark">

                    Edit Copy

                </g:link>


                <g:if test="${canDelete}">

                    <g:form
                        controller="bookCopy"
                        action="delete"
                        id="${bookCopy.id}"
                        method="DELETE">

                        <button
                            type="submit"
                            class="btn btn-outline-danger"
                            onclick="return confirm('Delete this physical copy?');">

                            Delete Copy

                        </button>

                    </g:form>

                </g:if>

            </div>



            <g:if test="${!canDelete}">

                <p class="small text-muted mt-3 mb-0">

                    This copy cannot be deleted because
                    it is currently in circulation or has
                    borrowing/reservation history.

                </p>

            </g:if>

        </div>

    </div>

</div>

</body>

</html>