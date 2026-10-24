<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History — Maple &amp; Crumb</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,400&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Google Material Symbols Outlined -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css?v=2.1">
</head>
<body class="d-flex flex-column min-vh-100" style="background-color: var(--maple-cream-50, #fdfbf7);">
<%
    if (request.getAttribute("orders") == null) {
        com.mapleandcrumb.model.comp01.User user = (com.mapleandcrumb.model.comp01.User) session.getAttribute("loggedInUser");
        if (user != null) {
            com.mapleandcrumb.dao.comp04.OrderDAO oDao = new com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl();
            boolean isStaffOrAdmin = "ADMIN".equalsIgnoreCase(user.getUserRole()) || "STAFF".equalsIgnoreCase(user.getUserRole());
            if (isStaffOrAdmin && request.getParameter("view") != null && "my".equals(request.getParameter("view"))) {
                request.setAttribute("orders", oDao.getOrdersByCustomer(user.getUserID()));
                request.setAttribute("isManagerView", false);
            } else if (isStaffOrAdmin) {
                request.setAttribute("orders", oDao.getAllOrders());
                request.setAttribute("isManagerView", true);
            } else {
                java.util.List<com.mapleandcrumb.model.comp04.Order> list = oDao.getOrdersByCustomer(user.getUserID());
                if (list.isEmpty() && user.getEmail() != null) {
                    list = oDao.getOrdersByCustomer(user.getEmail());
                }
                request.setAttribute("orders", list);
                request.setAttribute("isManagerView", false);
            }
        }
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${not empty sessionScope.loggedInUser}">
        <c:choose>
            <c:when test="${isManagerView}">
                <div class="mc-admin-layout-wrapper">
                    <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                        <jsp:param name="activeTab" value="orders" />
                    </jsp:include>

                    <div class="mc-admin-content-canvas">
                        <header class="mc-admin-header">
                            <div class="d-flex align-items-center gap-3">
                                <button type="button" class="d-lg-none btn btn-sm btn-maple-secondary rounded-3 px-2.5 py-1.5 d-inline-flex align-items-center gap-1 shadow-sm" onclick="toggleAdminSidebar()" aria-label="Toggle Admin Menu">
                                    <span class="material-symbols-outlined fs-5">menu</span>
                                    <span class="small fw-semibold">Console</span>
                                </button>
                                <nav aria-label="breadcrumb" class="mb-0">
                                    <ol class="breadcrumb small mb-0">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Operations Hub</a></li>
                                        <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Order Fulfillment</li>
                                    </ol>
                                </nav>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-sm btn-maple-secondary rounded-3 px-3 py-1.5 shadow-sm d-inline-flex align-items-center gap-1">
                                    <span class="material-symbols-outlined fs-6">visibility</span> Storefront Menu
                                </a>
                            </div>
                        </header>

                        <main id="main-content" class="mc-admin-main-body p-4 p-md-5">

            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Menu</a></li>
                    <li class="breadcrumb-item active text-muted" aria-current="page">Order History</li>
                </ol>
            </nav>

            <!-- Page Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                <div>
                    <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                        <c:choose>
                            <c:when test="${isManagerView}">Bakery Orders Management Console</c:when>
                            <c:otherwise>My Bakery Orders</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="text-muted small mb-0">
                        <c:choose>
                            <c:when test="${isManagerView}">Review active customer orders, update delivery dispatch, and track bakery fulfillment</c:when>
                            <c:otherwise>Track freshly baked orders, delivery statuses, and view previous purchase receipts</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="mt-3 mt-sm-0 d-flex gap-2">
                    <c:if test="${isManagerView}">
                        <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="btn btn-maple-secondary btn-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                            <span class="material-symbols-outlined fs-6">dashboard</span> Dashboard
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary shadow-sm btn-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                        <span class="material-symbols-outlined fs-6">storefront</span> Order Bakery Treats
                    </a>
                </div>
            </div>

            <!-- Feedback Alerts -->
            <c:if test="${param.msg == 'cancelled'}">
                <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #eff6ff; color: #1e40af;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-primary flex-shrink-0">info</span>
                    <div class="small fw-medium">The order was successfully cancelled and any simulated charges were marked refunded.</div>
                </div>
            </c:if>

            <c:if test="${param.msg == 'statusUpdated'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-success flex-shrink-0">check_circle</span>
                    <div class="small fw-medium">Order status was successfully updated in the database registry.</div>
                </div>
            </c:if>

            <c:if test="${param.error == 'unauthorized'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">shield_lock</span>
                    <div class="small fw-medium">You are not authorized to perform actions on this order.</div>
                </div>
            </c:if>

            <!-- Search and Filter Bar -->
            <div class="row g-3 align-items-center justify-content-between mb-4">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">
                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                        </span>
                        <input type="text" id="orderSearchInput" class="form-control form-control-maple border-start-0 ps-1" placeholder="Search orders by code, items, or status..." onkeyup="filterOrders()" aria-label="Search orders" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                    </div>
                </div>
                <div class="col-auto d-flex flex-wrap gap-2" role="group" aria-label="Filter Orders by Status">
                    <button type="button" class="btn btn-sm btn-maple-primary rounded-pill px-3 active" aria-pressed="true" id="orderFilterAll" onclick="setOrderStatusFilter('ALL', this)">All</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterPending" onclick="setOrderStatusFilter('Pending', this)">Pending</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterProcessing" onclick="setOrderStatusFilter('Processing', this)">Processing</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterCompleted" onclick="setOrderStatusFilter('Completed', this)">Completed</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterCancelled" onclick="setOrderStatusFilter('Cancelled', this)">Cancelled</button>
                </div>
            </div>

            <!-- Orders Listing -->
            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="row g-4" id="ordersContainer">
                        <c:forEach var="ord" items="${orders}">
                            <div class="col-12 order-card-item" data-status="${ord.status}">
                                <div class="card card-maple shadow-sm p-4 border-0" style="background: #ffffff; border-radius: var(--radius-xl, 16px); box-shadow: 0 6px 24px rgba(7, 1, 0, 0.05);">
                                    <div class="d-flex flex-wrap justify-content-between align-items-start pb-3 border-bottom mb-3 gap-2" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                        <div>
                                            <span class="badge-status-gold font-monospace fs-6 px-3 py-1 rounded-pill fw-bold">
                                                #${ord.orderId}
                                            </span>
                                            <span class="ms-2 small text-muted">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1">person</span> Customer: <strong>${ord.customerId}</strong>
                                            </span>
                                            <span class="ms-2 badge bg-light text-dark border px-2 py-1 rounded-pill small">
                                                <c:choose>
                                                    <c:when test="${ord['class'].simpleName == 'DeliveryOrder'}">
                                                        <span class="material-symbols-outlined fs-6 align-middle text-primary me-1">local_shipping</span> Delivery
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="material-symbols-outlined fs-6 align-middle text-primary me-1">storefront</span> Counter Pickup
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="d-flex align-items-center gap-2">
                                            <c:choose>
                                                <c:when test="${ord.status == 'Pending'}">
                                                    <span class="badge badge-status-warning px-3 py-1 rounded-pill small">Pending</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Confirmed'}">
                                                    <span class="badge badge-status-info px-3 py-1 rounded-pill small">Confirmed</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Baking'}">
                                                    <span class="badge badge-status-gold px-3 py-1 rounded-pill small">Baking</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Out for Delivery'}">
                                                    <span class="badge badge-status-gold px-3 py-1 rounded-pill small">Out for Delivery</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Completed'}">
                                                    <span class="badge badge-status-success px-3 py-1 rounded-pill small">Completed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-status-danger px-3 py-1 rounded-pill small">${ord.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Delivery Address (if applicable) -->
                                    <c:if test="${ord['class'].simpleName == 'DeliveryOrder'}">
                                        <div class="small text-muted mb-3 d-flex align-items-center gap-1">
                                            <span class="material-symbols-outlined fs-6 text-danger">location_on</span>
                                            <span>Destination: <strong>${ord.deliveryAddress}</strong></span>
                                        </div>
                                    </c:if>

                                    <!-- Items Breakdown -->
                                    <div class="table-responsive mb-3 border-0">
                                        <table class="table table-sm align-middle mb-0">
                                            <thead style="background-color: #faf7f2; color: var(--maple-dark-900, #070100);">
                                                <tr>
                                                    <th class="ps-2 py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Pastry / Catalogue Item</th>
                                                    <th class="text-center py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Quantity</th>
                                                    <th class="text-end py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Unit Price</th>
                                                    <th class="text-end pe-2 py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Subtotal</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${ord.items}">
                                                    <tr style="border-bottom: 1px solid rgba(43, 24, 16, 0.05);">
                                                        <td class="fw-semibold text-dark small ps-2 py-2">
                                                            ${item.productName}
                                                            <c:if test="${ord.status == 'Completed' && item.productId != null}">
                                                                <a href="${pageContext.request.contextPath}/viewReviews?productId=${item.productId}#writeReviewSection" class="text-decoration-none ms-2 badge badge-status-gold" style="font-size: 0.65rem;" title="Review this item">
                                                                    <span class="material-symbols-outlined fs-6 align-middle">rate_review</span> Review
                                                                </a>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-center small py-2">${item.quantity}</td>
                                                        <td class="text-end small py-2">Rs. <fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2"/></td>
                                                        <td class="text-end pe-2 fw-bold font-playfair small py-2" style="color: var(--maple-dark-900, #070100);">
                                                            Rs. <fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Footer: Price Total and Action Buttons -->
                                    <div class="pt-3 border-top d-flex flex-wrap justify-content-between align-items-center gap-2" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                        <div>
                                            <span class="text-muted small text-uppercase" style="letter-spacing: 0.05em; font-size: 0.75rem;">Total Value:</span>
                                            <span class="fs-4 fw-bold font-playfair ms-2" style="color: var(--maple-gold-600, #6d411b);">
                                                Rs. <fmt:formatNumber value="${ord.calculateFinalTotal()}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </span>
                                        </div>

                                        <div class="d-flex align-items-center gap-2">
                                            <!-- Staff / Admin Status Update Form -->
                                            <c:if test="${isManagerView}">
                                                <form action="${pageContext.request.contextPath}/cancelOrder" method="post" class="d-inline-flex gap-1 align-items-center">
                                                    <input type="hidden" name="orderId" value="${ord.orderId}">
                                                    <select name="status" class="form-select form-select-sm form-control-maple" style="width: 140px; font-size: 0.8rem;" aria-label="Change order status">
                                                        <option value="Pending" ${ord.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="Confirmed" ${ord.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                        <option value="Baking" ${ord.status == 'Baking' ? 'selected' : ''}>Baking</option>
                                                        <option value="Out for Delivery" ${ord.status == 'Out for Delivery' ? 'selected' : ''}>Out for Delivery</option>
                                                        <option value="Completed" ${ord.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                        <option value="Cancelled" ${ord.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-sm btn-maple-primary rounded-2 px-2 py-1" title="Update Order Status" aria-label="Submit status change">
                                                        <span class="material-symbols-outlined fs-6">check</span>
                                                    </button>
                                                </form>
                                            </c:if>

                                            <!-- Customer Cancel Button (only if Pending) -->
                                            <c:if test="${ord.status == 'Pending'}">
                                                <form action="${pageContext.request.contextPath}/cancelOrder" method="post" onsubmit="return confirm('Are you sure you want to cancel order ${ord.orderId}?');">
                                                    <input type="hidden" name="orderId" value="${ord.orderId}">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-3 py-1 d-inline-flex align-items-center gap-1">
                                                        <span class="material-symbols-outlined fs-6">cancel</span> Cancel Order
                                                    </button>
                                                </form>
                                            </c:if>

                                            <a href="${pageContext.request.contextPath}/orderSuccess?orderId=${ord.orderId}" class="btn btn-sm btn-maple-secondary rounded-2 px-3 py-1 d-inline-flex align-items-center gap-1">
                                                <span class="material-symbols-outlined fs-6">receipt</span> View Receipt
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Client-side Zero Matches Empty State -->
                    <div class="col-12 text-center py-5 d-none" id="clientSideNoOrders">
                        <div class="card card-maple maple-empty-state shadow-sm mx-auto p-5 border-0" style="max-width: 500px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                            <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                                <span class="material-symbols-outlined fs-1">search_off</span>
                            </div>
                            <h3 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Matching Orders</h3>
                            <p class="text-muted small mb-4">No bakery orders matched your selected status filter or search keyword.</p>
                            <button type="button" class="btn btn-maple-secondary d-inline-flex align-items-center justify-content-center gap-1 mx-auto" onclick="resetOrderFilters()">
                                <span class="material-symbols-outlined fs-5">filter_alt_off</span> Reset Filters
                            </button>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty State -->
                    <div class="text-center py-5">
                        <div class="card card-maple maple-empty-state shadow-sm mx-auto p-5 border-0" style="max-width: 500px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                            <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                                <span class="material-symbols-outlined fs-1">receipt_long</span>
                            </div>
                            <h3 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Orders Recorded</h3>
                            <p class="text-muted small mb-4">No bakery orders have been recorded in your purchase history yet.</p>
                            <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                                <span class="material-symbols-outlined fs-5">storefront</span> Explore Bakery Menu
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

                        </main>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <main id="main-content" class="mc-admin-main-body p-4 p-md-5">

            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Menu</a></li>
                    <li class="breadcrumb-item active text-muted" aria-current="page">Order History</li>
                </ol>
            </nav>

            <!-- Page Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                <div>
                    <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                        <c:choose>
                            <c:when test="${isManagerView}">Bakery Orders Management Console</c:when>
                            <c:otherwise>My Bakery Orders</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="text-muted small mb-0">
                        <c:choose>
                            <c:when test="${isManagerView}">Review active customer orders, update delivery dispatch, and track bakery fulfillment</c:when>
                            <c:otherwise>Track freshly baked orders, delivery statuses, and view previous purchase receipts</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="mt-3 mt-sm-0 d-flex gap-2">
                    <c:if test="${isManagerView}">
                        <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="btn btn-maple-secondary btn-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                            <span class="material-symbols-outlined fs-6">dashboard</span> Dashboard
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary shadow-sm btn-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                        <span class="material-symbols-outlined fs-6">storefront</span> Order Bakery Treats
                    </a>
                </div>
            </div>

            <!-- Feedback Alerts -->
            <c:if test="${param.msg == 'cancelled'}">
                <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #eff6ff; color: #1e40af;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-primary flex-shrink-0">info</span>
                    <div class="small fw-medium">The order was successfully cancelled and any simulated charges were marked refunded.</div>
                </div>
            </c:if>

            <c:if test="${param.msg == 'statusUpdated'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-success flex-shrink-0">check_circle</span>
                    <div class="small fw-medium">Order status was successfully updated in the database registry.</div>
                </div>
            </c:if>

            <c:if test="${param.error == 'unauthorized'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">shield_lock</span>
                    <div class="small fw-medium">You are not authorized to perform actions on this order.</div>
                </div>
            </c:if>

            <!-- Search and Filter Bar -->
            <div class="row g-3 align-items-center justify-content-between mb-4">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">
                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                        </span>
                        <input type="text" id="orderSearchInput" class="form-control form-control-maple border-start-0 ps-1" placeholder="Search orders by code, items, or status..." onkeyup="filterOrders()" aria-label="Search orders" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                    </div>
                </div>
                <div class="col-auto d-flex flex-wrap gap-2" role="group" aria-label="Filter Orders by Status">
                    <button type="button" class="btn btn-sm btn-maple-primary rounded-pill px-3 active" aria-pressed="true" id="orderFilterAll" onclick="setOrderStatusFilter('ALL', this)">All</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterPending" onclick="setOrderStatusFilter('Pending', this)">Pending</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterProcessing" onclick="setOrderStatusFilter('Processing', this)">Processing</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterCompleted" onclick="setOrderStatusFilter('Completed', this)">Completed</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="orderFilterCancelled" onclick="setOrderStatusFilter('Cancelled', this)">Cancelled</button>
                </div>
            </div>

            <!-- Orders Listing -->
            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="row g-4" id="ordersContainer">
                        <c:forEach var="ord" items="${orders}">
                            <div class="col-12 order-card-item" data-status="${ord.status}">
                                <div class="card card-maple shadow-sm p-4 border-0" style="background: #ffffff; border-radius: var(--radius-xl, 16px); box-shadow: 0 6px 24px rgba(7, 1, 0, 0.05);">
                                    <div class="d-flex flex-wrap justify-content-between align-items-start pb-3 border-bottom mb-3 gap-2" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                        <div>
                                            <span class="badge-status-gold font-monospace fs-6 px-3 py-1 rounded-pill fw-bold">
                                                #${ord.orderId}
                                            </span>
                                            <span class="ms-2 small text-muted">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1">person</span> Customer: <strong>${ord.customerId}</strong>
                                            </span>
                                            <span class="ms-2 badge bg-light text-dark border px-2 py-1 rounded-pill small">
                                                <c:choose>
                                                    <c:when test="${ord['class'].simpleName == 'DeliveryOrder'}">
                                                        <span class="material-symbols-outlined fs-6 align-middle text-primary me-1">local_shipping</span> Delivery
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="material-symbols-outlined fs-6 align-middle text-primary me-1">storefront</span> Counter Pickup
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="d-flex align-items-center gap-2">
                                            <c:choose>
                                                <c:when test="${ord.status == 'Pending'}">
                                                    <span class="badge badge-status-warning px-3 py-1 rounded-pill small">Pending</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Confirmed'}">
                                                    <span class="badge badge-status-info px-3 py-1 rounded-pill small">Confirmed</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Baking'}">
                                                    <span class="badge badge-status-gold px-3 py-1 rounded-pill small">Baking</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Out for Delivery'}">
                                                    <span class="badge badge-status-gold px-3 py-1 rounded-pill small">Out for Delivery</span>
                                                </c:when>
                                                <c:when test="${ord.status == 'Completed'}">
                                                    <span class="badge badge-status-success px-3 py-1 rounded-pill small">Completed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-status-danger px-3 py-1 rounded-pill small">${ord.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Delivery Address (if applicable) -->
                                    <c:if test="${ord['class'].simpleName == 'DeliveryOrder'}">
                                        <div class="small text-muted mb-3 d-flex align-items-center gap-1">
                                            <span class="material-symbols-outlined fs-6 text-danger">location_on</span>
                                            <span>Destination: <strong>${ord.deliveryAddress}</strong></span>
                                        </div>
                                    </c:if>

                                    <!-- Items Breakdown -->
                                    <div class="table-responsive mb-3 border-0">
                                        <table class="table table-sm align-middle mb-0">
                                            <thead style="background-color: #faf7f2; color: var(--maple-dark-900, #070100);">
                                                <tr>
                                                    <th class="ps-2 py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Pastry / Catalogue Item</th>
                                                    <th class="text-center py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Quantity</th>
                                                    <th class="text-end py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Unit Price</th>
                                                    <th class="text-end pe-2 py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Subtotal</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${ord.items}">
                                                    <tr style="border-bottom: 1px solid rgba(43, 24, 16, 0.05);">
                                                        <td class="fw-semibold text-dark small ps-2 py-2">
                                                            ${item.productName}
                                                            <c:if test="${ord.status == 'Completed' && item.productId != null}">
                                                                <a href="${pageContext.request.contextPath}/viewReviews?productId=${item.productId}#writeReviewSection" class="text-decoration-none ms-2 badge badge-status-gold" style="font-size: 0.65rem;" title="Review this item">
                                                                    <span class="material-symbols-outlined fs-6 align-middle">rate_review</span> Review
                                                                </a>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-center small py-2">${item.quantity}</td>
                                                        <td class="text-end small py-2">Rs. <fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2"/></td>
                                                        <td class="text-end pe-2 fw-bold font-playfair small py-2" style="color: var(--maple-dark-900, #070100);">
                                                            Rs. <fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Footer: Price Total and Action Buttons -->
                                    <div class="pt-3 border-top d-flex flex-wrap justify-content-between align-items-center gap-2" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                        <div>
                                            <span class="text-muted small text-uppercase" style="letter-spacing: 0.05em; font-size: 0.75rem;">Total Value:</span>
                                            <span class="fs-4 fw-bold font-playfair ms-2" style="color: var(--maple-gold-600, #6d411b);">
                                                Rs. <fmt:formatNumber value="${ord.calculateFinalTotal()}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </span>
                                        </div>

                                        <div class="d-flex align-items-center gap-2">
                                            <!-- Staff / Admin Status Update Form -->
                                            <c:if test="${isManagerView}">
                                                <form action="${pageContext.request.contextPath}/cancelOrder" method="post" class="d-inline-flex gap-1 align-items-center">
                                                    <input type="hidden" name="orderId" value="${ord.orderId}">
                                                    <select name="status" class="form-select form-select-sm form-control-maple" style="width: 140px; font-size: 0.8rem;" aria-label="Change order status">
                                                        <option value="Pending" ${ord.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="Confirmed" ${ord.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                        <option value="Baking" ${ord.status == 'Baking' ? 'selected' : ''}>Baking</option>
                                                        <option value="Out for Delivery" ${ord.status == 'Out for Delivery' ? 'selected' : ''}>Out for Delivery</option>
                                                        <option value="Completed" ${ord.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                        <option value="Cancelled" ${ord.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-sm btn-maple-primary rounded-2 px-2 py-1" title="Update Order Status" aria-label="Submit status change">
                                                        <span class="material-symbols-outlined fs-6">check</span>
                                                    </button>
                                                </form>
                                            </c:if>

                                            <!-- Customer Cancel Button (only if Pending) -->
                                            <c:if test="${ord.status == 'Pending'}">
                                                <form action="${pageContext.request.contextPath}/cancelOrder" method="post" onsubmit="return confirm('Are you sure you want to cancel order ${ord.orderId}?');">
                                                    <input type="hidden" name="orderId" value="${ord.orderId}">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-3 py-1 d-inline-flex align-items-center gap-1">
                                                        <span class="material-symbols-outlined fs-6">cancel</span> Cancel Order
                                                    </button>
                                                </form>
                                            </c:if>

                                            <a href="${pageContext.request.contextPath}/orderSuccess?orderId=${ord.orderId}" class="btn btn-sm btn-maple-secondary rounded-2 px-3 py-1 d-inline-flex align-items-center gap-1">
                                                <span class="material-symbols-outlined fs-6">receipt</span> View Receipt
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Client-side Zero Matches Empty State -->
                    <div class="col-12 text-center py-5 d-none" id="clientSideNoOrders">
                        <div class="card card-maple maple-empty-state shadow-sm mx-auto p-5 border-0" style="max-width: 500px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                            <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                                <span class="material-symbols-outlined fs-1">search_off</span>
                            </div>
                            <h3 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Matching Orders</h3>
                            <p class="text-muted small mb-4">No bakery orders matched your selected status filter or search keyword.</p>
                            <button type="button" class="btn btn-maple-secondary d-inline-flex align-items-center justify-content-center gap-1 mx-auto" onclick="resetOrderFilters()">
                                <span class="material-symbols-outlined fs-5">filter_alt_off</span> Reset Filters
                            </button>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty State -->
                    <div class="text-center py-5">
                        <div class="card card-maple maple-empty-state shadow-sm mx-auto p-5 border-0" style="max-width: 500px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                            <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                                <span class="material-symbols-outlined fs-1">receipt_long</span>
                            </div>
                            <h3 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Orders Recorded</h3>
                            <p class="text-muted small mb-4">No bakery orders have been recorded in your purchase history yet.</p>
                            <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                                <span class="material-symbols-outlined fs-5">storefront</span> Explore Bakery Menu
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

                </main>
            </c:otherwise>
        </c:choose>
</c:when>
        <c:otherwise>
            <!-- Unauthorized Guard -->
            <div class="text-center py-5">
                <div class="card card-maple shadow-sm mx-auto p-5 border-0" style="max-width: 480px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                    <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                        <span class="material-symbols-outlined fs-1">shield_lock</span>
                    </div>
                    <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Sign In Required</h3>
                    <p class="text-muted small mb-4">You must be signed in to view your order history and live tracking details.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=myOrders" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In Now
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
