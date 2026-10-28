<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seasonal Promotions &amp; Vouchers — Maple &amp; Crumb</title>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body class="d-flex flex-column min-vh-100" style="background-color: var(--maple-cream-50, #fdfbf7);">
<%
    if (request.getAttribute("activePromotions") == null) {
        com.mapleandcrumb.dao.comp06.PromotionDAO promoDao = new com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl();
        request.setAttribute("activePromotions", promoDao.getAllActivePromotions());
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main id="main-content" class="container my-4 my-md-5 flex-grow-1">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Menu</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Promotions</li>
        </ol>
    </nav>

    <!-- Header Banner -->
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom maple-section-divider">
        <div>
            <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                <span class="material-symbols-outlined fs-6">local_offer</span> Seasonal Privileges &amp; Savings
            </div>
            <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                Promotions &amp; Exclusive Bakery Vouchers
            </h1>
            <p class="text-muted small mb-0">Claim seasonal promotional codes for instant savings during checkout on handcrafted pastries, sourdoughs, and celebration cakes.</p>
        </div>
        <div class="mt-3 mt-sm-0">
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-2">
                <span class="material-symbols-outlined fs-5">storefront</span> Explore Catalogue
            </a>
        </div>
    </div>

    <!-- Active Promotions Grid -->
    <div class="row g-4 mb-5">
        <c:choose>
            <c:when test="${not empty activePromotions}">
                <c:forEach var="p" items="${activePromotions}">
                    <div class="col-12 col-md-6 col-lg-4">
                        <div class="voucher-card p-4 h-100 d-flex flex-column justify-content-between shadow-sm">
                            <div>
                                <!-- Top Row: Discount Value & Badge -->
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <c:choose>
                                            <c:when test="${p.getClass().simpleName == 'PercentageDiscount'}">
                                                <span class="badge badge-status-danger px-3 py-1 rounded-pill fw-bold text-uppercase" style="font-size: 0.75rem;">
                                                    <fmt:formatNumber value="${p.percentage}" maxFractionDigits="0"/>% OFF
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-status-gold px-3 py-1 rounded-pill fw-bold text-uppercase" style="font-size: 0.75rem;">
                                                    Rs. <fmt:formatNumber value="${p.fixedAmount}" minFractionDigits="2"/> OFF
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <span class="badge badge-status-success px-2 py-1 rounded-pill small d-inline-flex align-items-center gap-1" style="font-size: 0.68rem;">
                                        <span class="material-symbols-outlined fs-6">check_circle</span> Active
                                    </span>
                                </div>

                                <!-- Title / Description -->
                                <h4 class="font-playfair text-dark mb-2 fs-5 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">
                                    ${p.description}
                                </h4>

                                <!-- Expiry Date -->
                                <div class="text-muted smaller mb-4 d-flex align-items-center gap-1" style="font-size: 0.78rem;">
                                    <span class="material-symbols-outlined fs-6" style="color: var(--maple-gold-600, #6d411b);">event_available</span>
                                    Valid until: <strong class="text-dark">${p.expiryDate}</strong>
                                </div>
                            </div>

                            <!-- Bottom Row: Voucher Code with Copy Button -->
                            <div class="pt-3 border-top" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                <div class="d-flex align-items-center justify-content-between gap-2">
                                    <div class="voucher-pill px-3 py-2 rounded-2 fw-bold text-dark fs-6 text-uppercase flex-grow-1 text-center user-select-all">
                                        ${p.promoCode}
                                    </div>
                                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-2 px-3 py-2 d-inline-flex align-items-center gap-1" onclick="copyToClipboard('${p.promoCode}', 'Voucher Code')" title="Copy to clipboard">
                                        <span class="material-symbols-outlined fs-6">content_copy</span> Copy
                                    </button>
                                </div>
                                <div class="mt-2 text-center">
                                    <a href="${pageContext.request.contextPath}/checkout?promoCode=${p.promoCode}" class="text-decoration-none smaller fw-semibold d-inline-flex align-items-center gap-1" style="color: var(--maple-gold-600, #6d411b); font-size: 0.75rem;">
                                        Apply to checkout &rarr;
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="col-12 text-center py-5">
                    <div class="card card-maple maple-panel-card maple-empty-state p-5 mx-auto border-0 shadow-sm" style="max-width: 480px;">
                        <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                            <span class="material-symbols-outlined fs-1">local_offer</span>
                        </div>
                        <h4 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Active Vouchers</h4>
                        <p class="text-muted small mb-4">Check back soon for upcoming holiday promotions and seasonal celebratory privileges.</p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                            <span class="material-symbols-outlined fs-5">storefront</span> Browse Menu
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 3-Step Redemption Guide -->
    <div class="card card-maple maple-panel-card p-4 p-md-5 border-0 shadow-sm">
        <div class="text-center max-w-2xl mx-auto mb-4">
            <span class="badge-status-gold px-3 py-1 rounded-pill small text-uppercase" style="font-size: 0.7rem; letter-spacing: 0.08em;">Simple Redemption</span>
            <h3 class="font-playfair text-dark fs-3 fw-bold mt-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">How to Use Your Voucher</h3>
            <p class="text-muted small">Redeeming a promotional voucher code is effortless and automatic.</p>
        </div>

        <div class="row g-4 text-center">
            <div class="col-md-4">
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 54px; height: 54px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-600, #6d411b);">
                    <span class="material-symbols-outlined fs-3">content_copy</span>
                </div>
                <h5 class="fw-bold font-playfair fs-5 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">1. Copy Voucher Code</h5>
                <p class="text-muted small">Click the Copy button on any active campaign above to save it to your clipboard.</p>
            </div>
            <div class="col-md-4">
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 54px; height: 54px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-600, #6d411b);">
                    <span class="material-symbols-outlined fs-3">shopping_basket</span>
                </div>
                <h5 class="fw-bold font-playfair fs-5 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">2. Fill Your Basket</h5>
                <p class="text-muted small">Add your preferred pastries, rustic loaves, or bespoke cake bookings to your cart.</p>
            </div>
            <div class="col-md-4">
                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 54px; height: 54px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-600, #6d411b);">
                    <span class="material-symbols-outlined fs-3">redeem</span>
                </div>
                <h5 class="fw-bold font-playfair fs-5 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">3. Apply at Checkout</h5>
                <p class="text-muted small">Paste the voucher code during checkout to immediately deduct your savings.</p>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>

