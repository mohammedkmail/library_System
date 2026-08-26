<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Digital Access</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Digital Access</h1>

        <g:link controller="book" action="index" class="btn btn-primary">
            Browse Books
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:if test="${digitalAccessList}">

        <div class="table-responsive">

            <table class="table table-striped table-hover align-middle">

                <thead>
                <tr>
                    <th>Book</th>
                    <th>Access Type</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>

                    <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <th>User</th>
                    </sec:ifAnyGranted>

                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <g:each in="${digitalAccessList}" var="access">

                    <tr>

                        <td>
                            ${access.book?.title}
                        </td>

                        <td>
                            ${access.accessType}
                        </td>

                        <td>
                            <g:formatDate
                                date="${access.startDate}"
                                format="yyyy-MM-dd HH:mm"/>
                        </td>

                        <td>
                            <g:if test="${access.endDate}">
                                <g:formatDate
                                    date="${access.endDate}"
                                    format="yyyy-MM-dd HH:mm"/>
                            </g:if>

                            <g:else>
                                Permanent
                            </g:else>
                        </td>

                        <td>
                            ${access.status}
                        </td>

                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            <td>
                                ${access.user?.username}
                            </td>
                        </sec:ifAnyGranted>

                        <td>

                            <g:link
                                action="show"
                                id="${access.id}"
                                class="btn btn-sm btn-outline-primary">
                                View
                            </g:link>

                            <g:if test="${access.status == 'ACTIVE'}">

                                <g:link
                                    action="read"
                                    params="[bookId: access.book?.id]"
                                    class="btn btn-sm btn-success">
                                    Read
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
            No digital access found.
        </div>

    </g:else>

</div>

</body>
</html>