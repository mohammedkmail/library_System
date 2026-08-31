<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Book Copies</title>
</head>

<body>

<div class="container py-5">

    <div class="d-flex flex-column flex-md-row
                justify-content-between align-items-md-end
                gap-3 mb-5">

        <div>

            <div class="section-eyebrow">
                Circulation Inventory
            </div>

            <h1 class="display-6 fw-semibold mb-2">
                Book Copies
            </h1>

            <p class="text-muted mb-0">
                Manage the physical copies used for
                library borrowing and reservations.
            </p>

        </div>


        <g:link
            action="create"
            class="btn btn-primary">

            Add Book Copy

        </g:link>

    </div>



    <g:if test="${bookCopyList}">

        <div class="table-responsive">

            <table class="table align-middle border-top">

                <thead>

                <tr>
                    <th>Copy Code</th>
                    <th>Book</th>
                    <th>Status</th>
                    <th class="text-end">Actions</th>
                </tr>

                </thead>


                <tbody>

                <g:each
                    in="${bookCopyList}"
                    var="bookCopy">

                    <tr>

                        <td class="font-monospace fw-semibold">

                            ${bookCopy.copyCode}

                        </td>


                        <td>

                            <g:link
                                controller="book"
                                action="show"
                                id="${bookCopy.book?.id}"
                                class="text-decoration-none">

                                ${bookCopy.book?.title}

                            </g:link>

                        </td>


                        <td>

                            <g:if test="${bookCopy.status == 'AVAILABLE'}">

                                <span class="status-badge status-active">
                                    AVAILABLE
                                </span>

                            </g:if>


                            <g:elseif test="${bookCopy.status == 'RESERVED'}">

                                <span class="status-badge">
                                    RESERVED
                                </span>

                            </g:elseif>


                            <g:elseif test="${bookCopy.status == 'BORROWED'}">

                                <span class="status-badge">
                                    BORROWED
                                </span>

                            </g:elseif>


                            <g:else>

                                <span class="status-badge status-inactive">

                                    ${bookCopy.status}

                                </span>

                            </g:else>

                        </td>


                        <td class="text-end">

                            <div class="d-inline-flex gap-2">

                                <g:link
                                    action="show"
                                    id="${bookCopy.id}"
                                    class="btn btn-sm btn-outline-secondary">

                                    View

                                </g:link>


                                <g:link
                                    action="edit"
                                    id="${bookCopy.id}"
                                    class="btn btn-sm btn-outline-dark">

                                    Edit

                                </g:link>

                            </div>

                        </td>

                    </tr>

                </g:each>

                </tbody>

            </table>

        </div>

    </g:if>


    <g:else>

        <div class="empty-state">

            <h2>
                No lending copies
            </h2>

            <p>
                Add a physical copy before users
                can reserve this library inventory.
            </p>

            <g:link
                action="create"
                class="btn btn-primary">

                Add Book Copy

            </g:link>

        </div>

    </g:else>



    <g:if test="${(bookCopyCount ?: 0) > (pageSize ?: 20)}">

        <div class="library-pagination">

            <g:paginate
                total="${bookCopyCount ?: 0}"
                max="${pageSize ?: 20}"
            />

        </div>

    </g:if>

</div>

</body>

</html>