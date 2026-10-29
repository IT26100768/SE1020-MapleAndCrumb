(function (window, document) {
    'use strict';

    function selectCakeOrderType(type) {
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
        updateBookingSummary();
    }

    function updateBookingSummary() {
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

        const formatFn = window.formatCurrency || function (amt) {
            return 'Rs. ' + Number(amt).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
        };

        if (sSubtotal) sSubtotal.textContent = formatFn(basePrice);
        if (sDeliveryFee) sDeliveryFee.textContent = formatFn(deliveryFee);
        if (sGrandTotal) sGrandTotal.textContent = formatFn(grandTotal);
    }

    const MapleCakeStudio = {
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

            const orderTypeRadios = document.querySelectorAll('input[name="orderType"]');
            orderTypeRadios.forEach(function (radio) {
                if (!radio.dataset.cakeRadioInit) {
                    radio.dataset.cakeRadioInit = 'true';
                    radio.addEventListener('change', function () {
                        selectCakeOrderType(this.value);
                    });
                }
            });

            const checkedRadio = document.querySelector('input[name="orderType"]:checked');
            selectCakeOrderType(checkedRadio ? checkedRadio.value : 'Pickup');

            const syncInputs = [
                'cakeFlavor', 'cakeSize', 'cakeOccasion', 'pickupDate',
                'pickupTime', 'customMessage', 'specialNotes', 'cakeDeliveryAddressInput'
            ];
            syncInputs.forEach(function (id) {
                const el = document.getElementById(id);
                if (el && !el.dataset.cakeStudioSyncInit) {
                    el.dataset.cakeStudioSyncInit = 'true';
                    el.addEventListener('input', updateBookingSummary);
                    el.addEventListener('change', updateBookingSummary);
                }
            });

            updateBookingSummary();
        },

        updateLivePreview: function () {
            updateBookingSummary();
        }
    };

    function updateLivePreview() {
        updateBookingSummary();
    }

    window.selectCakeOrderType = selectCakeOrderType;
    window.updateBookingSummary = updateBookingSummary;
    window.MapleCakeStudio = MapleCakeStudio;
    window.updateLivePreview = updateLivePreview;

})(window, document);

