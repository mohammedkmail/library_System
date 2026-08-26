<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Create Book</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Create Book</h1>

        <g:link action="index" class="btn btn-secondary">
            Back to Books
        </g:link>
    </div>

    <g:if test="${flash.message}">
        <div class="alert alert-info">
            ${flash.message}
        </div>
    </g:if>

    <g:hasErrors bean="${book}">
        <div class="alert alert-danger">
            Please fix the errors below.
        </div>
    </g:hasErrors>

    <g:uploadForm action="save">

        <div class="mb-3">
            <label class="form-label">Title</label>

            <g:textField
                name="title"
                value="${book?.title}"
                class="form-control ${book?.errors?.hasFieldErrors('title') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="title"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">ISBN</label>

            <g:textField
                name="isbn"
                value="${book?.isbn}"
                class="form-control ${book?.errors?.hasFieldErrors('isbn') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="isbn"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Description</label>

            <g:textArea
                name="description"
                value="${book?.description}"
                rows="4"
                class="form-control ${book?.errors?.hasFieldErrors('description') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="description"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Publish Year</label>

            <g:field
                type="number"
                name="publishYear"
                value="${book?.publishYear}"
                class="form-control ${book?.errors?.hasFieldErrors('publishYear') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="publishYear"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Author</label>

            <g:select
                name="author.id"
                from="${authorList}"
                optionKey="id"
                optionValue="name"
                value="${book?.author?.id}"
                noSelection="['': 'Select Author']"
                class="form-select ${book?.errors?.hasFieldErrors('author') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="author"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Category</label>

            <g:select
                name="category.id"
                from="${categoryList}"
                optionKey="id"
                optionValue="name"
                value="${book?.category?.id}"
                noSelection="['': 'Select Category']"
                class="form-select ${book?.errors?.hasFieldErrors('category') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="category"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Book Cover</label>

            <input
                type="file"
                name="coverFile"
                accept="image/*"
                class="form-control"
            />
        </div>

        <hr>

        <h4>Physical Book</h4>

        <div class="mb-3">
            <label class="form-label">Physical Sale Stock</label>

            <g:field
                type="number"
                name="physicalSaleStock"
                value="${book?.physicalSaleStock ?: 0}"
                class="form-control ${book?.errors?.hasFieldErrors('physicalSaleStock') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="physicalSaleStock"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Physical Sale Price</label>

            <g:field
                type="number"
                step="0.01"
                name="physicalSalePrice"
                value="${book?.physicalSalePrice}"
                class="form-control ${book?.errors?.hasFieldErrors('physicalSalePrice') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="physicalSalePrice"/>
            </div>
        </div>

        <hr>

        <h4>Digital Book</h4>

        <div class="form-check mb-3">
            <g:checkBox
                name="digitalAvailable"
                value="${book?.digitalAvailable}"
                class="form-check-input"
            />

            <label class="form-check-label">
                Digital Version Available
            </label>
        </div>

        <div class="mb-3">
            <label class="form-label">Digital Purchase Price</label>

            <g:field
                type="number"
                step="0.01"
                name="digitalPurchasePrice"
                value="${book?.digitalPurchasePrice}"
                class="form-control ${book?.errors?.hasFieldErrors('digitalPurchasePrice') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="digitalPurchasePrice"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Digital Rental Price</label>

            <g:field
                type="number"
                step="0.01"
                name="digitalRentalPrice"
                value="${book?.digitalRentalPrice}"
                class="form-control ${book?.errors?.hasFieldErrors('digitalRentalPrice') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="digitalRentalPrice"/>
            </div>
        </div>

        <div class="form-check mb-3">
            <g:checkBox
                name="membershipIncluded"
                value="${book?.membershipIncluded}"
                class="form-check-input"
            />

            <label class="form-check-label">
                Included with Membership
            </label>

            <div class="text-danger mt-1">
                <g:fieldError bean="${book}" field="membershipIncluded"/>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Digital Content</label>

            <g:textArea
                name="digitalContent"
                value="${book?.digitalContent}"
                rows="6"
                class="form-control ${book?.errors?.hasFieldErrors('digitalContent') ? 'is-invalid' : ''}"
            />

            <div class="invalid-feedback">
                <g:fieldError bean="${book}" field="digitalContent"/>
            </div>
        </div>

        <div class="form-check mb-4">
            <g:checkBox
                name="active"
                value="${book?.active}"
                class="form-check-input"
            />

            <label class="form-check-label">
                Active
            </label>
        </div>

        <button type="submit" class="btn btn-primary">
            Create Book
        </button>

    </g:uploadForm>

</div>

</body>
</html>