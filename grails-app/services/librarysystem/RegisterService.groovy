package librarysystem

import grails.gorm.transactions.Transactional

@Transactional
class RegisterService {

    User registerUser(
        String username,
        String password
    ) {

        Role role =
            Role.findByAuthority('ROLE_USER')

        if (!role) {
            throw new IllegalStateException(
                'User role is not configured.'
            )
        }

        User user =
            new User(
                username: username,
                password: password,
                enabled: true
            )

        if (!user.save(flush: true)) {
            throw new IllegalArgumentException(
                user.errors.allErrors
                    .collect { it.defaultMessage }
                    .join(', ')
            )
        }

        UserRole.create(
            user,
            role,
            true
        )

        user
    }
}