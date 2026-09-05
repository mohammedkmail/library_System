package librarysystem

import grails.gorm.transactions.Transactional

import java.time.LocalDate
import java.time.ZoneId
import java.time.temporal.ChronoUnit
import java.math.RoundingMode

@Transactional
class MembershipService {

    private static final BigDecimal PRICE_PER_DAY = new BigDecimal('1.00')

    /*
     * Duration discounts are intentionally server-side. The browser only
     * previews them; this service remains the source of truth used before
     * the membership reaches checkout.
     */
    private static final List<Map<String, Object>> DISCOUNT_TIERS = [
        [minDays: 365, percentage: new BigDecimal('20'), label: 'سنة أو أكثر'],
        [minDays: 180, percentage: new BigDecimal('15'), label: '6 أشهر أو أكثر'],
        [minDays: 90,  percentage: new BigDecimal('10'), label: '3 أشهر أو أكثر'],
        [minDays: 30,  percentage: new BigDecimal('5'),  label: 'شهر أو أكثر']
    ].asImmutable()

    Membership get(Serializable id) { Membership.get(id) }
    List<Membership> list(Map params = [:]) { Membership.list(params) }
    Long count() { Membership.count() }

    boolean hasActiveMembership(User user) {
        if (!user) return false
        Membership membership = Membership.findByUserAndStatus(user, 'ACTIVE')
        if (!membership) return false

        LocalDate today = LocalDate.now()
        LocalDate startDate = toLocalDate(membership.startDate)
        LocalDate endDate = toLocalDate(membership.endDate)
        if (endDate.isBefore(today)) {
            membership.status = 'EXPIRED'
            membership.save(flush: true, failOnError: true)
            return false
        }
        !today.isBefore(startDate) && !today.isAfter(endDate)
    }

    Membership createMembershipRequest(User user, Date startDate, Date endDate) {
        validateDates(user, startDate, endDate)
        Map pricing = calculatePricing(startDate, endDate)
        BigDecimal price = pricing.totalPrice as BigDecimal

        Membership pending = Membership.findByUserAndStatus(user, 'PENDING')
        if (pending) {
            pending.startDate = startDate
            pending.endDate = endDate
            pending.price = price
            pending.save(flush: true, failOnError: true)
            return pending
        }

        new Membership(user: user, startDate: startDate, endDate: endDate, price: price, status: 'PENDING')
            .save(flush: true, failOnError: true)
    }

    Membership activateMembership(Long id) {
        Membership membership = Membership.lock(id)
        if (!membership) throw new IllegalArgumentException('طلب العضوية غير موجود.')
        if (membership.status == 'ACTIVE') return membership
        if (membership.status != 'PENDING') throw new IllegalStateException('طلب العضوية لم يعد بانتظار الدفع.')

        Membership current = Membership.findByUserAndStatus(membership.user, 'ACTIVE')
        if (current && current.id != membership.id && !toLocalDate(current.endDate).isBefore(toLocalDate(membership.startDate))) {
            throw new IllegalStateException('لدى المستخدم عضوية فعالة تغطي هذه الفترة.')
        }

        membership.status = 'ACTIVE'
        membership.save(flush: true, failOnError: true)
        membership
    }

    Membership cancelMembership(Long id) {
        Membership membership = Membership.get(id)
        if (!membership) return null
        membership.status = 'CANCELLED'
        membership.save(flush: true, failOnError: true)
        membership
    }

    Map calculatePricing(Date startDate, Date endDate) {
        if (!startDate || !endDate) {
            return emptyPricing()
        }

        LocalDate start = toLocalDate(startDate)
        LocalDate end = toLocalDate(endDate)
        if (end.isBefore(start)) {
            return emptyPricing()
        }

        long days = ChronoUnit.DAYS.between(start, end) + 1
        BigDecimal basePrice = PRICE_PER_DAY
            .multiply(BigDecimal.valueOf(days))
            .setScale(2, RoundingMode.HALF_UP)

        Map<String, Object> tier = DISCOUNT_TIERS.find { Map<String, Object> candidate ->
            days >= (candidate.minDays as Integer)
        }

        BigDecimal percentage = tier ? (tier.percentage as BigDecimal) : BigDecimal.ZERO
        BigDecimal discountAmount = basePrice
            .multiply(percentage)
            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP)
        BigDecimal totalPrice = basePrice
            .subtract(discountAmount)
            .setScale(2, RoundingMode.HALF_UP)

        [
            days              : days,
            basePrice         : basePrice,
            discountPercentage: percentage,
            discountAmount    : discountAmount,
            totalPrice        : totalPrice,
            tierLabel         : tier?.label
        ]
    }

    BigDecimal calculatePrice(Date startDate, Date endDate) {
        calculatePricing(startDate, endDate).totalPrice as BigDecimal
    }

    BigDecimal getPricePerDay() { PRICE_PER_DAY }

    List<Map<String, Object>> getDiscountTiers() {
        DISCOUNT_TIERS.collect { Map<String, Object> tier -> new LinkedHashMap<String, Object>(tier) }
    }

    private Map emptyPricing() {
        [
            days              : 0L,
            basePrice         : BigDecimal.ZERO.setScale(2),
            discountPercentage: BigDecimal.ZERO,
            discountAmount    : BigDecimal.ZERO.setScale(2),
            totalPrice        : BigDecimal.ZERO.setScale(2),
            tierLabel         : null
        ]
    }

    private void validateDates(User user, Date startDate, Date endDate) {
        if (!user) throw new IllegalArgumentException('يجب تسجيل الدخول لطلب عضوية.')
        if (!startDate || !endDate) throw new IllegalArgumentException('حدد تاريخ بداية ونهاية العضوية.')
        LocalDate start = toLocalDate(startDate)
        LocalDate end = toLocalDate(endDate)
        if (end.isBefore(start)) throw new IllegalArgumentException('تاريخ نهاية العضوية لا يمكن أن يسبق تاريخ البداية.')
        if (start.isBefore(LocalDate.now())) throw new IllegalArgumentException('لا يمكن بدء عضوية جديدة بتاريخ سابق.')
    }

    private LocalDate toLocalDate(Date date) {
        date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
    }
}
