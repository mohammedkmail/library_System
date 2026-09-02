#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

printf '\n[1/6] Java\n'
java -version

printf '\n[2/6] Grails\n'
if command -v grails >/dev/null 2>&1; then
  grails --version
else
  echo 'تحذير: أمر grails غير موجود في PATH.'
fi

printf '\n[3/6] الملفات الأساسية\n'
required=(
  grails-app/controllers/librarysystem/PaymentController.groovy
  grails-app/services/librarysystem/PaymentService.groovy
  grails-app/services/librarysystem/BraintreeGatewayService.groovy
  grails-app/services/librarysystem/HolidayCalendarService.groovy
  grails-app/domain/librarysystem/Payment.groovy
  grails-app/domain/librarysystem/CheckoutIntent.groovy
  grails-app/views/payment/checkout.gsp
  grails-app/views/holiday/index.gsp
  grails-app/views/discountRule/index.gsp
)
for file in "${required[@]}"; do
  [[ -f "$file" ]] || { echo "ملف ناقص: $file"; exit 1; }
done
echo 'الملفات الأساسية موجودة.'

printf '\n[4/6] إعدادات التكاملات\n'
if [[ -n "${BRAINTREE_MERCHANT_ID:-}" && -n "${BRAINTREE_PUBLIC_KEY:-}" && -n "${BRAINTREE_PRIVATE_KEY:-}" ]]; then
  echo 'Braintree Sandbox: configured'
else
  echo 'Braintree Sandbox: NOT configured (الدفع الأونلاين لن يعمل حتى تضبط المفاتيح)'
fi
if [[ -n "${HOLIDAY_API_KEY:-}" ]]; then
  echo 'Holiday API: configured'
else
  echo 'Holiday API: not configured (سيعمل fallback المحلي)'
fi

printf '\n[5/6] Compile\n'
if command -v grails >/dev/null 2>&1; then
  grails compile
else
  ./gradlew compileGroovy
fi

printf '\n[6/6] Tests\n'
./gradlew test

echo '\nتم التحقق بنجاح.'
