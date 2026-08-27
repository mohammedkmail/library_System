<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Books</title>
</head>

<body>

<section class="catalog-header">
    <div class="container">

        <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3">

            <div>
                <span class="section-eyebrow">Library Catalog</span>

                <h1 class="page-title mb-2">
                    Explore Books
                </h1>

                <p class="text-muted mb-0">
                    Discover physical and digital books available in the library.
                </p>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN">
                <g:link
                    action="create"
                    class="btn btn-primary">

                    <i class="bi bi-plus-circle me-2"></i>
                    Add Book

                </g:link>
            </sec:ifAnyGranted>

        </div>

    </div>
</section>


<section class="catalog-content">
    <div class="container">

        <g:if test="${flash.message}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle me-2"></i>
                ${flash.message}
            </div>
        </g:if>


        <div class="catalog-search-card">

            <g:form
                method="GET"
                action="index"
                class="row g-3 align-items-center">

                <div class="col-lg">

                    <div class="input-group">

                        <span class="input-group-text">
                            <i class="bi bi-search"></i>
                        </span>

                        <input
                            type="text"
                            name="search"
                            value="${search ?: ''}"
                            class="form-control"
                            placeholder="Search by book title..."
                        />

                    </div>

                </div>

                <div class="col-auto">

                    <button
                        type="submit"
                        class="btn btn-primary">

                        Search

                    </button>

                </div>

                <g:if test="${search}">

                    <div class="col-auto">

                        <g:link
                            action="index"
                            class="btn btn-outline-secondary">

                            Clear

                        </g:link>

                    </div>

                </g:if>

            </g:form>

        </div>


        <div class="d-flex justify-content-between align-items-center mb-4">

            <div class="catalog-result-count">

                <strong>${bookCount ?: 0}</strong>

                <span>
                    ${(bookCount ?: 0) == 1 ? 'book' : 'books'} found
                </span>

            </div>

            <g:if test="${search}">

                <div class="text-muted small">
                    Results for:
                    <strong>${search}</strong>
                </div>

            </g:if>

        </div>


        <g:if test="${bookList}">

            <div class="row g-4">

                <g:each in="${bookList}" var="book">

                    <div class="col-sm-6 col-lg-4 col-xl-3">

                        <div class="catalog-book-card">

                            <div class="catalog-book-cover">

                                <g:if test="${book.coverData}">

                                    <img
                                        src="${createLink(
                                            controller: 'book',
                                            action: 'cover',
                                            id: book.id
                                        )}"
                                        alt="${book.title}"
                                    />

                                </g:if>

                                <g:else>

                                    <div class="catalog-no-cover">

                                        <i class="bi bi-book"></i>

                                        <span>
                                            No Cover
                                        </span>

                                    </div>

                                </g:else>


                                <g:if test="${book.digitalAvailable}">

                                    <span class="catalog-badge catalog-badge-digital">

                                        <i class="bi bi-tablet me-1"></i>
                                        Digital

                                    </span>

                                </g:if>


                                <g:if test="${(book.physicalSaleStock ?: 0) > 0}">

                                    <span class="catalog-stock catalog-in-stock">
                                        In Stock
                                    </span>

                                </g:if><g:else>

                                    <span class="catalog-stock catalog-out-stock">
                                        Out of Stock
                                    </span>

                                </g:else>

                            </div>


                            <div class="catalog-book-body">

                                <div class="catalog-category">
                                    ${book.category?.name ?: 'Uncategorized'}
                                </div>

                                <h3 class="catalog-book-title">
                                    ${book.title}
                                </h3>

                                <div class="catalog-author">

                                    <i class="bi bi-person me-1"></i>

                                    ${book.author?.name ?: 'Unknown Author'}

                                </div>


                                <div class="catalog-book-meta">

                                    <span>
                                        <i class="bi bi-upc-scan me-1"></i>
                                        ${book.isbn ?: 'No ISBN'}
                                    </span>

                                </div>


                                <div class="catalog-price-area">

                                    <g:if test="${book.physicalSalePrice != null}">

                                        <div>
                                            <span class="catalog-price-label">
                                                Physical
                                            </span>

                                            <strong class="catalog-price">
                                                ${book.physicalSalePrice}
                                            </strong>
                                        </div>

                                    </g:if>


                                    <g:if test="${book.digitalAvailable && book.digitalPurchasePrice != null}">

                                        <div>
                                            <span class="catalog-price-label">
                                                Digital
                                            </span>

                                            <strong class="catalog-price">
                                                ${book.digitalPurchasePrice}
                                            </strong>
                                        </div>

                                    </g:if>

                                </div>

                            </div>


                            <div class="catalog-book-footer">

                                <g:link
                                    action="show"
                                    id="${book.id}"
                                    class="btn btn-primary flex-grow-1">

                                    <i class="bi bi-eye me-1"></i>
                                    View Details

                                </g:link>


                                <sec:ifAnyGranted roles="ROLE_ADMIN">

                                    <g:link
                                        action="edit"
                                        id="${book.id}"
                                        class="btn btn-outline-secondary">

                                        <i class="bi bi-pencil"></i>

                                    </g:link>

                                </sec:ifAnyGranted>

                            </div>

                        </div>

                    </div>

                </g:each>

            </div>

        </g:if><g:else>

            <div class="catalog-empty">

                <div class="catalog-empty-icon">
                    <i class="bi bi-search"></i>
                </div>

                <h3>
                    No books found
                </h3>

                <p>
                    Try changing your search term or browse the full catalog.
                </p>

                <g:link
                    action="index"
                    class="btn btn-primary">

                    View All Books

                </g:link>

            </div>

        </g:else>


        <g:if test="${bookCount > params.int('max')}">

            <div class="catalog-pagination">

                <g:paginate
                    total="${bookCount ?: 0}"
                    params="[search: search]"
                />

            </div>

        </g:if>

    </div>
</section>

</body>
</html>