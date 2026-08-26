package librarysystem

import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class MembershipController {

    SpringSecurityService springSecurityService
    MembershipService membershipService

    def index() {

        User currentUser =
            springSecurityService.currentUser as User

        List<Membership> memberships

        if (isAdmin(currentUser)) {

            memberships = Membership.list(
                sort: 'startDate',
                order: 'desc'
            )

        } else {

            memberships = Membership.findAllByUser(
                currentUser,
                [
                    sort : 'startDate',
                    order: 'desc'
                ]
            )
        }

        respond memberships
    }

    def show(Long id) {

        Membership membership =
            membershipService.get(id)

        if (!membership) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            membership.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        respond membership
    }

    def create() {

        User currentUser =
            springSecurityService.currentUser as User

        respond new Membership(
            user: currentUser
        )
    }

    def save() {

        User currentUser =
            springSecurityService.currentUser as User

        Date startDate = params.date(
            'startDate',
            'yyyy-MM-dd'
        )

        Date endDate = params.date(
            'endDate',
            'yyyy-MM-dd'
        )

        BigDecimal price =
            params.bigDecimal('price')

        try {

            Membership membership =
                membershipService.createMembership(
                    currentUser,
                    startDate,
                    endDate,
                    price
                )

            flash.message =
                'Membership created successfully.'

            redirect action: 'show',
                     id: membership.id

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message = e.message

            respond new Membership(
                user: currentUser,
                startDate: startDate,
                endDate: endDate,
                price: price
            ),
            view: 'create'
        }
    }

    def cancel(Long id) {

        Membership membership =
            membershipService.get(id)

        if (!membership) {
            notFound()
            return
        }

        User currentUser =
            springSecurityService.currentUser as User

        if (
            !isAdmin(currentUser) &&
            membership.user.id != currentUser.id
        ) {
            render status: 403
            return
        }

        membershipService.cancelMembership(id)

        flash.message =
            'Membership cancelled successfully.'

        redirect action: 'index'
    }

    private boolean isAdmin(User user) {

        user.authorities*.authority
            .contains('ROLE_ADMIN')
    }

    protected void notFound() {
        render status: 404
    }
}