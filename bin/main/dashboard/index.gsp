<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>لوحة التحكم | المنارة</title>
</head>
<body>

<section class="mn-system-page mn-dashboard-page">
    <div class="container">
        <div class="mn-page-heading">
            <div>
                <span class="mn-page-kicker"><i class="bi bi-grid"></i> نظرة سريعة</span>
                <h1>لوحة تحكم المنارة</h1>
                <p>ملخص لأهم حركة المكتبة والعمليات المسجلة في النظام.</p>
            </div>

            <div class="mn-page-actions">
                <g:link controller="book" action="index" class="btn btn-outline-primary">
                    <i class="bi bi-book"></i> تصفح الكتب
                </g:link>
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    <g:link controller="book" action="create" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> إضافة كتاب
                    </g:link>
                </sec:ifAnyGranted>
            </div>
        </div>

        <div class="mn-dashboard-grid">
            <g:link controller="book" action="index" class="mn-dashboard-card">
                <span class="mn-dashboard-card-icon"><i class="bi bi-bookshelf"></i></span>
                <div><small>إجمالي الكتب</small><strong>${totalBooks ?: 0}</strong><p>كتاب مسجل في النظام</p></div>
                <i class="bi bi-arrow-left mn-dashboard-card-arrow"></i>
            </g:link>

            <g:link controller="borrowing" action="index" class="mn-dashboard-card">
                <span class="mn-dashboard-card-icon"><i class="bi bi-arrow-left-right"></i></span>
                <div><small>الاستعارات الفعالة</small><strong>${activeBorrowings ?: 0}</strong><p>كتب ما زالت قيد الاستعارة</p></div>
                <i class="bi bi-arrow-left mn-dashboard-card-arrow"></i>
            </g:link>

            <g:link controller="reservation" action="index" class="mn-dashboard-card">
                <span class="mn-dashboard-card-icon"><i class="bi bi-bookmark"></i></span>
                <div><small>الحجوزات المنتظرة</small><strong>${waitingReservations ?: 0}</strong><p>طلبات بانتظار توفر نسخة</p></div>
                <i class="bi bi-arrow-left mn-dashboard-card-arrow"></i>
            </g:link>

            <g:link controller="purchase" action="index" class="mn-dashboard-card">
                <span class="mn-dashboard-card-icon"><i class="bi bi-bag-check"></i></span>
                <div><small>المشتريات المكتملة</small><strong>${completedPurchases ?: 0}</strong><p>عمليات شراء ناجحة</p></div>
                <i class="bi bi-arrow-left mn-dashboard-card-arrow"></i>
            </g:link>

            <g:link controller="purchase" action="index" class="mn-dashboard-card highlight">
                <span class="mn-dashboard-card-icon"><i class="bi bi-cash-stack"></i></span>
                <div><small>إجمالي المبيعات</small><strong>$${totalSales ?: 0}</strong><p>قيمة المشتريات المكتملة</p></div>
                <i class="bi bi-arrow-left mn-dashboard-card-arrow"></i>
            </g:link>

            <g:link controller="roomReservation" action="index" class="mn-dashboard-card">
                <span class="mn-dashboard-card-icon"><i class="bi bi-door-open"></i></span>
                <div><small>حجوزات الغرف</small><strong>${confirmedRoomReservations ?: 0}</strong><p>حجوزات غرف دراسة مؤكدة</p></div>
                <i class="bi bi-arrow-left mn-dashboard-card-arrow"></i>
            </g:link>
        </div>

        <div class="mn-dashboard-shortcuts">
            <div class="mn-dashboard-shortcuts-copy">
                <span>وصول سريع</span>
                <h2>انتقل مباشرة إلى ما تحتاجه</h2>
            </div>

            <div class="mn-dashboard-shortcuts-grid">
                <g:link controller="borrowing" action="index"><i class="bi bi-arrow-left-right"></i><span>الاستعارات</span></g:link>
                <g:link controller="reservation" action="index"><i class="bi bi-bookmark-check"></i><span>حجوزات الكتب</span></g:link>
                <g:link controller="membership" action="index"><i class="bi bi-person-badge"></i><span>العضوية</span></g:link>
                <g:link controller="digitalAccess" action="index"><i class="bi bi-tablet"></i><span>المكتبة الرقمية</span></g:link>
                <g:link controller="roomReservation" action="index"><i class="bi bi-calendar-check"></i><span>حجوزات الغرف</span></g:link>
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    <g:link controller="studyRoom" action="index"><i class="bi bi-door-closed"></i><span>إدارة الغرف</span></g:link>
                </sec:ifAnyGranted>
            </div>
        </div>
    </div>
</section>

</body>
</html>
