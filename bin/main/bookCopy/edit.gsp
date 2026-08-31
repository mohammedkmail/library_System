<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Edit Book Copy</title>
</head>

<body>

<div class="container py-5">

    <g:link
        action="show"
        id="${bookCopy?.id}"
        class="back-link">

        ← Back to Copy

    </g:link>


    <div class="row mt-4">

        <div class="col-lg-7">

            <div class="section-eyebrow">
                Circulation Inventory
            </div>

            <h1 class="display-6 fw-semibold mb-2">
                Edit Book Copy
            </h1>

            <p class="text-muted mb-5">
                Update the copy identifier or
                administrative availability status.
            </p>


            <g:hasErrors bean="${bookCopy}">

                <div class="alert alert-danger">
                    Please fix the errors below.
                </div>

            </g:hasErrors>


            <g:form
                controller="bookCopy"
                action="update"
                id="${bookCopy.id}"
                method="PUT">

                <g:hiddenField
                    name="version"
                    value="${bookCopy?.version}"
                />


                <div class="border-top">

                    <div class="py-4 border-bottom">

                        <label class="form-label fw-semibold">
                            Book
                        </label>


                        <g:if test="${canChangeBook}">

                            <g:select
                                name="book.id"
                                from="${bookList}"
                                optionKey="id"
                                optionValue="title"
                                value="${bookCopy?.book?.id}"
                                class="form-select"
                            />

                        </g:if>


                        <g:else>

                            <div class="form-control-plaintext fw-semibold">
                                ${bookCopy?.book?.title}
                            </div>

                            <div class="form-text">
                                The book cannot be changed
                                after this physical copy has
                                entered circulation history.
                            </div>

                        </g:else>

                    </div>


                    <div class="py-4 border-bottom">

                        <label
                            for="copyCode"
                            class="form-label fw-semibold">

                            Copy Code

                        </label>


                        <g:textField
                            id="copyCode"
                            name="copyCode"
                            value="${bookCopy?.copyCode}"
                            class="form-control ${bookCopy?.errors?.hasFieldErrors('copyCode') ? 'is-invalid' : ''}"
                        />


                        <div class="invalid-feedback">

                            <g:fieldError
                                bean="${bookCopy}"
                                field="copyCode"
                            />

                        </div>

                    </div>


                    <div class="py-4 border-bottom">

                        <label class="form-label fw-semibold">
                            Status
                        </label>


                        <g:if test="${statusEditable}">

                            <g:select
                                name="status"
                                from="${statusOptions}"
                                value="${bookCopy?.status}"
                                class="form-select"
                            />


                            <div class="form-text">
                                Use LOST or DAMAGED when a
                                physical copy is unavailable.
                                Return it to AVAILABLE after
                                recovery or repair.
                            </div>

                        </g:if>


                        <g:else>

                            <div class="form-control-plaintext fw-semibold">
                                ${bookCopy?.status}
                            </div>


                            <div class="form-text">
                                BORROWED and RESERVED statuses
                                are controlled automatically by
                                the circulation workflow.
                            </div>

                        </g:else>

                    </div>

                </div>


                <button
                    type="submit"
                    class="btn btn-primary mt-4">

                    Update Book Copy

                </button>

            </g:form>

        </div>

    </div>

</div>

</body>

</html>