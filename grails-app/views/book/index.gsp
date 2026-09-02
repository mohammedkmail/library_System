<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>الكتب | المنارة</title>
</head>
<body>
<section class="mn-catalog-page mn-books-catalog">
    <div class="container">
        <header class="mn-editorial-header mn-books-header">
            <div>
                <span class="mn-editorial-kicker">فهرس المنارة</span>
                <h1>الكتب</h1>
                <p>ابحث بالعنوان أو اسم المؤلف أو القسم، ثم افتح الكتاب لتشوف الاستعارة والنسخة الرقمية والشراء من مكان واحد.</p>
            </div>
            <div class="mn-editorial-side">
                <span class="mn-count-stamp"><b>${bookCount ?: 0}</b> كتاب</span>
                <sec:ifAnyGranted roles="ROLE_ADMIN"><g:link action="create" class="mn-solid-action"><i class="bi bi-plus-lg"></i> إضافة كتاب</g:link></sec:ifAnyGranted>
            </div>
        </header>

        <div class="mn-catalog-toolbar">
            <g:form action="index" method="GET" class="mn-catalog-search">
                <i class="bi bi-search"></i>
                <input type="search" name="search" value="${search ?: ''}" placeholder="ابحث بعنوان الكتاب، المؤلف، ISBN أو القسم..." autocomplete="off" dir="auto"/>
                <button type="submit">بحث</button>
            </g:form>
            <g:if test="${search}"><g:link action="index" class="mn-clear-search"><i class="bi bi-x-lg"></i> مسح البحث</g:link></g:if>
        </div>

        <g:if test="${bookList}">
            <div class="mn-library-shelf-grid">
                <g:each in="${bookList}" var="book" status="i">
                    <article class="mn-library-book-card">
                        <div class="mn-book-sequence">${String.format('%02d', i + 1 + (params.int('offset') ?: 0))}</div>
                        <g:link action="show" id="${book.id}" class="mn-library-cover">
                            <g:if test="${book.coverData || book.externalCoverUrl}"><img src="${createLink(controller:'book', action:'cover', id:book.id)}" alt="${book.title}"/></g:if>
                            <g:else><div class="mn-library-cover-placeholder"><i class="bi bi-book"></i><span dir="auto">${book.title}</span></div></g:else>
                            <g:if test="${book.digitalAvailable}"><span class="mn-cover-chip">رقمي</span></g:if>
                        </g:link>

                        <div class="mn-library-book-copy">
                            <div class="mn-book-card-topline">
                                <span>${book.category?.name ?: 'بدون قسم'}</span>
                                <g:if test="${isAdmin && !book.active}"><b>غير مفعّل</b></g:if>
                            </div>
                            <h2 dir="auto"><g:link action="show" id="${book.id}">${book.title}</g:link></h2>
                            <p class="mn-book-author" dir="auto">${book.author?.name ?: 'مؤلف غير محدد'}</p>
                            <p class="mn-book-card-desc">${book.description ?: 'لم يُضف وصف مختصر لهذا الكتاب بعد.'}</p>

                            <div class="mn-book-card-facts">
                                <span><i class="bi bi-journal-check"></i> ${bookAvailability?.get(book.id) ?: 0} نسخة متاحة</span>
                                <g:if test="${book.publishYear}"><span><i class="bi bi-calendar3"></i> ${book.publishYear}</span></g:if>
                                <g:if test="${book.physicalSalePrice != null}"><span><i class="bi bi-bag"></i> $<g:formatNumber number="${book.physicalSalePrice}" minFractionDigits="2" maxFractionDigits="2"/></span></g:if>
                            </div>

                            <div class="mn-book-card-actions">
                                <g:link action="show" id="${book.id}" class="mn-text-action">تفاصيل الكتاب <i class="bi bi-arrow-left"></i></g:link>
                                <sec:ifAnyGranted roles="ROLE_ADMIN"><g:link action="edit" id="${book.id}" class="mn-icon-action" title="تعديل"><i class="bi bi-pencil"></i></g:link></sec:ifAnyGranted>
                            </div>
                        </div>
                    </article>
                </g:each>
            </div>

            <div class="mn-pagination-wrap">
                <g:paginate total="${bookCount ?: 0}" max="${pageSize ?: 12}" params="${search ? [search: search] : [:]}"/>
            </div>
        </g:if>
        <g:else>
            <div class="mn-catalog-empty"><i class="bi bi-search"></i><h2>ما لقينا كتب مطابقة</h2><p>جرّب اسمًا أقصر أو ابحث باسم المؤلف أو القسم.</p><g:link action="index" class="mn-solid-action">عرض كل الكتب</g:link></div>
        </g:else>
    </div>
</section>
</body>
</html>
