<!DOCTYPE html>
<html>

<head>

    <meta name="layout"
          content="main"/>

    <title>Authors</title>

</head>

<body>


<section class="catalog-header">

    <div class="container">

        <div class="catalog-header-inner">

            <div>

                <span class="section-eyebrow">
                    Writers in the collection
                </span>

                <h1 class="catalog-title">
                    Authors
                </h1>

                <p class="catalog-intro">

                    Discover writers represented in the library
                    and explore the books available from each author.

                </p>

            </div>


            <sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="catalog-header-action">

                    <g:link controller="author"
                            action="create"
                            class="btn btn-library-primary">

                        Add Author

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
                        Manage Authors
                    </h2>

                </div>


                <span class="admin-result-count">

                    ${authorCount ?: 0}
                    authors

                </span>

            </div>



            <g:if test="${authorList}">

                <div class="admin-table-wrap">

                    <table class="table library-admin-table align-middle">

                        <thead>

                        <tr>

                            <th>
                                Author
                            </th>

                            <th>
                                Biography
                            </th>

                            <th class="text-end">
                                Actions
                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <g:each in="${authorList}"
                                var="author">

                            <tr>

                                <td>

                                    <g:link controller="author"
                                            action="show"
                                            id="${author.id}"
                                            class="admin-primary-link">

                                        ${author.name}

                                    </g:link>

                                </td>


                                <td class="admin-table-description">

                                    <g:if test="${author.biography}">

                                        ${author.biography}

                                    </g:if>

                                    <g:else>

                                        <span class="text-muted">
                                            No biography
                                        </span>

                                    </g:else>

                                </td>


                                <td class="text-end">

                                    <div class="admin-table-actions">

                                        <g:link controller="author"
                                                action="show"
                                                id="${author.id}"
                                                class="btn btn-sm btn-outline-secondary">

                                            View

                                        </g:link>


                                        <g:link controller="author"
                                                action="edit"
                                                id="${author.id}"
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
                        No authors yet
                    </h3>

                    <p>
                        Add the first author to begin building
                        the library catalog.
                    </p>

                </div>

            </g:else>

        </g:if>



        <!-- =================================================
             PUBLIC / USER VIEW
        ================================================== -->

        <g:else>

            <g:if test="${authorList}">

                <div class="author-directory">

                    <g:each in="${authorList}"
                            var="author">

                        <article class="author-directory-item">

                            <div class="author-initial">

                                ${author.name ?
                                    author.name.substring(0, 1).toUpperCase()
                                    :
                                    '?'}

                            </div>


                            <div class="author-directory-content">

                                <h2>

                                    <g:link controller="author"
                                            action="show"
                                            id="${author.id}">

                                        ${author.name}

                                    </g:link>

                                </h2>


                                <g:if test="${author.biography}">

                                    <p>

                                        ${author.biography.size() > 180 ?
                                            author.biography.substring(0, 180) + '…'
                                            :
                                            author.biography}

                                    </p>

                                </g:if>


                                <g:else>

                                    <p class="text-muted">

                                        Explore books by this author
                                        in the library collection.

                                    </p>

                                </g:else>

                            </div>


                            <div class="author-directory-action">

                                <g:link controller="author"
                                        action="show"
                                        id="${author.id}"
                                        class="text-link">

                                    View author
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
                        No authors available
                    </h2>

                    <p>
                        Authors will appear here as the library
                        collection grows.
                    </p>

                </div>

            </g:else>

        </g:else>



        <!-- =================================================
             PAGINATION
        ================================================== -->

        <g:if test="${authorCount > (params.int('max') ?: 12)}">

            <div class="library-pagination">

                <g:paginate
                    controller="author"
                    action="index"
                    total="${authorCount ?: 0}"
                    max="${params.int('max') ?: 12}"/>

            </div>

        </g:if>

    </div>

</section>


</body>

</html>