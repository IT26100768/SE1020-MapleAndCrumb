<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Reviews &amp; Ratings — Maple &amp; Crumb</title>
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
    if (request.getAttribute("reviews") == null) {
        com.mapleandcrumb.dao.comp06.ReviewDAO rDao = new com.mapleandcrumb.dao.impl.comp06.ReviewDAOImpl();
        com.mapleandcrumb.dao.comp02.ProductDAO pDao = new com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl();
        request.setAttribute("reviews", rDao.getAllReviews());
        request.setAttribute("products", pDao.getAllProducts());
        request.setAttribute("totalReviews", ((java.util.List<?>)request.getAttribute("reviews")).size());
        request.setAttribute("averageRating", 4.9);
        request.setAttribute("selectedProductId", "ALL");
        request.setAttribute("selectedRating", "ALL");
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${not empty sessionScope.loggedInUser && (sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF')}">
        <div class="mc-admin-layout-wrapper">
            <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                <jsp:param name="activeTab" value="reviews" />
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
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Customer Reviews</li>
                            </ol>
                        </nav>
                    </div>
                </header>

                <main id="main-content" class="mc-admin-main-body p-4 p-md-5">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Menu</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Customer Reviews</li>
        </ol>
    </nav>

    <!-- Page Header Banner -->
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom maple-section-divider">
        <div>
            <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                <span class="material-symbols-outlined fs-6">rate_review</span> Patron Voices &amp; Reflections
            </div>
            <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                Customer Reviews &amp; Artisanal Ratings
            </h1>
            <p class="text-muted small mb-0">Discover genuine impressions of our slow-fermented viennoiserie, sourdoughs, and celebration cakes.</p>
        </div>
        <div class="mt-3 mt-sm-0 d-flex gap-2">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <a href="#writeReviewSection" class="btn btn-maple-primary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">edit_note</span> Write a Review
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=viewReviews" class="btn btn-maple-secondary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In to Review
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <c:if test="${param.msg == 'reviewSubmitted'}">
        <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-success flex-shrink-0">verified</span>
            <div class="small fw-medium"><strong>Thank you for your review!</strong> Your rating and comments were published to the bakery catalogue.</div>
        </div>
    </c:if>
    <c:if test="${param.msg == 'reviewDeleted'}">
        <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #eff6ff; color: #1e40af;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-primary flex-shrink-0">info</span>
            <div class="small fw-medium">Review was successfully deleted from the system.</div>
        </div>
    </c:if>
    <c:if test="${param.error == 'invalidRating'}">
        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">error</span>
            <div class="small fw-medium"><strong>Invalid rating:</strong> Please select a star rating between 1 and 5.</div>
        </div>
    </c:if>
    <c:if test="${param.error == 'invalidInput'}">
        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">error</span>
            <div class="small fw-medium"><strong>Missing information:</strong> Please choose a product, assign stars, and write your comment.</div>
        </div>
    </c:if>

    <!-- Metrics Summary & Rating Histogram Row -->
    <div class="row g-3 mb-5">
        <!-- Average Score Card -->
        <div class="col-12 col-md-4">
            <div class="card card-maple maple-panel-card p-4 shadow-sm h-100 border-0 text-center d-flex flex-column justify-content-center">
                <span class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.72rem; letter-spacing: 0.08em;">Average Satisfaction</span>
                <div class="display-3 fw-bold font-playfair my-2" style="color: var(--maple-dark-900, #070100);">${averageRating}</div>
                <div class="d-flex justify-content-center gap-1 mb-2">
                    <c:forEach begin="1" end="5" var="s">
                        <span class="material-symbols-outlined fs-4 ${s <= averageRating ? 'gold-star' : 'gray-star'}">star</span>
                    </c:forEach>
                </div>
                <span class="text-muted small">Based on <strong class="text-dark">${totalReviews}</strong> authentic community reviews</span>
            </div>
        </div>

        <!-- Rating Distribution Histogram -->
        <div class="col-12 col-md-5">
            <div class="card card-maple maple-panel-card p-4 shadow-sm h-100 border-0 d-flex flex-column justify-content-center">
                <span class="text-muted smaller text-uppercase fw-semibold mb-3" style="font-size: 0.72rem; letter-spacing: 0.08em;">Rating Distribution</span>
                
                <!-- 5 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">5 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct5Star}%;" role="progressbar" aria-valuenow="${pct5Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count5Star}</span>
                </div>

                <!-- 4 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">4 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct4Star}%;" role="progressbar" aria-valuenow="${pct4Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count4Star}</span>
                </div>

                <!-- 3 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">3 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct3Star}%;" role="progressbar" aria-valuenow="${pct3Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count3Star}</span>
                </div>

                <!-- 2 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">2 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct2Star}%;" role="progressbar" aria-valuenow="${pct2Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count2Star}</span>
                </div>

                <!-- 1 Star -->
                <div class="d-flex align-items-center gap-2 small">
                    <span class="text-muted" style="width: 48px;">1 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct1Star}%;" role="progressbar" aria-valuenow="${pct1Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count1Star}</span>
                </div>
            </div>
        </div>

        <!-- Trust Guarantee Card -->
        <div class="col-12 col-md-3">
            <div class="card card-maple maple-panel-card p-4 shadow-sm h-100 border-0 d-flex flex-column justify-content-between" style="background: linear-gradient(135deg, #f7f3ed, #fdf9f1);">
                <div>
                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 46px; height: 46px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-600, #6d411b);">
                        <span class="material-symbols-outlined fs-4">verified</span>
                    </div>
                    <h5 class="font-playfair text-dark fs-5 fw-bold mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Authentic Feedback</h5>
                    <p class="text-muted small mb-0">Every reflection is submitted by registered patrons and inspected to ensure authentic culinary experiences.</p>
                </div>
                <div class="pt-3 border-top mt-3" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-sm btn-maple-secondary w-100 rounded-3 px-3 py-2 d-inline-flex align-items-center justify-content-center gap-1">
                        <span class="material-symbols-outlined fs-6">storefront</span> Browse Menu
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Write a Review Interactive Card -->
    <div id="writeReviewSection" class="card card-maple maple-panel-card shadow-sm p-4 p-md-5 border-0 mb-5">
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser}">
                <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom maple-section-divider">
                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle text-white fw-bold shadow-xs" style="width: 48px; height: 48px; background: linear-gradient(135deg, var(--maple-gold-600, #6d411b), var(--maple-dark-900, #070100)); font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-size: 1.2rem;">
                        ${sessionScope.loggedInUser.username.substring(0, 1).toUpperCase()}
                    </div>
                    <div>
                        <h4 class="font-playfair text-dark mb-0 fs-4 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Share Your Culinary Experience</h4>
                        <span class="text-muted small">Posting as: <strong class="text-dark">${sessionScope.loggedInUser.username}</strong> (${sessionScope.loggedInUser.userRole})</span>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/submitReview" method="post" id="reviewForm">
                    <div class="row g-4">
                        <!-- Product Selection -->
                        <div class="col-md-6">
                            <label for="reviewProductSelect" class="form-label small fw-semibold text-dark">Select Bakery Item <span class="text-danger">*</span></label>
                            <select name="productId" id="reviewProductSelect" class="form-select form-control-maple" required>
                                <option value="" disabled ${empty selectedProductId || selectedProductId == 'ALL' ? 'selected' : ''}>— Choose a pastry, bread, or cake —</option>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.productId}" ${selectedProductId == p.productId ? 'selected' : ''}>
                                        ${p.name} (${p.category} — Rs. <fmt:formatNumber value="${p.price}" minFractionDigits="2"/>)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Interactive Star Rating Selector -->
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-dark d-block mb-1">Overall Rating <span class="text-danger">*</span></label>
                            <div class="star-rating-container" id="starRatingContainerCust">
                                <div class="star-rating-group" role="radiogroup" aria-label="Overall Rating">
                                    <input type="radio" id="cust_star1" name="rating" value="1" class="star-rating-radio" aria-label="1 star - Disappointing">
                                    <label for="cust_star1" class="star-rating-star material-symbols-outlined" data-value="1" title="1 star - Disappointing">star</label>

                                    <input type="radio" id="cust_star2" name="rating" value="2" class="star-rating-radio" aria-label="2 stars - Below Expectations">
                                    <label for="cust_star2" class="star-rating-star material-symbols-outlined" data-value="2" title="2 stars - Below Expectations">star</label>

                                    <input type="radio" id="cust_star3" name="rating" value="3" class="star-rating-radio" aria-label="3 stars - Average">
                                    <label for="cust_star3" class="star-rating-star material-symbols-outlined" data-value="3" title="3 stars - Average">star</label>

                                    <input type="radio" id="cust_star4" name="rating" value="4" class="star-rating-radio" aria-label="4 stars - Very Good">
                                    <label for="cust_star4" class="star-rating-star material-symbols-outlined" data-value="4" title="4 stars - Very Good">star</label>

                                    <input type="radio" id="cust_star5" name="rating" value="5" class="star-rating-radio" checked aria-label="5 stars - Outstanding">
                                    <label for="cust_star5" class="star-rating-star material-symbols-outlined" data-value="5" title="5 stars - Outstanding">star</label>
                                </div>
                                <div class="star-rating-feedback">
                                    <span class="star-rating-text-label">5 stars — Outstanding</span>
                                    <span class="text-muted smaller d-block" style="font-size: 0.72rem;">Click a star or use arrow keys to adjust rating</span>
                                </div>
                            </div>
                        </div>

                        <!-- Review Comment -->
                        <div class="col-12">
                            <label for="reviewComment" class="form-label small fw-semibold text-dark">Your Review &amp; Tasting Notes <span class="text-danger">*</span></label>
                            <textarea name="comment" id="reviewComment" rows="4" class="form-control form-control-maple" placeholder="Describe the crust, crumb texture, filling balance, or celebratory presentation..." minlength="5" maxlength="1000" required></textarea>
                            <div class="d-flex justify-content-between mt-1 text-muted smaller" style="font-size: 0.72rem;">
                                <span>Minimum 5 characters. Be specific and respectful.</span>
                                <span id="charCounter">0 / 1000</span>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-maple-primary px-4 py-2 rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                                <span class="material-symbols-outlined fs-5">send</span> Publish Review
                            </button>
                        </div>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="text-center py-3">
                    <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 56px; height: 56px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-600, #6d411b);">
                        <span class="material-symbols-outlined fs-2">rate_review</span>
                    </div>
                    <h4 class="font-playfair text-dark fs-4 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Have you tasted our creations?</h4>
                    <p class="text-muted small mb-4 mx-auto" style="max-width: 480px;">Please sign in with your customer account to leave verified ratings and share your impressions with the Maple &amp; Crumb community.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=viewReviews" class="btn btn-maple-primary px-4 py-2 rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In to Write a Review
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Filters & Search Toolbar -->
    <div class="row g-3 align-items-center mb-4 pb-2">
        <!-- Filter by Product Dropdown -->
        <div class="col-12 col-md-6 col-lg-5">
            <form action="${pageContext.request.contextPath}/viewReviews" method="get" class="d-flex align-items-center gap-2">
                <label for="filterProductSelect" class="small fw-semibold text-muted text-nowrap">Filter Product:</label>
                <select name="productId" id="filterProductSelect" class="form-select form-select-sm form-control-maple" onchange="this.form.submit()">
                    <option value="ALL" ${empty selectedProductId || selectedProductId == 'ALL' ? 'selected' : ''}>All Catalog Items</option>
                    <c:forEach var="p" items="${products}">
                        <option value="${p.productId}" ${selectedProductId == p.productId ? 'selected' : ''}>${p.name}</option>
                    </c:forEach>
                </select>
            </form>
        </div>
    </div>

    <!-- Reviews Feed -->
    <div class="row g-4" id="reviewsGrid">
        <c:choose>
            <c:when test="${not empty reviews}">
                <c:forEach var="rev" items="${reviews}">
                    <div class="col-12 col-md-6">
                        <div class="card card-maple maple-panel-card review-card h-100 p-4 border-0 shadow-sm d-flex flex-column justify-content-between">
                            <div>
                                <!-- Header: User & Rating & Product Badge -->
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-xs flex-shrink-0" style="width: 44px; height: 44px; background: linear-gradient(135deg, var(--maple-gold-600, #6d411b), var(--maple-dark-900, #070100)); font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-size: 1.1rem;">
                                            ${rev.customerName != null && !rev.customerName.isEmpty() ? rev.customerName.substring(0, 1).toUpperCase() : 'P'}
                                        </div>
                                        <div>
                                            <div class="d-flex align-items-center gap-2">
                                                <strong class="text-dark small">${rev.customerName}</strong>
                                                <span class="badge badge-status-success px-2 py-0" style="font-size: 0.65rem;">Verified</span>
                                            </div>
                                            <span class="text-muted smaller" style="font-size: 0.72rem;">#${rev.reviewId}</span>
                                        </div>
                                    </div>

                                    <!-- Stars -->
                                    <div class="text-end">
                                        <div class="d-inline-flex gap-0">
                                            <c:forEach begin="1" end="5" var="s">
                                                <span class="material-symbols-outlined fs-6 ${s <= rev.rating ? 'gold-star' : 'gray-star'}">star</span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <!-- Product Tag -->
                                <div class="mb-3">
                                    <span class="badge badge-status-gold px-2 py-1 rounded-pill small d-inline-flex align-items-center gap-1" style="font-size: 0.72rem;">
                                        <span class="material-symbols-outlined fs-6">bakery_dining</span>
                                        ${rev.productName}
                                    </span>
                                </div>

                                <!-- Comment Body -->
                                <p class="text-muted small mb-3" style="line-height: 1.6; font-style: italic;">
                                    &ldquo;${rev.comment}&rdquo;
                                </p>
                            </div>

                            <!-- Footer: Timestamp & Administrative Moderation -->
                            <div class="pt-3 border-top d-flex align-items-center justify-content-between" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                <span class="text-muted smaller" style="font-size: 0.72rem;">
                                    <span class="material-symbols-outlined fs-6 align-middle me-1">calendar_today</span>
                                    ${rev.reviewDate.toLocalDate()}
                                </span>

                                <!-- Admin / Staff Moderation Removal -->
                                <c:if test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
                                    <form action="${pageContext.request.contextPath}/viewReviews" method="post" onsubmit="return confirm('Moderate and permanently remove review ${rev.reviewId}?');" class="m-0">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="reviewId" value="${rev.reviewId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger px-2 py-1 rounded-2 d-inline-flex align-items-center gap-1" style="font-size: 0.7rem;" title="Decommission Review">
                                            <span class="material-symbols-outlined fs-6">delete</span> Moderate
                                        </button>
                                    </form>
                                </c:if>
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
                            <span class="material-symbols-outlined fs-1">rate_review</span>
                        </div>
                        <h4 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Reviews Found</h4>
                        <p class="text-muted small mb-4">No customer feedback matches your chosen filter criteria yet. Be the first to share your tasting impressions!</p>
                        <a href="${pageContext.request.contextPath}/viewReviews" class="btn btn-maple-secondary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                            <span class="material-symbols-outlined fs-5">refresh</span> Reset Filters
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

                </main>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <main id="main-content" class="mc-admin-main-body p-4 p-md-5">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Menu</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Customer Reviews</li>
        </ol>
    </nav>

    <!-- Page Header Banner -->
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom maple-section-divider">
        <div>
            <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                <span class="material-symbols-outlined fs-6">rate_review</span> Patron Voices &amp; Reflections
            </div>
            <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                Customer Reviews &amp; Artisanal Ratings
            </h1>
            <p class="text-muted small mb-0">Discover genuine impressions of our slow-fermented viennoiserie, sourdoughs, and celebration cakes.</p>
        </div>
        <div class="mt-3 mt-sm-0 d-flex gap-2">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <a href="#writeReviewSection" class="btn btn-maple-primary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">edit_note</span> Write a Review
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=viewReviews" class="btn btn-maple-secondary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In to Review
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <c:if test="${param.msg == 'reviewSubmitted'}">
        <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-success flex-shrink-0">verified</span>
            <div class="small fw-medium"><strong>Thank you for your review!</strong> Your rating and comments were published to the bakery catalogue.</div>
        </div>
    </c:if>
    <c:if test="${param.msg == 'reviewDeleted'}">
        <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #eff6ff; color: #1e40af;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-primary flex-shrink-0">info</span>
            <div class="small fw-medium">Review was successfully deleted from the system.</div>
        </div>
    </c:if>
    <c:if test="${param.error == 'invalidRating'}">
        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">error</span>
            <div class="small fw-medium"><strong>Invalid rating:</strong> Please select a star rating between 1 and 5.</div>
        </div>
    </c:if>
    <c:if test="${param.error == 'invalidInput'}">
        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
            <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">error</span>
            <div class="small fw-medium"><strong>Missing information:</strong> Please choose a product, assign stars, and write your comment.</div>
        </div>
    </c:if>

    <!-- Metrics Summary & Rating Histogram Row -->
    <div class="row g-3 mb-5">
        <!-- Average Score Card -->
        <div class="col-12 col-md-4">
            <div class="card card-maple maple-panel-card p-4 shadow-sm h-100 border-0 text-center d-flex flex-column justify-content-center">
                <span class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.72rem; letter-spacing: 0.08em;">Average Satisfaction</span>
                <div class="display-3 fw-bold font-playfair my-2" style="color: var(--maple-dark-900, #070100);">${averageRating}</div>
                <div class="d-flex justify-content-center gap-1 mb-2">
                    <c:forEach begin="1" end="5" var="s">
                        <span class="material-symbols-outlined fs-4 ${s <= averageRating ? 'gold-star' : 'gray-star'}">star</span>
                    </c:forEach>
                </div>
                <span class="text-muted small">Based on <strong class="text-dark">${totalReviews}</strong> authentic community reviews</span>
            </div>
        </div>

        <!-- Rating Distribution Histogram -->
        <div class="col-12 col-md-5">
            <div class="card card-maple maple-panel-card p-4 shadow-sm h-100 border-0 d-flex flex-column justify-content-center">
                <span class="text-muted smaller text-uppercase fw-semibold mb-3" style="font-size: 0.72rem; letter-spacing: 0.08em;">Rating Distribution</span>
                
                <!-- 5 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">5 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct5Star}%;" role="progressbar" aria-valuenow="${pct5Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count5Star}</span>
                </div>

                <!-- 4 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">4 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct4Star}%;" role="progressbar" aria-valuenow="${pct4Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count4Star}</span>
                </div>

                <!-- 3 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">3 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct3Star}%;" role="progressbar" aria-valuenow="${pct3Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count3Star}</span>
                </div>

                <!-- 2 Star -->
                <div class="d-flex align-items-center gap-2 mb-2 small">
                    <span class="text-muted" style="width: 48px;">2 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct2Star}%;" role="progressbar" aria-valuenow="${pct2Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count2Star}</span>
                </div>

                <!-- 1 Star -->
                <div class="d-flex align-items-center gap-2 small">
                    <span class="text-muted" style="width: 48px;">1 ★</span>
                    <div class="progress flex-grow-1" style="height: 8px; background-color: #ece8e0; border-radius: 999px;">
                        <div class="progress-bar" style="background-color: #c5a059; width: ${pct1Star}%;" role="progressbar" aria-valuenow="${pct1Star}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span class="text-muted text-end" style="width: 36px;">${count1Star}</span>
                </div>
            </div>
        </div>

        <!-- Trust Guarantee Card -->
        <div class="col-12 col-md-3">
            <div class="card card-maple maple-panel-card p-4 shadow-sm h-100 border-0 d-flex flex-column justify-content-between" style="background: linear-gradient(135deg, #f7f3ed, #fdf9f1);">
                <div>
                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 46px; height: 46px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-600, #6d411b);">
                        <span class="material-symbols-outlined fs-4">verified</span>
                    </div>
                    <h5 class="font-playfair text-dark fs-5 fw-bold mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Authentic Feedback</h5>
                    <p class="text-muted small mb-0">Every reflection is submitted by registered patrons and inspected to ensure authentic culinary experiences.</p>
                </div>
                <div class="pt-3 border-top mt-3" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-sm btn-maple-secondary w-100 rounded-3 px-3 py-2 d-inline-flex align-items-center justify-content-center gap-1">
                        <span class="material-symbols-outlined fs-6">storefront</span> Browse Menu
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Write a Review Interactive Card -->
    <div id="writeReviewSection" class="card card-maple maple-panel-card shadow-sm p-4 p-md-5 border-0 mb-5">
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser}">
                <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom maple-section-divider">
                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle text-white fw-bold shadow-xs" style="width: 48px; height: 48px; background: linear-gradient(135deg, var(--maple-gold-600, #6d411b), var(--maple-dark-900, #070100)); font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-size: 1.2rem;">
                        ${sessionScope.loggedInUser.username.substring(0, 1).toUpperCase()}
                    </div>
                    <div>
                        <h4 class="font-playfair text-dark mb-0 fs-4 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Share Your Culinary Experience</h4>
                        <span class="text-muted small">Posting as: <strong class="text-dark">${sessionScope.loggedInUser.username}</strong> (${sessionScope.loggedInUser.userRole})</span>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/submitReview" method="post" id="reviewForm">
                    <div class="row g-4">
                        <!-- Product Selection -->
                        <div class="col-md-6">
                            <label for="reviewProductSelect" class="form-label small fw-semibold text-dark">Select Bakery Item <span class="text-danger">*</span></label>
                            <select name="productId" id="reviewProductSelect" class="form-select form-control-maple" required>
                                <option value="" disabled ${empty selectedProductId || selectedProductId == 'ALL' ? 'selected' : ''}>— Choose a pastry, bread, or cake —</option>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.productId}" ${selectedProductId == p.productId ? 'selected' : ''}>
                                        ${p.name} (${p.category} — Rs. <fmt:formatNumber value="${p.price}" minFractionDigits="2"/>)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Interactive Star Rating Selector -->
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-dark d-block mb-1">Overall Rating <span class="text-danger">*</span></label>
                            <div class="star-rating-container" id="starRatingContainerCust">
                                <div class="star-rating-group" role="radiogroup" aria-label="Overall Rating">
                                    <input type="radio" id="cust_star1" name="rating" value="1" class="star-rating-radio" aria-label="1 star - Disappointing">
                                    <label for="cust_star1" class="star-rating-star material-symbols-outlined" data-value="1" title="1 star - Disappointing">star</label>

                                    <input type="radio" id="cust_star2" name="rating" value="2" class="star-rating-radio" aria-label="2 stars - Below Expectations">
                                    <label for="cust_star2" class="star-rating-star material-symbols-outlined" data-value="2" title="2 stars - Below Expectations">star</label>

                                    <input type="radio" id="cust_star3" name="rating" value="3" class="star-rating-radio" aria-label="3 stars - Average">
                                    <label for="cust_star3" class="star-rating-star material-symbols-outlined" data-value="3" title="3 stars - Average">star</label>

                                    <input type="radio" id="cust_star4" name="rating" value="4" class="star-rating-radio" aria-label="4 stars - Very Good">
                                    <label for="cust_star4" class="star-rating-star material-symbols-outlined" data-value="4" title="4 stars - Very Good">star</label>

                                    <input type="radio" id="cust_star5" name="rating" value="5" class="star-rating-radio" checked aria-label="5 stars - Outstanding">
                                    <label for="cust_star5" class="star-rating-star material-symbols-outlined" data-value="5" title="5 stars - Outstanding">star</label>
                                </div>
                                <div class="star-rating-feedback">
                                    <span class="star-rating-text-label">5 stars — Outstanding</span>
                                    <span class="text-muted smaller d-block" style="font-size: 0.72rem;">Click a star or use arrow keys to adjust rating</span>
                                </div>
                            </div>
                        </div>

                        <!-- Review Comment -->
                        <div class="col-12">
                            <label for="reviewComment" class="form-label small fw-semibold text-dark">Your Review &amp; Tasting Notes <span class="text-danger">*</span></label>
                            <textarea name="comment" id="reviewComment" rows="4" class="form-control form-control-maple" placeholder="Describe the crust, crumb texture, filling balance, or celebratory presentation..." minlength="5" maxlength="1000" required></textarea>
                            <div class="d-flex justify-content-between mt-1 text-muted smaller" style="font-size: 0.72rem;">
                                <span>Minimum 5 characters. Be specific and respectful.</span>
                                <span id="charCounter">0 / 1000</span>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-maple-primary px-4 py-2 rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                                <span class="material-symbols-outlined fs-5">send</span> Publish Review
                            </button>
                        </div>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="text-center py-3">
                    <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 56px; height: 56px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-600, #6d411b);">
                        <span class="material-symbols-outlined fs-2">rate_review</span>
                    </div>
                    <h4 class="font-playfair text-dark fs-4 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Have you tasted our creations?</h4>
                    <p class="text-muted small mb-4 mx-auto" style="max-width: 480px;">Please sign in with your customer account to leave verified ratings and share your impressions with the Maple &amp; Crumb community.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=viewReviews" class="btn btn-maple-primary px-4 py-2 rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In to Write a Review
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Filters & Search Toolbar -->
    <div class="row g-3 align-items-center mb-4 pb-2">
        <!-- Filter by Product Dropdown -->
        <div class="col-12 col-md-6 col-lg-5">
            <form action="${pageContext.request.contextPath}/viewReviews" method="get" class="d-flex align-items-center gap-2">
                <label for="filterProductSelect" class="small fw-semibold text-muted text-nowrap">Filter Product:</label>
                <select name="productId" id="filterProductSelect" class="form-select form-select-sm form-control-maple" onchange="this.form.submit()">
                    <option value="ALL" ${empty selectedProductId || selectedProductId == 'ALL' ? 'selected' : ''}>All Catalog Items</option>
                    <c:forEach var="p" items="${products}">
                        <option value="${p.productId}" ${selectedProductId == p.productId ? 'selected' : ''}>${p.name}</option>
                    </c:forEach>
                </select>
            </form>
        </div>
    </div>

    <!-- Reviews Feed -->
    <div class="row g-4" id="reviewsGrid">
        <c:choose>
            <c:when test="${not empty reviews}">
                <c:forEach var="rev" items="${reviews}">
                    <div class="col-12 col-md-6">
                        <div class="card card-maple maple-panel-card review-card h-100 p-4 border-0 shadow-sm d-flex flex-column justify-content-between">
                            <div>
                                <!-- Header: User & Rating & Product Badge -->
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-xs flex-shrink-0" style="width: 44px; height: 44px; background: linear-gradient(135deg, var(--maple-gold-600, #6d411b), var(--maple-dark-900, #070100)); font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-size: 1.1rem;">
                                            ${rev.customerName != null && !rev.customerName.isEmpty() ? rev.customerName.substring(0, 1).toUpperCase() : 'P'}
                                        </div>
                                        <div>
                                            <div class="d-flex align-items-center gap-2">
                                                <strong class="text-dark small">${rev.customerName}</strong>
                                                <span class="badge badge-status-success px-2 py-0" style="font-size: 0.65rem;">Verified</span>
                                            </div>
                                            <span class="text-muted smaller" style="font-size: 0.72rem;">#${rev.reviewId}</span>
                                        </div>
                                    </div>

                                    <!-- Stars -->
                                    <div class="text-end">
                                        <div class="d-inline-flex gap-0">
                                            <c:forEach begin="1" end="5" var="s">
                                                <span class="material-symbols-outlined fs-6 ${s <= rev.rating ? 'gold-star' : 'gray-star'}">star</span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <!-- Product Tag -->
                                <div class="mb-3">
                                    <span class="badge badge-status-gold px-2 py-1 rounded-pill small d-inline-flex align-items-center gap-1" style="font-size: 0.72rem;">
                                        <span class="material-symbols-outlined fs-6">bakery_dining</span>
                                        ${rev.productName}
                                    </span>
                                </div>

                                <!-- Comment Body -->
                                <p class="text-muted small mb-3" style="line-height: 1.6; font-style: italic;">
                                    &ldquo;${rev.comment}&rdquo;
                                </p>
                            </div>

                            <!-- Footer: Timestamp & Administrative Moderation -->
                            <div class="pt-3 border-top d-flex align-items-center justify-content-between" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                <span class="text-muted smaller" style="font-size: 0.72rem;">
                                    <span class="material-symbols-outlined fs-6 align-middle me-1">calendar_today</span>
                                    ${rev.reviewDate.toLocalDate()}
                                </span>

                                <!-- Admin / Staff Moderation Removal -->
                                <c:if test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
                                    <form action="${pageContext.request.contextPath}/viewReviews" method="post" onsubmit="return confirm('Moderate and permanently remove review ${rev.reviewId}?');" class="m-0">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="reviewId" value="${rev.reviewId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger px-2 py-1 rounded-2 d-inline-flex align-items-center gap-1" style="font-size: 0.7rem;" title="Decommission Review">
                                            <span class="material-symbols-outlined fs-6">delete</span> Moderate
                                        </button>
                                    </form>
                                </c:if>
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
                            <span class="material-symbols-outlined fs-1">rate_review</span>
                        </div>
                        <h4 class="font-playfair text-dark mb-2 fs-4" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Reviews Found</h4>
                        <p class="text-muted small mb-4">No customer feedback matches your chosen filter criteria yet. Be the first to share your tasting impressions!</p>
                        <a href="${pageContext.request.contextPath}/viewReviews" class="btn btn-maple-secondary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                            <span class="material-symbols-outlined fs-5">refresh</span> Reset Filters
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

        </main>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    // Character counter for comment
    const commentInput = document.getElementById('reviewComment');
    const charCounter = document.getElementById('charCounter');
    if (commentInput && charCounter) {
        commentInput.addEventListener('input', function() {
            charCounter.textContent = this.value.length + ' / 1000';
        });
    }

    // Initialize Star Rating Selectors
    if (typeof window.initStarRatingSelectors === 'function') {
        window.initStarRatingSelectors();
    }
</script>
</body>
</html>

