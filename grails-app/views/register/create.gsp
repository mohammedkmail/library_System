<!doctype html>
<html>

<head>

    <meta name="layout" content="main"/>

    <title>Create Account | Smart Library</title>

</head>

<body>

<section class="sl-login-page">

    <div class="container">

        <div class="sl-login-shell">


            <!-- LEFT SIDE -->

            <div class="sl-login-visual">

                <div class="sl-login-visual-content">

                    <a href="${createLink(uri: '/')}"
                       class="sl-login-brand">

                        <span class="sl-login-brand-icon">
                            <i class="bi bi-book-half"></i>
                        </span>

                        <span>
                            Smart<span>Library</span>
                        </span>

                    </a>


                    <div class="sl-login-copy">

                        <span class="sl-login-eyebrow">
                            Join Smart Library
                        </span>

                        <h1>
                            Your next
                            <span>chapter</span>
                            starts here.
                        </h1>

                        <p>
                            Create your library account to reserve books,
                            access digital content and book study rooms
                            from one place.
                        </p>

                    </div>


                    <div class="sl-login-features">

                        <div class="sl-login-feature">

                            <span>
                                <i class="bi bi-journal-bookmark"></i>
                            </span>

                            <div>
                                <strong>Reserve books</strong>
                                <small>
                                    Manage your book reservations easily.
                                </small>
                            </div>

                        </div>


                        <div class="sl-login-feature">

                            <span>
                                <i class="bi bi-tablet"></i>
                            </span>

                            <div>
                                <strong>Digital library</strong>
                                <small>
                                    Keep your digital collection together.
                                </small>
                            </div>

                        </div>


                        <div class="sl-login-feature">

                            <span>
                                <i class="bi bi-door-open"></i>
                            </span>

                            <div>
                                <strong>Study rooms</strong>
                                <small>
                                    Reserve available study spaces.
                                </small>
                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- RIGHT SIDE -->

            <div class="sl-login-form-side">

                <div class="sl-login-form-wrap">


                    <div class="sl-login-mobile-brand">

                        <span class="sl-login-brand-icon">
                            <i class="bi bi-book-half"></i>
                        </span>

                        Smart<span>Library</span>

                    </div>


                    <div class="sl-login-heading">

                        <span class="sl-login-form-eyebrow">
                            Get started
                        </span>

                        <h2>
                            Create your account
                        </h2>

                        <p>
                            Enter your details below to create
                            a Smart Library account.
                        </p>

                    </div>


                    <g:hasErrors bean="${user}">

                        <div class="sl-login-alert">

                            <i class="bi bi-exclamation-circle"></i>

                            <div>

                                <g:eachError bean="${user}" var="error">

                                    <div>
                                        <g:message error="${error}"/>
                                    </div>

                                </g:eachError>

                            </div>

                        </div>

                    </g:hasErrors>


                    <g:form controller="register"
                            action="save"
                            method="POST">


                        <!-- USERNAME -->

                        <div class="sl-login-field">

                            <label for="username">
                                Username
                            </label>

                            <div class="sl-login-input-wrap">

                                <span class="sl-login-input-icon">
                                    <i class="bi bi-person"></i>
                                </span>

                                <input
                                    type="text"
                                    name="username"
                                    id="username"
                                    class="form-control sl-login-input"
                                    value="${user?.username ?: ''}"
                                    placeholder="Choose a username"
                                    autocomplete="username"
                                    required
                                    autofocus/>

                            </div>

                        </div>


                        <!-- PASSWORD -->

                        <div class="sl-login-field">

                            <label for="password">
                                Password
                            </label>

                            <div class="sl-login-input-wrap">

                                <span class="sl-login-input-icon">
                                    <i class="bi bi-lock"></i>
                                </span>

                                <input
                                    type="password"
                                    name="password"
                                    id="password"
                                    class="form-control sl-login-input sl-login-password-input"
                                    placeholder="Create a password"
                                    autocomplete="new-password"
                                    required/>

                                <button
                                    type="button"
                                    class="sl-password-toggle"
                                    data-password-target="password"
                                    aria-label="Show password">

                                    <i class="bi bi-eye"></i>

                                </button>

                            </div>

                        </div>


                        <!-- CONFIRM PASSWORD -->

                        <div class="sl-login-field">

                            <label for="confirmPassword">
                                Confirm Password
                            </label>

                            <div class="sl-login-input-wrap">

                                <span class="sl-login-input-icon">
                                    <i class="bi bi-shield-lock"></i>
                                </span>

                                <input
                                    type="password"
                                    name="confirmPassword"
                                    id="confirmPassword"
                                    class="form-control sl-login-input sl-login-password-input"
                                    placeholder="Repeat your password"
                                    autocomplete="new-password"
                                    required/>

                                <button
                                    type="button"
                                    class="sl-password-toggle"
                                    data-password-target="confirmPassword"
                                    aria-label="Show password">

                                    <i class="bi bi-eye"></i>

                                </button>

                            </div>

                        </div>


                        <!-- SUBMIT -->

                        <button
                            type="submit"
                            class="btn sl-login-submit">

                            <span>
                                Create Account
                            </span>

                            <i class="bi bi-arrow-right"></i>

                        </button>


                    </g:form>


                    <div class="sl-login-divider">

                        <span></span>

                        <small>
                            SMART LIBRARY
                        </small>

                        <span></span>

                    </div>


                    <div class="text-center">

                        <span class="text-muted"
                              style="font-size: 0.8rem;">

                            Already have an account?

                        </span>

                        <g:link controller="login"
                                action="auth"
                                style="font-size: 0.8rem; font-weight: 650; color: var(--sl-navy-700);">

                            Sign In

                        </g:link>

                    </div>


                    <a href="${createLink(uri: '/')}"
                       class="sl-login-home">

                        <i class="bi bi-arrow-left"></i>

                        Back to library

                    </a>

                </div>

            </div>

        </div>

    </div>

</section>


<script>

document.addEventListener(
    'DOMContentLoaded',
    function () {

        document
            .querySelectorAll('.sl-password-toggle')
            .forEach(function (button) {

                button.addEventListener(
                    'click',
                    function () {

                        const targetId =
                            button.getAttribute(
                                'data-password-target'
                            );

                        const input =
                            document.getElementById(
                                targetId
                            );

                        if (!input) {
                            return;
                        }

                        const hidden =
                            input.type === 'password';

                        input.type =
                            hidden
                                ? 'text'
                                : 'password';

                        button.innerHTML =
                            hidden
                                ? '<i class="bi bi-eye-slash"></i>'
                                : '<i class="bi bi-eye"></i>';

                    }
                );

            });

    }
);

</script>

</body>

</html>