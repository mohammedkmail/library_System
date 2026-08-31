<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>
        Reservation Details
    </title>

</head>

<body>


<div class="container py-5">


    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">

        ← Back to Reservations

    </g:link>


    <div class="row g-5">


        <!-- =================================================
             BOOK / STATUS
        ================================================== -->

        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                Physical book request
            </div>


            <h1 class="display-6 fw-semibold mb-2">

                ${reservation?.book?.title}

            </h1>


            <g:if test="${reservation?.book?.author}">

                <p class="lead text-muted mb-4">

                    ${reservation.book.author.name}

                </p>

            </g:if>


            <div class="mb-3">

                <g:if test="${reservation?.status == 'WAITING'}">

                    <span class="badge text-bg-warning">
                        WAITING
                    </span>

                </g:if>


                <g:elseif test="${reservation?.status == 'READY'}">

                    <span class="badge text-bg-success">
                        READY FOR PICKUP
                    </span>

                </g:elseif>


                <g:elseif test="${reservation?.status == 'FULFILLED'}">

                    <span class="badge text-bg-primary">
                        FULFILLED
                    </span>

                </g:elseif>


                <g:else>

                    <span class="badge text-bg-secondary">

                        ${reservation?.status}

                    </span>

                </g:else>

            </div>



            <!-- STATUS EXPLANATION -->

            <g:if test="${reservation?.status == 'WAITING'}">

                <p class="text-muted">

                    The reservation is waiting for a
                    physical copy to be prepared.

                </p>

            </g:if>


            <g:elseif test="${reservation?.status == 'READY'}">

                <p class="text-muted">

                    A physical copy has been prepared.
                    The member can now collect it from
                    the library.

                </p>

            </g:elseif>


            <g:elseif test="${reservation?.status == 'FULFILLED'}">

                <p class="text-muted">

                    The book was collected and this
                    reservation has been converted into
                    an active borrowing.

                </p>

            </g:elseif>


            <g:elseif test="${reservation?.status == 'EXPIRED'}">

                <p class="text-muted">

                    The pickup period expired before
                    the book was collected.

                </p>

            </g:elseif>


            <g:elseif test="${reservation?.status == 'CANCELLED'}">

                <p class="text-muted">

                    This reservation was cancelled.

                </p>

            </g:elseif>


            <g:link controller="book"
                    action="show"
                    id="${reservation?.book?.id}"
                    class="btn btn-sm btn-outline-secondary">

                View Book

            </g:link>

        </div>



        <!-- =================================================
             DETAILS
        ================================================== -->

        <div class="col-lg-7">

            <div class="border-top">


                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <div class="row py-3 border-bottom">

                        <div class="col-sm-4 text-muted">
                            Member
                        </div>

                        <div class="col-sm-8 fw-semibold">

                            ${reservation?.user?.username}

                        </div>

                    </div>

                </sec:ifAnyGranted>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Requested
                    </div>

                    <div class="col-sm-8">

                        <g:formatDate
                            date="${reservation?.reservationDate}"
                            format="MMMM d, yyyy HH:mm"/>

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Assigned Copy
                    </div>

                    <div class="col-sm-8 font-monospace">

                        ${reservation?.assignedCopy?.copyCode ?:
                            'Not assigned yet'}

                    </div>

                </div>



                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Pickup Deadline
                    </div>

                    <div class="col-sm-8">

                        <g:if test="${reservation?.readyUntil}">

                            <g:formatDate
                                date="${reservation.readyUntil}"
                                format="MMMM d, yyyy HH:mm"/>

                        </g:if>

                        <g:else>
                            Not set yet
                        </g:else>

                    </div>

                </div>

            </div>



            <!-- =================================================
                 ADMIN: PREPARE WAITING RESERVATION
            ================================================== -->

            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <g:if test="${reservation?.status == 'WAITING'}">

                    <div class="mt-5">

                        <div class="text-uppercase small fw-semibold text-muted mb-2">
                            Staff action
                        </div>

                        <h2 class="h4">
                            Prepare for Pickup
                        </h2>

                        <p class="text-muted">

                            Assign one AVAILABLE physical copy
                            of this book to the reservation.

                        </p>


                        <g:if test="${availableCopyList}">

                            <g:form controller="reservation"
                                    action="assignCopy"
                                    id="${reservation.id}"
                                    method="POST">

                                <div class="row g-3 align-items-end">

                                    <div class="col-md-8">

                                        <label for="bookCopyId"
                                               class="form-label fw-semibold">

                                            Physical Copy

                                        </label>

                                        <select name="bookCopyId"
                                                id="bookCopyId"
                                                class="form-select"
                                                required>

                                            <option value="">
                                                Select available copy
                                            </option>

                                            <g:each in="${availableCopyList}"
                                                    var="copy">

                                                <option value="${copy.id}">

                                                    ${copy.copyCode}

                                                </option>

                                            </g:each>

                                        </select>

                                    </div>


                                    <div class="col-md-4">

                                        <button type="submit"
                                                class="btn btn-primary w-100">

                                            Prepare Copy

                                        </button>

                                    </div>

                                </div>

                            </g:form>

                        </g:if>


                        <g:else>

                            <div class="alert alert-warning mb-0">

                                There is currently no AVAILABLE
                                physical copy of this book.

                            </div>

                        </g:else>

                    </div>

                </g:if>



                <!-- READY -> HAND OVER -->

                <g:if test="${reservation?.status == 'READY'}">

                    <div class="mt-5">

                        <div class="text-uppercase small fw-semibold text-muted mb-2">
                            Staff action
                        </div>

                        <h2 class="h4">
                            Hand Over Book
                        </h2>

                        <p class="text-muted">

                            Confirm this only when the member
                            is physically receiving the reserved
                            book copy.

                        </p>


                        <g:form controller="reservation"
                                action="fulfill"
                                id="${reservation.id}"
                                method="POST">

                            <button type="submit"
                                    class="btn btn-success"
                                    onclick="return confirm('Confirm that this physical book is being handed to the member?');">

                                Hand Over & Create Borrowing

                            </button>

                        </g:form>

                    </div>

                </g:if>

            </sec:ifAnyGranted>



            <!-- =================================================
                 CANCEL
            ================================================== -->

            <g:if test="${reservation?.status in ['WAITING', 'READY']}">

                <div class="mt-4 pt-4 border-top">

                    <g:form controller="reservation"
                            action="cancel"
                            id="${reservation.id}"
                            method="POST">

                        <button type="submit"
                                class="btn btn-outline-danger"
                                onclick="return confirm('Are you sure you want to cancel this reservation?');">

                            Cancel Reservation

                        </button>

                    </g:form>

                </div>

            </g:if>

        </div>

    </div>

</div>


</body>

</html>