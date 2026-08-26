package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class MembershipService {

    Membership get(Serializable id) {
        Membership.get(id)
    }

    List<Membership> list(Map params = [:]) {
        Membership.list(params)
    }

    Long count() {
        Membership.count()
    }

    boolean hasActiveMembership(User user) {

        if (!user) {
            return false
        }

        Date now = new Date()

        Membership membership = Membership.findByUserAndStatus(
            user,
            'ACTIVE'
        )

        if (!membership) {
            return false
        }

        if (membership.endDate < now) {
            membership.status = 'EXPIRED'
            membership.save(flush: true)

            return false
        }

        return membership.startDate <= now &&
               membership.endDate >= now
    }

    Membership createMembership(
        User user,
        Date startDate,
        Date endDate,
        BigDecimal price
    ) {

        if (!user) {
            throw new IllegalArgumentException('User is required.')
        }

        if (!startDate || !endDate) {
            throw new IllegalArgumentException(
                'Start date and end date are required.'
            )
        }

        if (endDate <= startDate) {
            throw new IllegalArgumentException(
                'Membership end date must be after the start date.'
            )
        }

        if (price == null || price < 0) {
            throw new IllegalArgumentException(
                'Membership price cannot be negative.'
            )
        }

        Membership activeMembership =
            Membership.findByUserAndStatus(user, 'ACTIVE')

        if (activeMembership &&
            activeMembership.endDate >= startDate) {

            throw new IllegalStateException(
                'User already has an active membership.'
            )
        }

        Membership membership = new Membership(
            user: user,
            startDate: startDate,
            endDate: endDate,
            price: price,
            status: 'ACTIVE'
        )

        membership.save(
            flush: true,
            failOnError: true
        )

        membership
    }

    Membership cancelMembership(Long id) {

        Membership membership = Membership.get(id)

        if (!membership) {
            return null
        }

        membership.status = 'CANCELLED'

        membership.save(
            flush: true,
            failOnError: true
        )

        membership
    }
}