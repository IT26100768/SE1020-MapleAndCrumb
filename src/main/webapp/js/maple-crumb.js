(function (window, document) {
    'use strict';


    window.Maple = {
        version: '2.2',
        toast: window.MapleToast,
        filter: window.MapleFilter,
        admin: window.MapleAdmin,
        checkout: window.MapleCheckout,
        cakeStudio: window.MapleCakeStudio,
        kitchen: window.MapleKitchen
    };

    document.addEventListener('DOMContentLoaded', function () {
        // Universal form & input enhancements
        if (typeof window.initPasswordToggles === 'function') {
            window.initPasswordToggles();
        }

        if (typeof window.initFormValidationAndLoading === 'function') {
            window.initFormValidationAndLoading();
        }

        // Bootstrap interactive tooltips
        if (typeof window.initTooltips === 'function') {
            window.initTooltips();
        }

        // Interactive 5-star rating controls (view_reviews.jsp)
        if (typeof window.initStarRatingSelectors === 'function') {
            window.initStarRatingSelectors();
        }

        // Page-specific initializations (strictly guarded by DOM element presence)

        // 1. Staff Directory Filter (manage_staff.jsp)
        if (document.getElementById('staffSearchInput') && typeof window.initStaffFilter === 'function') {
            window.initStaffFilter();
        }

        // 2. Custom Cake Studio Live Preview Auto-init (book_cake.jsp)
        if (document.getElementById('cakeFlavor') && document.getElementById('pickupDate') && window.MapleCakeStudio) {
            window.MapleCakeStudio.init();
        }

        // 3. Promotions Default Expiry Date (manage_promotions.jsp)
        const expiryInput = document.getElementById('expiryDate');
        if (expiryInput && !expiryInput.value) {
            const d = new Date();
            d.setMonth(d.getMonth() + 1);
            expiryInput.value = d.toISOString().split('T')[0];
        }

        // 4. Order History Filters Auto-init (order_history.jsp)
        if (document.querySelector('[aria-label="Filter Orders by Status"]') && typeof window.initOrderHistoryFilters === 'function') {
            window.initOrderHistoryFilters();
        }
    });

})(window, document);
