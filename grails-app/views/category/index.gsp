<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>Categories</title>

</head>

<body>


<section class="catalog-header">

    <div class="container">

        <div class="catalog-header-inner">

            <div>

                <span class="section-eyebrow">
                    Explore the collection
                </span>

                <h1 class="catalog-title">
                    Categories
                </h1>

                <p class="catalog-intro">

                    Browse the library by subject and discover
                    books collected around the topics that
                    interest you.

                </p>

            </div>


            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="catalog-header-action">

                    <g:link controller="category"
                            action="create"
                            class="btn btn-library-primary">

                        Add Category

                    </g:link>

                </div>

            </sec:ifAnyGranted>

        </div>

    </div>

</section>



<section class="catalog-section">

    <div class="container">


        <!-- =================================================
             ADMIN VIEW
        ================================================== -->

        <g:if test="${isAdmin}">

            <div class="admin-section-heading">

                <div>

                    <span class="section-eyebrow">
                        Catalog management
                    </span>

                    <h2>
                        Manage Categories
                    </h2>

                </div>

                <span class="admin-result-count">
                    ${categoryCount ?: 0} categories
                </span>

            </div>


            <g:if test="${categoryList}">

                <div class="admin-table-wrap">

                    <table class="table library-admin-table align-middle">

                        <thead>

                        <tr>

                            <th>
                                Category
                            </th>

                            <th>
                                Description
                            </th>

                            <th>
                                Status
                            </th>

                            <th class="text-end">
                                Actions
                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <g:each in="${categoryList}"
                                var="category">

                            <tr>

                                <td>

                                    <g:link controller="category"
                                            action="show"
                                            id="${category.id}"
                                            class="admin-primary-link">

                                        ${category.name}

                                    </g:link>

                                </td>


                                <td class="admin-table-description">

                                    <g:if test="${category.description}">

                                        ${category.description}

                                    </g:if>

                                    <g:else>

                                        <span class="text-muted">
                                            No description
                                        </span>

                                    </g:else>

                                </td>


                                <td>

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

                                </td>


                                <td class="text-end">

                                    <div class="admin-table-actions">

                                        <g:link controller="category"
                                                action="show"
                                                id="${category.id}"
                                                class="btn btn-sm btn-outline-secondary">

                                            View

                                        </g:link>


                                        <g:link controller="category"
                                                action="edit"
                                                id="${category.id}"
                                                class="btn btn-sm btn-outline-primary">

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

                    <h3>
                        No categories yet
                    </h3>

                    <p>
                        Create the first category to begin organizing
                        the library catalog.
                    </p>

                </div>

            </g:else>

        </g:if>



        <!-- =================================================
             PUBLIC / USER VIEW
        ================================================== -->

        <g:if test="${!isAdmin}">

            <g:if test="${categoryList}">

                <div class="category-directory">

                    <g:each in="${categoryList}"
                            var="category"
                            status="i">

                        <article class="category-directory-item">

                            <div class="category-number">

                                ${(params.int('offset') ?: 0) + i + 1}

                            </div>


                            <div class="category-directory-content">

                                <h2>

                                    <g:link controller="category"
                                            action="show"
                                            id="${category.id}">

                                        ${category.name}

                                    </g:link>

                                </h2>


                                <g:if test="${category.description}">

                                    <p>
                                        ${category.description}
                                    </p>

                                </g:if>

                                <g:else>

                                    <p class="text-muted">
                                        Explore books available in this category.
                                    </p>

                                </g:else>

                            </div>


                            <div class="category-directory-action">

                                <g:link controller="category"
                                        action="show"
                                        id="${category.id}"
                                        class="text-link">

                                    Explore books
                                    <span aria-hidden="true">
                                        →
                                    </span>

                                </g:link>

                            </div>

                        </article>

                    </g:each>

                </div>

            </g:if>


            <g:else>

                <div class="empty-state">

                    <h2>
                        No categories available
                    </h2>

                    <p>
                        There are no active library categories
                        to browse right now.
                    </p>

                </div>

            </g:else>

        </g:if>



        <!-- =================================================
             PAGINATION
        ================================================== -->

        <g:if test="${categoryCount > (params.int('max') ?: 12)}">

            <div class="library-pagination">

                <g:paginate
                    controller="category"
                    action="index"
                    total="${categoryCount ?: 0}"
                    max="${params.int('max') ?: 12}"/>

            </div>

        </g:if>

    </div>

</section>


</body>

</html>