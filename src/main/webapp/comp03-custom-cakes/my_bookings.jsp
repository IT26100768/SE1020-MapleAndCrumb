<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cake Bookings - Maple &amp; Crumb</title>
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
    <!-- Header with Action -->
    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-2 border-bottom">
        <div>
            <h1 class="page-title fs-2 mb-1">My Custom Cake Bookings</h1>
            <p class="text-muted small mb-0">Track preparation progress and pickup schedules for your custom orders</p>
        </div>
        <div class="mt-2 mt-sm-0">
            <a href="${pageContext.request.contextPath}/comp03-custom-cakes/book_cake.jsp" class="btn btn-primary shadow-sm">
                <i class="bi bi-cake2 me-1"></i> Book New Cake
            </a>
        </div>
    </div>

    <!-- Booking Confirmation Alert -->
    <c:if test="${param.msg == 'booked'}">
        <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
            <i class="bi bi-check-circle-fill fs-5 me-2"></i>
            <div>Your custom cake booking request was successfully received! Our master baker will review it promptly.</div>
        </div>
    </c:if>

    <!-- Bookings Table Card -->
    <div class="card card-maple shadow-sm p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark" style="background-color: var(--mc-espresso);">
                    <tr>
                        <th class="ps-4">Booking ID</th>
                        <th>Flavor &amp; Size</th>
                        <th>Custom Inscription</th>
                        <th>Pickup Date</th>
                        <th>Base Price</th>
                        <th class="pe-4">Booking Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty bookings}">
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td class="ps-4 fw-semibold text-secondary">${b.bookingId}</td>
                                    <td>
                                        <div class="fw-bold text-dark">${b.flavor}</div>
                                        <span class="badge bg-light text-dark border small">${b.sizeInches}-inch round</span>
                                    </td>
                                    <td class="small fst-italic text-muted">
                                        <c:choose>
                                            <c:when test="${not empty b.customMessage}">&ldquo;${b.customMessage}&rdquo;</c:when>
                                            <c:otherwise><span class="text-secondary">(No inscription requested)</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-medium">${b.pickupDate}</td>
                                    <td class="fw-bold text-dark font-playfair">$<fmt:formatNumber value="${b.calculateBasePrice()}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td class="pe-4">
                                        <span class="badge ${b.status == 'Approved' || b.status == 'Ready' ? 'bg-success-subtle text-success' : (b.status == 'Pending' ? 'bg-warning-subtle text-dark' : 'bg-secondary-subtle text-secondary')} rounded-pill px-3 py-1">
                                            ${b.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Sample Preview Rows -->
                            <tr>
                                <td class="ps-4 fw-semibold text-secondary">CK-9021</td>
                                <td>
                                    <div class="fw-bold text-dark">Belgian Chocolate Truffle</div>
                                    <span class="badge bg-light text-dark border small">8-inch round</span>
                                </td>
                                <td class="small fst-italic text-muted">&ldquo;Happy 25th Birthday Alex!&rdquo;</td>
                                <td class="fw-medium">2026-10-20</td>
                                <td class="fw-bold text-dark font-playfair">$120.00</td>
                                <td class="pe-4">
                                    <span class="badge bg-warning-subtle text-dark rounded-pill px-3 py-1">Pending Review</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4 fw-semibold text-secondary">CK-8840</td>
                                <td>
                                    <div class="fw-bold text-dark">Red Velvet &amp; Cream Cheese</div>
                                    <span class="badge bg-light text-dark border small">10-inch round</span>
                                </td>
                                <td class="small fst-italic text-muted">&ldquo;Congratulations on your Graduation!&rdquo;</td>
                                <td class="fw-medium">2026-10-15</td>
                                <td class="fw-bold text-dark font-playfair">$150.00</td>
                                <td class="pe-4">
                                    <span class="badge bg-success-subtle text-success rounded-pill px-3 py-1">Ready for Pickup</span>
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

