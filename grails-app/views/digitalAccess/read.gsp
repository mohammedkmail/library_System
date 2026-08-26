<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>${book?.title}</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1>${book?.title}</h1>
            <p class="text-muted mb-0">
                ${book?.author?.name}
            </p>
        </div>

        <g:link
            controller="book"
            action="show"
            id="${book?.id}"
            class="btn btn-secondary">
            Back to Book
        </g:link>
    </div>

    <div class="card shadow-sm">

        <div class="card-body">

            <h5 class="card-title mb-4">
                Digital Reading
            </h5>

            <g:if test="${book?.digitalContent}">

                <div style="white-space: pre-wrap;">
                    ${book.digitalContent}
                </div>

            </g:if>

            <g:else>

                <div class="alert alert-info">
                    No digital content has been added for this book yet.
                </div>

            </g:else>

        </div>

    </div>

</div>

</body>
</html>