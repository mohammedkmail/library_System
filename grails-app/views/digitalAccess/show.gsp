<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Digital Access Details</title>
</head>

<body>

<div class="container py-5">

    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">

        ← Back to Digital Library

    </g:link>


    <div class="row g-5">


        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                Digital Access
            </div>


            <h1 class="display-6 fw-semibold mb-2">

                ${digitalAccess?.book?.title}

            </h1>


            <g:if test="${digitalAccess?.book?.author}">

                <p class="lead text-muted">

                    ${digitalAccess.book.author.name}

                </p>

            </g:if>


            <g:if test="${digitalAccess?.status == 'ACTIVE'}">

                <span class="badge text-bg-success">
                    ACTIVE
                </span>

            </g:if>


            <g:else>

                <span class="badge text-bg-secondary">
                    ${digitalAccess?.status}
                </span>

            </g:else>


            <div class="mt-4">

                <g:link controller="book"
                        action="show"
                        id="${digitalAccess?.book?.id}"
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
                            ${digitalAccess?.user?.username}
                        </div>

                    </div>

                </sec:ifAnyGranted>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Access Type
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        ${digitalAccess?.accessType}

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Start Date
                    </div>

                    <div class="col-sm-8">

                        <g:formatDate
                            date="${digitalAccess?.startDate}"
                            format="MMMM d, yyyy HH:mm"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        End Date
                    </div>

                    <div class="col-sm-8">

                        <g:if test="${digitalAccess?.endDate}">

                            <g:formatDate
                                date="${digitalAccess.endDate}"
                                format="MMMM d, yyyy HH:mm"/>

                        </g:if>

                        <g:else>
                            Permanent Access
                        </g:else>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Status
                    </div>

                    <div class="col-sm-8 fw-semibold">

                        ${digitalAccess?.status}

                    </div>

                </div>

            </div>



            <sec:ifNotGranted roles="ROLE_ADMIN">

                <g:if test="${canRead}">

                    <div class="mt-4">

                        <g:link action="read"
                                params="[bookId: digitalAccess.book?.id]"
                                class="btn btn-primary">

                            Read Digital Book

                        </g:link>

                    </div>

                </g:if>


                <g:else>

                    <div class="alert alert-secondary mt-4 mb-0">

                        This access record is no longer
                        valid for digital reading.

                    </div>

                </g:else>

            </sec:ifNotGranted>

        </div>

    </div>

</div>

</body>

</html>