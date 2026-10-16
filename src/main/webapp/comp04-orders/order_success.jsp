<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - Maple &amp; Crumb</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="container my-auto py-5 flex-grow-1">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6 text-center">

            <!-- Success Celebration Card -->
            <div class="card card-maple shadow-sm py-5 px-4">
                <div class="card-maple-icon mx-auto mb-3" style="width: 76px; height: 76px; font-size: 2.25rem; background-color: #EBF8EE; color: #1E6635;">
                    <i class="bi bi-check-lg"></i>
                </div>

                <h1 class="page-title fs-2 mb-2">Order Confirmed!</h1>
                <p class="text-muted small mb-4">Thank you for your order with Maple &amp; Crumb Bakery</p>

                <!-- Order Ticket Details -->
                <div class="p-4 rounded-3 border bg-light text-start mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                        <span class="text-muted small">Order Reference:</span>
                        <span class="fw-bold text-dark font-monospace">${param.orderId != null ? param.orderId : 'MC-ORD-7821'}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                        <span class="text-muted small">Estimated Readiness:</span>
                        <span class="fw-semibold text-dark">Approximately 30–45 minutes</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-0">
                        <span class="text-muted small">Fulfillment Status:</span>
                        <span class="badge bg-warning-subtle text-dark rounded-pill px-3 py-1">In Preparation</span>
                    </div>
                </div>

                <p class="small text-muted mb-4">A confirmation receipt has been sent to your registered email address. Our bakers are already rolling and baking your fresh treats!</p>

                <div class="d-flex flex-wrap justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/comp04-orders/order_history.jsp" class="btn btn-outline-maple px-4">
                        <i class="bi bi-receipt me-1"></i> View My Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/comp02-products/menu.jsp" class="btn btn-primary px-4">
                        <i class="bi bi-shop me-1"></i> Back to Menu
                    </a>
                </div>
            </div>

        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>