<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Books</title>
</head>

<body>

<section class="catalog-header">

    <div class="container">

        <div class="catalog-header-inner">

            <div>

                <span class="section-eyebrow">
                    Library Catalog
                </span>

                <h1 class="catalog-title">
                    Explore Books
                </h1>

                <p class="catalog-intro">
                    Discover books to borrow, purchase
                    or read digitally.
                </p>

            </div>


            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <g:link
                    action="create"
                    class="btn btn-primary">

                    Add Book

                </g:link>

            </sec:ifAnyGranted>

        </div>

    </div>

</section>


<section class="catalog-section">

    <div class="container">


        <g:form
            action="index"
            method="GET"
            class="catalog-search">

            <div class="input-group">

                <span class="input-group-text">
                    <i class="bi bi-search"></i>
                </span>

                <input
                    type="text"
                    name="search"
                    value="${search ?: ''}"
                    class="form-control"
                    placeholder="Search by title..."
                />

                <button
                    type="submit"
                    class="btn btn-primary">

                    Search

                </button>

            </div>

        </g:form>


        <div class="d-flex justify-content-between
                    align-items-center mt-4 mb-4">

            <div class="text-muted">

                <strong>
                    ${bookCount ?: 0}
                </strong>

                ${(bookCount ?: 0) == 1
                    ? 'book'
                    : 'books'}

            </div>


            <g:if test="${search}">

                <g:link
                    action="index"
                    class="text-link">

                    Clear search

                </g:link>

            </g:if>

        </div>



        <g:if test="${bookList}">

            <div class="book-shelf-grid">

                <g:each
                    in="${bookList}"
                    var="book">

                    <article class="book-shelf-item">


                        <g:link
                            action="show"
                            id="${book.id}"
                            class="book-cover-link">

                            <div class="book-cover-frame">

                                <g:if test="${book.coverData}">

                                    <img
                                        src="${createLink(
                                            controller: 'book',
                                            action: 'cover',
                                            id: book.id
                                        )}"
                                        alt="${book.title}"
                                        class="book-cover-image"
                                    />

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

                            <div class="book-meta">

                                ${book.category?.name ?: 'Uncategorized'}

                            </div>


                            <h2 class="h5 mb-1">

                                <g:link
                                    action="show"
                                    id="${book.id}"
                                    class="text-decoration-none">

                                    ${book.title}

                                </g:link>

                            </h2>


                            <div class="text-muted small mb-3">

                                ${book.author?.name ?: 'Unknown Author'}

                            </div>



                            <div class="d-flex flex-wrap gap-2 mb-3">

                                <g:if test="${book.digitalAvailable}">

                                    <span class="status-badge">
                                        Digital
                                    </span>

                                </g:if>


                                <g:if test="${book.membershipIncluded}">

                                    <span class="status-badge">
                                        Membership
                                    </span>

                                </g:if>


                                <g:if test="${(book.physicalSaleStock ?: 0) > 0}">

                                    <span class="status-badge">
                                        Physical Sale
                                    </span>

                                </g:if>


                                <g:if test="${isAdmin && !book.active}">

                                    <span class="status-badge status-inactive">
                                        Inactive
                                    </span>

                                </g:if>

                            </div>



                            <div class="small">

                                <g:if test="${book.physicalSalePrice != null}">

                                    <div class="mb-1">

                                        Physical:

                                        <strong>

                                            $<g:formatNumber
                                                number="${book.physicalSalePrice}"
                                                minFractionDigits="2"
                                                maxFractionDigits="2"
                                            />

                                        </strong>

                                    </div>

                                </g:if>


                                <g:if test="${book.digitalAvailable &&
                                              book.digitalPurchasePrice != null}">

                                    <div>

                                        Digital:

                                        <strong>

                                            $<g:formatNumber
                                                number="${book.digitalPurchasePrice}"
                                                minFractionDigits="2"
                                                maxFractionDigits="2"
                                            />

                                        </strong>

                                    </div>

                                </g:if>

                            </div>



                            <div class="mt-3 d-flex gap-2">

                                <g:link
                                    action="show"
                                    id="${book.id}"
                                    class="btn btn-sm btn-outline-dark">

                                    View Book

                                </g:link>


                                <sec:ifAnyGranted roles="ROLE_ADMIN">

                                    <g:link
                                        action="edit"
                                        id="${book.id}"
                                        class="btn btn-sm btn-outline-secondary">

                                        Edit

                                    </g:link>

                                </sec:ifAnyGranted>

                            </div>

                        </div>

                    </article>

                </g:each>

            </div>

        </g:if>


        <g:else>

            <div class="empty-state">

                <h2>
                    No books found
                </h2>

                <p>
                    Try a different title or return
                    to the full catalog.
                </p>

                <g:link
                    action="index"
                    class="btn btn-primary">

                    View All Books

                </g:link>

            </div>

        </g:else>



        <g:if test="${(bookCount ?: 0) > (pageSize ?: 12)}">

            <div class="library-pagination">

                <g:paginate
                    total="${bookCount ?: 0}"
                    max="${pageSize ?: 12}"
                    params="[search: search]"
                />

            </div>

        </g:if>

    </div>

</section>

</body>

</html>