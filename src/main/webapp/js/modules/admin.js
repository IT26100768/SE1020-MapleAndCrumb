(function (window, document) {
    'use strict';

    // 1. Admin Form Helpers
    const MapleAdmin = {
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

    function toggleCategoryFields() {
        MapleAdmin.toggleProductCategoryFields();
    }

    function toggleAdminTier() {
        MapleAdmin.toggleAdminRoleTier();
    }


    // 2. Product Catalogue Admin Table Filter (manage_products.jsp)
    let productActiveCategory = 'ALL';

    function setProductCategoryFilter(category, btn) {
        productActiveCategory = category;
        const filterGroup = btn ? btn.closest('[role="group"]') : document.querySelector('[aria-label="Filter Products by Category"]');
        const buttons = filterGroup ? filterGroup.querySelectorAll('.btn') : document.querySelectorAll('[aria-label="Filter Products by Category"] .btn');
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
        filterAdminTable();
    }

    function filterAdminTable() {
        const query = (document.getElementById('adminTableSearch')?.value || '').toLowerCase().trim();
        const rows = document.querySelectorAll('#adminProductTable tbody tr.product-row');
        let visibleCount = 0;
        rows.forEach(function (row) {
            const text = row.innerText.toLowerCase();
            const cat = (row.getAttribute('data-category') || '').trim().toLowerCase();
            const matchesQuery = !query || text.includes(query);
            const matchesCategory = (productActiveCategory === 'ALL' || cat === productActiveCategory.toLowerCase());
            if (matchesQuery && matchesCategory) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        const noResults = document.getElementById('noProductsFoundRow');
        if (noResults) {
            noResults.classList.toggle('d-none', visibleCount > 0 || rows.length === 0);
        }
    }

    function resetProductFilters() {
        const searchInput = document.getElementById('adminTableSearch');
        if (searchInput) searchInput.value = '';
        const allBtn = document.getElementById('productFilterAll');
        setProductCategoryFilter('ALL', allBtn);
    }


    // 3. Booking Reservations Table Filter (manage_bookings.jsp)
    let bookingActiveStatus = 'ALL';

    function setStatusFilter(status, btn) {
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
        filterBookingsTable();
    }

    function filterBookingsTable() {
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
    }

    function resetBookingFilters() {
        const searchInput = document.getElementById('bookingSearchInput');
        if (searchInput) searchInput.value = '';
        const allBtn = document.getElementById('bookingFilterAll');
        setStatusFilter('ALL', allBtn);
    }

    // 4. Staff Directory Search & Role Filter (manage_staff.jsp)

    function initStaffFilter() {
        const staffSearchInput = document.getElementById('staffSearchInput');
        if (!staffSearchInput || staffSearchInput.dataset.staffFilterInit) return;
        staffSearchInput.dataset.staffFilterInit = 'true';

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

        const debounced = window.debounce ? window.debounce(filterStaff, 150) : filterStaff;
        staffSearchInput.addEventListener('input', debounced);

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

    // 5. Kitchen Queue Card Filter (kitchen_queue.jsp)

    const MapleKitchen = {
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

    function filterKitchenCards() {
        MapleKitchen.filterCards();
    }

    // 6. Promotion Management Helpers (manage_promotions.jsp)
    function updateDiscountHelp() {
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
    }

    let currentPromoStatus = 'ALL';

    function applyCombinedPromoFilter() {
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
    }

    function filterPromotionsTable() {
        applyCombinedPromoFilter();
    }

    function filterByStatus(status) {
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
        applyCombinedPromoFilter();
    }

    function resetPromoFilters() {
        const searchInput = document.getElementById('promoSearchInput');
        if (searchInput) searchInput.value = '';
        filterByStatus('ALL');
    }

    // Public Global Exports
    window.MapleAdmin = MapleAdmin;
    window.toggleCategoryFields = toggleCategoryFields;
    window.toggleAdminTier = toggleAdminTier;
    window.setProductCategoryFilter = setProductCategoryFilter;
    window.filterAdminTable = filterAdminTable;
    window.resetProductFilters = resetProductFilters;
    window.setStatusFilter = setStatusFilter;
    window.filterBookingsTable = filterBookingsTable;
    window.resetBookingFilters = resetBookingFilters;
    window.initStaffFilter = initStaffFilter;
    window.MapleKitchen = MapleKitchen;
    window.filterKitchenCards = filterKitchenCards;
    window.updateDiscountHelp = updateDiscountHelp;
    window.applyCombinedPromoFilter = applyCombinedPromoFilter;
    window.filterPromotionsTable = filterPromotionsTable;
    window.filterByStatus = filterByStatus;
    window.resetPromoFilters = resetPromoFilters;

})(window, document);

