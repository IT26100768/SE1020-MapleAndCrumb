/**
 * Maple & Crumb Bakery - Unified Client-Side Interaction & Polish
 * Framework: Bootstrap 5.3.3 + Material Symbols
 */

(function () {
    'use strict';

    // -------------------------------------------------------------------------
    // 1. Global Toast Notification System
    // -------------------------------------------------------------------------
    window.MapleToast = {
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
            if (window.bootstrap && bootstrap.Toast) {
                const toastInstance = new bootstrap.Toast(toastEl);
                toastInstance.show();
                toastEl.addEventListener('hidden.bs.toast', function () {
                    toastEl.remove();
                });
            }
        }
    };


    // -------------------------------------------------------------------------
    // 2. Clipboard Helper
    // -------------------------------------------------------------------------
    window.copyToClipboard = function (text, label) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text).then(function () {
                MapleToast.show(`<strong>${label || text}</strong> copied to clipboard!`, 'success', 'Copied');
            }).catch(function () {
                fallbackPrompt(text);
            });
        } else {
            fallbackPrompt(text);
        }
    };


    function fallbackPrompt(text) {
        window.prompt('Copy to clipboard:', text);
    }

    // -------------------------------------------------------------------------
    // 3. Password Visibility Toggle
    // -------------------------------------------------------------------------
    window.initPasswordToggles = function () {
        document.querySelectorAll('[data-toggle-password]').forEach(function (button) {
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
    };

    // -------------------------------------------------------------------------
    // 4. Quantity Steppers
    // -------------------------------------------------------------------------
    window.adjustQuantity = function (inputId, delta) {
        const input = document.getElementById(inputId);
        if (!input) return;
        let val = parseInt(input.value, 10) || 1;
        val += delta;
        if (val < 1) val = 1;
        input.value = val;
        input.dispatchEvent(new Event('change', {bubbles: true}));
    };

    // -------------------------------------------------------------------------
    // 5. Currency Formatting Helper (Sri Lankan Rupee LKR)
    // -------------------------------------------------------------------------
    window.formatLKR = function (amount) {
        if (isNaN(amount)) return 'Rs. 0';
        return 'Rs. ' + Math.round(amount).toLocaleString('en-US');
    };

    window.formatCurrency = function (amount) {
        if (isNaN(amount)) return 'Rs. 0.00';
        return 'Rs. ' + Number(amount).toLocaleString('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    };

    // -------------------------------------------------------------------------
    // 6. Interactive Studio Estimator Calculator (Canonical Tier Pricing)
    // -------------------------------------------------------------------------
    window.updateEstimatorPrice = function () {
        const sizeSelect = document.getElementById('estimatorSize');
        const displayPriceEl = document.getElementById('estimatorDisplayPrice');
        const servingNoteEl = document.getElementById('estimatorServingNote');
        if (!displayPriceEl) return;

        const basePrices = {
            '6': {price: 4500, serving: 'Serves 6 - 8 guests'},
            '8': {price: 6500, serving: 'Serves 8 - 12 guests'},
            '10': {price: 8500, serving: 'Serves 14 - 18 guests'},
            '12': {price: 11000, serving: 'Serves 20 - 26 guests'}
        };

        const size = sizeSelect ? (sizeSelect.value || '8') : '8';
        const tier = basePrices[size] || basePrices['8'];
        let price = tier.price;

        const flavorSelect = document.getElementById('estimatorFlavor');
        if (flavorSelect && flavorSelect.value && flavorSelect.value.includes('Pistachio')) {
            price += 1500;
        }

        displayPriceEl.textContent = formatLKR(price);
        if (servingNoteEl) {
            servingNoteEl.textContent = '(' + tier.serving + ')';
        }
    };


    // Forward estimator parameters to Custom Cake Booking
    window.proceedToCakeStudio = function () {
        const sizeEl = document.getElementById('estimatorSize');
        const flavorEl = document.getElementById('estimatorFlavor');
        const messageEl = document.getElementById('estimatorMessage');

        const size = sizeEl ? sizeEl.value : '8';
        const flavor = flavorEl ? encodeURIComponent(flavorEl.value) : '';
        const msg = messageEl ? encodeURIComponent(messageEl.value) : '';
        window.location.href = window.location.pathname.replace(/\/([^\/]*)$/, '') + '/bookCake?size=' + size + '&flavor=' + flavor + '&message=' + msg;
    };

    // -------------------------------------------------------------------------
    // 7. Form Validation & Double-Submission Prevention
    // -------------------------------------------------------------------------
    window.initFormValidationAndLoading = function () {
        const forms = document.querySelectorAll('.needs-validation, form[data-protect-submit]');
        Array.from(forms).forEach(function (form) {
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
    };

    // -------------------------------------------------------------------------
    // 8. Utility: Debounce for Live Searches & Filters
    // -------------------------------------------------------------------------
    window.debounce = function (func, wait) {
        let timeout;
        return function (...args) {
            const context = this;
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(context, args), wait);
        };
    };

    // -------------------------------------------------------------------------
    // 9. Global Navigation & Header Helpers (Extracted from navbar.jsp)
    // -------------------------------------------------------------------------
    window.toggleMapleMobileMenu = function () {
        const drawer = document.getElementById('mapleMobileDrawer');
        if (drawer) {
            drawer.style.display = (drawer.style.display === 'block') ? 'none' : 'block';
        }
    };


    window.toggleMapleUserDropdown = function (event) {
        if (event) event.stopPropagation();
        const dd = document.getElementById('mapleUserDropdown');
        const btn = document.getElementById('mapleUserMenuBtn');
        if (dd) {
            const isShown = (dd.style.display === 'block');
            dd.style.display = isShown ? 'none' : 'block';
            if (btn) {
                btn.setAttribute('aria-expanded', isShown ? 'false' : 'true');
            }
        }
    };

    // Global outside-click listener to dismiss dropdown
    document.addEventListener('click', function (e) {
        const dd = document.getElementById('mapleUserDropdown');
        const btn = document.getElementById('mapleUserMenuBtn');
        if (dd && dd.style.display === 'block') {
            if (btn && !btn.contains(e.target) && !dd.contains(e.target)) {
                dd.style.display = 'none';
                if (btn) btn.setAttribute('aria-expanded', 'false');
            }
        }
    });

    // -------------------------------------------------------------------------
    // 10. Unified Client-Side Search & Filter Engine (MapleFilter)
    // -------------------------------------------------------------------------
    window.MapleFilter = {
        /**
         * Generic debounced table text filter (used in manage_products, manage_bookings, etc.)
         */
        initTableFilter: function (config) {
            const searchInput = document.getElementById(config.inputId);
            if (!searchInput) return;

            const runFilter = function () {
                const query = (searchInput.value || '').toLowerCase().trim();
                const rows = document.querySelectorAll(config.rowSelector);
                let visibleCount = 0;

                rows.forEach(function (row) {
                    const statusAttr = config.statusAttribute ? (row.getAttribute(config.statusAttribute) || '') : '';
                    const matchesStatus = !config.getActiveStatus || config.getActiveStatus() === 'ALL' || statusAttr.toLowerCase() === config.getActiveStatus().toLowerCase();
                    const text = row.innerText.toLowerCase();
                    const matchesQuery = !query || text.includes(query);

                    if (matchesQuery && matchesStatus) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });

                if (config.noResultsId) {
                    const noResults = document.getElementById(config.noResultsId);
                    if (noResults) {
                        noResults.classList.toggle('d-none', visibleCount > 0 || rows.length === 0);
                    }
                }
            };

            const debounced = window.debounce ? window.debounce(runFilter, 150) : runFilter;
            searchInput.addEventListener('input', debounced);
            return runFilter;
        },

        /**
         * Generic debounced card/item list filter (used in menu, order_history, manage_staff)
         */
        initCardFilter: function (config) {
            const searchInput = document.getElementById(config.inputId);
            let activeFilter = config.defaultFilter || 'ALL';

            const runFilter = function () {
                const query = (searchInput ? searchInput.value : '').toLowerCase().trim();
                const items = document.querySelectorAll(config.itemSelector);
                let visibleCount = 0;

                items.forEach(function (item) {
                    const itemCat = (item.getAttribute(config.categoryAttr || 'data-category') || '').toLowerCase();
                    const itemSearch = config.searchAttr ? (item.getAttribute(config.searchAttr) || '').toLowerCase() : item.innerText.toLowerCase();

                    const matchesFilter = (activeFilter === 'ALL' || itemCat === activeFilter.toLowerCase());
                    const matchesQuery = (!query || itemSearch.includes(query));

                    if (matchesFilter && matchesQuery) {
                        item.style.display = '';
                        visibleCount++;
                    } else {
                        item.style.display = 'none';
                    }
                });

                if (config.noResultsId) {
                    const noResults = document.getElementById(config.noResultsId);
                    if (noResults) {
                        noResults.classList.toggle('d-none', visibleCount > 0 || items.length === 0);
                    }
                }
            };

            const debounced = window.debounce ? window.debounce(runFilter, 150) : runFilter;
            if (searchInput) {
                searchInput.addEventListener('input', debounced);
            }

            return {
                setFilter: function (filterVal) {
                    activeFilter = filterVal;
                    runFilter();
                },
                refresh: runFilter
            };
        }
    };


    // -------------------------------------------------------------------------
    // 11. Admin Form Helpers (MapleAdmin)
    // -------------------------------------------------------------------------
    window.MapleAdmin = {
        toggleProductCategoryFields: function () {
            const categoryEl = document.getElementById('productCategory');
            if (!categoryEl) return;
            const category = categoryEl.value;
            const cakeSection = document.getElementById('cakeFieldsSection');
            const pastrySection = document.getElementById('pastryFieldsSection');

            if (cakeSection && pastrySection) {
                if (category === 'Cake') {
                    cakeSection.classList.remove('d-none');
                    pastrySection.classList.add('d-none');
                } else {
                    cakeSection.classList.add('d-none');
                    pastrySection.classList.remove('d-none');
                }
            }
        },

        toggleAdminRoleTier: function () {
            const roleSelect = document.getElementById('staffRoleSelect');
            const adminGroup = document.getElementById('adminLevelGroup');
            if (roleSelect && adminGroup) {
                if (roleSelect.value === 'ADMIN') {
                    adminGroup.classList.remove('d-none');
                } else {
                    adminGroup.classList.add('d-none');
                }
            }
        }
    };

    window.toggleCategoryFields = function () {
        window.MapleAdmin.toggleProductCategoryFields();
    };
    window.toggleAdminTier = function () {
        window.MapleAdmin.toggleAdminRoleTier();
    };


    // -------------------------------------------------------------------------
    // 12. Checkout & Order Helpers (MapleCheckout)
    // -------------------------------------------------------------------------
    window.MapleCheckout = {
        init: function (baseSubtotal) {
            let deliveryFee = 0.0;

            window.selectOrderType = function (type) {
                const deliveryRadio = document.getElementById('orderTypeDelivery');
                const pickupRadio = document.getElementById('orderTypePickup');
                if (type === 'Delivery') {
                    if (deliveryRadio) deliveryRadio.checked = true;
                    if (pickupRadio) pickupRadio.checked = false;
                } else {
                    if (pickupRadio) pickupRadio.checked = true;
                    if (deliveryRadio) deliveryRadio.checked = false;
                }
                updateFulfillment();
            };

            window.updateFulfillment = function () {
                const deliveryRadio = document.getElementById('orderTypeDelivery');
                const pickupRadio = document.getElementById('orderTypePickup');
                const isDelivery = deliveryRadio ? deliveryRadio.checked : false;
                const addrSection = document.getElementById('deliveryAddressSection');
                const addrInput = document.getElementById('deliveryAddressInput');
                const feeEl = document.getElementById('displayDeliveryFee');
                const totalEl = document.getElementById('displayGrandTotal');
                const pickupWrap = document.getElementById('pickupOptionWrapper');
                const deliveryWrap = document.getElementById('deliveryOptionWrapper');
                const pickupBadge = document.getElementById('pickupSelectedBadge');
                const deliveryBadge = document.getElementById('deliverySelectedBadge');

                if (isDelivery) {
                    deliveryFee = 500.00;
                    if (deliveryRadio) deliveryRadio.checked = true;
                    if (pickupRadio) pickupRadio.checked = false;
                    if (deliveryWrap) deliveryWrap.classList.add('active');
                    if (pickupWrap) pickupWrap.classList.remove('active');
                    if (deliveryBadge) {
                        deliveryBadge.classList.remove('d-none');
                        deliveryBadge.style.display = 'inline-block';
                    }
                    if (pickupBadge) {
                        pickupBadge.classList.add('d-none');
                        pickupBadge.style.display = 'none';
                    }
                    if (addrSection) addrSection.classList.remove('d-none');
                    if (addrInput) addrInput.required = true;
                    if (feeEl) feeEl.textContent = 'Rs. 500.00';
                } else {
                    deliveryFee = 0.00;
                    if (pickupRadio) pickupRadio.checked = true;
                    if (deliveryRadio) deliveryRadio.checked = false;
                    if (pickupWrap) pickupWrap.classList.add('active');
                    if (deliveryWrap) deliveryWrap.classList.remove('active');
                    if (pickupBadge) {
                        pickupBadge.classList.remove('d-none');
                        pickupBadge.style.display = 'inline-block';
                    }
                    if (deliveryBadge) {
                        deliveryBadge.classList.add('d-none');
                        deliveryBadge.style.display = 'none';
                    }
                    if (addrSection) addrSection.classList.add('d-none');
                    if (addrInput) addrInput.required = false;
                    if (feeEl) feeEl.textContent = 'Rs. 0.00';
                }

                if (totalEl) {
                    const grandTotal = Number(baseSubtotal + deliveryFee).toLocaleString('en-US', {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    });
                    totalEl.textContent = 'Rs. ' + grandTotal;
                }
            };

            const checkoutOrderTypeRadios = document.querySelectorAll('input[name="orderType"]');
            checkoutOrderTypeRadios.forEach(function (radio) {
                radio.addEventListener('change', function () {
                    window.updateFulfillment();
                });
            });

            // Initial fulfillment check
            window.updateFulfillment();

            window.selectPaymentMethod = function (method) {
                const methodInput = document.getElementById('paymentMethodInput');
                if (methodInput) methodInput.value = method;

                document.querySelectorAll('.payment-method-card').forEach(function (c) {
                    c.classList.remove('active');
                });

                const cardFields = document.getElementById('cardPaymentFields');
                const counterFields = document.getElementById('counterCashFields');

                if (cardFields) cardFields.classList.add('d-none');
                if (counterFields) counterFields.classList.add('d-none');

                if (method === 'CARD_SIMULATED') {
                    const el = document.getElementById('payMethodCard');
                    if (el) el.classList.add('active');
                    if (cardFields) cardFields.classList.remove('d-none');
                } else if (method === 'COUNTER_CASH') {
                    const el = document.getElementById('payMethodCounter');
                    if (el) el.classList.add('active');
                    if (counterFields) counterFields.classList.remove('d-none');
                }
            };

            window.formatCardNumber = function (input) {
                let v = input.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
                let matches = v.match(/\d{4,16}/g);
                let match = (matches && matches[0]) || '';
                let parts = [];
                for (let i = 0, len = match.length; i < len; i += 4) {
                    parts.push(match.substring(i, i + 4));
                }
                if (parts.length) {
                    input.value = parts.join(' ');
                }
            };

            window.handleFormSubmit = function (e) {
                const form = document.getElementById('checkoutForm');
                if (form && !form.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                    form.classList.add('was-validated');
                    return false;
                }
                const btn = document.getElementById('btnPlaceOrder');
                if (btn) {
                    btn.disabled = true;
                    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Processing Simulated Payment...';
                }
                return true;
            };
        }
    };


    // -------------------------------------------------------------------------
    // 13. Custom Cake Studio Form Helpers (MapleCakeStudio)
    // -------------------------------------------------------------------------
    window.selectCakeOrderType = function (type) {
        const deliveryRadio = document.getElementById('cakeOrderTypeDelivery');
        const pickupRadio = document.getElementById('cakeOrderTypePickup');
        const deliveryWrap = document.getElementById('cakeDeliveryOptionWrapper');
        const pickupWrap = document.getElementById('cakePickupOptionWrapper');
        const deliveryBadge = document.getElementById('cakeDeliverySelectedBadge');
        const pickupBadge = document.getElementById('cakePickupSelectedBadge');
        const addrSection = document.getElementById('cakeDeliveryAddressSection');
        const addrInput = document.getElementById('cakeDeliveryAddressInput');

        if (type === 'Delivery') {
            if (deliveryRadio) deliveryRadio.checked = true;
            if (pickupRadio) pickupRadio.checked = false;
            if (deliveryWrap) deliveryWrap.classList.add('active');
            if (pickupWrap) pickupWrap.classList.remove('active');
            if (deliveryBadge) {
                deliveryBadge.classList.remove('d-none');
                deliveryBadge.style.display = 'inline-block';
            }
            if (pickupBadge) {
                pickupBadge.classList.add('d-none');
                pickupBadge.style.display = 'none';
            }
            if (addrSection) addrSection.classList.remove('d-none');
            if (addrInput) addrInput.required = true;
        } else {
            if (pickupRadio) pickupRadio.checked = true;
            if (deliveryRadio) deliveryRadio.checked = false;
            if (pickupWrap) pickupWrap.classList.add('active');
            if (deliveryWrap) deliveryWrap.classList.remove('active');
            if (pickupBadge) {
                pickupBadge.classList.remove('d-none');
                pickupBadge.style.display = 'inline-block';
            }
            if (deliveryBadge) {
                deliveryBadge.classList.add('d-none');
                deliveryBadge.style.display = 'none';
            }
            if (addrSection) addrSection.classList.add('d-none');
            if (addrInput) {
                addrInput.required = false;
                addrInput.value = '';
            }
        }
        window.updateBookingSummary();
    };

    window.updateBookingSummary = function () {
        const flavorSelect = document.getElementById('cakeFlavor');
        const sizeSelect = document.getElementById('cakeSize');
        const occasionSelect = document.getElementById('cakeOccasion');
        const dateInput = document.getElementById('pickupDate');
        const timeSelect = document.getElementById('pickupTime');
        const msgInput = document.getElementById('customMessage');
        const notesInput = document.getElementById('specialNotes');
        const deliveryRadio = document.getElementById('cakeOrderTypeDelivery');
        const addrInput = document.getElementById('cakeDeliveryAddressInput');

        // Target Summary Elements
        const sFlavor = document.getElementById('summaryFlavor');
        const sSize = document.getElementById('summarySize');
        const sOccasion = document.getElementById('summaryOccasion');
        const sInscription = document.getElementById('summaryInscription');
        const sSchedule = document.getElementById('summarySchedule');
        const sFulfillmentMode = document.getElementById('summaryFulfillmentMode');
        const sAddressRow = document.getElementById('summaryDeliveryAddressRow');
        const sAddressText = document.getElementById('summaryDeliveryAddressText');
        const sNotesRow = document.getElementById('summaryNotesRow');
        const sNotesText = document.getElementById('summaryNotesText');
        const sSubtotal = document.getElementById('summarySubtotal');
        const sDeliveryFee = document.getElementById('summaryDeliveryFee');
        const sGrandTotal = document.getElementById('summaryGrandTotal');

        if (!sGrandTotal) return;

        // Canonical base price schedule (LKR)
        const basePrices = {6: 4500, 8: 6500, 10: 8500, 12: 11000};
        const sizeVal = sizeSelect ? parseInt(sizeSelect.value, 10) : 8;
        const basePrice = basePrices[sizeVal] || 6500;

        const isDelivery = deliveryRadio ? deliveryRadio.checked : false;
        const deliveryFee = isDelivery ? 500.00 : 0.00;
        const grandTotal = basePrice + deliveryFee;

        if (sFlavor && flavorSelect) {
            sFlavor.textContent = flavorSelect.value || 'Belgian Chocolate Truffle';
        }
        if (sSize && sizeSelect) {
            const opt = sizeSelect.options[sizeSelect.selectedIndex];
            let sizeText = sizeVal + '-Inch';
            if (opt) {
                const t = opt.text;
                const idx = t.indexOf('—') !== -1 ? t.indexOf('—') : (t.indexOf('--') !== -1 ? t.indexOf('--') : t.indexOf(' - '));
                sizeText = idx !== -1 ? t.substring(0, idx).trim() : t;
            }
            sSize.textContent = sizeText;
        }
        if (sOccasion && occasionSelect) {
            sOccasion.textContent = occasionSelect.value || 'Birthday Celebration';
        }
        if (sInscription) {
            const msg = msgInput ? msgInput.value.trim() : '';
            if (msg) {
                sInscription.textContent = '"' + msg + '"';
                sInscription.className = 'fst-italic text-dark fw-semibold mt-0.5';
            } else {
                sInscription.textContent = 'None provided';
                sInscription.className = 'fst-italic text-secondary mt-0.5';
            }
        }
        if (sSchedule) {
            let dateStr = 'Required Date';
            if (dateInput && dateInput.value) {
                const parts = dateInput.value.split('-');
                if (parts.length === 3) {
                    const d = new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
                    if (!isNaN(d.getTime())) {
                        dateStr = d.toLocaleDateString('en-US', {month: 'short', day: 'numeric', year: 'numeric'});
                    } else {
                        dateStr = dateInput.value;
                    }
                } else {
                    dateStr = dateInput.value;
                }
            }
            const timeStr = timeSelect && timeSelect.value ? timeSelect.value : 'Morning (9:00 AM - 12:00 PM)';
            sSchedule.textContent = dateStr + ' • ' + timeStr;
        }
        if (sFulfillmentMode) {
            if (isDelivery) {
                sFulfillmentMode.innerHTML = '<span class="badge bg-primary text-white border px-2 py-0.5"><span class="material-symbols-outlined fs-6 align-middle me-1">local_shipping</span>Doorstep Delivery (+Rs. 500.00)</span>';
            } else {
                sFulfillmentMode.innerHTML = '<span class="badge bg-secondary-subtle text-secondary-emphasis border px-2 py-0.5"><span class="material-symbols-outlined fs-6 align-middle me-1">storefront</span>Bakery Counter Pickup (Free)</span>';
            }
        }
        if (sAddressRow && sAddressText) {
            const addr = addrInput ? addrInput.value.trim() : '';
            if (isDelivery && addr) {
                sAddressText.textContent = addr;
                sAddressRow.classList.remove('d-none');
            } else {
                sAddressRow.classList.add('d-none');
            }
        }
        if (sNotesRow && sNotesText) {
            const notes = notesInput ? notesInput.value.trim() : '';
            if (notes) {
                sNotesText.textContent = notes;
                sNotesRow.classList.remove('d-none');
            } else {
                sNotesRow.classList.add('d-none');
            }
        }
        if (sSubtotal) sSubtotal.textContent = window.formatCurrency(basePrice);
        if (sDeliveryFee) sDeliveryFee.textContent = window.formatCurrency(deliveryFee);
        if (sGrandTotal) sGrandTotal.textContent = window.formatCurrency(grandTotal);
    };

    window.MapleCakeStudio = {
        init: function () {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            const yyyy = tomorrow.getFullYear();
            const mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
            const dd = String(tomorrow.getDate()).padStart(2, '0');
            const minDateStr = yyyy + '-' + mm + '-' + dd;

            const dateInput = document.getElementById('pickupDate');
            if (dateInput) {
                dateInput.min = minDateStr;
                if (!dateInput.value) {
                    dateInput.value = minDateStr;
                }
            }

            // Bind order type radios
            const orderTypeRadios = document.querySelectorAll('input[name="orderType"]');
            orderTypeRadios.forEach(function (radio) {
                radio.addEventListener('change', function () {
                    window.selectCakeOrderType(this.value);
                });
            });

            // Sync initial radio state with cards
            const checkedRadio = document.querySelector('input[name="orderType"]:checked');
            window.selectCakeOrderType(checkedRadio ? checkedRadio.value : 'Pickup');

            // Attach live synchronization listeners to all custom cake form controls
            const syncInputs = [
                'cakeFlavor', 'cakeSize', 'cakeOccasion', 'pickupDate',
                'pickupTime', 'customMessage', 'specialNotes', 'cakeDeliveryAddressInput'
            ];
            syncInputs.forEach(function (id) {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('input', window.updateBookingSummary);
                    el.addEventListener('change', window.updateBookingSummary);
                }
            });

            window.updateBookingSummary();
        },

        updateLivePreview: function () {
            window.updateBookingSummary();
        }
    };

    window.updateLivePreview = function () {
        window.updateBookingSummary();
    };

    // -------------------------------------------------------------------------
    // 14. Standard Page Event Handlers (Extracted from JSPs)
    // -------------------------------------------------------------------------

    // Public Storefront Menu Filter (menu.jsp)
    let currentMenuCategory = 'ALL';
    window.filterCategory = function (category) {
        currentMenuCategory = category;
        const catMap = {
            'ALL': 'filterAll',
            'Cake': 'filterCakes',
            'Pastry': 'filterPastries',
            'Bread': 'filterBreads'
        };
        ['filterAll', 'filterCakes', 'filterPastries', 'filterBreads'].forEach(function (id) {
            const btn = document.getElementById(id);
            if (btn) {
                btn.classList.remove('btn-maple-primary', 'active');
                btn.classList.add('btn-maple-secondary');
                btn.setAttribute('aria-pressed', 'false');
            }
        });
        const target = document.getElementById(catMap[category]);
        if (target) {
            target.classList.remove('btn-maple-secondary');
            target.classList.add('btn-maple-primary', 'active');
            target.setAttribute('aria-pressed', 'true');
        }
        window.applyMenuFilters();
    };

    window.applyMenuFilters = function () {
        const query = (document.getElementById('menuSearchInput')?.value || '').toLowerCase().trim();
        const items = document.querySelectorAll('.product-item');
        let visible = 0;
        items.forEach(function (item) {
            const itemCat = (item.getAttribute('data-category') || '').toLowerCase();
            const itemName = (item.getAttribute('data-name') || '').toLowerCase();
            const matchCat = (currentMenuCategory === 'ALL' || itemCat === currentMenuCategory.toLowerCase());
            const matchQuery = (!query || itemName.includes(query));
            if (matchCat && matchQuery) {
                item.style.display = '';
                visible++;
            } else {
                item.style.display = 'none';
            }
        });
        const noResults = document.getElementById('clientSideNoResults');
        if (noResults) {
            noResults.classList.toggle('d-none', visible > 0 || items.length === 0);
        }
    };

    window.searchProducts = window.debounce ? window.debounce(function () {
        window.applyMenuFilters();
    }, 150) : function () {
        window.applyMenuFilters();
    };

    // Product Catalogue Admin Table Filter (manage_products.jsp)
    window.filterAdminTable = function () {
        const query = (document.getElementById('adminTableSearch')?.value || '').toLowerCase().trim();
        document.querySelectorAll('#adminProductTable tbody tr.product-row').forEach(function (row) {
            const text = row.innerText.toLowerCase();
            row.style.display = (!query || text.includes(query)) ? '' : 'none';
        });
    };

    // Booking Reservations Table Filter (manage_bookings.jsp)
    let bookingActiveStatus = 'ALL';
    window.setStatusFilter = function (status, btn) {
        bookingActiveStatus = status;
        const filterGroup = btn ? btn.closest('[role="group"]') : document.querySelector('[aria-label="Filter Bookings by Status"]');
        const buttons = filterGroup ? filterGroup.querySelectorAll('.btn') : document.querySelectorAll('[aria-label="Filter Bookings by Status"] .btn');
        buttons.forEach(function (b) {
            b.classList.remove('btn-maple-primary', 'active');
            b.classList.add('btn-maple-secondary');
            b.setAttribute('aria-pressed', 'false');
        });
        if (btn) {
            btn.classList.remove('btn-maple-secondary');
            btn.classList.add('btn-maple-primary', 'active');
            btn.setAttribute('aria-pressed', 'true');
        }
        window.filterBookingsTable();
    };

    window.filterBookingsTable = function () {
        const query = (document.getElementById('bookingSearchInput')?.value || '').toLowerCase().trim();
        const rows = document.querySelectorAll('.booking-row');
        let visibleCount = 0;
        rows.forEach(function (row) {
            const rowText = row.innerText.toLowerCase();
            const rowStatus = (row.getAttribute('data-status') || '').toLowerCase();
            const matchesQuery = !query || rowText.includes(query);
            let matchesStatus = false;

            if (bookingActiveStatus === 'ALL') {
                matchesStatus = true;
            } else {
                matchesStatus = (rowStatus === bookingActiveStatus.toLowerCase());
            }

            if (matchesQuery && matchesStatus) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        const noResults = document.getElementById('noBookingsFoundRow');
        if (noResults) {
            noResults.classList.toggle('d-none', visibleCount > 0 || rows.length === 0);
        }
    };

    window.resetBookingFilters = function () {
        const searchInput = document.getElementById('bookingSearchInput');
        if (searchInput) searchInput.value = '';
        const allBtn = document.getElementById('bookingFilterAll');
        window.setStatusFilter('ALL', allBtn);
    };

    // Order History Cards Filter (order_history.jsp)
    let orderActiveFilter = 'ALL';
    const PROCESSING_STATUSES = ['processing', 'confirmed', 'baking', 'in preparation', 'out for delivery'];
    const COMPLETED_STATUSES = ['completed', 'finished'];

    window.setOrderStatusFilter = function (status, btn) {
        orderActiveFilter = status;
        try {
            sessionStorage.setItem('orderActiveStatus', status);
            const url = new URL(window.location.href);
            if (status && status !== 'ALL') {
                url.searchParams.set('status', status);
            } else {
                url.searchParams.delete('status');
            }
            window.history.replaceState({}, '', url.toString());
        } catch (e) {
            // Safe fallback if sessionStorage or history API restricted
        }

        const filterGroup = btn ? btn.closest('[role="group"]') : document.querySelector('[aria-label="Filter Orders by Status"]');
        const buttons = filterGroup ? filterGroup.querySelectorAll('.btn') : document.querySelectorAll('[aria-label="Filter Orders by Status"] .btn');
        buttons.forEach(function (b) {
            b.classList.remove('btn-maple-primary', 'active');
            b.classList.add('btn-maple-secondary');
            b.setAttribute('aria-pressed', 'false');
        });
        if (btn) {
            btn.classList.remove('btn-maple-secondary');
            btn.classList.add('btn-maple-primary', 'active');
            btn.setAttribute('aria-pressed', 'true');
        }
        window.filterOrders();
    };

    window.filterOrders = function () {
        const query = (document.getElementById('orderSearchInput')?.value || '').toLowerCase().trim();
        const items = document.querySelectorAll('.order-card-item');
        let visibleCount = 0;

        items.forEach(function (item) {
            const text = item.innerText.toLowerCase();
            const status = (item.getAttribute('data-status') || '').toLowerCase();
            const matchesQuery = !query || text.includes(query);
            let matchesStatus = false;

            if (orderActiveFilter === 'ALL') {
                matchesStatus = true;
            } else if (orderActiveFilter === 'Processing') {
                matchesStatus = PROCESSING_STATUSES.includes(status);
            } else if (orderActiveFilter === 'Completed') {
                matchesStatus = COMPLETED_STATUSES.includes(status);
            } else {
                matchesStatus = (status === orderActiveFilter.toLowerCase());
            }

            if (matchesQuery && matchesStatus) {
                item.style.display = '';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        const noOrdersCard = document.getElementById('clientSideNoOrders');
        if (noOrdersCard) {
            noOrdersCard.classList.toggle('d-none', visibleCount > 0 || items.length === 0);
        }
    };

    window.resetOrderFilters = function () {
        const searchInput = document.getElementById('orderSearchInput');
        if (searchInput) searchInput.value = '';
        const allBtn = document.getElementById('orderFilterAll');
        window.setOrderStatusFilter('ALL', allBtn);
    };

    window.initOrderHistoryFilters = function () {
        try {
            const urlParams = new URLSearchParams(window.location.search);
            const statusParam = urlParams.get('status') || sessionStorage.getItem('orderActiveStatus');
            if (statusParam && statusParam !== 'ALL') {
                const btnIdMap = {
                    'pending': 'orderFilterPending',
                    'processing': 'orderFilterProcessing',
                    'completed': 'orderFilterCompleted',
                    'cancelled': 'orderFilterCancelled'
                };
                const btnId = btnIdMap[statusParam.toLowerCase()];
                const targetBtn = btnId ? document.getElementById(btnId) : null;
                if (targetBtn) {
                    window.setOrderStatusFilter(statusParam, targetBtn);
                    return;
                }
            }
        } catch (e) {
            // Ignore storage retrieval error
        }
        window.filterOrders();
    };

    // Profile Account Deletion (profile.jsp)
    window.confirmAccountDeletion = function () {
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
    };

    // -------------------------------------------------------------------------
    // 15. Global Initializer
    // -------------------------------------------------------------------------
    document.addEventListener('DOMContentLoaded', function () {
        initPasswordToggles();
        initFormValidationAndLoading();
        // Staff Directory Search Filter (manage_staff.jsp)
        const staffSearchInput = document.getElementById('staffSearchInput');
        if (staffSearchInput) {
            let activeStaffRole = 'ALL';
            const filterStaff = function () {
                const query = (staffSearchInput.value || '').toLowerCase().trim();
                const rows = document.querySelectorAll('.staff-row');
                const noResults = document.getElementById('noStaffFoundRow');
                let visibleCount = 0;
                rows.forEach(function (row) {
                    const searchData = (row.getAttribute('data-search') || '').toLowerCase();
                    const roleData = (row.getAttribute('data-role') || '').toUpperCase();
                    const matchesQuery = !query || searchData.includes(query);
                    const matchesRole = (activeStaffRole === 'ALL') || (roleData === activeStaffRole);
                    if (matchesQuery && matchesRole) {
                        row.classList.remove('d-none');
                        visibleCount++;
                    } else {
                        row.classList.add('d-none');
                    }
                });
                if (noResults) {
                    noResults.classList.toggle('d-none', visibleCount > 0 || rows.length === 0);
                }
            };
            staffSearchInput.addEventListener('input', window.debounce ? window.debounce(filterStaff, 150) : filterStaff);
            document.querySelectorAll('[data-role-filter]').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    activeStaffRole = (btn.getAttribute('data-role-filter') || 'ALL').toUpperCase();
                    document.querySelectorAll('[data-role-filter]').forEach(function (b) {
                        b.classList.remove('btn-maple-primary', 'active');
                        b.classList.add('btn-maple-secondary');
                        b.setAttribute('aria-pressed', 'false');
                    });
                    btn.classList.remove('btn-maple-secondary');
                    btn.classList.add('btn-maple-primary', 'active');
                    btn.setAttribute('aria-pressed', 'true');
                    filterStaff();
                });
            });
            const resetBtn = document.getElementById('resetStaffFilterBtn');
            if (resetBtn) {
                resetBtn.addEventListener('click', function () {
                    if (staffSearchInput) staffSearchInput.value = '';
                    activeStaffRole = 'ALL';
                    document.querySelectorAll('[data-role-filter]').forEach(function (b) {
                        b.classList.remove('btn-maple-primary', 'active');
                        b.classList.add('btn-maple-secondary');
                        b.setAttribute('aria-pressed', 'false');
                    });
                    const allBtn = document.querySelector('[data-role-filter="ALL"]');
                    if (allBtn) {
                        allBtn.classList.remove('btn-maple-secondary');
                        allBtn.classList.add('btn-maple-primary', 'active');
                        allBtn.setAttribute('aria-pressed', 'true');
                    }
                    filterStaff();
                });
            }
        }

        // -------------------------------------------------------------------------
        // 16. Consolidated Page Helpers (Catalog, Kitchen Queue, Promotions)
        // -------------------------------------------------------------------------

        // Best Sellers category filter (index.jsp)
        window.filterBestSellers = function (cat, btn) {
            document.querySelectorAll('.filter-btn').forEach(function (b) {
                b.classList.remove('active', 'bg-primary', 'text-background');
                b.classList.add('bg-surface-container-high', 'text-on-surface-variant');
            });
            if (btn) {
                btn.classList.add('active', 'bg-primary', 'text-background');
                btn.classList.remove('bg-surface-container-high', 'text-on-surface-variant');
            }
            const items = document.querySelectorAll('#productGrid .product-item');
            items.forEach(function (item) {
                const itemCat = item.getAttribute('data-cat');
                if (cat === 'all' || itemCat === cat) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        };

        // Kitchen Queue Card Filter (kitchen_queue.jsp)
        window.MapleKitchen = {
            filterCards: function () {
                const input = document.getElementById('kitchenSearchInput');
                if (!input) return;
                const filter = input.value.toLowerCase().trim();
                const items = document.querySelectorAll('.kitchen-card-item');
                items.forEach(function (card) {
                    const text = card.getAttribute('data-search') ? card.getAttribute('data-search').toLowerCase() : '';
                    card.style.display = text.includes(filter) ? '' : 'none';
                });
            }
        };
        window.filterKitchenCards = function () {
            window.MapleKitchen.filterCards();
        };

        // Promotion Management Helpers (manage_promotions.jsp)
        window.updateDiscountHelp = function () {
            const typeEl = document.getElementById('discountType');
            if (!typeEl) return;
            const type = typeEl.value;
            const sym = document.getElementById('discountSymbol');
            const help = document.getElementById('discountHelpText');
            const valInput = document.getElementById('discountValue');
            if (type === 'PERCENTAGE') {
                if (sym) sym.textContent = '%';
                if (help) help.textContent = 'e.g. 15 for 15% off cart subtotal';
                if (valInput) valInput.max = '100';
            } else {
                if (sym) sym.textContent = 'Rs.';
                if (help) help.textContent = 'e.g. 5.00 for Rs. 5.00 flat discount';
                if (valInput) valInput.removeAttribute('max');
            }
        };

        let currentPromoStatus = 'ALL';
        window.applyCombinedPromoFilter = function () {
            const input = document.getElementById('promoSearchInput');
            const query = (input ? input.value : '').toLowerCase().trim();
            const rows = document.querySelectorAll('#promotionsTableBody tr.promo-row');
            let visibleCount = 0;
            rows.forEach(function (row) {
                const searchData = (row.getAttribute('data-search') || '').toLowerCase();
                const rowStatus = row.getAttribute('data-status');
                const matchesQuery = !query || searchData.includes(query);
                const matchesStatus = (currentPromoStatus === 'ALL' || rowStatus === currentPromoStatus);
                if (matchesQuery && matchesStatus) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            const noResults = document.getElementById('noPromosFoundRow');
            if (noResults) {
                noResults.classList.toggle('d-none', visibleCount > 0 || rows.length === 0);
            }
        };

        window.filterPromotionsTable = function () {
            window.applyCombinedPromoFilter();
        };

        window.filterByStatus = function (status) {
            currentPromoStatus = status;
            document.querySelectorAll('[id^="btnFilter"]').forEach(function (btn) {
                btn.classList.remove('btn-maple-primary', 'active');
                btn.classList.add('btn-maple-secondary');
                btn.setAttribute('aria-pressed', 'false');
            });
            const activeBtn = document.getElementById('btnFilter' + status.charAt(0) + status.slice(1).toLowerCase());
            if (activeBtn) {
                activeBtn.classList.remove('btn-maple-secondary');
                activeBtn.classList.add('btn-maple-primary', 'active');
                activeBtn.setAttribute('aria-pressed', 'true');
            }
            window.applyCombinedPromoFilter();
        };

        // -------------------------------------------------------------------------
        // Star Rating Interactive Controller
        // -------------------------------------------------------------------------
        const RATING_DESCRIPTIONS = {
            1: '1 star — Disappointing',
            2: '2 stars — Below Expectations',
            3: '3 stars — Average',
            4: '4 stars — Very Good',
            5: '5 stars — Outstanding'
        };

        window.initStarRatingSelectors = function () {
            const containers = document.querySelectorAll('.star-rating-container');
            containers.forEach(function (container) {
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

                // Initial render based on checked radio (defaults to 5)
                updateDisplay(getCheckedValue(), false);

                // Change listener on radio inputs (clicks or keyboard arrows)
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

                // Hover preview on individual stars
                stars.forEach(function (star) {
                    star.addEventListener('mouseenter', function () {
                        const hoverVal = this.getAttribute('data-value');
                        updateDisplay(hoverVal, true);
                    });
                });

                // Restore selection when cursor leaves the star group
                if (group) {
                    group.addEventListener('mouseleave', function () {
                        stars.forEach(function (s) {
                            s.classList.remove('is-preview');
                        });
                        updateDisplay(getCheckedValue(), false);
                    });
                }
            });
        };

        window.resetPromoFilters = function () {
            const searchInput = document.getElementById('promoSearchInput');
            if (searchInput) searchInput.value = '';
            window.filterByStatus('ALL');
        };

        // Custom Cake Studio Live Preview Auto-init (book_cake.jsp)
        if (document.getElementById('cakeFlavor') && document.getElementById('pickupDate')) {
            MapleCakeStudio.init();
        }

        // Promotions default expiry initialization (manage_promotions.jsp)
        const expiryInput = document.getElementById('expiryDate');
        if (expiryInput && !expiryInput.value) {
            const d = new Date();
            d.setMonth(d.getMonth() + 1);
            expiryInput.value = d.toISOString().split('T')[0];
        }

        // Auto-initialize order history filters if on order_history.jsp
        if (document.querySelector('[aria-label="Filter Orders by Status"]')) {
            window.initOrderHistoryFilters();
        }

        // Initialize Bootstrap tooltips if available
        if (window.bootstrap && bootstrap.Tooltip) {
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        }

        // Initialize Star Rating Selectors
        if (typeof window.initStarRatingSelectors === 'function') {
            window.initStarRatingSelectors();
        }
    });

})();
