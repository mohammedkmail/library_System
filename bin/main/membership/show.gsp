<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Membership Details</title>
</head>

<body>

<div class="container py-5">

    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">
        ← Back to Memberships
    </g:link>

    <div class="row g-5">

        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                Library Membership
            </div>

            <h1 class="display-6 fw-semibold mb-3">
                Membership Details
            </h1>

            <g:if test="${membership?.status == 'ACTIVE'}">
                <span class="badge text-bg-success">
                    ACTIVE
                </span>
            </g:if>

            <g:elseif test="${membership?.status == 'EXPIRED'}">
                <span class="badge text-bg-secondary">
                    EXPIRED
                </span>
            </g:elseif>

            <g:else>
                <span class="badge text-bg-dark">
                    ${membership?.status}
                </span>
            </g:else>

            <g:if test="${membership?.status == 'ACTIVE'}">

                <p class="text-muted mt-4">
                    This membership can currently be used
                    for physical borrowing and book
                    reservations.
                </p>

            </g:if>

        </div>

        <div class="col-lg-7">

            <div class="border-top">

                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <div class="row py-3 border-bottom">

                        <div class="col-sm-4 text-muted">
                            Member
                        </div>

                        <div class="col-sm-8 fw-semibold">
                            ${membership?.user?.username}
                        </div>

                    </div>

                </sec:ifAnyGranted>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Start Date
                    </div>

                    <div class="col-sm-8">
                        <g:formatDate
                            date="${membership?.startDate}"
                            format="MMMM d, yyyy"/>
                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        End Date
                    </div>

                    <div class="col-sm-8">
                        <g:formatDate
                            date="${membership?.endDate}"
                            format="MMMM d, yyyy"/>
                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Status
                    </div>

                    <div class="col-sm-8 fw-semibold">
                        ${membership?.status}
                    </div>

                </div>

                <div class="row py-3 border-bottom">

                    <div class="col-sm-4 text-muted">
                        Total Price
                    </div>

                    <div class="col-sm-8 fw-semibold">
                        $<g:formatNumber
                            number="${membership?.price ?: 0}"
                            minFractionDigits="2"
                            maxFractionDigits="2"/>
                    </div>

                </div>

            </div>

            <g:if test="${membership?.status == 'ACTIVE'}">

                <div class="mt-4">

                    <g:form controller="membership"
                            action="cancel"
                            id="${membership.id}"
                            method="POST">

                        <button type="submit"
                                class="btn btn-outline-danger"
                                onclick="return confirm('Are you sure you want to cancel this membership?');">
                            Cancel Membership
                        </button>

                    </g:form>

                </div>

            </g:if>

        </div>

    </div>

</div>

</body>
</html>