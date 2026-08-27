<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <title>Create Membership</title>
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>
            <h1>Create Membership</h1>

            <p class="text-muted mb-0">
                Choose your membership period.
                The price is $${pricePerDay} per day.
            </p>
        </div>


        <g:link
            action="index"
            class="btn btn-secondary">

            Back to Memberships

        </g:link>

    </div>


    <g:if test="${flash.message}">

        <div class="alert alert-danger">
            ${flash.message}
        </div>

    </g:if>


    <g:hasErrors bean="${membership}">

        <div class="alert alert-danger">
            Please fix the errors below.
        </div>

    </g:hasErrors>


    <div class="card shadow-sm">

        <div class="card-body p-4">

            <g:form
                action="save"
                method="POST">


                <div class="mb-3">

                    <label class="form-label">
                        Start Date
                    </label>


                    <g:field
                        type="date"
                        name="startDate"
                        id="startDate"
                        value="${membership?.startDate?.format('yyyy-MM-dd')}"
                        class="form-control"
                        required="true"
                    />


                    <g:fieldError
                        bean="${membership}"
                        field="startDate"
                    />

                </div>


                <div class="mb-3">

                    <label class="form-label">
                        End Date
                    </label>


                    <g:field
                        type="date"
                        name="endDate"
                        id="endDate"
                        value="${membership?.endDate?.format('yyyy-MM-dd')}"
                        class="form-control"
                        required="true"
                    />


                    <g:fieldError
                        bean="${membership}"
                        field="endDate"
                    />

                </div>


                <div
                    id="priceSummary"
                    class="alert alert-info d-none">

                    <div class="d-flex justify-content-between">

                        <span>
                            Membership Days
                        </span>

                        <strong id="numberOfDays">
                            0
                        </strong>

                    </div>


                    <hr/>


                    <div class="d-flex justify-content-between">

                        <span>
                            Price Per Day
                        </span>

                        <strong>
                            $${pricePerDay}
                        </strong>

                    </div>


                    <hr/>


                    <div class="d-flex justify-content-between">

                        <span>
                            Total Price
                        </span>

                        <strong id="totalPrice">
                            $0.00
                        </strong>

                    </div>

                </div>


                <button
                    type="submit"
                    class="btn btn-primary">

                    Create Membership

                </button>

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

        const pricePerDay =
            10.00;


        function calculatePrice() {

            if (
                !startInput.value ||
                !endInput.value
            ) {

                priceSummary.classList.add('d-none');
                return;
            }


            const start =
                new Date(
                    startInput.value +
                    'T00:00:00'
                );

            const end =
                new Date(
                    endInput.value +
                    'T00:00:00'
                );


            if (end < start) {

                priceSummary.classList.add('d-none');
                return;
            }


            const millisecondsPerDay =
                1000 * 60 * 60 * 24;


            const difference =
                Math.round(
                    (end - start) /
                    millisecondsPerDay
                );


            const numberOfDays =
                difference + 1;


            const totalPrice =
                numberOfDays *
                pricePerDay;


            numberOfDaysElement.textContent =
                numberOfDays;


            totalPriceElement.textContent =
                '$' +
                totalPrice.toFixed(2);


            priceSummary.classList.remove(
                'd-none'
            );
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