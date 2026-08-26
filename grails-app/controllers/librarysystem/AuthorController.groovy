package librarysystem

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class AuthorController {

    AuthorService authorService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond authorService.list(params), model:[authorCount: authorService.count()]
    }

    def show(Long id) {
        respond authorService.get(id)
    }

    def create() {
        respond new Author(params)
    }

    def save(Author author) {
        if (author == null) {
            notFound()
            return
        }

        try {
            authorService.save(author)
        } catch (ValidationException e) {
            respond author.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'author.label', default: 'Author'), author.id])
                redirect author
            }
            '*' { respond author, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond authorService.get(id)
    }

    def update(Author author) {
        if (author == null) {
            notFound()
            return
        }

        try {
            authorService.save(author)
        } catch (ValidationException e) {
            respond author.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'author.label', default: 'Author'), author.id])
                redirect author
            }
            '*'{ respond author, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        authorService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'author.label', default: 'Author'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'author.label', default: 'Author'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
