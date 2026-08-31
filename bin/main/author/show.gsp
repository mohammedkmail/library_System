<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>${author.name}</title>

</head>

<body>


<section class="author-profile-section">

    <div class="container">

        <g:link controller="author"
                action="index"
                class="back-link">

            ← All Authors

        </g:link>


        <div class="author-profile">

            <div class="author-profile-mark">

                ${author.name ?
                    author.name.substring(0, 1).toUpperCase()
                    :
                    '?'}

            </div>


            <div class="author-profile-content">

                <span class="section-eyebrow">
                    Author
                </span>


                <h1>
                    ${author.name}
                </h1>


                <g:if test="${author.biography}">

                    <div class="author-biography">

                        ${author.biography}

                    </div>

                </g:if>


                <g:else>

                    <p class="author-biography text-muted">

                        Biography information is not available
                        for this author.

                    </p>

                </g:else>


                <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <div class="detail-admin-actions">

                        <g:link controller="author"
                                action="edit"
                                id="${author.id}"
                                class="btn btn-outline-primary">

                            Edit Author

                        </g:link>


                        <g:form controller="author"
                                action="delete"
                                id="${author.id}"
                                method="DELETE"
                                class="d-inline">

                            <button type="submit"
                                    class="btn btn-outline-danger"
                                    onclick="return confirm('Are you sure you want to delete this author?');">

                                Delete

                            </button>

                        </g:form>

                    </div>

                </sec:ifAnyGranted>

            </div>

        </div>

    </div>

</section>



<section class="book-collection-section">

    <div class="container">

        <div class="collection-heading">

            <div>

                <span class="section-eyebrow">
                    Library collection
                </span>

                <h2>
                    Books by ${author.name}
                </h2>

            </div>


            <span class="collection-count">

                ${bookList?.size() ?: 0}
                ${bookList?.size() == 1 ? 'book' : 'books'}

            </span>

        </div>



        <g:if test="${bookList}">

            <div class="book-shelf-grid">

                <g:each in="${bookList}"
                        var="book">

                    <article class="book-shelf-item">


                        <g:link controller="book"
                                action="show"
                                id="${book.id}"
                                class="book-cover-link">

                            <div class="book-cover-frame">

                                <g:if test="${book.coverData}">

                                    <img src="${createLink(
                                        controller: 'book',
                                        action: 'cover',
                                        id: book.id
                                    )}"
                                         alt="${book.title}"
                                         class="book-cover-image"/>

                                </g:if>


                                <g:else>

                                    <div class="book-cover-placeholder">

                                        <span>
                                            ${book.title}
                                        </span>

                                    </div>

                                </g:else>

                            </div>

                        </g:link>


                        <div class="book-shelf-info">

                            <h3>

                                <g:link controller="book"
                                        action="show"
                                        id="${book.id}">

                                    ${book.title}

                                </g:link>

                            </h3>


                            <g:if test="${book.category}">

                                <p>

                                    <g:link controller="category"
                                            action="show"
                                            id="${book.category.id}">

                                        ${book.category.name}

                                    </g:link>

                                </p>

                            </g:if>


                            <g:if test="${book.publishYear}">

                                <span class="book-meta">
                                    ${book.publishYear}
                                </span>

                            </g:if>


                            <g:if test="${isAdmin && !book.active}">

                                <div class="mt-2">

                                    <span class="status-badge status-inactive">
                                        Inactive
                                    </span>

                                </div>

                            </g:if>

                        </div>

                    </article>

                </g:each>

            </div>

        </g:if>


        <g:else>

            <div class="empty-state">

                <h3>
                    No books available
                </h3>

                <p>

                    There are currently no
                    ${isAdmin ? '' : 'active '}
                    books by ${author.name}
                    in the collection.

                </p>

            </div>

        </g:else>

    </div>

</section>


</body>

</html>