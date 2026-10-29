(function (window, document) {
    'use strict';

    const MapleToast = {
        show: function (message, type = 'info', title = null, delay = 3500) {
            let container = document.getElementById('globalToastContainer');
            if (!container) {
                container = document.createElement('div');
                container.id = 'globalToastContainer';
                container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
                container.style.zIndex = '1090';
                document.body.appendChild(container);
            }

            const toastId = 'toast-' + Date.now();
            let iconSymbol = 'info';
            let iconColor = '#0050cb';
            let headerTitle = title || 'Maple & Crumb';

            if (type === 'success') {
                iconSymbol = 'check_circle';
                iconColor = '#1D6334';
                headerTitle = title || 'Success';
            } else if (type === 'danger' || type === 'error') {
                iconSymbol = 'error';
                iconColor = '#ba1a1a';
                headerTitle = title || 'Notice';
            } else if (type === 'warning') {
                iconSymbol = 'warning';
                iconColor = '#875500';
                headerTitle = title || 'Attention';
            }

            const toastHtml = `
                <div id="${toastId}" class="toast bg-white shadow-md border" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="${delay}" style="border-radius: 12px; border-color: rgba(211, 195, 190, 0.5) !important;">
                    <div class="toast-header border-bottom-0 pb-1" style="background: transparent;">
                        <span class="material-symbols-outlined me-2 fs-6" style="color: ${iconColor}; font-size: 18px;">${iconSymbol}</span>
                        <strong class="me-auto text-dark" style="font-family: 'Playfair Display', serif; font-size: 0.95rem;">${headerTitle}</strong>
                        <small class="text-muted" style="font-size: 0.75rem;">Just now</small>
                        <button type="button" class="btn-close ms-2" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body pt-0 text-secondary" style="font-size: 0.88rem; font-family: 'Outfit', sans-serif;">
                        ${message}
                    </div>
                </div>
            `;

            container.insertAdjacentHTML('beforeend', toastHtml);
            const toastEl = document.getElementById(toastId);
            if (window.bootstrap && window.bootstrap.Toast && toastEl) {
                const toastInstance = new window.bootstrap.Toast(toastEl);
                toastInstance.show();
                toastEl.addEventListener('hidden.bs.toast', function () {
                    toastEl.remove();
                });
            }
        }
    };


    function fallbackPrompt(text) {
        window.prompt('Copy to clipboard:', text);
    }

    function copyToClipboard(text, label) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text).then(function () {
                MapleToast.show(`<strong>${label || text}</strong> copied to clipboard!`, 'success', 'Copied');
            }).catch(function () {
                fallbackPrompt(text);
            });
        } else {
            fallbackPrompt(text);
        }
    }


    function formatLKR(amount) {
        if (isNaN(amount)) return 'Rs. 0';
        return 'Rs. ' + Math.round(amount).toLocaleString('en-US');
    }

    function formatCurrency(amount) {
        if (isNaN(amount)) return 'Rs. 0.00';
        return 'Rs. ' + Number(amount).toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    function debounce(func, wait) {
        let timeout;
        return function (...args) {
            const context = this;
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(context, args), wait);
        };
    }

    const RATING_DESCRIPTIONS = {
        1: '1 star — Disappointing',
        2: '2 stars — Below Expectations',
        3: '3 stars — Average',
        4: '4 stars — Very Good',
        5: '5 stars — Outstanding'
    };

    function initStarRatingSelectors() {
        const containers = document.querySelectorAll('.star-rating-container');
        containers.forEach(function (container) {
            if (container.dataset.ratingInitialized === 'true') {
                return;
            }
            container.dataset.ratingInitialized = 'true';

            const group = container.querySelector('.star-rating-group');
            const stars = container.querySelectorAll('.star-rating-star');
            const inputs = container.querySelectorAll('.star-rating-radio');
            const label = container.querySelector('.star-rating-text-label');

            function getCheckedValue() {
                const checked = container.querySelector('.star-rating-radio:checked');
                return checked ? parseInt(checked.value, 10) : 5;
            }

            function updateDisplay(val, isPreview) {
                const ratingNum = parseInt(val, 10) || 5;
                stars.forEach(function (star) {
                    const starVal = parseInt(star.getAttribute('data-value'), 10);
                    if (starVal <= ratingNum) {
                        star.classList.add(isPreview ? 'is-preview' : 'is-active');
                        if (!isPreview) {
                            star.classList.remove('is-preview');
                        }
                    } else {
                        star.classList.remove('is-active', 'is-preview');
                    }
                });
                if (label) {
                    label.textContent = RATING_DESCRIPTIONS[ratingNum] || (ratingNum + ' stars');
                }
            }

            updateDisplay(getCheckedValue(), false);

            inputs.forEach(function (input) {
                input.addEventListener('change', function () {
                    stars.forEach(function (s) {
                        s.classList.remove('is-preview');
                    });
                    updateDisplay(this.value, false);
                });
                input.addEventListener('focus', function () {
                    stars.forEach(function (s) {
                        s.classList.remove('is-preview');
                    });
                    updateDisplay(this.value, false);
                });
            });

            stars.forEach(function (star) {
                star.addEventListener('mouseenter', function () {
                    const hoverVal = this.getAttribute('data-value');
                    updateDisplay(hoverVal, true);
                });
            });

            if (group) {
                group.addEventListener('mouseleave', function () {
                    stars.forEach(function (s) {
                        s.classList.remove('is-preview');
                    });
                    updateDisplay(getCheckedValue(), false);
                });
            }
        });
    }
    function initTooltips() {
        if (window.bootstrap && window.bootstrap.Tooltip) {
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (tooltipTriggerEl) {
                if (!tooltipTriggerEl.dataset.tooltipInitialized) {
                    tooltipTriggerEl.dataset.tooltipInitialized = 'true';
                    new window.bootstrap.Tooltip(tooltipTriggerEl);
                }
            });
        }
    }

    window.MapleToast = MapleToast;
    window.copyToClipboard = copyToClipboard;
    window.formatLKR = formatLKR;
    window.formatCurrency = formatCurrency;
    window.debounce = debounce;
    window.RATING_DESCRIPTIONS = RATING_DESCRIPTIONS;
    window.initStarRatingSelectors = initStarRatingSelectors;
    window.initTooltips = initTooltips;

})(window, document);

