<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - Maple &amp; Crumb</title>
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
    <c:choose>
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
            <!-- Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-2 border-bottom">
                <div>
                    <h1 class="page-title fs-2 mb-1">Custom Cake Bookings Manager</h1>
                    <p class="text-muted small mb-0">Review custom orders, update preparation stages, and manage pickup readiness</p>
                </div>
                <div class="mt-2 mt-sm-0">
                    <span class="badge bg-danger text-white px-3 py-2 rounded-pill">
                        <i class="bi bi-shield-lock-fill me-1"></i> Admin &amp; Staff Access
                    </span>
                </div>
            </div>

            <!-- Status Updated Alert -->
            <c:if test="${param.msg == 'statusUpdated'}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                    <div>Booking status successfully updated and saved.</div>
                </div>
            </c:if>

            <!-- Bookings Management Table -->
            <div class="card card-maple shadow-sm p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark" style="background-color: var(--mc-espresso);">
                            <tr>
                                <th class="ps-4">Booking ID</th>
                                <th>Customer ID</th>
                                <th>Specs &amp; Inscription</th>
                                <th>Pickup Date</th>
                                <th>Base Price</th>
                                <th>Current Status</th>
                                <th class="text-end pe-4">Update Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty bookings}">
                                    <c:forEach var="b" items="${bookings}">
                                        <tr>
                                            <td class="ps-4 fw-semibold text-secondary">${b.bookingId}</td>
                                            <td class="fw-medium">${b.customerId}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${b.flavor} (${b.sizeInches}&quot;)</div>
                                                <small class="text-muted fst-italic">&ldquo;${b.customMessage}&rdquo;</small>
                                            </td>
                                            <td class="fw-medium">${b.pickupDate}</td>
                                            <td class="fw-bold text-dark font-playfair">$<fmt:formatNumber value="${b.calculateBasePrice()}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td>
                                                <span class="badge ${b.status == 'Approved' || b.status == 'Ready' ? 'bg-success-subtle text-success' : (b.status == 'Pending' ? 'bg-warning-subtle text-dark' : 'bg-secondary-subtle text-secondary')} rounded-pill px-2 py-1">
                                                    ${b.status}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <form action="${pageContext.request.contextPath}/updateBookingStatus" method="post" class="d-inline-flex gap-1 align-items-center">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    <select name="status" class="form-select form-select-sm" style="width: auto;">
                                                        <option value="Pending" ${b.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="Approved" ${b.status == 'Approved' ? 'selected' : ''}>Approved</option>
                                                        <option value="In Preparation" ${b.status == 'In Preparation' ? 'selected' : ''}>In Prep</option>
                                                        <option value="Ready" ${b.status == 'Ready' ? 'selected' : ''}>Ready</option>
                                                        <option value="Completed" ${b.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                        <option value="Cancelled" ${b.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-arrow-repeat"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td class="ps-4 fw-semibold text-secondary">CK-9021</td>
                                        <td class="fw-medium">U-7489</td>
                                        <td>
                                            <div class="fw-bold text-dark">Belgian Chocolate Truffle (8&quot;)</div>
                                            <small class="text-muted fst-italic">&ldquo;Happy 25th Birthday Alex!&rdquo;</small>
                                        </td>
                                        <td class="fw-medium">2026-10-20</td>
                                        <td class="fw-bold text-dark font-playfair">$120.00</td>
                                        <td><span class="badge bg-warning-subtle text-dark rounded-pill px-2 py-1">Pending</span></td>
                                        <td class="text-end pe-4">
                                            <form action="${pageContext.request.contextPath}/updateBookingStatus" method="post" class="d-inline-flex gap-1 align-items-center">
                                                <input type="hidden" name="bookingId" value="CK-9021">
                                                <select name="status" class="form-select form-select-sm" style="width: auto;">
                                                    <option value="Pending" selected>Pending</option>
                                                    <option value="Approved">Approved</option>
                                                    <option value="In Preparation">In Prep</option>
                                                    <option value="Ready">Ready</option>
                                                    <option value="Completed">Completed</option>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-arrow-repeat"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Unauthorized Access Guard -->
            <div class="text-center py-5">
                <div class="card card-maple shadow-sm mx-auto p-5" style="max-width: 500px;">
                    <div class="fs-1 text-danger mb-3"><i class="bi bi-shield-lock-fill"></i></div>
                    <h3 class="font-playfair text-dark">Staff Access Only</h3>
                    <p class="text-muted small mb-4">Please log in with appropriate administrative privileges to manage custom cake bookings.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary px-4">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Login
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>

