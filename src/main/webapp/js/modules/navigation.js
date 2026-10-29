(function (window, document) {
    'use strict';

    // -------------------------------------------------------------------------
    // 1. Mobile Drawer Navigation Toggle (navbar.jsp)
    // -------------------------------------------------------------------------
    function toggleMapleMobileMenu() {
        const drawer = document.getElementById('mapleMobileDrawer');
        if (drawer) {
            drawer.style.display = (drawer.style.display === 'block') ? 'none' : 'block';
        }
    }

    // -------------------------------------------------------------------------
    // 2. User Avatar Dropdown Toggle (navbar.jsp)
    // -------------------------------------------------------------------------
    function toggleMapleUserDropdown(event) {
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
    }

    // Dismiss dropdown when clicking anywhere outside
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
    // 3. Admin Sidebar Toggle Helper (admin_sidebar.jsp)
    // -------------------------------------------------------------------------
    function toggleAdminSidebar(force) {
        const sb = document.getElementById('mcAdminSidebar');
        const bd = document.getElementById('mcAdminSidebarBackdrop');
        if (!sb) return;
        const willShow = (force !== undefined) ? force : !sb.classList.contains('show');
        if (willShow) {
            sb.classList.add('show');
            if (bd) bd.classList.add('show');
        } else {
            sb.classList.remove('show');
            if (bd) bd.classList.remove('show');
        }
    }

    // -------------------------------------------------------------------------
    // Public Global Exports
    // -------------------------------------------------------------------------
    window.toggleMapleMobileMenu = toggleMapleMobileMenu;
    window.toggleMapleUserDropdown = toggleMapleUserDropdown;
    if (typeof window.toggleAdminSidebar !== 'function') {
        window.toggleAdminSidebar = toggleAdminSidebar;
    }

})(window, document);

