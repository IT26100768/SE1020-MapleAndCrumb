<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Maple &amp; Crumb</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="container my-5 flex-grow-1">
    <!-- Role Guard: Admin or Staff -->
    <c:choose>
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
            <!-- Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-2 border-bottom">
                <div>
                    <h1 class="page-title fs-2 mb-1">Administrative Operations Hub</h1>
                    <p class="text-muted small mb-0">Logged in as: <strong class="text-dark">${sessionScope.loggedInUser.username}</strong> (${sessionScope.loggedInUser.userRole})</p>
                </div>
                <div class="mt-2 mt-sm-0">
                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill">
                        <i class="bi bi-circle-fill fs-6 me-1 text-success"></i> Bakery Server Live
                    </span>
                </div>
            </div>

            <!-- KPI Metric Stat Cards -->
            <div class="row g-3 mb-5">
                <div class="col-6 col-lg-3">
                    <div class="card card-maple p-3 shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted smaller text-uppercase fw-bold" style="font-size: 0.75rem;">Active Products</span>
                                <h3 class="fw-bold text-dark font-playfair mb-0 mt-1">28</h3>
                            </div>
                            <div class="card-maple-icon m-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                                <i class="bi bi-basket2-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card card-maple p-3 shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted smaller text-uppercase fw-bold" style="font-size: 0.75rem;">Cake Bookings</span>
                                <h3 class="fw-bold text-dark font-playfair mb-0 mt-1">9</h3>
                            </div>
                            <div class="card-maple-icon m-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                                <i class="bi bi-cake2-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card card-maple p-3 shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted smaller text-uppercase fw-bold" style="font-size: 0.75rem;">Today's Orders</span>
                                <h3 class="fw-bold text-dark font-playfair mb-0 mt-1">34</h3>
                            </div>
                            <div class="card-maple-icon m-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                                <i class="bi bi-receipt-cutoff"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="card card-maple p-3 shadow-sm h-100">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted smaller text-uppercase fw-bold" style="font-size: 0.75rem;">Staff Active</span>
                                <h3 class="fw-bold text-dark font-playfair mb-0 mt-1">6</h3>
                            </div>
                            <div class="card-maple-icon m-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Access Navigation Cards -->
            <h4 class="font-playfair text-dark mb-3">Management Consoles</h4>
            <div class="row g-4 mb-5">
                <!-- Module 1: Product Inventory -->
                <div class="col-md-6 col-lg-4">
                    <div class="card card-maple h-100 shadow-sm d-flex flex-column justify-content-between">
                        <div>
                            <div class="card-maple-icon mb-3">
                                <i class="bi bi-box-seam"></i>
                            </div>
                            <h5 class="font-playfair text-dark">Product Catalogue</h5>
                            <p class="text-muted small">Update menu offerings, adjust pricing, and track live bakery stock.</p>
                        </div>
                        <div class="pt-3 border-top d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/comp02-products/manage_products.jsp" class="btn btn-sm btn-outline-maple flex-grow-1">Manage</a>
                            <a href="${pageContext.request.contextPath}/comp02-products/add_product.jsp" class="btn btn-sm btn-primary"><i class="bi bi-plus-lg"></i></a>
                        </div>
                    </div>
                </div>

                <!-- Module 2: Custom Cake Bookings -->
                <div class="col-md-6 col-lg-4">
                    <div class="card card-maple h-100 shadow-sm d-flex flex-column justify-content-between">
                        <div>
                            <div class="card-maple-icon mb-3">
                                <i class="bi bi-cake2"></i>
                            </div>
                            <h5 class="font-playfair text-dark">Custom Cake Bookings</h5>
                            <p class="text-muted small">Review customer flavor choices, inscriptions, and update prep stages.</p>
                        </div>
                        <div class="pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/comp03-custom-cakes/manage_bookings.jsp" class="btn btn-sm btn-primary w-100">
                                Review Bookings
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Module 3: Customer Orders -->
                <div class="col-md-6 col-lg-4">
                    <div class="card card-maple h-100 shadow-sm d-flex flex-column justify-content-between">
                        <div>
                            <div class="card-maple-icon mb-3">
                                <i class="bi bi-bag-check"></i>
                            </div>
                            <h5 class="font-playfair text-dark">Fulfillment &amp; Orders</h5>
                            <p class="text-muted small">Track pending delivery packages, store pickups, and handle order inquiries.</p>
                        </div>
                        <div class="pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/comp04-orders/order_history.jsp" class="btn btn-sm btn-primary w-100">
                                View Orders
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Module 4: Staff Directory -->
                <div class="col-md-6 col-lg-4">
                    <div class="card card-maple h-100 shadow-sm d-flex flex-column justify-content-between">
                        <div>
                            <div class="card-maple-icon mb-3">
                                <i class="bi bi-person-badge"></i>
                            </div>
                            <h5 class="font-playfair text-dark">Staff &amp; Admins</h5>
                            <p class="text-muted small">Manage staff records, assign administrative tiers, and update payroll.</p>
                        </div>
                        <div class="pt-3 border-top d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/comp05-admin/manage_staff.jsp" class="btn btn-sm btn-outline-maple flex-grow-1">Directory</a>
                            <a href="${pageContext.request.contextPath}/comp05-admin/add_staff.jsp" class="btn btn-sm btn-primary"><i class="bi bi-person-plus"></i></a>
                        </div>
                    </div>
                </div>

                <!-- Module 5: Promotions -->
                <div class="col-md-6 col-lg-4">
                    <div class="card card-maple h-100 shadow-sm d-flex flex-column justify-content-between">
                        <div>
                            <div class="card-maple-icon mb-3">
                                <i class="bi bi-tag"></i>
                            </div>
                            <h5 class="font-playfair text-dark">Promo Campaigns</h5>
                            <p class="text-muted small">Configure percentage discounts and coupon vouchers for loyal patrons.</p>
                        </div>
                        <div class="pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/comp06-feedback/manage_promotions.jsp" class="btn btn-sm btn-primary w-100">
                                Manage Offers
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Module 6: Customer Feedback -->
                <div class="col-md-6 col-lg-4">
                    <div class="card card-maple h-100 shadow-sm d-flex flex-column justify-content-between">
                        <div>
                            <div class="card-maple-icon mb-3">
                                <i class="bi bi-chat-heart"></i>
                            </div>
                            <h5 class="font-playfair text-dark">Reviews &amp; Feedback</h5>
                            <p class="text-muted small">Inspect customer ratings, evaluate testimonials, and maintain quality.</p>
                        </div>
                        <div class="pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/comp06-feedback/view_reviews.jsp" class="btn btn-sm btn-primary w-100">
                                View Reviews
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Unauthorized Access Guard -->
            <div class="text-center py-5">
                <div class="card card-maple shadow-sm mx-auto p-5" style="max-width: 500px;">
                    <div class="fs-1 text-danger mb-3"><i class="bi bi-shield-lock-fill"></i></div>
                    <h3 class="font-playfair text-dark">Administrator Access Required</h3>
                    <p class="text-muted small mb-4">You must be logged in as an authorized Staff member or Administrator to access the administrative dashboard.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary px-4">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Log In
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>

