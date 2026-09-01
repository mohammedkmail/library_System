<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>المؤلفون | المنارة</title>
</head>
<body>
<section class="mn-catalog-page mn-authors-catalog">
    <div class="container">
        <header class="mn-editorial-header">
            <div>
                <span class="mn-editorial-kicker">أصحاب الكلمات</span>
                <h1>المؤلفون</h1>
                <p>تعرّف إلى الكتّاب الموجودين في المنارة، واقرأ نبذة سريعة عن كل اسم قبل أن تفتح رف كتبه.</p>
            </div>
            <div class="mn-editorial-side">
                <span class="mn-count-stamp"><b>${authorCount ?: 0}</b> مؤلف</span>
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    <g:link action="create" class="mn-solid-action"><i class="bi bi-plus-lg"></i> إضافة مؤلف</g:link>
                </sec:ifAnyGranted>
            </div>
        </header>

        <g:if test="${authorList}">
            <div class="mn-author-notes-grid">
                <g:each in="${authorList}" var="author" status="i">
                    <article class="mn-author-note">
                        <div class="mn-note-index">${String.format('%02d', i + 1 + (params.int('offset') ?: 0))}</div>
                        <div class="mn-author-monogram" dir="auto">${author.name?.trim()?.take(1)?.toUpperCase() ?: '؟'}</div>
                        <div class="mn-author-note-copy">
                            <span class="mn-note-label">${authorBookCounts?.get(author.id) ?: 0} كتاب في المكتبة</span>
                            <h2 dir="auto"><g:link action="show" id="${author.id}">${author.name}</g:link></h2>
                            <p>${author.biography ?: 'لم تُضف سيرة مختصرة لهذا المؤلف بعد.'}</p>
                        </div>
                        <div class="mn-note-actions">
                            <g:link action="show" id="${author.id}" class="mn-text-action">فتح صفحة المؤلف <i class="bi bi-arrow-left"></i></g:link>
                            <sec:ifAnyGranted roles="ROLE_ADMIN">
                                <g:link action="edit" id="${author.id}" class="mn-icon-action" title="تعديل"><i class="bi bi-pencil"></i></g:link>
                            </sec:ifAnyGranted>
                        </div>
                    </article>
                </g:each>
            </div>

            <div class="mn-pagination-wrap">
                <g:paginate total="${authorCount ?: 0}" max="${params.int('max') ?: 12}"/>
            </div>
        </g:if>
        <g:else>
            <div class="mn-catalog-empty"><i class="bi bi-pen"></i><h2>لا يوجد مؤلفون بعد</h2><p>عند إضافة المؤلفين سيظهر كل اسم هنا مع سيرته وكتبه.</p></div>
        </g:else>
    </div>
</section>
</body>
</html>
