<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>الدفع الآمن | المنارة</title>
</head>
<body>
<section class="mn-payment-page">
    <div class="container">
        <div class="mn-payment-shell">
            <div class="mn-payment-summary">
                <span class="mn-payment-kicker">محاكاة دفع آمنة</span>
                <h1>إتمام الدفع</h1>
                <p>هذه صفحة تدريبية تحاكي الدفع ببطاقة Visa ولا ترسل أي بيانات إلى بنك أو بوابة دفع حقيقية.</p>

                <div class="mn-payment-order">
                    <span class="mn-payment-order-icon"><i class="bi ${targetIcon ?: 'bi-credit-card'}"></i></span>
                    <div>
                        <small>${targetDescription}</small>
                        <strong dir="auto">${targetTitle}</strong>
                    </div>
                    <b>$<g:formatNumber number="${amount}" minFractionDigits="2" maxFractionDigits="2"/></b>
                </div>

                <div class="mn-payment-trust">
                    <i class="bi bi-shield-check"></i>
                    <span>لا نحفظ رقم البطاقة الكامل أو CVV. بعد نجاح المحاكاة يُحفظ آخر 4 أرقام فقط مع مرجع العملية.</span>
                </div>
            </div>

            <div class="mn-card-checkout">
                <div class="mn-visa-card" aria-hidden="true">
                    <div class="mn-visa-top">
                        <span>المنارة</span>
                        <strong>VISA</strong>
                    </div>
                    <div class="mn-card-chip"></div>
                    <div class="mn-card-number-preview" id="cardNumberPreview">4242&nbsp;4242&nbsp;4242&nbsp;4242</div>
                    <div class="mn-visa-bottom">
                        <span><small>حامل البطاقة</small><b id="cardHolderPreview">اسمك هنا</b></span>
                        <span><small>تنتهي</small><b id="cardExpiryPreview">12/30</b></span>
                    </div>
                </div>

                <div class="mn-test-card-note">
                    <i class="bi bi-info-circle"></i>
                    للتجربة استخدم <strong dir="ltr">4242 4242 4242 4242</strong>، تاريخًا مستقبليًا مثل <strong dir="ltr">12/30</strong>، وCVV <strong dir="ltr">123</strong>.
                </div>

                <g:form controller="payment" action="process" method="POST" class="mn-payment-form" id="paymentForm">
                    <g:hiddenField name="purpose" value="${purpose}"/>
                    <g:hiddenField name="targetId" value="${targetId}"/>

                    <label>
                        <span>اسم حامل البطاقة</span>
                        <input type="text" name="cardholderName" id="cardholderName" maxlength="100" autocomplete="cc-name" placeholder="الاسم كما يظهر على البطاقة" required dir="auto"/>
                    </label>

                    <label>
                        <span>رقم بطاقة Visa</span>
                        <div class="mn-payment-input-icon">
                            <i class="bi bi-credit-card-2-front"></i>
                            <input type="text" name="cardNumber" id="cardNumber" inputmode="numeric" autocomplete="cc-number" maxlength="23" placeholder="4242 4242 4242 4242" required dir="ltr"/>
                        </div>
                    </label>

                    <div class="mn-payment-row">
                        <label>
                            <span>تاريخ الانتهاء</span>
                            <input type="text" name="expiry" id="cardExpiry" inputmode="numeric" autocomplete="cc-exp" maxlength="7" placeholder="MM/YY" required dir="ltr"/>
                        </label>

                        <label>
                            <span>CVV</span>
                            <input type="password" name="cvv" inputmode="numeric" autocomplete="cc-csc" maxlength="3" placeholder="123" required dir="ltr"/>
                        </label>
                    </div>

                    <button type="submit" class="mn-pay-button">
                        <i class="bi bi-lock"></i>
                        دفع $<g:formatNumber number="${amount}" minFractionDigits="2" maxFractionDigits="2"/>
                    </button>
                </g:form>

                <g:form controller="payment" action="cancel" method="POST" class="mn-payment-cancel-form">
                    <g:hiddenField name="purpose" value="${purpose}"/>
                    <g:hiddenField name="targetId" value="${targetId}"/>
                    <button type="submit">إلغاء والعودة</button>
                </g:form>
            </div>
        </div>
    </div>
</section>
</body>
</html>
