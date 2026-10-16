<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History - Maple &amp; Crumb</title>
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
    <!-- Header -->
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-2 border-bottom">
        <div>
            <h1 class="page-title fs-2 mb-1">My Order History</h1>
            <p class="text-muted small mb-0">Review past deliveries, pickup tickets, and real-time order status</p>
        </div>
        <div class="mt-2 mt-sm-0">
            <a href="${pageContext.request.contextPath}/comp02-products/menu.jsp" class="btn btn-primary shadow-sm">
                <i class="bi bi-cart-plus me-1"></i> Order Fresh Pastries
            </a>
        </div>
    </div>

    <!-- Feedback Message on Order Cancellation -->
    <c:if test="${param.msg == 'cancelled'}">
        <div class="alert alert-warning d-flex align-items-center mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i>
            <div>Your order has been cancelled successfully.</div>
        </div>
    </c:if>

    <!-- Orders Table Card -->
    <div class="card card-maple shadow-sm p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark" style="background-color: var(--mc-espresso);">
                    <tr>
                        <th class="ps-4">Order ID</th>
                        <th>Date &amp; Time</th>
                        <th>Fulfillment</th>
                        <th>Items Summary</th>
                        <th>Final Total</th>
                        <th>Order Status</th>
                        <th class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td class="ps-4 fw-semibold text-secondary">${o.orderId}</td>
                                    <td class="small text-muted">${o.orderDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty o.deliveryAddress}">
                                                <span class="badge bg-primary-subtle text-primary border"><i class="bi bi-truck me-1"></i>Delivery</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary border"><i class="bi bi-shop me-1"></i>Pickup</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="small">
                                        <c:forEach var="item" items="${o.items}" varStatus="status">
                                            <span>${item.productName} &times; ${item.quantity}</span><c:if test="${!status.last}">, </c:if>
                                        </c:forEach>
                                    </td>
                                    <td class="fw-bold text-dark font-playfair">$<fmt:formatNumber value="${o.calculateFinalTotal()}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td>
                                        <span class="badge ${o.status == 'Delivered' || o.status == 'Confirmed' ? 'bg-success-subtle text-success' : (o.status == 'Pending' ? 'bg-warning-subtle text-dark' : 'bg-danger-subtle text-danger')} rounded-pill px-3 py-1">
                                            ${o.status}
                                        </span>
                                    </td>
                                    <td class="text-end pe-4">
                                        <c:if test="${o.status == 'Pending'}">
                                            <form action="${pageContext.request.contextPath}/cancelOrder" method="post" class="d-inline" onsubmit="return confirm('Cancel this order?');">
                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    Cancel
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Sample Preview Rows -->
                            <tr>
                                <td class="ps-4 fw-semibold text-secondary">MC-ORD-7821</td>
                                <td class="small text-muted">2026-10-14 09:30</td>
                                <td><span class="badge bg-primary-subtle text-primary border"><i class="bi bi-truck me-1"></i>Delivery</span></td>
                                <td class="small">Chocolate Fudge Cake &times; 1</td>
                                <td class="fw-bold text-dark font-playfair">$43.50</td>
                                <td><span class="badge bg-warning-subtle text-dark rounded-pill px-3 py-1">Pending</span></td>
                                <td class="text-end pe-4">
                                    <form action="${pageContext.request.contextPath}/cancelOrder" method="post" class="d-inline" onsubmit="return confirm('Cancel this order?');">
                                        <input type="hidden" name="orderId" value="MC-ORD-7821">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Cancel</button>
                                    </form>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4 fw-semibold text-secondary">MC-ORD-7612</td>
                                <td class="small text-muted">2026-10-10 14:15</td>
                                <td><span class="badge bg-secondary-subtle text-secondary border"><i class="bi bi-shop me-1"></i>Pickup</span></td>
                                <td class="small">Butter Croissant &times; 4, Vanilla Bean Sponge &times; 1</td>
                                <td class="fw-bold text-dark font-playfair">$47.00</td>
                                <td><span class="badge bg-success-subtle text-success rounded-pill px-3 py-1">Delivered</span></td>
                                <td class="text-end pe-4">
                                    <span class="text-muted small">Completed</span>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
