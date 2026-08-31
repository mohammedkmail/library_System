<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>${category.name}</title>

</head>

<body>


<section class="detail-hero">

    <div class="container">

        <div class="detail-hero-inner">

            <div>

                <g:link controller="category"
                        action="index"
                        class="back-link">

                    ← All Categories

                </g:link>


                <span class="section-eyebrow">
                    Library category
                </span>


                <h1 class="detail-title">
                    ${category.name}
                </h1>


                <g:if test="${category.description}">

                    <p class="detail-lead">
                        ${category.description}
                    </p>

                </g:if>


                <g:if test="${isAdmin}">

                    <div class="mt-3">

                        <g:if test="${category.active}">

                            <span class="status-badge status-active">
                                Active
                            </span>

                        </g:if>

                        <g:else>

                            <span class="status-badge status-inactive">
                                Inactive
                            </span>

                        </g:else>

                    </div>

                </g:if>

            </div>



            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="detail-admin-actions">

                    <g:link controller="category"
                            action="edit"
                            id="${category.id}"
                            class="btn btn-outline-primary">

                        Edit Category

                    </g:link>


                    <g:form controller="category"
                            action="delete"
                            id="${category.id}"
                            method="DELETE"
                            class="d-inline">

                        <button type="submit"
                                class="btn btn-outline-danger"
                                onclick="return confirm('Are you sure you want to delete this category?');">

                            Delete

                        </button>

                    </g:form>

                </div>

            </sec:ifAnyGranted>

        </div>

    </div>

</section>



<section class="book-collection-section">

    <div class="container">

        <div class="collection-heading">

            <div>

                <span class="section-eyebrow">
                    In this category
                </span>

                <h2>
                    Books
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


                            <g:if test="${book.author}">

                                <p>
                                    ${book.author.name}
                                </p>

                            </g:if>


                            <g:if test="${isAdmin && !book.active}">

                                <span class="status-badge status-inactive">
                                    Inactive
                                </span>

                            </g:if>

                        </div>

                    </article>

                </g:each>

            </div>

        </g:if>


        <g:else>

            <div class="empty-state">

                <h3>
                    No books in this category
                </h3>

                <p>

                    There are currently no
                    ${isAdmin ? '' : 'active '}
                    books assigned to this category.

                </p>

            </div>

        </g:else>

    </div>

</section>


</body>

</html>