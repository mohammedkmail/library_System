<!DOCTYPE html>
<html>

<head>

    <meta name="layout" content="main"/>

    <title>
        Read ${book?.title}
    </title>

</head>

<body>

<div class="digital-reader-page">


    <section class="reader-header">

        <div class="container">

            <div class="reader-header-inner">


                <div class="reader-book-identity">

                    <g:if test="${book?.coverData}">

                        <img
                            src="${createLink(
                                controller: 'book',
                                action: 'cover',
                                id: book.id
                            )}"
                            alt="${book?.title}"
                            class="reader-mini-cover"/>

                    </g:if>


                    <div>

                        <span class="reader-label">

                            <i class="bi bi-shield-check"></i>

                            Protected Digital Reading

                        </span>


                        <h1>
                            ${book?.title}
                        </h1>


                        <p>
                            ${book?.author?.name}
                        </p>

                    </div>

                </div>


                <g:link controller="book"
                        action="show"
                        id="${book?.id}"
                        class="btn reader-back-btn">

                    <i class="bi bi-arrow-left me-2"></i>

                    Book Details

                </g:link>

            </div>

        </div>

    </section>



    <section class="reader-area">

        <div class="container">


            <div class="reader-toolbar">

                <div>

                    <i class="bi bi-book-half"></i>

                    <span>
                        Digital Edition
                    </span>

                </div>


                <div class="reader-status">

                    <span class="reader-status-dot"></span>

                    Access Active

                </div>

            </div>



            <div class="reader-paper">


                <div class="reader-paper-heading">

                    <span>
                        ${book?.category?.name}
                    </span>

                    <h2>
                        ${book?.title}
                    </h2>

                    <p>
                        ${book?.author?.name}
                    </p>

                </div>



                <div class="reader-divider">

                    <span></span>

                    <i class="bi bi-book"></i>

                    <span></span>

                </div>



                <g:if test="${book?.digitalContent}">

                    <article class="reader-text">

                        ${book.digitalContent}

                    </article>

                </g:if>


                <g:else>

                    <div class="reader-empty">

                        <div class="reader-empty-icon">

                            <i class="bi bi-file-earmark-text"></i>

                        </div>


                        <h3>
                            Content not available yet
                        </h3>


                        <p>

                            Digital access is valid,
                            but reading content has not
                            been added to this book yet.

                        </p>

                    </div>

                </g:else>



                <div class="reader-end">

                    <i class="bi bi-book-half"></i>

                    <span>
                        End of available digital content
                    </span>

                </div>

            </div>



            <div class="reader-footer-actions">

                <g:link controller="book"
                        action="show"
                        id="${book?.id}"
                        class="btn btn-outline-dark">

                    <i class="bi bi-arrow-left me-2"></i>

                    Back to Book

                </g:link>


                <g:link controller="digitalAccess"
                        action="index"
                        class="btn btn-primary">

                    <i class="bi bi-collection me-2"></i>

                    My Digital Library

                </g:link>

            </div>

        </div>

    </section>

</div>

</body>

</html>