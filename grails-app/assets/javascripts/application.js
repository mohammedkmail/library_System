// This is a manifest file that'll be compiled into application.js.
//
//= require webjars/jquery/3.7.1/dist/jquery.js
//= require webjars/bootstrap/5.3.7/dist/js/bootstrap.bundle
//= require_self

(function () {
    'use strict';

    const ready = function (callback) {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', callback);
        } else {
            callback();
        }
    };

    ready(function () {

        /* =========================================================
           GLOBAL SEARCH SHORTCUT
           Ctrl/Cmd + K focuses the navbar search.
           ========================================================= */

        const globalSearch =
            document.querySelector('#globalLibrarySearch input[type="search"]');

        document.addEventListener('keydown', function (event) {
            const shortcutPressed =
                (event.ctrlKey || event.metaKey) &&
                event.key.toLowerCase() === 'k';

            if (!shortcutPressed || !globalSearch) {
                return;
            }

            event.preventDefault();
            globalSearch.focus();
            globalSearch.select();
        });


        /* =========================================================
           HORIZONTAL HOME SCROLLERS
           ========================================================= */

        document.querySelectorAll('[data-scroll-target]').forEach(function (button) {
            button.addEventListener('click', function () {
                const selector = button.getAttribute('data-scroll-target');
                const direction = Number(button.getAttribute('data-scroll-direction') || 1);
                const target = document.querySelector(selector);

                if (!target) {
                    return;
                }

                const distance = Math.max(target.clientWidth * 0.72, 320);

                const isRtl =
                    window.getComputedStyle(target).direction === 'rtl';

                target.scrollBy({
                    left: direction * distance * (isRtl ? -1 : 1),
                    behavior: 'smooth'
                });
            });
        });


        /* =========================================================
           PAGE LOADER
           Shows only for normal form submissions and navigation.
           ========================================================= */

        const spinner = document.getElementById('spinner');

        const showSpinner = function () {
            if (!spinner) {
                return;
            }

            spinner.classList.add('is-visible');
            spinner.setAttribute('aria-hidden', 'false');
        };

        const hideSpinner = function () {
            if (!spinner) {
                return;
            }

            spinner.classList.remove('is-visible');
            spinner.setAttribute('aria-hidden', 'true');
        };

        document.querySelectorAll('form').forEach(function (form) {
            form.addEventListener('submit', function () {
                if (!form.checkValidity()) {
                    return;
                }

                const submitButtons = form.querySelectorAll('button[type="submit"], input[type="submit"]');

                submitButtons.forEach(function (button) {
                    button.setAttribute('aria-disabled', 'true');
                    button.classList.add('is-submitting');
                    button.disabled = true;
                });

                showSpinner();
            });
        });

        window.addEventListener('pageshow', hideSpinner);


        /* =========================================================
           FLASH MESSAGE AUTO DISMISS
           ========================================================= */

        const flashMessage = document.querySelector('.manara-flash-message');

        if (flashMessage && window.bootstrap) {
            window.setTimeout(function () {
                const alert = bootstrap.Alert.getOrCreateInstance(flashMessage);
                alert.close();
            }, 5500);
        }


        /* =========================================================
           GENERIC CONFIRMATION HOOK
           Add data-confirm="..." to any button/link/form submit.
           ========================================================= */

        document.addEventListener('click', function (event) {
            const target = event.target.closest('[data-confirm]');

            if (!target) {
                return;
            }

            const message = target.getAttribute('data-confirm');

            if (message && !window.confirm(message)) {
                event.preventDefault();
                event.stopImmediatePropagation();
            }
        });


        /* =========================================================
           SUBTLE REVEAL FOR HOME SECTIONS
           ========================================================= */

        const revealItems = document.querySelectorAll(
            '.mn-category-card, .mn-book-card, .mn-author-card, .mn-dashboard-metric'
        );

        if ('IntersectionObserver' in window && revealItems.length) {
            const observer = new IntersectionObserver(function (entries, currentObserver) {
                entries.forEach(function (entry) {
                    if (!entry.isIntersecting) {
                        return;
                    }

                    entry.target.classList.add('mn-visible');
                    currentObserver.unobserve(entry.target);
                });
            }, {
                threshold: 0.08,
                rootMargin: '0px 0px -24px 0px'
            });

            revealItems.forEach(function (item) {
                item.classList.add('mn-reveal');
                observer.observe(item);
            });
        }
    });


    /* Keep compatibility with existing jQuery AJAX spinner behavior. */
    if (typeof jQuery !== 'undefined') {
        (function ($) {
            $(document).ajaxStart(function () {
                $('#spinner').addClass('is-visible').attr('aria-hidden', 'false');
            }).ajaxStop(function () {
                $('#spinner').removeClass('is-visible').attr('aria-hidden', 'true');
            });
        })(jQuery);
    }
})();
