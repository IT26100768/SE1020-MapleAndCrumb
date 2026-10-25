<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.util.List, java.util.ArrayList, com.mapleandcrumb.model.comp04.OrderItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout &amp; Place Order — Maple &amp; Crumb</title>
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
    @SuppressWarnings("unchecked")
    List<OrderItem> cart = (List<OrderItem>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
        session.setAttribute("cart", cart);
    }
    double subtotal = 0;
    for (OrderItem it : cart) {
        subtotal += it.getSubtotal();
    }
    Double appliedDisc = (Double) session.getAttribute("appliedDiscount");
    double discountVal = (appliedDisc != null) ? appliedDisc : 0.0;
    double finalSubtotal = Math.max(0.0, subtotal - discountVal);
    request.setAttribute("cartSubtotal", subtotal);
    request.setAttribute("appliedDiscount", discountVal);
    request.setAttribute("discountedSubtotal", finalSubtotal);
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main id="main-content" class="container my-4 my-md-5 flex-grow-1">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Menu</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Checkout</li>
        </ol>
    </nav>

    <!-- Header -->
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom maple-section-divider">
        <div>
            <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                Bakery Order Checkout
            </h1>
            <p class="text-muted small mb-0">Review selected baked treats, select fulfillment option &amp; complete payment</p>
        </div>
        <div class="mt-3 mt-sm-0">
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-secondary btn-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                <span class="material-symbols-outlined fs-6">add_shopping_cart</span> Add More Items
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
            <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm" class="needs-validation" onsubmit="return handleFormSubmit(event)" novalidate>
                <div class="row g-4">
                    <!-- Left Column: Fulfillment, Customer Details & Payment Options -->
                    <div class="col-lg-7 col-xl-8">

                        <!-- Step 1: Fulfillment Type -->
                        <div class="card card-maple maple-panel-card mb-4 shadow-sm p-4 p-md-5 border-0">
                            <h5 class="font-playfair text-dark mb-4 fs-5 fw-bold d-flex align-items-center" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">
                                <span class="maple-step-badge me-3">1</span>
                                Fulfillment Method
                            </h5>

                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <div class="p-3 rounded-3 h-100 transition-all maple-selectable-card active" id="pickupOptionWrapper" onclick="selectOrderType('Pickup')">
                                        <div class="d-flex align-items-center justify-content-between mb-1">
                                            <div class="d-flex align-items-center gap-2">
                                                <input class="form-check-input mt-0" type="radio" name="orderType" id="orderTypePickup" value="Pickup" checked onchange="updateFulfillment()">
                                                <label class="form-check-label fw-bold small text-dark mb-0" for="orderTypePickup" style="cursor: pointer;">
                                                    <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-600, #6d411b);">storefront</span> Bakery Counter Pickup
                                                </label>
                                            </div>
                                            <span id="pickupSelectedBadge" class="badge rounded-pill text-white selected-pill small px-2 py-0.5" style="background-color: var(--maple-gold-600, #865225); font-size: 0.7rem;">Selected</span>
                                        </div>
                                        <div class="small text-muted ps-4">Collect freshly boxed pastries at our bakery counter. <strong class="text-success">Free</strong></div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="p-3 rounded-3 h-100 transition-all maple-selectable-card" id="deliveryOptionWrapper" onclick="selectOrderType('Delivery')">
                                        <div class="d-flex align-items-center justify-content-between mb-1">
                                            <div class="d-flex align-items-center gap-2">
                                                <input class="form-check-input mt-0" type="radio" name="orderType" id="orderTypeDelivery" value="Delivery" onchange="updateFulfillment()">
                                                <label class="form-check-label fw-bold small text-dark mb-0" for="orderTypeDelivery" style="cursor: pointer;">
                                                    <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-600, #6d411b);">local_shipping</span> Doorstep Delivery
                                                </label>
                                            </div>
                                            <span id="deliverySelectedBadge" class="badge rounded-pill text-white selected-pill small px-2 py-0.5 d-none" style="background-color: var(--maple-gold-600, #865225); font-size: 0.7rem; display: none;">Selected</span>
                                        </div>
                                        <div class="small text-muted ps-4">Delivered warm by local courier. <strong style="color: var(--maple-gold-600, #6d411b);">+Rs. 500.00 flat fee</strong></div>
                                    </div>
                                </div>
                            </div>

                            <div id="deliveryAddressSection" class="d-none mt-3 p-3 rounded-3" style="background-color: #faf7f2; border: 1px dashed rgba(134,82,37,0.2);">
                                <label for="deliveryAddressInput" class="form-label fw-semibold small" style="color: var(--maple-dark-800, #2b1810);">Delivery Street Address &amp; Unit <span class="text-danger">*</span></label>
                                <textarea id="deliveryAddressInput" name="deliveryAddress" class="form-control form-control-maple" rows="2" placeholder="e.g. 142 Elmwood Street, Suite 4B, Colombo 03"></textarea>
                                <div class="invalid-feedback">Please provide your delivery street address.</div>
                                <div class="form-text small text-muted">Orders are freshly dispatched in temperature-controlled pastry boxes.</div>
                            </div>
                        </div>

                        <!-- Step 2: Contact Details -->
                        <div class="card card-maple maple-panel-card mb-4 shadow-sm p-4 p-md-5 border-0">
                            <h5 class="font-playfair text-dark mb-4 fs-5 fw-bold d-flex align-items-center" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">
                                <span class="maple-step-badge me-3">2</span>
                                Customer Contact Information
                            </h5>

                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedInUser}">
                                    <div class="alert alert-success d-flex align-items-center gap-3 mb-0 rounded-3 py-3 px-4 border-0" style="background-color: #ecfdf5; color: #065f46;">
                                        <span class="material-symbols-outlined fs-4 text-success flex-shrink-0">verified_user</span>
                                        <div class="small">
                                            Ordering as Customer: <strong>${sessionScope.loggedInUser.username}</strong> (${sessionScope.loggedInUser.email})
                                            <c:if test="${not empty sessionScope.loggedInUser.phone}">
                                                &bull; Phone: ${sessionScope.loggedInUser.phone}
                                            </c:if>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="custName" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Full Name <span class="text-danger">*</span></label>
                                            <input type="text" id="custName" name="customerName" class="form-control form-control-maple" required placeholder="e.g. Eleanor Vance">
                                            <div class="invalid-feedback">Full name is required.</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="custEmail" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Email Address <span class="text-danger">*</span></label>
                                            <input type="email" id="custEmail" name="customerEmail" class="form-control form-control-maple" required placeholder="eleanor@example.com">
                                            <div class="invalid-feedback">A valid email address is required.</div>
                                        </div>
                                        <div class="col-12">
                                            <label for="custPhone" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Contact Phone Number <span class="text-danger">*</span></label>
                                            <input type="tel" id="custPhone" name="customerPhone" class="form-control form-control-maple" required placeholder="+94 77 123 4567">
                                            <div class="invalid-feedback">Contact phone is required for collection and delivery notifications.</div>
                                        </div>
                                    </div>
                                    <div class="mt-3 text-muted small">
                                        Already registered? <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=checkout" class="fw-semibold text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Sign in to access your saved details</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Step 3: Payment Method -->
                        <div class="card card-maple maple-panel-card shadow-sm p-4 p-md-5 border-0">
                            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                                <h5 class="font-playfair text-dark mb-0 fs-5 fw-bold d-flex align-items-center" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">
                                    <span class="maple-step-badge me-3">3</span>
                                    Maple &amp; Crumb Payment
                                </h5>
                            </div>

                            <p class="text-muted small mb-3">Select your preferred payment option to complete your order:</p>

                            <!-- Payment Options Pills -->
                            <div class="row g-2 mb-4">
                                <div class="col-md-6">
                                    <div class="payment-method-card p-3 text-center active rounded-3 border" id="payMethodCard" onclick="selectPaymentMethod('CARD_SIMULATED')" style="cursor: pointer; transition: all 0.2s;">
                                        <span class="material-symbols-outlined fs-2 d-block mb-1" style="color: var(--maple-gold-600, #6d411b);">credit_card</span>
                                        <strong class="d-block small">Credit / Debit Card</strong>
                                        <span class="text-muted smaller" style="font-size: 0.72rem;">Safe &amp; secure processing</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="payment-method-card p-3 text-center rounded-3 border" id="payMethodCounter" onclick="selectPaymentMethod('COUNTER_CASH')" style="cursor: pointer; transition: all 0.2s;">
                                        <span class="material-symbols-outlined fs-2 d-block mb-1 text-success">payments</span>
                                        <strong class="d-block small">Pay at Counter / COD</strong>
                                        <span class="text-muted smaller" style="font-size: 0.72rem;">Pay on collection</span>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="CARD_SIMULATED">

                            <!-- Mock Card Visualizer Box -->
                            <div id="cardPaymentFields">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="cardNumber" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Card Number</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">credit_card</span></span>
                                            <input type="text" id="cardNumber" class="form-control form-control-maple border-start-0 ps-1" placeholder="4242 4242 4242 4242" value="4242 4242 4242 4242" maxlength="19" oninput="formatCardNumber(this)" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardHolder" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Name on Card</label>
                                        <input type="text" id="cardHolder" class="form-control form-control-maple" placeholder="e.g. ELEANOR VANCE" value="${sessionScope.loggedInUser.username}">
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <label for="cardExpiry" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Expiry (MM/YY)</label>
                                        <input type="text" id="cardExpiry" class="form-control form-control-maple" placeholder="12/28" value="12/28" maxlength="5">
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <label for="cardCvv" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">CVV</label>
                                        <input type="password" id="cardCvv" class="form-control form-control-maple" placeholder="123" value="123" maxlength="4">
                                    </div>
                                </div>
                            </div>

                            <!-- Counter Cash Note -->
                            <div id="counterCashFields" class="d-none">
                                <div class="alert alert-light border d-flex align-items-center gap-3 rounded-3 py-3 px-4" style="background-color: #faf7f2; border-color: rgba(134,82,37,0.2) !important;">
                                    <span class="material-symbols-outlined fs-3 text-success flex-shrink-0">payments</span>
                                    <div>
                                        <strong class="d-block text-dark">Pay Upon Collection / Delivery</strong>
                                        <span class="small text-muted">You can pay with cash, contactless mobile card, or debit card at our counter when collecting, or directly to your courier.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Cart Item Summary & Receipt -->
                    <div class="col-lg-5 col-xl-4">
                        <div class="card card-maple maple-panel-card order-summary-box p-4 border-0 shadow-sm" style="position: sticky; top: 100px;">
                            <h5 class="font-playfair text-dark mb-3 pb-2 border-bottom maple-section-divider fs-5 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Order Summary</h5>

                            <div class="table-responsive mb-3 border-0">
                                <table class="table table-sm align-middle mb-0">
                                    <tbody>
                                        <c:forEach var="item" items="${sessionScope.cart}">
                                            <tr class="border-bottom maple-section-divider">
                                                <td class="ps-0 py-2">
                                                    <div class="fw-semibold text-dark small">${item.productName}</div>
                                                    <div class="smaller text-muted">
                                                        Rs. <fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2"/> &times; ${item.quantity}
                                                    </div>
                                                </td>
                                                <td class="text-end pe-0 py-2">
                                                    <span class="fw-bold font-playfair small" style="color: var(--maple-dark-900, #070100);">
                                                        Rs. <fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/>
                                                    </span>
                                                    <a href="${pageContext.request.contextPath}/checkout?action=remove&productId=${item.productId}" class="text-danger ms-2 smaller text-decoration-none" title="Remove Item" aria-label="Remove ${item.productName}">
                                                        <span class="material-symbols-outlined fs-6 align-middle">delete</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Promo Code Voucher Entry (Comp 06 Synergy) -->
                            <div class="mb-3 pt-2">
                                <label class="form-label small fw-semibold text-muted text-uppercase" style="font-size: 0.7rem; letter-spacing: 0.05em;">Bakery Voucher / Promo Code</label>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.appliedPromoCode}">
                                        <div class="p-2 px-3 rounded-3 d-flex align-items-center justify-content-between border" style="background-color: #ecfdf5; border-color: #a7f3d0 !important;">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="material-symbols-outlined fs-5 text-success">check_circle</span>
                                                <div>
                                                    <span class="fw-bold text-success font-monospace small">${sessionScope.appliedPromoCode}</span>
                                                    <span class="text-muted smaller d-block" style="font-size: 0.7rem;">Discount applied</span>
                                                </div>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/checkout?action=removePromo" class="text-danger smaller text-decoration-none d-inline-flex align-items-center gap-1" title="Remove Voucher">
                                                <span class="material-symbols-outlined fs-6">close</span>
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="input-group">
                                            <input type="text" id="promoCodeInput" class="form-control form-control-sm form-control-maple text-uppercase font-monospace" placeholder="e.g. AUTUMN15" aria-label="Promo code">
                                            <button class="btn btn-sm btn-maple-secondary" type="button" onclick="applyPromoCode()">Apply</button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${param.msg == 'promoApplied'}">
                                    <span class="text-success smaller d-block mt-1" style="font-size: 0.72rem;"><span class="material-symbols-outlined fs-6 align-middle me-1">check</span>Voucher applied to your order!</span>
                                </c:if>
                                <c:if test="${param.msg == 'promoRemoved'}">
                                    <span class="text-muted smaller d-block mt-1" style="font-size: 0.72rem;">Voucher code was removed.</span>
                                </c:if>
                                <c:if test="${param.error == 'invalidPromo'}">
                                    <span class="text-danger smaller d-block mt-1" style="font-size: 0.72rem;"><span class="material-symbols-outlined fs-6 align-middle me-1">error</span>Invalid voucher code. <a href="${pageContext.request.contextPath}/comp06-reviews/promotions.jsp" class="text-danger fw-semibold">View active vouchers</a></span>
                                </c:if>
                                <c:if test="${param.error == 'promoExpired'}">
                                    <span class="text-danger smaller d-block mt-1" style="font-size: 0.72rem;"><span class="material-symbols-outlined fs-6 align-middle me-1">schedule</span>This promotional code has expired.</span>
                                </c:if>
                            </div>

                            <!-- Subtotal, Discount, Delivery Fee & Grand Total -->
                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Items Subtotal</span>
                                <span class="fw-semibold text-dark" id="displaySubtotal">
                                    Rs. <fmt:formatNumber value="${cartSubtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                            </div>

                            <c:if test="${not empty sessionScope.appliedPromoCode && appliedDiscount > 0}">
                                <div class="d-flex justify-content-between mb-2 small text-success">
                                    <span>Voucher (${sessionScope.appliedPromoCode})</span>
                                    <span class="fw-bold font-playfair" id="displayDiscount">
                                        -Rs. <fmt:formatNumber value="${appliedDiscount}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                </div>
                            </c:if>

                            <div class="d-flex justify-content-between mb-2 small text-muted">
                                <span>Delivery Fee</span>
                                <span class="fw-semibold text-dark" id="displayDeliveryFee">Rs. 0.00</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top maple-section-divider mt-2">
                                <span class="fw-bold font-playfair fs-5 text-dark">Grand Total</span>
                                <span class="fw-bold font-playfair fs-4" style="color: var(--maple-gold-600, #6d411b);" id="displayGrandTotal">
                                    Rs. <fmt:formatNumber value="${discountedSubtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                            </div>

                            <div class="mt-4">
                                <button type="submit" id="btnPlaceOrder" class="btn btn-maple-primary w-100 py-3 fw-bold shadow-sm d-inline-flex align-items-center justify-content-center gap-2" data-loading-text="Processing Payment...">
                                    <span class="material-symbols-outlined fs-5">lock</span> Place Order &amp; Pay
                                </button>
                            </div>

                            <div class="text-center mt-3 smaller text-muted d-flex align-items-center justify-content-center gap-1" style="font-size: 0.75rem;">
                                <span class="material-symbols-outlined fs-6 text-success">verified</span> Handcrafted freshness guaranteed from Maple &amp; Crumb
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </c:when>
        <c:otherwise>
            <!-- Empty Cart State -->
            <div class="text-center py-5">
                <div class="card card-maple maple-panel-card maple-empty-state shadow-sm mx-auto p-5 border-0" style="max-width: 500px;">
                    <div class="maple-icon-circle-lg mx-auto mb-3">
                        <span class="material-symbols-outlined fs-1">remove_shopping_cart</span>
                    </div>
                    <h3 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Your Basket is Empty</h3>
                    <p class="text-muted small mb-4">You haven't added any fresh baked treats to your order yet. Explore our handcrafted pastries, breads, and bespoke celebration cakes!</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">storefront</span> Browse Bakery Menu
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
<script>
    document.addEventListener('DOMContentLoaded', function() {
        MapleCheckout.init(${discountedSubtotal != null ? discountedSubtotal : 0.0});
        const promoInput = document.getElementById('promoCodeInput');
        if (promoInput) {
            promoInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    applyPromoCode();
                }
            });
        }
    });

    function applyPromoCode() {
        const input = document.getElementById('promoCodeInput');
        if (input && input.value.trim()) {
            window.location.href = '${pageContext.request.contextPath}/checkout?action=applyPromo&promoCode=' + encodeURIComponent(input.value.trim());
        }
    }
</script>
</body>
</html>
