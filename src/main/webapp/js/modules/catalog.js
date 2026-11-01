(function (window, document) {
    'use strict';


    const MapleFilter = {

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

    function updateEstimatorPrice() {
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

        const formatFn = window.formatLKR || function (amt) {
            return 'Rs. ' + Math.round(amt).toLocaleString('en-US');
        };
        displayPriceEl.textContent = formatFn(price);
        if (servingNoteEl) {
            servingNoteEl.textContent = '(' + tier.serving + ')';
        }
    }

    function proceedToCakeStudio() {
        const sizeEl = document.getElementById('estimatorSize');
        const flavorEl = document.getElementById('estimatorFlavor');
        const messageEl = document.getElementById('estimatorMessage');

        const size = sizeEl ? sizeEl.value : '8';
        const flavor = flavorEl ? encodeURIComponent(flavorEl.value) : '';
        const msg = messageEl ? encodeURIComponent(messageEl.value) : '';
        window.location.href = window.location.pathname.replace(/\/([^\/]*)$/, '') + '/bookCake?size=' + size + '&flavor=' + flavor + '&message=' + msg;
    }

    function filterBestSellers(cat, btn) {
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
    }

    let currentMenuCategory = 'ALL';

    function filterCategory(category) {
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
        applyMenuFilters();
    }

    function applyMenuFilters() {
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
    }

    const searchProducts = window.debounce
        ? window.debounce(function () {
            applyMenuFilters();
        }, 150)
        : function () {
            applyMenuFilters();
        };

    window.MapleFilter = MapleFilter;
    window.updateEstimatorPrice = updateEstimatorPrice;
    window.proceedToCakeStudio = proceedToCakeStudio;
    window.filterBestSellers = filterBestSellers;
    window.filterCategory = filterCategory;
    window.applyMenuFilters = applyMenuFilters;
    window.searchProducts = searchProducts;
    window.currentMenuCategory = currentMenuCategory;

})(window, document);

