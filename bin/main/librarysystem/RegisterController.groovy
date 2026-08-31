package librarysystem

import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class RegisterController {

    RegisterService registerService

    static allowedMethods = [
        save: 'POST'
    ]

    def create() {

        respond new User()
    }

    def save() {

        String username =
            params.username?.trim()

        String password =
            params.password

        String confirmPassword =
            params.confirmPassword


        if (!username) {

            flash.message =
                'Username is required.'

            respond new User(
                username: username
            ),
            view: 'create'

            return
        }


        if (!password) {

            flash.message =
                'Password is required.'

            respond new User(
                username: username
            ),
            view: 'create'

            return
        }


        if (password != confirmPassword) {

            flash.message =
                'Passwords do not match.'

            respond new User(
                username: username
            ),
            view: 'create'

            return
        }


        if (User.findByUsername(username)) {

            flash.message =
                'This username is already registered.'

            respond new User(
                username: username
            ),
            view: 'create'

            return
        }


        try {

            registerService.registerUser(
                username,
                password
            )

            flash.message =
                'Account created successfully. You can now sign in.'

            redirect controller: 'login',
                     action: 'auth'

        } catch (
            IllegalArgumentException |
            IllegalStateException e
        ) {

            flash.message = e.message

            respond new User(
                username: username
            ),
            view: 'create'
        }
    }
}