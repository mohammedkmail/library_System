package librarysystem

import grails.gorm.transactions.Transactional

import java.time.LocalDate
import java.time.ZoneId
import java.time.temporal.ChronoUnit

@Transactional
class MembershipService {

    private static final BigDecimal PRICE_PER_DAY =
        new BigDecimal('10.00')


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

        Membership membership =
            Membership.findByUserAndStatus(
                user,
                'ACTIVE'
            )

        if (!membership) {
            return false
        }

        LocalDate today =
            LocalDate.now()

        LocalDate startDate =
            toLocalDate(membership.startDate)

        LocalDate endDate =
            toLocalDate(membership.endDate)


        if (endDate.isBefore(today)) {

            membership.status = 'EXPIRED'

            membership.save(
                flush: true,
                failOnError: true
            )

            return false
        }


        return !today.isBefore(startDate) &&
               !today.isAfter(endDate)
    }


    Membership createMembership(
        User user,
        Date startDate,
        Date endDate
    ) {

        if (!user) {
            throw new IllegalArgumentException(
                'User is required.'
            )
        }


        if (!startDate || !endDate) {
            throw new IllegalArgumentException(
                'Start date and end date are required.'
            )
        }


        LocalDate start =
            toLocalDate(startDate)

        LocalDate end =
            toLocalDate(endDate)


        if (end.isBefore(start)) {
            throw new IllegalArgumentException(
                'Membership end date cannot be before the start date.'
            )
        }


        long numberOfDays =
            ChronoUnit.DAYS.between(
                start,
                end
            ) + 1


        BigDecimal price =
            PRICE_PER_DAY.multiply(
                BigDecimal.valueOf(numberOfDays)
            )


        Membership activeMembership =
            Membership.findByUserAndStatus(
                user,
                'ACTIVE'
            )


        if (activeMembership) {

            LocalDate activeEndDate =
                toLocalDate(
                    activeMembership.endDate
                )

            if (!activeEndDate.isBefore(start)) {

                throw new IllegalStateException(
                    'User already has an active membership.'
                )
            }
        }


        Membership membership =
            new Membership(
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

        Membership membership =
            Membership.get(id)

        if (!membership) {
            return null
        }


        membership.status =
            'CANCELLED'


        membership.save(
            flush: true,
            failOnError: true
        )


        membership
    }


    BigDecimal calculatePrice(
        Date startDate,
        Date endDate
    ) {

        if (!startDate || !endDate) {
            return BigDecimal.ZERO
        }


        LocalDate start =
            toLocalDate(startDate)

        LocalDate end =
            toLocalDate(endDate)


        if (end.isBefore(start)) {
            return BigDecimal.ZERO
        }


        long numberOfDays =
            ChronoUnit.DAYS.between(
                start,
                end
            ) + 1


        PRICE_PER_DAY.multiply(
            BigDecimal.valueOf(numberOfDays)
        )
    }


    BigDecimal getPricePerDay() {
        PRICE_PER_DAY
    }


    private LocalDate toLocalDate(Date date) {

        date.toInstant()
            .atZone(ZoneId.systemDefault())
            .toLocalDate()
    }
}