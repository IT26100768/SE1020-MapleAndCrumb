<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed â€” Maple &amp; Crumb</title>
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
    <!-- Maple & Crumb Global Stylesheet Suite -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <!-- Orders & Checkout Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/checkout.css">
</head>
<body class="d-flex flex-column min-vh-100" style="background-color: var(--maple-cream-50, #fdfbf7);">
<%
    if (request.getAttribute("order") == null) {
        String ordId = request.getParameter("orderId");
        if (ordId != null && !ordId.trim().isEmpty()) {
            com.mapleandcrumb.dao.comp04.OrderDAO oDao = new com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl();
            com.mapleandcrumb.model.comp04.Order ord = oDao.getOrderById(ordId.trim());
            if (ord != null) {
                request.setAttribute("order", ord);
                request.setAttribute("paymentMethod", oDao.getPaymentMethod(ordId.trim()));
            }
        }
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main id="main-content" class="container my-4 my-md-5 flex-grow-1">
    <c:choose>
        <c:when test="${not empty order}">
            <div class="row justify-content-center">
                <div class="col-lg-9 col-xl-8">
                    <!-- Success Header Card -->
                    <div class="card card-maple maple-panel-card text-center p-4 p-md-5 mb-4 shadow-sm border-0">
                        <div class="maple-icon-circle-lg mx-auto mb-3 shadow-sm" aria-hidden="true">
                            <span class="material-symbols-outlined fs-1">verified</span>
                        </div>
                        <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2 small mx-auto" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                            <span class="material-symbols-outlined fs-6">task_alt</span> Order Placed &amp; Confirmed
                        </div>
                        <h1 class="font-playfair text-dark fs-2 mb-2 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">
                            Thank You for Your Order!
                        </h1>
                        <p class="text-muted small mb-4 mx-auto" style="max-width: 520px; line-height: 1.6;">
                            We have received your bakery order and our kitchen team is already preparing to bake your treats with organic butter, raw sugars, and slow-milled heritage grains.
                        </p>
                        <div class="d-inline-block rounded-pill px-4 py-2 font-monospace fw-bold fs-6" style="background-color: #faf7f2; border: 1px solid rgba(134,82,37,0.2); color: var(--maple-dark-900, #070100);">
                            Order Reference: <span style="color: var(--maple-gold-600, #6d411b);">#${order.orderId}</span>
                        </div>
                    </div>

                    <!-- Order Details Card -->
                    <div class="card card-maple maple-panel-card p-4 p-md-5 mb-4 shadow-sm border-0">
                        <h5 class="font-playfair text-dark mb-4 pb-3 border-bottom maple-section-divider fs-5 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Fulfillment &amp; Receipt Summary</h5>

                        <div class="row g-3 mb-4">
                            <div class="col-sm-6">
                                <span class="smaller text-muted text-uppercase fw-semibold d-block" style="font-size: 0.7rem; letter-spacing: 0.05em;">Fulfillment Type</span>
                                <strong class="fs-6 text-dark d-inline-flex align-items-center gap-1 mt-1">
                                    <c:choose>
                                        <c:when test="${order['class'].simpleName == 'DeliveryOrder'}">
                                            <span class="material-symbols-outlined fs-5 text-primary">local_shipping</span> Doorstep Delivery
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">storefront</span> Bakery Counter Pickup
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>
                            <div class="col-sm-6 text-sm-end">
                                <span class="smaller text-muted text-uppercase fw-semibold d-block" style="font-size: 0.7rem; letter-spacing: 0.05em;">Current Status</span>
                                <span class="badge badge-status-warning px-3 py-1 rounded-pill mt-1">
                                    ${order.status}
                                </span>
                            </div>
                            <c:if test="${order['class'].simpleName == 'DeliveryOrder'}">
                                <div class="col-12">
                                    <div class="p-3 rounded-3 border small d-flex align-items-center gap-2" style="background-color: #faf7f2; border-color: rgba(134,82,37,0.15) !important;">
                                        <span class="material-symbols-outlined fs-5 text-danger">location_on</span>
                                        <div><strong>Delivery Address:</strong> ${order.deliveryAddress}</div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Itemized Products Table -->
                        <h6 class="font-playfair text-dark mb-2 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">Items Handcrafted in Order:</h6>
                        <div class="table-responsive mb-3 border-0">
                            <table class="table table-sm align-middle mb-0">
                                <thead style="background-color: #faf7f2;">
                                    <tr>
                                        <th class="ps-2 py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase;">Item</th>
                                        <th class="text-center py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase;">Qty</th>
                                        <th class="text-end py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase;">Price</th>
                                        <th class="text-end pe-2 py-2" style="font-size: 0.72rem; letter-spacing: 0.06em; text-transform: uppercase;">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${order.items}">
                                        <tr style="border-bottom: 1px solid rgba(43, 24, 16, 0.05);">
                                            <td class="fw-semibold text-dark small ps-2 py-2">${item.productName}</td>
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

                        <!-- Total Summary -->
                        <div class="row justify-content-end">
                            <div class="col-md-6 col-lg-5">
                                <div class="p-3 rounded-3" style="background-color: #faf7f2; border: 1px solid rgba(134,82,37,0.15);">
                                    <c:if test="${order['class'].simpleName == 'DeliveryOrder'}">
                                        <div class="d-flex justify-content-between mb-1 small text-muted">
                                            <span>Delivery Fee:</span>
                                            <span>Rs. 500.00</span>
                                        </div>
                                    </c:if>
                                    <div class="d-flex justify-content-between align-items-center pt-2 border-top" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                        <span class="fw-bold font-playfair">Total Settled:</span>
                                        <span class="fs-4 fw-bold font-playfair" style="color: var(--maple-gold-600, #6d411b);">
                                            Rs. <fmt:formatNumber value="${order.calculateFinalTotal()}" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Payment Method Badge -->
                        <div class="mt-4 pt-3 border-top d-flex flex-wrap align-items-center justify-content-between gap-2" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                            <div class="small text-muted d-flex align-items-center gap-2">
                                <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">credit_card</span>
                                <span>Payment Mode: <strong>${not empty paymentMethod ? paymentMethod : 'Card / Counter Payment'}</strong></span>
                                <span class="badge badge-status-success ms-1 small">Cleared</span>
                            </div>
                            <div class="smaller text-muted d-flex align-items-center gap-1">
                                <span class="material-symbols-outlined fs-6 text-muted">history</span> Transaction logged in bakery registry
                            </div>
                        </div>
                    </div>

                    <!-- Action Controls -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 btn-no-print">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-secondary rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                            <span class="material-symbols-outlined fs-6">arrow_back</span> Return to Menu
                        </a>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-maple-secondary rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1" onclick="window.print()">
                                <span class="material-symbols-outlined fs-6">print</span> Print Receipt
                            </button>
                            <a href="${pageContext.request.contextPath}/myOrders" class="btn btn-maple-primary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                                <span class="material-symbols-outlined fs-6">receipt_long</span> View Order History
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Order Not Found -->
            <div class="text-center py-5">
                <div class="card card-maple maple-empty-state shadow-sm mx-auto p-5 border-0" style="max-width: 500px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                    <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: #dc2626;">
                        <span class="material-symbols-outlined fs-1">error</span>
                    </div>
                    <h3 class="font-playfair text-dark fs-4 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Order Not Found</h3>
                    <p class="text-muted small mb-4">We could not locate the requested order in our bakery registry.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">storefront</span> Browse Bakery Menu
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>

