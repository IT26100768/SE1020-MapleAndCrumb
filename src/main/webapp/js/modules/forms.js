(function (window, document) {
    'use strict';

    // 1. Password Visibility Toggle
    function initPasswordToggles() {
        document.querySelectorAll('[data-toggle-password]').forEach(function (button) {
            if (button.dataset.togglePasswordInit === 'true') {
                return;
            }
            button.dataset.togglePasswordInit = 'true';

            button.addEventListener('click', function () {
                const targetId = button.getAttribute('data-toggle-password');
                const targetInput = document.getElementById(targetId);
                const matIcon = button.querySelector('.material-symbols-outlined');
                const biIcon = button.querySelector('i');

                if (targetInput) {
                    if (targetInput.type === 'password') {
                        targetInput.type = 'text';
                        if (matIcon) matIcon.textContent = 'visibility_off';
                        if (biIcon) {
                            biIcon.classList.remove('bi-eye');
                            biIcon.classList.add('bi-eye-slash');
                        }
                        button.setAttribute('aria-label', 'Hide password');
                    } else {
                        targetInput.type = 'password';
                        if (matIcon) matIcon.textContent = 'visibility';
                        if (biIcon) {
                            biIcon.classList.remove('bi-eye-slash');
                            biIcon.classList.add('bi-eye');
                        }
                        button.setAttribute('aria-label', 'Show password');
                    }
                }
            });
        });
    }

    // 2. Quantity Steppers
    function adjustQuantity(inputId, delta) {
        const input = document.getElementById(inputId);
        if (!input) return;
        let val = parseInt(input.value, 10) || 1;
        val += delta;
        if (val < 1) val = 1;
        input.value = val;
        input.dispatchEvent(new Event('change', {bubbles: true}));
    }


    // 3. Form Validation & Double-Submission Prevention
    let pageshowListenerRegistered = false;

    function initFormValidationAndLoading() {
        const forms = document.querySelectorAll('.needs-validation, form[data-protect-submit]');
        Array.from(forms).forEach(function (form) {
            if (form.dataset.validationInit === 'true') {
                return;
            }
            form.dataset.validationInit = 'true';

            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                    form.classList.add('was-validated');
                    const firstInvalid = form.querySelector(':invalid');
                    if (firstInvalid) {
                        firstInvalid.focus();
                    }
                    return false;
                }

                form.classList.add('was-validated');

                // Button submit loading state
                const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
                if (submitBtn && !submitBtn.disabled) {
                    const originalWidth = submitBtn.offsetWidth;
                    if (originalWidth > 0) {
                        submitBtn.style.minWidth = originalWidth + 'px';
                    }
                    if (!submitBtn.hasAttribute('data-original-html')) {
                        submitBtn.setAttribute('data-original-html', submitBtn.innerHTML);
                    }
                    const loadingText = submitBtn.getAttribute('data-loading-text') || 'Processing...';
                    submitBtn.setAttribute('aria-busy', 'true');
                    form.setAttribute('aria-busy', 'true');
                    submitBtn.innerHTML = `<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>${loadingText}`;
                    setTimeout(function () {
                        submitBtn.disabled = true;
                    }, 0);

                    // Safety timeout: If submission hangs or network drops, re-enable after 10s to prevent trapping the user
                    setTimeout(function () {
                        if (submitBtn.disabled && submitBtn.hasAttribute('data-original-html')) {
                            submitBtn.disabled = false;
                            submitBtn.removeAttribute('aria-busy');
                            form.removeAttribute('aria-busy');
                            submitBtn.innerHTML = submitBtn.getAttribute('data-original-html');
                        }
                    }, 10000);

                    return true;
                }
            }, false);
        });

        // Restore any disabled submit buttons if page is restored from bfcache or back navigation
        if (!pageshowListenerRegistered) {
            pageshowListenerRegistered = true;
            window.addEventListener('pageshow', function () {
                document.querySelectorAll('button[type="submit"], input[type="submit"]').forEach(function (btn) {
                    if (btn.hasAttribute('data-original-html')) {
                        btn.disabled = false;
                        btn.removeAttribute('aria-busy');
                        btn.innerHTML = btn.getAttribute('data-original-html');
                    }
                });
                document.querySelectorAll('form[aria-busy="true"]').forEach(function (f) {
                    f.removeAttribute('aria-busy');
                });
            });
        }
    }


    // 4. Account Deletion (profile.jsp)
    function confirmAccountDeletion() {
        const pwd = document.getElementById('deleteAccountPassword');
        if (!pwd || !pwd.value.trim()) {
            alert('Please enter your password to confirm account deletion.');
            if (pwd) pwd.focus();
            return false;
        }
        const btn = document.getElementById('confirmDeleteSubmitBtn');
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Deleting...';
        }
        return true;
    }

    window.initPasswordToggles = initPasswordToggles;
    window.adjustQuantity = adjustQuantity;
    window.initFormValidationAndLoading = initFormValidationAndLoading;
    window.confirmAccountDeletion = confirmAccountDeletion;

})(window, document);

