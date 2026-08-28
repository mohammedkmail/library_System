<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Memberships</title>
</head>

<body>

<div class="container py-5">

    <div class="d-flex flex-column flex-lg-row
                justify-content-between align-items-lg-end
                gap-3 mb-5">

        <div>

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Membership Management
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    My Library
                </sec:ifNotGranted>
            </div>

            <h1 class="display-6 fw-semibold mb-2">

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Memberships
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    My Membership
                </sec:ifNotGranted>

            </h1>

            <p class="text-muted mb-0">

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    Review membership periods, status
                    and charges across library members.
                </sec:ifAnyGranted>

                <sec:ifNotGranted roles="ROLE_ADMIN">
                    Membership gives you access to physical
                    borrowing, book reservations and eligible
                    membership digital titles.
                </sec:ifNotGranted>

            </p>

        </div>

        <sec:ifNotGranted roles="ROLE_ADMIN">

            <g:link action="create"
                    class="btn btn-primary">
                New Membership
            </g:link>

        </sec:ifNotGranted>

    </div>


    <sec:ifAnyGranted roles="ROLE_ADMIN">

        <g:if test="${membershipList}">

            <div class="table-responsive">

                <table class="table align-middle border-top">

                    <thead>
                    <tr>
                        <th>Member</th>
                        <th>Period</th>
                        <th>Status</th>
                        <th>Price</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>

                    <tbody>

                    <g:each in="${membershipList}" var="membership">

                        <tr>

                            <td class="fw-semibold">
                                ${membership.user?.username}
                            </td>

                            <td>
                                <g:formatDate
                                    date="${membership.startDate}"
                                    format="MMM d, yyyy"/>

                                <span class="text-muted mx-1">→</span>

                                <g:formatDate
                                    date="${membership.endDate}"
                                    format="MMM d, yyyy"/>
                            </td>

                            <td>

                                <g:if test="${membership.status == 'ACTIVE'}">
                                    <span class="badge text-bg-success">
                                        ACTIVE
                                    </span>
                                </g:if>

                                <g:elseif test="${membership.status == 'EXPIRED'}">
                                    <span class="badge text-bg-secondary">
                                        EXPIRED
                                    </span>
                                </g:elseif>

                                <g:else>
                                    <span class="badge text-bg-dark">
                                        ${membership.status}
                                    </span>
                                </g:else>

                            </td>

                            <td>
                                $<g:formatNumber
                                    number="${membership.price ?: 0}"
                                    minFractionDigits="2"
                                    maxFractionDigits="2"/>
                            </td>

                            <td class="text-end">

                                <g:link action="show"
                                        id="${membership.id}"
                                        class="btn btn-sm btn-outline-secondary">
                                    View
                                </g:link>

                            </td>

                        </tr>

                    </g:each>

                    </tbody>

                </table>

            </div>

        </g:if>

        <g:else>

            <div class="py-5 text-center border-top">

                <h2 class="h4">
                    No memberships found
                </h2>

                <p class="text-muted mb-0">
                    Membership records will appear here
                    when users create them.
                </p>

            </div>

        </g:else>

    </sec:ifAnyGranted>


    <sec:ifNotGranted roles="ROLE_ADMIN">

        <g:if test="${membershipList}">

            <div class="border-top">

                <g:each in="${membershipList}" var="membership">

                    <article class="py-4 border-bottom">

                        <div class="row align-items-center gy-3">

                            <div class="col-lg-4">

                                <div class="small text-muted mb-1">
                                    Membership Period
                                </div>

                                <h2 class="h5 mb-0">

                                    <g:formatDate
                                        date="${membership.startDate}"
                                        format="MMM d, yyyy"/>

                                    <span class="text-muted mx-1">—</span>

                                    <g:formatDate
                                        date="${membership.endDate}"
                                        format="MMM d, yyyy"/>

                                </h2>

                            </div>

                            <div class="col-6 col-lg-2">

                                <div class="small text-muted mb-1">
                                    Status
                                </div>

                                <g:if test="${membership.status == 'ACTIVE'}">
                                    <span class="badge text-bg-success">
                                        Active
                                    </span>
                                </g:if>

                                <g:elseif test="${membership.status == 'EXPIRED'}">
                                    <span class="badge text-bg-secondary">
                                        Expired
                                    </span>
                                </g:elseif>

                                <g:else>
                                    <span class="badge text-bg-dark">
                                        ${membership.status}
                                    </span>
                                </g:else>

                            </div>

                            <div class="col-6 col-lg-2">

                                <div class="small text-muted">
                                    Price
                                </div>

                                <div class="fw-semibold">
                                    $<g:formatNumber
                                        number="${membership.price ?: 0}"
                                        minFractionDigits="2"
                                        maxFractionDigits="2"/>
                                </div>

                            </div>

                            <div class="col-lg-4 text-lg-end">

                                <div class="d-inline-flex gap-2">

                                    <g:link action="show"
                                            id="${membership.id}"
                                            class="btn btn-sm btn-outline-secondary">
                                        Details
                                    </g:link>

                                    <g:if test="${membership.status == 'ACTIVE'}">

                                        <g:form controller="membership"
                                                action="cancel"
                                                id="${membership.id}"
                                                method="POST"
                                                class="d-inline">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('Cancel this membership?');">
                                                Cancel
                                            </button>

                                        </g:form>

                                    </g:if>

                                </div>

                            </div>

                        </div>

                    </article>

                </g:each>

            </div>

        </g:if>

        <g:else>

            <div class="py-5 border-top">

                <div class="row">

                    <div class="col-lg-7">

                        <h2 class="h3">
                            Start your library membership
                        </h2>

                        <p class="text-muted">
                            Choose the membership period that
                            works for you. Pricing is calculated
                            automatically based on the number
                            of membership days.
                        </p>

                        <g:link action="create"
                                class="btn btn-primary">
                            Create Membership
                        </g:link>

                    </div>

                </div>

            </div>

        </g:else>

    </sec:ifNotGranted>

</div>

</body>
</html>