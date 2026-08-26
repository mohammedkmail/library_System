<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Dashboard</title>
</head>

<body>

<div class="container mt-4">

    <div class="mb-4">
        <h1>Library Dashboard</h1>
        <p class="text-muted mb-0">
            Overview of the main library activities
        </p>
    </div>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="text-muted">Total Books</h6>
                    <h2>${totalBooks ?: 0}</h2>
                    <p class="mb-0">
                        Books registered in the system
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="text-muted">Active Borrowings</h6>
                    <h2>${activeBorrowings ?: 0}</h2>
                    <p class="mb-0">
                        Books currently borrowed
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="text-muted">Waiting Reservations</h6>
                    <h2>${waitingReservations ?: 0}</h2>
                    <p class="mb-0">
                        Users waiting for physical copies
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="text-muted">Completed Purchases</h6>
                    <h2>${completedPurchases ?: 0}</h2>
                    <p class="mb-0">
                        Successfully completed purchases
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="text-muted">Total Sales</h6>
                    <h2>${totalSales ?: 0}</h2>
                    <p class="mb-0">
                        Total value of completed purchases
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="text-muted">Room Reservations</h6>
                    <h2>${confirmedRoomReservations ?: 0}</h2>
                    <p class="mb-0">
                        Confirmed study-room reservations
                    </p>
                </div>
            </div>
        </div>

    </div>

    <div class="mt-4 d-flex gap-2">

        <g:link
            controller="book"
            action="index"
            class="btn btn-primary">
            View Books
        </g:link>

        <sec:ifAnyGranted roles="ROLE_ADMIN">
            <g:link
                controller="book"
                action="create"
                class="btn btn-outline-primary">
                Add Book
            </g:link>
        </sec:ifAnyGranted>

    </div>

</div>

</body>
</html>