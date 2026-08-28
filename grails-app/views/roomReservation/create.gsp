<!DOCTYPE html>
<html>

<head>

    <meta name="layout" content="main"/>

    <title>
        Reserve Study Room
    </title>

</head>

<body>

<div class="container py-5">


    <g:link action="index"
            class="text-decoration-none d-inline-block mb-4">

        ← Back to Room Reservations

    </g:link>


    <div class="row g-5">


        <!-- =================================================
             INTRO
        ================================================== -->

        <div class="col-lg-5">

            <div class="text-uppercase small fw-semibold text-muted mb-2">
                Study Rooms
            </div>


            <h1 class="display-6 fw-semibold mb-3">

                Reserve a quiet place to work.

            </h1>


            <p class="lead text-muted">

                Select a study room and choose your
                start and end time. The reservation
                price is calculated from the room's
                hourly rate.

            </p>


            <div class="border-top pt-4 mt-4">

                <div class="small text-muted mb-2">
                    Reservation rules
                </div>

                <p class="mb-2">
                    Start time must be in the future.
                </p>

                <p class="mb-2">
                    End time must be later than start time.
                </p>

                <p class="mb-0">
                    A room cannot be booked during
                    an overlapping reservation.
                </p>

            </div>

        </div>



        <!-- =================================================
             FORM
        ================================================== -->

        <div class="col-lg-7">


            <g:hasErrors bean="${roomReservation}">

                <div class="alert alert-danger">

                    Please review the reservation
                    information below.

                </div>

            </g:hasErrors>


            <g:if test="${activeRooms}">

                <g:form action="save"
                        method="POST">


                    <!-- ROOM -->

                    <div class="border-top py-4 border-bottom">

                        <label for="studyRoom"
                               class="form-label fw-semibold">

                            Study Room

                        </label>


                        <select
                            name="studyRoom.id"
                            id="studyRoom"
                            class="form-select"
                            required>

                            <option value="">
                                Select study room
                            </option>


                            <g:each in="${activeRooms}"
                                    var="room">

                                <option
                                    value="${room.id}"
                                    data-price="${room.pricePerHour}"
                                    data-capacity="${room.capacity}"
                                    ${roomReservation?.studyRoom?.id == room.id ? 'selected' : ''}>

                                    Room ${room.roomNumber}
                                    —
                                    Capacity ${room.capacity}
                                    —
                                    $${room.pricePerHour}/hour

                                </option>

                            </g:each>

                        </select>


                        <div id="roomInformation"
                             class="small text-muted mt-2 d-none">

                            Capacity:
                            <strong id="selectedCapacity"></strong>

                            <span class="mx-2">•</span>

                            Hourly rate:
                            <strong id="selectedPrice"></strong>

                        </div>

                    </div>



                    <!-- START -->

                    <div class="py-4 border-bottom">

                        <label for="startTime"
                               class="form-label fw-semibold">

                            Start Time

                        </label>


                        <input
                            type="datetime-local"
                            name="startTime"
                            id="startTime"
                            value="${roomReservation?.startTime?.format("yyyy-MM-dd'T'HH:mm")}"
                            class="form-control"
                            required/>


                        <div class="text-danger small mt-1">

                            <g:fieldError
                                bean="${roomReservation}"
                                field="startTime"/>

                        </div>

                    </div>



                    <!-- END -->

                    <div class="py-4 border-bottom">

                        <label for="endTime"
                               class="form-label fw-semibold">

                            End Time

                        </label>


                        <input
                            type="datetime-local"
                            name="endTime"
                            id="endTime"
                            value="${roomReservation?.endTime?.format("yyyy-MM-dd'T'HH:mm")}"
                            class="form-control"
                            required/>


                        <div class="text-danger small mt-1">

                            <g:fieldError
                                bean="${roomReservation}"
                                field="endTime"/>

                        </div>

                    </div>



                    <!-- ERROR -->

                    <div id="timeError"
                         class="alert alert-danger mt-4 d-none">

                        End time must be later than
                        start time.

                    </div>



                    <!-- PRICE PREVIEW -->

                    <div id="roomPriceSummary"
                         class="border mt-4 p-4 d-none">


                        <div class="d-flex justify-content-between mb-3">

                            <span class="text-muted">
                                Duration
                            </span>

                            <strong id="reservationDuration">
                                —
                            </strong>

                        </div>


                        <div class="d-flex justify-content-between mb-3">

                            <span class="text-muted">
                                Price per hour
                            </span>

                            <strong id="hourlyPrice">
                                —
                            </strong>

                        </div>


                        <div class="border-top pt-3
                                    d-flex justify-content-between
                                    align-items-end">

                            <span class="fw-semibold">
                                Estimated total
                            </span>

                            <strong id="estimatedTotal"
                                    class="h4 mb-0">

                                —

                            </strong>

                        </div>

                    </div>



                    <div class="mt-4">

                        <button type="submit"
                                id="reserveRoomButton"
                                class="btn btn-primary">

                            Confirm Reservation

                        </button>

                    </div>

                </g:form>

            </g:if>


            <g:else>

                <div class="alert alert-info">

                    There are currently no active study
                    rooms available for reservation.

                </div>

            </g:else>

        </div>

    </div>

</div>



<script>

document.addEventListener(
    'DOMContentLoaded',
    function () {

        const roomSelect =
            document.getElementById('studyRoom');

        const startInput =
            document.getElementById('startTime');

        const endInput =
            document.getElementById('endTime');

        const roomInformation =
            document.getElementById('roomInformation');

        const selectedCapacity =
            document.getElementById('selectedCapacity');

        const selectedPrice =
            document.getElementById('selectedPrice');

        const priceSummary =
            document.getElementById('roomPriceSummary');

        const reservationDuration =
            document.getElementById('reservationDuration');

        const hourlyPrice =
            document.getElementById('hourlyPrice');

        const estimatedTotal =
            document.getElementById('estimatedTotal');

        const timeError =
            document.getElementById('timeError');

        const submitButton =
            document.getElementById('reserveRoomButton');


        if (
            !roomSelect ||
            !startInput ||
            !endInput
        ) {
            return;
        }


        function updateRoomInformation() {

            const option =
                roomSelect.options[
                    roomSelect.selectedIndex
                ];


            if (
                !option ||
                !option.value
            ) {

                roomInformation.classList.add('d-none');
                return;
            }


            const capacity =
                option.dataset.capacity;

            const price =
                Number(option.dataset.price);


            selectedCapacity.textContent =
                capacity;

            selectedPrice.textContent =
                '$' + price.toFixed(2) + '/hour';


            roomInformation.classList.remove('d-none');
        }


        function calculatePrice() {

            updateRoomInformation();


            const option =
                roomSelect.options[
                    roomSelect.selectedIndex
                ];


            if (
                !option ||
                !option.value ||
                !startInput.value ||
                !endInput.value
            ) {

                priceSummary.classList.add('d-none');
                timeError.classList.add('d-none');
                submitButton.disabled = false;

                return;
            }


            const start =
                new Date(startInput.value);

            const end =
                new Date(endInput.value);


            if (
                Number.isNaN(start.getTime()) ||
                Number.isNaN(end.getTime()) ||
                end <= start
            ) {

                priceSummary.classList.add('d-none');
                timeError.classList.remove('d-none');
                submitButton.disabled = true;

                return;
            }


            timeError.classList.add('d-none');
            submitButton.disabled = false;


            const pricePerHour =
                Number(option.dataset.price);


            const durationMinutes =
                (end - start) /
                (1000 * 60);


            const durationHours =
                durationMinutes / 60;


            const totalPrice =
                durationHours *
                pricePerHour;


            const hours =
                Math.floor(
                    durationMinutes / 60
                );


            const minutes =
                Math.round(
                    durationMinutes % 60
                );


            let durationText = '';


            if (hours > 0) {

                durationText +=
                    hours +
                    (
                        hours === 1
                            ? ' hour'
                            : ' hours'
                    );
            }


            if (minutes > 0) {

                if (durationText) {
                    durationText += ' ';
                }

                durationText +=
                    minutes +
                    (
                        minutes === 1
                            ? ' minute'
                            : ' minutes'
                    );
            }


            reservationDuration.textContent =
                durationText;


            hourlyPrice.textContent =
                '$' +
                pricePerHour.toFixed(2);


            estimatedTotal.textContent =
                '$' +
                totalPrice.toFixed(2);


            priceSummary.classList.remove('d-none');
        }


        roomSelect.addEventListener(
            'change',
            calculatePrice
        );


        startInput.addEventListener(
            'change',
            calculatePrice
        );


        endInput.addEventListener(
            'change',
            calculatePrice
        );


        updateRoomInformation();
        calculatePrice();
    }
);

</script>

</body>

</html>