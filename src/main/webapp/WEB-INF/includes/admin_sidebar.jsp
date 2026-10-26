<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String currentURI = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    if (currentURI == null) {
        currentURI = request.getRequestURI();
    }
    request.setAttribute("reqURI", currentURI);

    String activeTab = request.getParameter("activeTab");
    if (activeTab == null || activeTab.trim().isEmpty()) {
        if (currentURI.endsWith("dashboard.jsp")) activeTab = "dashboard";
        else if (currentURI.contains("kitchenQueue") || currentURI.contains("kitchen_queue") || currentURI.contains("kitchenTicket") || currentURI.contains("kitchen_ticket")) activeTab = "kitchen";
        else if (currentURI.contains("manageProducts") || currentURI.contains("comp02-products") || currentURI.contains("Product") || currentURI.contains("product")) activeTab = "products";
        else if (currentURI.contains("manageBookings") || currentURI.contains("comp03-bookings") || currentURI.contains("Booking") || currentURI.contains("bookCake")) activeTab = "bookings";
        else if (currentURI.contains("viewOrders") || currentURI.contains("orderHistory") || currentURI.contains("comp04-orders") || currentURI.contains("Order")) activeTab = "orders";
        else if (currentURI.contains("managePromotions") || currentURI.contains("comp06-reviews/manage_promotions") || currentURI.contains("promo")) activeTab = "promotions";
        else if (currentURI.contains("viewReviews") || currentURI.contains("comp06-reviews/view_reviews") || currentURI.contains("Review")) activeTab = "reviews";
        else if (currentURI.contains("viewStaff") || currentURI.contains("manage_staff") || currentURI.contains("add_staff")) activeTab = "staff";
        else activeTab = "dashboard";
    }
    request.setAttribute("currentActiveTab", activeTab);

    // Self-healing lazy loading of live real database counts if not provided by host page
    if (request.getAttribute("kpiProductCount") == null) {
        try {
            com.mapleandcrumb.dao.comp02.ProductDAO pDao = new com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl();
            com.mapleandcrumb.dao.comp03.CustomCakeDAO cDao = new com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl();
            com.mapleandcrumb.dao.comp04.OrderDAO oDao = new com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl();
            com.mapleandcrumb.dao.comp06.PromotionDAO prDao = new com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl();
            com.mapleandcrumb.dao.comp06.ReviewDAO rDao = new com.mapleandcrumb.dao.impl.comp06.ReviewDAOImpl();
            com.mapleandcrumb.dao.comp05.KitchenTaskDAO kDao = new com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl();
            com.mapleandcrumb.dao.comp05.StaffDAO sDao = new com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl();

            request.setAttribute("kpiProductCount", pDao.getProductCount());
            request.setAttribute("kpiBookingCount", cDao.getBookingCount());
            request.setAttribute("kpiOrderCount", oDao.getOrderCount());
            request.setAttribute("kpiActivePromos", prDao.getAllActivePromotions().size());
            request.setAttribute("kpiActiveTasks", kDao.getActiveTaskCount());
            request.setAttribute("kpiStaffCount", sDao.getStaffCount());

            java.util.List<com.mapleandcrumb.model.comp06.Review> revs = rDao.getAllReviews();
            double avg = 5.0;
            if (revs != null && !revs.isEmpty()) {
                int s = 0;
                for (com.mapleandcrumb.model.comp06.Review r : revs) s += r.getRating();
                avg = Math.round(((double) s / revs.size()) * 10.0) / 10.0;
            }
            request.setAttribute("averageRating", avg);
        } catch (Exception ignored) {}
    }
%>

<style id="mc-admin-scoped-layout-styles">
    .mc-admin-layout-wrapper {
        display: flex !important;
        flex-direction: row !important;
        align-items: stretch !important;
        width: 100% !important;
        min-height: calc(100vh - 104px);
        background-color: #fdf9f1;
        position: relative;
        box-sizing: border-box;
    }
    .mc-admin-sidebar {
        width: 280px !important;
        min-width: 280px !important;
        max-width: 280px !important;
        flex: 0 0 280px !important;
        flex-shrink: 0 !important;
        position: sticky !important;
        top: 104px !important;
        height: calc(100vh - 104px) !important;
        display: flex !important;
        flex-direction: column !important;
        justify-content: space-between !important;
        background-color: #ffffff !important;
        border-right: 1px solid rgba(211, 195, 190, 0.4) !important;
        z-index: 25;
        box-sizing: border-box;
    }
    .mc-sidebar-inner {
        display: flex;
        flex-direction: column;
        height: 100%;
        overflow: hidden;
    }
    .mc-sidebar-brand-wrap {
        padding: 1.25rem 1.25rem 1rem 1.25rem;
        border-bottom: 1px solid rgba(211, 195, 190, 0.25);
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.75rem;
        background-color: #ffffff;
    }
    .mc-sidebar-brand-left {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .mc-sidebar-monogram {
        width: 40px;
        height: 40px;
        border-radius: 12px;
        background-color: #2b1810;
        color: #ffffff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Playfair Display', Georgia, serif;
        font-weight: 700;
        font-size: 1.15rem;
        box-shadow: 0 2px 6px rgba(43, 24, 16, 0.15);
        flex-shrink: 0;
    }
    .mc-sidebar-brand-title {
        font-family: 'Playfair Display', Georgia, serif;
        font-size: 0.95rem;
        font-weight: 600;
        color: #070100;
        line-height: 1.2;
        margin: 0;
    }
    .mc-sidebar-brand-sub {
        font-family: 'Outfit', 'Plus Jakarta Sans', sans-serif;
        font-size: 0.72rem;
        font-weight: 500;
        color: #6a5a54;
        margin: 0;
    }
    .mc-sidebar-nav-scroll {
        flex: 1 1 0%;
        overflow-y: auto;
        padding: 1rem 0.75rem;
        display: flex;
        flex-direction: column;
        gap: 1.25rem;
    }
    .mc-sidebar-section-title {
        display: block;
        padding: 0 0.5rem 0.4rem 0.5rem;
        font-size: 0.68rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: #865225;
    }
    .mc-sidebar-nav-list {
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
    }
    .mc-sidebar-nav-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.5rem 0.75rem;
        border-radius: 10px;
        text-decoration: none !important;
        transition: background-color 0.15s ease, color 0.15s ease;
        font-size: 0.825rem;
        font-weight: 500;
        color: #1c1c17;
    }
    .mc-sidebar-nav-item:hover {
        background-color: #f7f3eb;
        color: #070100;
    }
    .mc-sidebar-nav-item.active {
        background-color: #2b1810 !important;
        color: #ffffff !important;
        font-weight: 600;
        box-shadow: 0 2px 6px rgba(43, 24, 16, 0.12);
    }
    .mc-sidebar-nav-left {
        display: flex;
        align-items: center;
        gap: 0.65rem;
    }
    .mc-sidebar-nav-icon {
        font-size: 1.15rem !important;
        color: #865225;
    }
    .mc-sidebar-nav-item.active .mc-sidebar-nav-icon {
        color: #fdb882 !important;
    }
    .mc-sidebar-nav-label {
        white-space: nowrap;
    }
    .mc-sidebar-badge {
        font-size: 0.68rem;
        font-weight: 600;
        padding: 0.15rem 0.55rem;
        border-radius: 9999px;
        background-color: #f1ede6;
        color: #4f4440;
        display: inline-flex;
        align-items: center;
        gap: 0.25rem;
        white-space: nowrap;
    }
    .mc-sidebar-nav-item.active .mc-sidebar-badge {
        background-color: #865225 !important;
        color: #ffffff !important;
    }
    .mc-sidebar-badge-gold {
        background-color: #ffdea5;
        color: #261900;
    }
    .mc-sidebar-badge-live {
        background-color: #865225;
        color: #ffffff;
    }
    .mc-sidebar-live-dot {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background-color: #4ade80;
        animation: mcPulse 1.8s infinite;
    }
    .mc-sidebar-gateway {
        padding-top: 0.85rem;
        border-top: 1px solid rgba(211, 195, 190, 0.25);
    }
    .mc-admin-content-canvas {
        flex: 1 1 0% !important;
        min-width: 0 !important;
        width: calc(100% - 280px) !important;
        display: flex !important;
        flex-direction: column !important;
        background-color: #fdf9f1;
        box-sizing: border-box;
    }
    .mc-admin-sidebar-backdrop {
        display: none;
        position: fixed;
        top: 104px;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(7, 1, 0, 0.45);
        z-index: 1040;
        backdrop-filter: blur(2px);
    }
    @media (max-width: 991.98px) {
        .mc-admin-layout-wrapper {
            display: block !important;
        }
        .mc-admin-sidebar {
            position: fixed !important;
            top: 104px !important;
            left: 0 !important;
            bottom: 0 !important;
            height: calc(100vh - 104px) !important;
            transform: translateX(-100%);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            z-index: 1050 !important;
        }
        .mc-admin-sidebar.show {
            transform: translateX(0) !important;
        }
        .mc-admin-sidebar-backdrop.show {
            display: block !important;
        }
        .mc-admin-content-canvas {
            width: 100% !important;
        }
    }
</style>

<div id="mcAdminSidebarBackdrop" class="mc-admin-sidebar-backdrop" onclick="toggleAdminSidebar(false)"></div>

<aside id="mcAdminSidebar" class="mc-admin-sidebar">
    <div class="mc-sidebar-inner">
        <!-- Brand Header -->
        <div class="mc-sidebar-brand-wrap">
            <div class="mc-sidebar-brand-left">
                <div class="mc-sidebar-monogram">
                    M
                </div>
                <div>
                    <h1 class="mc-sidebar-brand-title">Maple &amp; Crumb</h1>
                    <p class="mc-sidebar-brand-sub">Haute-Pâtisserie Atelier</p>
                </div>
            </div>
            <button type="button" class="d-lg-none btn btn-sm btn-link text-muted p-0 text-decoration-none" onclick="toggleAdminSidebar(false)" aria-label="Close Sidebar">
                <span class="material-symbols-outlined fs-5">close</span>
            </button>
        </div>

        <div class="mc-sidebar-nav-scroll mc-custom-scroll">
            <div>
                <span class="mc-sidebar-section-title">Consoles &amp; Modules</span>
                <nav class="mc-sidebar-nav-list">
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'dashboard' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">dashboard</span>
                            <span class="mc-sidebar-nav-label">Operations Hub</span>
                        </div>
                        <span class="mc-sidebar-badge">Suite</span>
                    </a>

                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'kitchen' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/kitchenQueue">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">countertops</span>
                            <span class="mc-sidebar-nav-label">Kitchen Operations</span>
                        </div>
                        <c:choose>
                            <c:when test="${kpiActiveTasks > 0}">
                                <span class="mc-sidebar-badge mc-sidebar-badge-live">
                                    <span class="mc-sidebar-live-dot"></span>
                                    Live (${kpiActiveTasks})
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="mc-sidebar-badge">Idle</span>
                            </c:otherwise>
                        </c:choose>
                    </a>

                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'products' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/manageProducts">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">inventory_2</span>
                            <span class="mc-sidebar-nav-label">Product Catalogue</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiProductCount}</span>
                    </a>

                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'bookings' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/manageBookings">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">cake</span>
                            <span class="mc-sidebar-nav-label">Cake Reservations</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiBookingCount}</span>
                    </a>

                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'orders' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/viewOrders?view=manage">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">local_shipping</span>
                            <span class="mc-sidebar-nav-label">Order Fulfillment</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiOrderCount}</span>
                    </a>

                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'promotions' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/managePromotions">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">local_offer</span>
                            <span class="mc-sidebar-nav-label">Promotions</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiActivePromos} Active</span>
                    </a>

                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'reviews' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/viewReviews">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">star</span>
                            <span class="mc-sidebar-nav-label">Customer Reviews</span>
                        </div>
                        <span class="mc-sidebar-badge mc-sidebar-badge-gold">${averageRating}★</span>
                    </a>

                    <c:if test="${sessionScope.loggedInUser.userRole == 'ADMIN'}">
                        <a class="mc-sidebar-nav-item ${currentActiveTab == 'staff' ? 'active' : ''}" 
                           href="${pageContext.request.contextPath}/viewStaff">
                            <div class="mc-sidebar-nav-left">
                                <span class="material-symbols-outlined mc-sidebar-nav-icon">badge</span>
                                <span class="mc-sidebar-nav-label">Staff &amp; Payroll</span>
                            </div>
                            <span class="mc-sidebar-badge">${kpiStaffCount}</span>
                        </a>
                    </c:if>
                </nav>
            </div>

            <div class="mc-sidebar-gateway">
                <span class="mc-sidebar-section-title">Atelier Gateway</span>
                <nav class="mc-sidebar-nav-list">
                    <a class="mc-sidebar-nav-item" href="${pageContext.request.contextPath}/menu">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">store</span>
                            <span class="mc-sidebar-nav-label">Public Storefront</span>
                        </div>
                        <span class="mc-sidebar-badge" style="color: #15803d; background-color: #dcfce7; border: 1px solid #bbf7d0;">Open ↗</span>
                    </a>
                    <a class="mc-sidebar-nav-item" href="${pageContext.request.contextPath}/comp01-user/profile.jsp">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">manage_accounts</span>
                            <span class="mc-sidebar-nav-label">Account Profile</span>
                        </div>
                        <span class="mc-sidebar-badge">${not empty sessionScope.loggedInUser.adminLevel ? sessionScope.loggedInUser.adminLevel : sessionScope.loggedInUser.userRole}</span>
                    </a>
                </nav>
            </div>
        </div>
    </div>
</aside>

<script>
    function toggleAdminSidebar(force) {
        var sb = document.getElementById('mcAdminSidebar');
        var bd = document.getElementById('mcAdminSidebarBackdrop');
        if (!sb) return;
        var willShow = (force !== undefined) ? force : !sb.classList.contains('show');
        if (willShow) {
            sb.classList.add('show');
            if (bd) bd.classList.add('show');
        } else {
            sb.classList.remove('show');
            if (bd) bd.classList.remove('show');
        }
    }
</script>
