<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Promotions — Maple &amp; Crumb</title>
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
    request.setAttribute("todayDate", java.time.LocalDate.now());
    if (request.getAttribute("promotions") == null) {
        com.mapleandcrumb.dao.comp06.PromotionDAO pDao = new com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl();
        java.util.List<com.mapleandcrumb.model.comp06.Promotion> all = pDao.getAllPromotions();
        java.time.LocalDate now = java.time.LocalDate.now();
        int active = 0;
        int expired = 0;
        for (com.mapleandcrumb.model.comp06.Promotion pr : all) {
            if (pr.getExpiryDate() != null && !pr.getExpiryDate().isBefore(now)) {
                active++;
            } else {
                expired++;
            }
        }
        request.setAttribute("promotions", all);
        request.setAttribute("totalPromotions", all.size());
        request.setAttribute("activeCount", active);
        request.setAttribute("expiredCount", expired);
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
        <div class="mc-admin-layout-wrapper">
            <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                <jsp:param name="activeTab" value="promotions" />
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
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Promotions &amp; Vouchers</li>
                            </ol>
                        </nav>
                    </div>
                </header>

                <main id="main-content" class="mc-admin-main-body p-4 p-md-5">
            <!-- Breadcrumb Navigation -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Operations Hub</a></li>
                    <li class="breadcrumb-item active text-muted" aria-current="page">Promotions Management</li>
                </ol>
            </nav>

            <!-- Page Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom maple-section-divider">
                <div>
                    <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                        <span class="material-symbols-outlined fs-6">campaign</span> Marketing &amp; Discount Vouchers
                    </div>
                    <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                        Promotions &amp; Voucher Console
                    </h1>
                    <p class="text-muted small mb-0">Oversee active campaigns, define percentage or fixed discounts, and retire expired vouchers.</p>
                </div>
                <div class="mt-3 mt-sm-0 d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="btn btn-maple-secondary btn-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                        <span class="material-symbols-outlined fs-6">dashboard</span> Dashboard
                    </a>
                    <a href="#newPromoSection" class="btn btn-maple-primary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">add_circle</span> Create Campaign
                    </a>
                </div>
            </div>

            <!-- Feedback Alerts -->
            <c:if test="${param.msg == 'created'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                    <div class="small fw-medium"><strong>Promotion published!</strong> The promotional voucher code is now active and ready for customer checkout.</div>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #eff6ff; color: #1e40af;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">info</span>
                    <div class="small fw-medium"><strong>Promotion removed.</strong> The voucher code was decommissioned from the database.</div>
                </div>
            </c:if>
            <c:if test="${param.error == 'missingFields'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                    <div class="small fw-medium"><strong>Incomplete form:</strong> Please enter a code, description, discount value, and valid expiry date.</div>
                </div>
            </c:if>
            <c:if test="${param.error == 'invalidValue'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                    <div class="small fw-medium"><strong>Invalid amount:</strong> Discount value must be greater than zero.</div>
                </div>
            </c:if>
            <c:if test="${param.error == 'percentageOverLimit'}">
                <div class="alert alert-warning d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fffbeb; color: #92400e;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">warning</span>
                    <div class="small fw-medium"><strong>Percentage too high:</strong> Percentage discounts cannot exceed 100%.</div>
                </div>
            </c:if>

            <!-- Metrics Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-lg-3">
                    <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Total Campaigns</span>
                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">campaign</span>
                        </div>
                        <h3 class="font-playfair text-dark mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">${totalPromotions}</h3>
                        <span class="text-muted fs-xs" style="font-size: 0.75rem;">Created promotions</span>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="smaller text-uppercase fw-semibold text-success" style="font-size: 0.7rem; letter-spacing: 0.05em;">Active Now</span>
                            <span class="material-symbols-outlined fs-5 text-success">check_circle</span>
                        </div>
                        <h3 class="font-playfair text-success mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${activeCount}</h3>
                        <span class="text-muted fs-xs" style="font-size: 0.75rem;">Redeemable in checkout</span>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="smaller text-uppercase fw-semibold text-muted" style="font-size: 0.7rem; letter-spacing: 0.05em;">Expired</span>
                            <span class="material-symbols-outlined fs-5 text-muted">history_toggle_off</span>
                        </div>
                        <h3 class="font-playfair text-muted mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${expiredCount}</h3>
                        <span class="text-muted fs-xs" style="font-size: 0.75rem;">Past valid dates</span>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="smaller text-uppercase fw-semibold text-primary" style="font-size: 0.7rem; letter-spacing: 0.05em;">Customer Hub</span>
                            <span class="material-symbols-outlined fs-5 text-primary">visibility</span>
                        </div>
                        <h5 class="font-playfair mb-0 mt-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-size: 1.1rem;">
                            <a href="${pageContext.request.contextPath}/comp06-reviews/promotions.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Live Page &rarr;</a>
                        </h5>
                        <span class="text-muted fs-xs" style="font-size: 0.75rem;">Public voucher board</span>
                    </div>
                </div>
            </div>

            <!-- Create New Promotion Form Card -->
            <div id="newPromoSection" class="card card-maple maple-panel-card shadow-sm p-4 p-md-5 border-0 mb-4">
                <div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom maple-section-divider">
                    <span class="material-symbols-outlined fs-4" style="color: var(--maple-gold-600, #6d411b);">add_card</span>
                    <h4 class="font-playfair text-dark mb-0 fs-4 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Publish New Promotional Voucher</h4>
                </div>

                <form action="${pageContext.request.contextPath}/addPromo" method="post" id="createPromoForm">
                    <div class="row g-3">
                        <!-- Code -->
                        <div class="col-md-4">
                            <label for="promoCode" class="form-label small fw-semibold text-dark">Voucher Code <span class="text-danger">*</span></label>
                            <input type="text" name="promoCode" id="promoCode" class="form-control form-control-maple text-uppercase font-monospace" placeholder="e.g. FESTIVE20" maxlength="30" required style="letter-spacing: 0.05em;">
                            <span class="text-muted smaller" style="font-size: 0.72rem;">Uppercase alphanumeric characters</span>
                        </div>

                        <!-- Type -->
                        <div class="col-md-4">
                            <label for="discountType" class="form-label small fw-semibold text-dark">Discount Type <span class="text-danger">*</span></label>
                            <select name="discountType" id="discountType" class="form-select form-control-maple" onchange="updateDiscountHelp()" required>
                                <option value="PERCENTAGE" selected>Percentage Discount (%)</option>
                                <option value="FIXED">Fixed Amount Discount (Rs.)</option>
                            </select>
                        </div>

                        <!-- Value -->
                        <div class="col-md-4">
                            <label for="discountValue" class="form-label small fw-semibold text-dark">Discount Amount <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted" id="discountSymbol" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);">%</span>
                                <input type="number" step="0.01" min="0.01" name="discountValue" id="discountValue" class="form-control form-control-maple border-start-0" placeholder="15" required style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                            </div>
                            <span class="text-muted smaller" id="discountHelpText" style="font-size: 0.72rem;">e.g. 15 for 15% off cart subtotal</span>
                        </div>

                        <!-- Description -->
                        <div class="col-md-8">
                            <label for="description" class="form-label small fw-semibold text-dark">Promotional Campaign Title / Notes <span class="text-danger">*</span></label>
                            <input type="text" name="description" id="description" class="form-control form-control-maple" placeholder="e.g. 15% discount on all artisan pastries and celebratory cakes" maxlength="255" required>
                        </div>

                        <!-- Expiry Date -->
                        <div class="col-md-4">
                            <label for="expiryDate" class="form-label small fw-semibold text-dark">Expiration Date <span class="text-danger">*</span></label>
                            <input type="date" name="expiryDate" id="expiryDate" class="form-control form-control-maple" required>
                        </div>

                        <div class="col-12 text-end pt-2">
                            <button type="submit" class="btn btn-maple-primary px-4 py-2 rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                                <span class="material-symbols-outlined fs-5">publish</span> Publish Campaign
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Search & Filter Controls -->
            <div class="row g-3 align-items-center justify-content-between mb-3">
                <div class="col-12 col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);">
                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                        </span>
                        <input type="search" id="promoSearchInput" onkeyup="filterPromotionsTable()" class="form-control form-control-maple border-start-0 ps-1" placeholder="Search by voucher code or description..." aria-label="Search promotions" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                    </div>
                </div>
                <div class="col-12 col-md-6 text-md-end">
                    <div class="d-inline-flex flex-wrap gap-2" role="group" aria-label="Filter by Status">
                        <button type="button" class="btn btn-sm btn-maple-primary rounded-pill px-3 active" aria-pressed="true" id="btnFilterAll" onclick="filterByStatus('ALL')">All Campaigns</button>
                        <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="btnFilterActive" onclick="filterByStatus('ACTIVE')">Active Vouchers</button>
                        <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="btnFilterExpired" onclick="filterByStatus('EXPIRED')">Expired</button>
                    </div>
                </div>
            </div>

            <!-- Promotions Table Card -->
            <div class="card card-maple maple-panel-card border-0 shadow-sm p-0 overflow-hidden mb-5">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 maple-table" id="promotionsTable">
                        <thead style="background-color: #f7f3ed; color: var(--maple-dark-900, #070100);">
                            <tr>
                                <th scope="col" class="ps-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Voucher Code</th>
                                <th scope="col" class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Campaign Description</th>
                                <th scope="col" class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Discount Type &amp; Rate</th>
                                <th scope="col" class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Expiration Date</th>
                                <th scope="col" class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Status</th>
                                <th scope="col" class="text-end pe-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="promotionsTableBody">
                            <c:choose>
                                <c:when test="${not empty promotions}">
                                    <%
                                        java.time.LocalDate todayDate = java.time.LocalDate.now();
                                        request.setAttribute("todayDate", todayDate);
                                    %>
                                    <c:forEach var="pr" items="${promotions}">
                                        <c:set var="isExpired" value="${pr.expiryDate != null && pr.expiryDate.isBefore(todayDate)}" />
                                        <tr class="promo-row" data-status="${isExpired ? 'EXPIRED' : 'ACTIVE'}" data-search="${pr.promoCode.toLowerCase()} ${pr.description.toLowerCase()}" style="border-bottom: 1px solid rgba(43, 24, 16, 0.06);">
                                            <!-- Code -->
                                            <td class="ps-4 py-3">
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">confirmation_number</span>
                                                    <span class="badge badge-status-gold font-monospace px-2 py-1 fs-6 text-uppercase" style="letter-spacing: 0.08em;">
                                                        ${pr.promoCode}
                                                    </span>
                                                </div>
                                            </td>

                                            <!-- Description -->
                                            <td class="py-3 fw-medium text-dark small" style="max-width: 280px;">
                                                ${pr.description}
                                            </td>

                                            <!-- Rate -->
                                            <td class="py-3">
                                                <c:choose>
                                                    <c:when test="${pr.getClass().simpleName == 'PercentageDiscount'}">
                                                        <span class="badge badge-status-danger px-2 py-1 font-monospace">
                                                            <fmt:formatNumber value="${pr.percentage}" maxFractionDigits="0"/>% OFF
                                                        </span>
                                                        <span class="text-muted smaller d-block mt-1" style="font-size: 0.7rem;">Percentage reduction</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-status-gold px-2 py-1 font-monospace">
                                                            Rs. <fmt:formatNumber value="${pr.fixedAmount}" minFractionDigits="2"/> OFF
                                                        </span>
                                                        <span class="text-muted smaller d-block mt-1" style="font-size: 0.7rem;">Fixed amount voucher</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Expiry -->
                                            <td class="py-3 small text-muted">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1">calendar_today</span>
                                                ${pr.expiryDate}
                                            </td>

                                            <!-- Status -->
                                            <td class="py-3">
                                                <c:choose>
                                                    <c:when test="${!isExpired}">
                                                        <span class="badge badge-status-success px-2 py-1 rounded-pill small d-inline-flex align-items-center gap-1">
                                                            <span class="material-symbols-outlined fs-6">check_circle</span> Active
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-muted border px-2 py-1 rounded-pill small d-inline-flex align-items-center gap-1">
                                                            <span class="material-symbols-outlined fs-6">schedule</span> Expired
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Actions -->
                                            <td class="text-end pe-4 py-3">
                                                <form action="${pageContext.request.contextPath}/addPromo" method="post" onsubmit="return confirm('Decommission promotional voucher ${pr.promoCode}?');" class="d-inline">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="promoCode" value="${pr.promoCode}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger px-2 py-1 rounded-2 d-inline-flex align-items-center gap-1" title="Delete Promotion">
                                                        <span class="material-symbols-outlined fs-6">delete</span> Retire
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <tr id="noPromosFoundRow" class="d-none">
                                        <td colspan="6" class="text-center py-5">
                                            <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 56px; height: 56px; background: rgba(134,82,37,0.08); color: var(--maple-gold-500, #865225);">
                                                <span class="material-symbols-outlined fs-2">search_off</span>
                                            </div>
                                            <h5 class="fw-semibold text-dark mb-1 font-playfair">No Matching Promotions</h5>
                                            <p class="text-muted small mb-3">No promotional vouchers match your current status or search filter.</p>
                                            <button type="button" class="btn btn-sm btn-maple-secondary" onclick="resetPromoFilters()">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1">replay</span> Reset Filters
                                            </button>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted small">
                                            No promotional campaigns registered yet. Use the form above to publish your first voucher.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
                </main>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <!-- Unauthorized Guard -->
        <main class="container my-5 py-5 flex-grow-1 text-center">
            <div class="card card-maple maple-panel-card shadow-sm mx-auto p-5 border-0 rounded-4" style="max-width: 480px; background: #ffffff;">
                <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                    <span class="material-symbols-outlined fs-1">shield_lock</span>
                </div>
                <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Staff Access Required</h3>
                <p class="text-muted small mb-4">You must be authenticated as an authorized Staff member or Administrator to access promotion campaign controls.</p>
                <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2 rounded-pill shadow-sm">
                    <span class="material-symbols-outlined fs-5">login</span> Sign In with Staff Account
                </a>
            </div>
        </main>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>

