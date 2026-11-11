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
        String cleanUri = currentURI;
        String ctx = request.getContextPath();
        if (ctx != null && !ctx.isEmpty() && cleanUri.startsWith(ctx)) {
            cleanUri = cleanUri.substring(ctx.length());
        }
        int qIdx = cleanUri.indexOf('?');
        if (qIdx >= 0) {
            cleanUri = cleanUri.substring(0, qIdx);
        }
        if (cleanUri.length() > 1 && cleanUri.endsWith("/")) {
            cleanUri = cleanUri.substring(0, cleanUri.length() - 1);
        }

        if (cleanUri.equals("/comp05-admin/dashboard.jsp") || cleanUri.equals("/dashboard") || cleanUri.equals("/admin")) {
            activeTab = "dashboard";
        } else if (cleanUri.startsWith("/kitchenQueue") || cleanUri.startsWith("/kitchen_queue") || cleanUri.startsWith("/kitchenTicket") || cleanUri.startsWith("/comp05-admin/kitchen")) {
            activeTab = "kitchen";
        } else if (cleanUri.startsWith("/manageProducts") || cleanUri.startsWith("/manage_products") || cleanUri.startsWith("/addProduct") || cleanUri.startsWith("/editProduct") || cleanUri.startsWith("/comp02-products")) {
            activeTab = "products";
        } else if (cleanUri.startsWith("/manageBookings") || cleanUri.startsWith("/manage_bookings") || cleanUri.startsWith("/comp03-bookings/manage")) {
            activeTab = "bookings";
        } else if (cleanUri.startsWith("/viewOrders") || cleanUri.startsWith("/comp04-orders/order_history") || cleanUri.startsWith("/orderHistory")) {
            activeTab = "orders";
        } else if (cleanUri.startsWith("/managePromotions") || cleanUri.startsWith("/manage_promotions") || cleanUri.startsWith("/addPromo") || cleanUri.equals("/comp06-reviews/manage_promotions.jsp")) {
            activeTab = "promotions";
        } else if (cleanUri.startsWith("/viewReviews") || cleanUri.startsWith("/view_reviews") || cleanUri.equals("/comp06-reviews/view_reviews.jsp")) {
            activeTab = "reviews";
        } else if (cleanUri.startsWith("/viewStaff") || cleanUri.startsWith("/manageStaff") || cleanUri.startsWith("/manage_staff") || cleanUri.startsWith("/addStaff") || cleanUri.startsWith("/comp05-admin/manage_staff") || cleanUri.startsWith("/comp05-admin/add_staff")) {
            activeTab = "staff";
        } else {
            activeTab = "dashboard";
        }
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

<!-- Admin Suite Layout & Sidebar styles are provided by css/layout.css -->

<!-- Mobile Backdrop Overlay -->
<div id="mcAdminSidebarBackdrop" class="mc-admin-sidebar-backdrop" onclick="toggleAdminSidebar(false)"></div>

<!-- Left Dedicated Navigation Sidebar -->
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
                </div>
            </div>
            <!-- Mobile Close Button -->
            <button type="button" class="d-lg-none btn btn-sm btn-link text-muted p-0 text-decoration-none" onclick="toggleAdminSidebar(false)" aria-label="Close Sidebar">
                <span class="material-symbols-outlined fs-5">close</span>
            </button>
        </div>

        <!-- Navigation Menu Items -->
        <div class="mc-sidebar-nav-scroll mc-custom-scroll">
            <div>
                <span class="mc-sidebar-section-title">Consoles &amp; Modules</span>
                <nav class="mc-sidebar-nav-list">
                    <!-- 1. Console Operations Hub (Executive Dashboard) -->
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'dashboard' ? 'active' : ''}" 
                       aria-current="${currentActiveTab == 'dashboard' ? 'page' : 'false'}"
                       href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">dashboard</span>
                            <span class="mc-sidebar-nav-label">Operations Hub</span>
                        </div>
                        <span class="mc-sidebar-badge">Suite</span>
                    </a>

                    <!-- 2. Kitchen Operations Queue -->
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'kitchen' ? 'active' : ''}" 
                       aria-current="${currentActiveTab == 'kitchen' ? 'page' : 'false'}"
                       href="${pageContext.request.contextPath}/kitchenQueue">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">countertops</span>
                            <span class="mc-sidebar-nav-label">Kitchen Queue</span>
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

                    <!-- 3. Product Catalogue -->
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'products' ? 'active' : ''}" 
                       aria-current="${currentActiveTab == 'products' ? 'page' : 'false'}"
                       href="${pageContext.request.contextPath}/manageProducts">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">inventory_2</span>
                            <span class="mc-sidebar-nav-label">Product Inventory</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiProductCount}</span>
                    </a>

                    <!-- 4. Cake Reservations -->
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'bookings' ? 'active' : ''}" 
                       aria-current="${currentActiveTab == 'bookings' ? 'page' : 'false'}"
                       href="${pageContext.request.contextPath}/manageBookings">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">cake</span>
                            <span class="mc-sidebar-nav-label">Cake Bookings</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiBookingCount}</span>
                    </a>

                    <!-- 5. Order Fulfillment -->
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'orders' ? 'active' : ''}" 
                       aria-current="${currentActiveTab == 'orders' ? 'page' : 'false'}"
                       href="${pageContext.request.contextPath}/viewOrders?view=manage">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">local_shipping</span>
                            <span class="mc-sidebar-nav-label">Orders &amp; Dispatch</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiOrderCount}</span>
                    </a>

                    <!-- 6. Promotions & Discounts -->
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'promotions' ? 'active' : ''}" 
                       aria-current="${currentActiveTab == 'promotions' ? 'page' : 'false'}"
                       href="${pageContext.request.contextPath}/managePromotions">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">local_offer</span>
                            <span class="mc-sidebar-nav-label">Manage Promotions</span>
                        </div>
                        <span class="mc-sidebar-badge">${kpiActivePromos} Active</span>
                    </a>

                    <!-- 7. Customer Reviews -->
                    <a class="mc-sidebar-nav-item ${currentActiveTab == 'reviews' ? 'active' : ''}" 
                       aria-current="${currentActiveTab == 'reviews' ? 'page' : 'false'}"
                       href="${pageContext.request.contextPath}/viewReviews">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">star</span>
                            <span class="mc-sidebar-nav-label">Customer Reviews</span>
                        </div>
                        <span class="mc-sidebar-badge mc-sidebar-badge-gold">${averageRating}★</span>
                    </a>

                    <!-- 8. Staff Directory (Admin Only) -->
                    <c:if test="${sessionScope.loggedInUser.userRole == 'ADMIN'}">
                        <a class="mc-sidebar-nav-item ${currentActiveTab == 'staff' ? 'active' : ''}" 
                           aria-current="${currentActiveTab == 'staff' ? 'page' : 'false'}"
                           href="${pageContext.request.contextPath}/viewStaff">
                            <div class="mc-sidebar-nav-left">
                                <span class="material-symbols-outlined mc-sidebar-nav-icon">badge</span>
                                <span class="mc-sidebar-nav-label">Staff Directory</span>
                            </div>
                            <span class="mc-sidebar-badge">${kpiStaffCount}</span>
                        </a>
                    </c:if>
                </nav>
            </div>

            <!-- Atelier Gateway Links -->
            <div class="mc-sidebar-gateway">
                <span class="mc-sidebar-section-title">Atelier Gateway</span>
                <nav class="mc-sidebar-nav-list">
                    <!-- Public Storefront -->
                    <a class="mc-sidebar-nav-item" href="${pageContext.request.contextPath}/menu">
                        <div class="mc-sidebar-nav-left">
                            <span class="material-symbols-outlined mc-sidebar-nav-icon">store</span>
                            <span class="mc-sidebar-nav-label">Public Storefront</span>
                        </div>
                        <span class="mc-sidebar-badge" style="color: #15803d; background-color: #dcfce7; border: 1px solid #bbf7d0;">Open ↗</span>
                    </a>
                    <!-- Account Profile -->
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

<!-- Admin Mobile Toggle Script -->
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
