<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Memberships</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Memberships</h1>

        <g:link action="create" class="btn btn-primary">
            New Membership
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:if test="${membershipList}">

        <div class="table-responsive">

            <table class="table table-striped table-hover align-middle">

                <thead>
                <tr>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                    <th>Price</th>

                    <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <th>User</th>
                    </sec:ifAnyGranted>

                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <g:each in="${membershipList}" var="membership">

                    <tr>

                        <td>
                            <g:formatDate
                                date="${membership.startDate}"
                                format="yyyy-MM-dd"/>
                        </td>

                        <td>
                            <g:formatDate
                                date="${membership.endDate}"
                                format="yyyy-MM-dd"/>
                        </td>

                        <td>
                            ${membership.status}
                        </td>

                        <td>
                            ${membership.price}
                        </td>

                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            <td>
                                ${membership.user?.username}
                            </td>
                        </sec:ifAnyGranted>

                        <td>

                            <g:link
                                action="show"
                                id="${membership.id}"
                                class="btn btn-sm btn-outline-primary">
                                View
                            </g:link>

                            <g:if test="${membership.status == 'ACTIVE'}">

                                <g:link
                                    action="cancel"
                                    id="${membership.id}"
                                    class="btn btn-sm btn-outline-danger"
                                    onclick="return confirm('Cancel this membership?');">
                                    Cancel
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
            No memberships found.
        </div>

    </g:else>

</div>

</body>
</html>