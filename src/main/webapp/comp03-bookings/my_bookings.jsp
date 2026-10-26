<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cake Reservations — Maple &amp; Crumb</title>
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
    if (request.getAttribute("bookings") == null) {
        com.mapleandcrumb.model.comp01.User user = (com.mapleandcrumb.model.comp01.User) session.getAttribute("loggedInUser");
        if (user != null) {
            com.mapleandcrumb.dao.comp03.CustomCakeDAO cakeDao = new com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl();
            java.util.List<com.mapleandcrumb.model.comp03.CustomCakeOrder> list = cakeDao.getBookingsByCustomer(user.getUserID());
            if (list.isEmpty() && user.getEmail() != null) {
                list = cakeDao.getBookingsByCustomer(user.getEmail());
            }
            if (list.isEmpty() && user.getUsername() != null) {
                list = cakeDao.getBookingsByCustomer(user.getUsername());
            }
            request.setAttribute("bookings", list);
        }
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main id="main-content" class="container my-4 my-md-5 flex-grow-1">
    <c:choose>
        <c:when test="${not empty sessionScope.loggedInUser}">
            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/bookCake" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Custom Cake Studio</a></li>
                    <li class="breadcrumb-item active text-muted" aria-current="page">My Bookings</li>
                </ol>
            </nav>

            <!-- Page Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                <div>
                    <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                        My Cake Reservations
                    </h1>
                    <p class="text-muted small mb-0">Track custom celebration cakes currently in planning, in our ovens, or ready for counter collection</p>
                </div>
                <div class="mt-3 mt-sm-0">
                    <a href="${pageContext.request.contextPath}/bookCake" class="btn btn-maple-primary shadow-sm d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">cake</span> Book Another Cake
                    </a>
                </div>
            </div>

            <!-- Feedback Alerts -->
            <c:if test="${param.msg == 'booked'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-success flex-shrink-0">check_circle</span>
                    <div>
                        <strong class="d-block fw-semibold">Your custom cake reservation has been submitted!</strong>
                        <span class="small">Our master pastry chef will review your request. Booking Reference: <strong class="font-monospace"><c:out value="${param.id}" /></strong></span>
                    </div>
                </div>
            </c:if>

            <c:if test="${param.msg == 'cancelled'}">
                <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #eff6ff; color: #1e40af;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-primary flex-shrink-0">info</span>
                    <div class="small fw-medium">Your cake reservation has been safely cancelled.</div>
                </div>
            </c:if>

            <c:if test="${param.error == 'unauthorized'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">shield_lock</span>
                    <div class="small fw-medium">You do not have authorization to modify this reservation.</div>
                </div>
            </c:if>

            <c:if test="${param.error == 'notfound'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-4 me-3 text-danger flex-shrink-0">error</span>
                    <div class="small fw-medium">The requested cake reservation could not be found.</div>
                </div>
            </c:if>

            <!-- Bookings List -->
            <c:choose>
                <c:when test="${not empty bookings}">
                    <div class="row g-4">
                        <c:forEach var="b" items="${bookings}">
                            <div class="col-12 col-lg-6">
                                <div class="card card-maple h-100 shadow-sm d-flex flex-column justify-content-between p-4 border-0" style="background: #ffffff; border-radius: var(--radius-xl, 16px); box-shadow: 0 6px 24px rgba(7, 1, 0, 0.05);">
                                    <div>
                                        <!-- Header row of card -->
                                        <div class="d-flex justify-content-between align-items-start mb-3 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                            <div>
                                                <span class="badge-status-gold font-monospace px-3 py-1 rounded-pill small fw-bold">
                                                    #${b.bookingId}
                                                </span>
                                                <div class="small text-muted mt-2 d-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined fs-6" style="color: var(--maple-gold-500, #865225);">calendar_today</span>
                                                    <span>Collection Date: <strong>${b.pickupDate}</strong></span>
                                                </div>
                                            </div>

                                            <!-- Status Pill -->
                                            <div>
                                                <c:choose>
                                                    <c:when test="${b.status == 'Pending'}">
                                                        <span class="badge badge-status-warning px-3 py-1 rounded-pill small">
                                                            Pending Review
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'Confirmed'}">
                                                        <span class="badge badge-status-info px-3 py-1 rounded-pill small">
                                                            Confirmed
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'In Preparation' || b.status == 'Baking'}">
                                                        <span class="badge badge-status-gold px-3 py-1 rounded-pill small">
                                                            In the Oven
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'Ready for Pickup'}">
                                                        <span class="badge badge-status-success px-3 py-1 rounded-pill small fw-bold">
                                                            Ready for Pickup!
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'Completed'}">
                                                        <span class="badge badge-status-success px-3 py-1 rounded-pill small">
                                                            Completed
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-status-danger px-3 py-1 rounded-pill small">
                                                            ${b.status}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- Cake Attributes -->
                                        <div class="row g-2 mb-3">
                                            <div class="col-sm-7">
                                                <div class="smaller text-muted text-uppercase fw-semibold" style="letter-spacing: 0.05em; font-size: 0.7rem;">Flavor Profile</div>
                                                <div class="font-playfair fs-5 text-dark fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">${b.flavor}</div>
                                            </div>
                                            <div class="col-sm-5 text-sm-end">
                                                <div class="smaller text-muted text-uppercase fw-semibold" style="letter-spacing: 0.05em; font-size: 0.7rem;">Size &amp; Base Price</div>
                                                <div class="fs-5 fw-bold font-playfair" style="color: var(--maple-gold-600, #6d411b);">
                                                    ${b.sizeInches}" &bull; Rs. <fmt:formatNumber value="${b.calculateBasePrice()}" minFractionDigits="2" maxFractionDigits="2" />
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Inscription & Details -->
                                        <div class="p-3 rounded-3 mb-3" style="background-color: #faf7f2; border: 1px dashed rgba(134,82,37,0.2);">
                                            <div class="smaller text-muted fw-bold text-uppercase mb-1" style="font-size: 0.68rem; letter-spacing: 0.06em;">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-500, #865225);">stylus</span> Royal Piped Inscription:
                                            </div>
                                            <div class="small fst-italic text-dark" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">
                                                <c:choose>
                                                    <c:when test="${not empty b.customMessage}">
                                                        "${b.customMessage}"
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-normal">No custom inscription specified.</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Bottom Actions -->
                                    <div class="pt-3 border-top d-flex justify-content-between align-items-center" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                        <div class="small text-muted">
                                            <c:if test="${b.status == 'Ready for Pickup'}">
                                                <strong class="text-success d-inline-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined fs-6">storefront</span> Visit our counter with reference #${b.bookingId}
                                                </strong>
                                            </c:if>
                                            <c:if test="${b.status != 'Ready for Pickup'}">
                                                <span>Payment upon collection at bakery counter</span>
                                            </c:if>
                                        </div>

                                        <div>
                                            <c:if test="${b.status == 'Pending' || b.status == 'Confirmed'}">
                                                <form action="${pageContext.request.contextPath}/updateBookingStatus" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to cancel booking ${b.bookingId}?');">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-3 py-1 d-inline-flex align-items-center gap-1">
                                                        <span class="material-symbols-outlined fs-6">cancel</span> Cancel Booking
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty State -->
                    <div class="text-center py-5">
                        <div class="card card-maple maple-empty-state shadow-sm mx-auto p-5 border-0" style="max-width: 520px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                            <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                                <span class="material-symbols-outlined fs-1">cake</span>
                            </div>
                            <h3 class="font-playfair fs-4 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Cake Reservations Found</h3>
                            <p class="text-muted small mb-4">
                                You haven't booked any custom celebration cakes yet. Have a birthday, wedding, or special milestone coming up? Let our pastry artists bring your dream cake to life!
                            </p>
                            <div>
                                <a href="${pageContext.request.contextPath}/bookCake" class="btn btn-maple-primary px-4 py-2 shadow-sm d-inline-flex align-items-center justify-content-center gap-2">
                                    <span class="material-symbols-outlined fs-5">palette</span> Design Your Custom Cake
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <!-- Unauthorized Guard -->
            <div class="text-center py-5">
                <div class="card card-maple shadow-sm mx-auto p-5 border-0" style="max-width: 480px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
                    <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                        <span class="material-symbols-outlined fs-1">shield_lock</span>
                    </div>
                    <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Sign In Required</h3>
                    <p class="text-muted small mb-4">You need to be signed in to your Maple &amp; Crumb account to view your cake bookings and status.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=myBookings" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In Now
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
