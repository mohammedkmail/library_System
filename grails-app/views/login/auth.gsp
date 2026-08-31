<!doctype html>
<html>

<head>

    <meta name="layout" content="main"/>

    <title>Sign In | Smart Library</title>

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
                            Your library. One account.
                        </span>

                        <h1>
                            Read.
                            <span>Reserve.</span>
                            Discover.
                        </h1>

                        <p>
                            Sign in to manage your library activity,
                            reserve books and study rooms, access your
                            digital collection and keep everything in
                            one place.
                        </p>

                    </div>


                    <div class="sl-login-features">

                        <div class="sl-login-feature">

                            <span>
                                <i class="bi bi-book"></i>
                            </span>

                            <div>
                                <strong>Library access</strong>

                                <small>
                                    Borrow and reserve physical books.
                                </small>
                            </div>

                        </div>


                        <div class="sl-login-feature">

                            <span>
                                <i class="bi bi-tablet"></i>
                            </span>

                            <div>
                                <strong>Digital reading</strong>

                                <small>
                                    Access your digital collection.
                                </small>
                            </div>

                        </div>


                        <div class="sl-login-feature">

                            <span>
                                <i class="bi bi-door-open"></i>
                            </span>

                            <div>
                                <strong>Study spaces</strong>

                                <small>
                                    Reserve available study rooms.
                                </small>
                            </div>

                        </div>

                    </div>

                </div>


                <div class="sl-login-decoration sl-login-decoration-one"></div>
                <div class="sl-login-decoration sl-login-decoration-two"></div>

            </div>


            <!-- RIGHT SIDE -->

            <div class="sl-login-form-side">

                <div class="sl-login-form-wrap">


                    <!-- MOBILE BRAND -->

                    <div class="sl-login-mobile-brand">

                        <span class="sl-login-brand-icon">
                            <i class="bi bi-book-half"></i>
                        </span>

                        Smart<span>Library</span>

                    </div>


                    <!-- HEADING -->

                    <div class="sl-login-heading">

                        <span class="sl-login-form-eyebrow">
                            Welcome back
                        </span>

                        <h2>
                            Sign in to your account
                        </h2>

                        <p>
                            Enter your account details to continue
                            to Smart Library.
                        </p>

                    </div>


                    <!-- LOGIN ERROR -->

                    <g:if test="${flash.message}">

                        <div class="sl-login-alert">

                            <i class="bi bi-exclamation-circle"></i>

                            <span>
                                ${flash.message}
                            </span>

                        </div>

                    </g:if>


                    <!-- LOGIN FORM -->

                    <form action="${postUrl ?: createLink(uri: '/login/authenticate')}"
                          method="POST"
                          id="loginForm"
                          autocomplete="off">


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
                                    name="${usernameParameter ?: 'username'}"
                                    id="username"
                                    class="form-control sl-login-input"
                                    placeholder="Enter your username"
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
                                    name="${passwordParameter ?: 'password'}"
                                    id="password"
                                    class="form-control sl-login-input sl-login-password-input"
                                    placeholder="Enter your password"
                                    autocomplete="current-password"
                                    required/>

                                <button
                                    type="button"
                                    class="sl-password-toggle"
                                    id="togglePassword"
                                    aria-label="Show password">

                                    <i class="bi bi-eye"></i>

                                </button>

                            </div>

                        </div>


                        <!-- OPTIONS -->

                        <div class="sl-login-options">

                            <label class="sl-remember">

                                <input
                                    type="checkbox"
                                    name="${rememberMeParameter ?: 'remember-me'}"
                                    id="remember_me"/>

                                <span>
                                    Remember me
                                </span>

                            </label>

                        </div>


                        <!-- LOGIN BUTTON -->

                        <button
                            type="submit"
                            class="btn sl-login-submit">

                            <span>
                                Sign In
                            </span>

                            <i class="bi bi-arrow-right"></i>

                        </button>


                    </form>


                    <!-- DIVIDER -->

                    <div class="sl-login-divider">

                        <span></span>

                        <small>
                            SMART LIBRARY
                        </small>

                        <span></span>

                    </div>


                    <!-- SIGN UP -->

                    <div class="text-center mb-3">

                        <span class="text-muted"
                              style="font-size: 0.8rem;">

                            Don't have an account?

                        </span>

                        <g:link controller="register"
                                action="create"
                                style="
                                    font-size: 0.8rem;
                                    font-weight: 650;
                                    color: var(--sl-navy-700);
                                    margin-left: 0.2rem;
                                ">

                            Create Account

                        </g:link>

                    </div>


                    <!-- SECURITY -->

                    <div class="sl-login-bottom">

                        <i class="bi bi-shield-check"></i>

                        <span>
                            Secure access powered by
                            Spring Security
                        </span>

                    </div>


                    <!-- BACK HOME -->

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

        const passwordInput =
            document.getElementById('password');

        const toggleButton =
            document.getElementById('togglePassword');


        if (
            passwordInput &&
            toggleButton
        ) {

            toggleButton.addEventListener(
                'click',
                function () {

                    const hidden =
                        passwordInput.type === 'password';

                    passwordInput.type =
                        hidden
                            ? 'text'
                            : 'password';

                    toggleButton.innerHTML =
                        hidden
                            ? '<i class="bi bi-eye-slash"></i>'
                            : '<i class="bi bi-eye"></i>';

                    toggleButton.setAttribute(
                        'aria-label',
                        hidden
                            ? 'Hide password'
                            : 'Show password'
                    );

                }
            );

        }

    }
);

</script>

</body>

</html>