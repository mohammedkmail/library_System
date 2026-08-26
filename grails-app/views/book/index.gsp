<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Books</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Books</h1>

        <sec:ifAnyGranted roles="ROLE_ADMIN">
            <g:link action="create" class="btn btn-primary">
                Add Book
            </g:link>
        </sec:ifAnyGranted>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-success">
            ${flash.message}
        </div>
    </g:if>

    <g:form method="GET" action="index" class="row g-2 mb-4">

        <div class="col-md-6">
            <input
                type="text"
                name="search"
                value="${search ?: ''}"
                class="form-control"
                placeholder="Search by book title"
            />
        </div>

        <div class="col-auto">
            <button type="submit" class="btn btn-dark">
                Search
            </button>
        </div>

        <g:if test="${search}">
            <div class="col-auto">
                <g:link action="index" class="btn btn-secondary">
                    Clear
                </g:link>
            </div>
        </g:if>

    </g:form>

    <div class="table-responsive">

        <table class="table table-striped table-bordered align-middle">

            <thead>
            <tr>
                <th>Cover</th>
                <th>Title</th>
                <th>ISBN</th>
                <th>Author</th>
                <th>Category</th>
                <th>Physical Stock</th>
                <th>Digital</th>
                <th>Actions</th>
            </tr>
            </thead>

            <tbody>

            <g:each in="${bookList}" var="book">

                <tr>

                    <td style="width: 90px;">

                        <g:if test="${book.coverData}">

                            <img
                                src="${createLink(controller: 'book', action: 'cover', id: book.id)}"
                                alt="${book.title}"
                                class="img-thumbnail"
                                style="width: 60px; height: 80px; object-fit: cover;"
                            />

                        </g:if>

                        <g:else>
                            <span class="text-muted">
                                No Cover
                            </span>
                        </g:else>

                    </td>

                    <td>${book.title}</td>

                    <td>${book.isbn}</td>

                    <td>${book.author?.name}</td>

                    <td>${book.category?.name}</td>

                    <td>${book.physicalSaleStock}</td>

                    <td>
                        ${book.digitalAvailable ? 'Yes' : 'No'}
                    </td>

                    <td>

                        <g:link
                            action="show"
                            id="${book.id}"
                            class="btn btn-sm btn-info">

                            View
                        </g:link>

                        <sec:ifAnyGranted roles="ROLE_ADMIN">

                            <g:link
                                action="edit"
                                id="${book.id}"
                                class="btn btn-sm btn-warning">

                                Edit
                            </g:link>

                        </sec:ifAnyGranted>

                    </td>

                </tr>

            </g:each>


            <g:if test="${!bookList}">

                <tr>
                    <td
                        colspan="8"
                        class="text-center">

                        No books found.

                    </td>
                </tr>

            </g:if>

            </tbody>

        </table>

    </div>


    <g:if test="${bookCount > params.int('max')}">

        <div class="mt-3">

            <g:paginate
                total="${bookCount ?: 0}"
                params="[search: search]"
            />

        </div>

    </g:if>

</div>

</body>
</html>