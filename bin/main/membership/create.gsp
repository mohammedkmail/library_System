<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Create Membership</title>
</head>

<body>

<div class="container py-5">

    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">
        ← Back to Memberships
    </g:link>

    <div class="row g-5">

        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                Library Membership
            </div>

            <h1 class="display-6 fw-semibold mb-3">
                Choose your membership period.
            </h1>

            <p class="lead text-muted">
                Your membership is charged by the day.
                Start and end dates are both included
                in the calculation.
            </p>

            <div class="border-top mt-4 pt-4">

                <div class="small text-muted mb-1">
                    Daily membership price
                </div>

                <div class="h3 mb-1">
                    $${pricePerDay}
                </div>

                <div class="text-muted">
                    per day
                </div>

            </div>

        </div>

        <div class="col-lg-7">

            <g:hasErrors bean="${membership}">
                <div class="alert alert-danger">
                    Please review the membership dates below.
                </div>
            </g:hasErrors>

            <g:form action="save"
                    method="POST">

                <div class="border-top">

                    <div class="py-4 border-bottom">

                        <label for="startDate"
                               class="form-label fw-semibold">
                            Start Date
                        </label>

                        <g:field type="date"
                                 name="startDate"
                                 id="startDate"
                                 value="${membership?.startDate?.format('yyyy-MM-dd')}"
                                 class="form-control"
                                 required="true"/>

                        <div class="text-danger small mt-1">
                            <g:fieldError
                                bean="${membership}"
                                field="startDate"/>
                        </div>

                    </div>

                    <div class="py-4 border-bottom">

                        <label for="endDate"
                               class="form-label fw-semibold">
                            End Date
                        </label>

                        <g:field type="date"
                                 name="endDate"
                                 id="endDate"
                                 value="${membership?.endDate?.format('yyyy-MM-dd')}"
                                 class="form-control"
                                 required="true"/>

                        <div class="text-danger small mt-1">
                            <g:fieldError
                                bean="${membership}"
                                field="endDate"/>
                        </div>

                    </div>

                </div>

                <div id="priceSummary"
                     class="mt-4 p-4 border d-none">

                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">
                            Membership days
                        </span>

                        <strong id="numberOfDays">
                            0
                        </strong>
                    </div>

                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">
                            Price per day
                        </span>

                        <strong>
                            $${pricePerDay}
                        </strong>
                    </div>

                    <div class="border-top pt-3
                                d-flex justify-content-between
                                align-items-end">

                        <span class="fw-semibold">
                            Estimated total
                        </span>

                        <strong id="totalPrice"
                                class="h4 mb-0">
                            $0.00
                        </strong>

                    </div>

                </div>

                <div id="dateError"
                     class="alert alert-danger mt-4 d-none">
                    End date must be the same as
                    or later than the start date.
                </div>

                <div class="mt-4">

                    <button type="submit"
                            id="createMembershipButton"
                            class="btn btn-primary">
                        Create Membership
                    </button>

                </div>

            </g:form>

        </div>

    </div>

</div>

<script>

document.addEventListener(
    'DOMContentLoaded',
    function () {

        const startInput =
            document.getElementById('startDate');

        const endInput =
            document.getElementById('endDate');

        const priceSummary =
            document.getElementById('priceSummary');

        const numberOfDaysElement =
            document.getElementById('numberOfDays');

        const totalPriceElement =
            document.getElementById('totalPrice');

        const dateError =
            document.getElementById('dateError');

        const submitButton =
            document.getElementById(
                'createMembershipButton'
            );

        const pricePerDay =
            Number('${pricePerDay}');


        function parseDate(value) {

            const parts =
                value.split('-');

            return Date.UTC(
                Number(parts[0]),
                Number(parts[1]) - 1,
                Number(parts[2])
            );
        }


        function calculatePrice() {

            if (
                !startInput.value ||
                !endInput.value
            ) {

                priceSummary.classList.add('d-none');
                dateError.classList.add('d-none');
                submitButton.disabled = false;

                return;
            }


            const start =
                parseDate(startInput.value);

            const end =
                parseDate(endInput.value);


            if (end < start) {

                priceSummary.classList.add('d-none');
                dateError.classList.remove('d-none');
                submitButton.disabled = true;

                return;
            }


            dateError.classList.add('d-none');
            submitButton.disabled = false;


            const oneDay =
                1000 * 60 * 60 * 24;

            const difference =
                end - start;

            const numberOfDays =
                Math.floor(
                    difference / oneDay
                ) + 1;

            const totalPrice =
                numberOfDays *
                pricePerDay;


            numberOfDaysElement.textContent =
                numberOfDays +
                (
                    numberOfDays === 1
                        ? ' day'
                        : ' days'
                );

            totalPriceElement.textContent =
                '$' +
                totalPrice.toFixed(2);

            priceSummary.classList.remove('d-none');
        }


        startInput.addEventListener(
            'change',
            calculatePrice
        );

        endInput.addEventListener(
            'change',
            calculatePrice
        );

        calculatePrice();
    }
);

</script>

</body>
</html>