<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Create Book</title>
</head>

<body>

<div class="container py-5">

    <g:link
        action="index"
        class="back-link">

        ← Back to Books

    </g:link>


    <div class="row mt-4">

        <div class="col-xl-9">

            <div class="section-eyebrow">
                Catalog Administration
            </div>

            <h1 class="display-6 fw-semibold mb-2">
                Create Book
            </h1>

            <p class="text-muted mb-5">
                Add catalog information, sale options
                and digital access settings.
            </p>


            <g:hasErrors bean="${book}">

                <div class="alert alert-danger">
                    Please fix the errors below.
                </div>

            </g:hasErrors>


            <g:uploadForm action="save">


                <!-- =========================
                     BOOK INFORMATION
                     ========================= -->

                <section class="admin-form-section">

                    <h2 class="h4">
                        Book Information
                    </h2>


                    <div class="row g-4 mt-1">

                        <div class="col-md-8">

                            <label class="form-label">
                                Title
                            </label>

                            <g:textField
                                name="title"
                                value="${book?.title}"
                                class="form-control ${book?.errors?.hasFieldErrors('title') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="title"
                                />
                            </div>

                        </div>


                        <div class="col-md-4">

                            <label class="form-label">
                                ISBN
                            </label>

                            <g:textField
                                name="isbn"
                                value="${book?.isbn}"
                                class="form-control ${book?.errors?.hasFieldErrors('isbn') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="isbn"
                                />
                            </div>

                        </div>


                        <div class="col-12">

                            <label class="form-label">
                                Description
                            </label>

                            <g:textArea
                                name="description"
                                value="${book?.description}"
                                rows="5"
                                class="form-control ${book?.errors?.hasFieldErrors('description') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="description"
                                />
                            </div>

                        </div>


                        <div class="col-md-4">

                            <label class="form-label">
                                Publish Year
                            </label>

                            <g:field
                                type="number"
                                name="publishYear"
                                value="${book?.publishYear}"
                                class="form-control ${book?.errors?.hasFieldErrors('publishYear') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="publishYear"
                                />
                            </div>

                        </div>


                        <div class="col-md-4">

                            <label class="form-label">
                                Author
                            </label>

                            <g:select
                                name="author.id"
                                from="${authorList}"
                                optionKey="id"
                                optionValue="name"
                                value="${book?.author?.id}"
                                noSelection="${['': 'Select Author']}"
                                class="form-select ${book?.errors?.hasFieldErrors('author') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="author"
                                />
                            </div>

                        </div>


                        <div class="col-md-4">

                            <label class="form-label">
                                Category
                            </label>

                            <g:select
                                name="category.id"
                                from="${categoryList}"
                                optionKey="id"
                                optionValue="name"
                                value="${book?.category?.id}"
                                noSelection="${['': 'Select Category']}"
                                class="form-select ${book?.errors?.hasFieldErrors('category') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="category"
                                />
                            </div>

                        </div>


                        <div class="col-12">

                            <label class="form-label">
                                Book Cover
                            </label>

                            <input
                                type="file"
                                name="coverFile"
                                accept="image/*"
                                class="form-control"
                            />

                        </div>

                    </div>

                </section>



                <!-- =========================
                     PHYSICAL SALES
                     ========================= -->

                <section class="admin-form-section">

                    <div class="section-eyebrow">
                        Physical Sales
                    </div>

                    <h2 class="h4">
                        Physical Book for Sale
                    </h2>

                    <p class="text-muted">
                        These values are for bookstore sales.
                        Lending copies are managed separately
                        under Book Copies.
                    </p>


                    <div class="row g-4">

                        <div class="col-md-6">

                            <label class="form-label">
                                Sale Stock
                            </label>

                            <g:field
                                type="number"
                                min="0"
                                name="physicalSaleStock"
                                value="${book?.physicalSaleStock ?: 0}"
                                class="form-control ${book?.errors?.hasFieldErrors('physicalSaleStock') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="physicalSaleStock"
                                />
                            </div>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label">
                                Sale Price
                            </label>

                            <g:field
                                type="number"
                                min="0"
                                step="0.01"
                                name="physicalSalePrice"
                                value="${book?.physicalSalePrice}"
                                class="form-control ${book?.errors?.hasFieldErrors('physicalSalePrice') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="physicalSalePrice"
                                />
                            </div>

                        </div>

                    </div>

                </section>



                <!-- =========================
                     DIGITAL BOOK
                     ========================= -->

                <section class="admin-form-section">

                    <div class="section-eyebrow">
                        Digital Edition
                    </div>

                    <h2 class="h4">
                        Digital Access
                    </h2>


                    <div class="form-check mb-4">

                        <g:checkBox
                            name="digitalAvailable"
                            value="${book?.digitalAvailable}"
                            class="form-check-input"
                        />

                        <label class="form-check-label">
                            Digital version available
                        </label>

                    </div>


                    <div class="row g-4">

                        <div class="col-md-6">

                            <label class="form-label">
                                Digital Purchase Price
                            </label>

                            <g:field
                                type="number"
                                min="0"
                                step="0.01"
                                name="digitalPurchasePrice"
                                value="${book?.digitalPurchasePrice}"
                                class="form-control ${book?.errors?.hasFieldErrors('digitalPurchasePrice') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="digitalPurchasePrice"
                                />
                            </div>

                        </div>


                        <div class="col-md-6">

                            <label class="form-label">
                                Digital Rental Price
                            </label>

                            <g:field
                                type="number"
                                min="0"
                                step="0.01"
                                name="digitalRentalPrice"
                                value="${book?.digitalRentalPrice}"
                                class="form-control ${book?.errors?.hasFieldErrors('digitalRentalPrice') ? 'is-invalid' : ''}"
                            />

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="digitalRentalPrice"
                                />
                            </div>

                        </div>


                        <div class="col-12">

                            <div class="form-check">

                                <g:checkBox
                                    name="membershipIncluded"
                                    value="${book?.membershipIncluded}"
                                    class="form-check-input"
                                />

                                <label class="form-check-label">
                                    Include this digital edition
                                    with active membership
                                </label>

                            </div>

                        </div>


                        <div class="col-12">

                            <label class="form-label">
                                Digital Content
                            </label>

                            <g:textArea
                                name="digitalContent"
                                value="${book?.digitalContent}"
                                rows="10"
                                class="form-control ${book?.errors?.hasFieldErrors('digitalContent') ? 'is-invalid' : ''}"
                            />

                            <div class="form-text">
                                Content displayed inside the protected digital reader.
                            </div>

                            <div class="invalid-feedback">
                                <g:fieldError
                                    bean="${book}"
                                    field="digitalContent"
                                />
                            </div>

                        </div>

                    </div>

                </section>



                <!-- =========================
                     STATUS
                     ========================= -->

                <section class="admin-form-section">

                    <div class="form-check">

                        <g:checkBox
                            name="active"
                            value="${book?.active}"
                            class="form-check-input"
                        />

                        <label class="form-check-label fw-semibold">
                            Active in catalog
                        </label>

                    </div>

                </section>


                <button
                    type="submit"
                    class="btn btn-primary">

                    Create Book

                </button>

            </g:uploadForm>

        </div>

    </div>

</div>

</body>

</html>