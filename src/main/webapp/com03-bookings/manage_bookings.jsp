<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Cake Bookings — Maple &amp; Crumb</title>
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
        com.mapleandcrumb.dao.comp03.CustomCakeDAO cakeDao = new com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl();
        request.setAttribute("bookings", cakeDao.getAllBookings());
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
        <div class="mc-admin-layout-wrapper">
            <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                <jsp:param name="activeTab" value="bookings" />
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
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Cake Reservations</li>
                            </ol>
                        </nav>
                    </div>
                </header>

                <main id="main-content" class="mc-admin-main-body p-4 p-md-5">
            <!-- Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                <div>
                    <nav aria-label="breadcrumb" class="mb-2">
                        <ol class="breadcrumb small mb-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Dashboard</a></li>
                            <li class="breadcrumb-item active text-muted" aria-current="page">Custom Cake Inquiries</li>
                        </ol>
                    </nav>
                    <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                        Custom Cake Bookings Console
                    </h1>
                    <p class="text-muted small mb-0">Review artisan celebration cake inquiries, manage baking queues, and update fulfillment status</p>
                </div>
                <div class="mt-3 mt-sm-0 d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="btn btn-sm btn-maple-secondary rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                        <span class="material-symbols-outlined fs-6">dashboard</span> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/bookCake" class="btn btn-sm btn-maple-primary shadow-sm d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-6">add_circle</span> New Cake Order
                    </a>
                </div>
            </div>

            <!-- Feedback Alerts -->
            <c:if test="${param.msg == 'statusUpdated'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                    <div class="small fw-medium">Cake booking status updated successfully!</div>
                </div>
            </c:if>
            <c:if test="${param.msg == 'cancelled'}">
                <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #eff6ff; color: #1e40af;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">info</span>
                    <div class="small fw-medium">Cake reservation was marked as Cancelled.</div>
                </div>
            </c:if>
            <c:if test="${param.error == 'notfound'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                    <div class="small fw-medium">The specified cake booking was not found.</div>
                </div>
            </c:if>

            <!-- Metrics Summary Cards -->
            <c:set var="totalCount" value="${bookings.size()}" />
            <c:set var="pendingCount" value="0" />
            <c:set var="confirmedCount" value="0" />
            <c:set var="readyCount" value="0" />
            <c:forEach var="b" items="${bookings}">
                <c:if test="${b.status == 'Pending'}">
                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                </c:if>
                <c:if test="${b.status == 'Confirmed' || b.status == 'In Preparation' || b.status == 'Baking'}">
                    <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                </c:if>
                <c:if test="${b.status == 'Ready for Pickup'}">
                    <c:set var="readyCount" value="${readyCount + 1}" />
                </c:if>
            </c:forEach>

            <div class="row g-3 mb-4">
                <div class="col-6 col-md-3">
                    <div class="card card-maple p-3 shadow-sm h-100 border-0" style="background: #ffffff; border-radius: var(--radius-lg, 12px);">
                        <span class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Total Inquiries</span>
                        <h3 class="fw-bold font-playfair mb-0 mt-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">${totalCount}</h3>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card card-maple p-3 shadow-sm h-100 border-0" style="background: #ffffff; border-radius: var(--radius-lg, 12px);">
                        <span class="smaller text-uppercase fw-semibold" style="color: #b45309; font-size: 0.7rem; letter-spacing: 0.05em;">Pending Review</span>
                        <h3 class="fw-bold font-playfair mb-0 mt-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: #b45309;">${pendingCount}</h3>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card card-maple p-3 shadow-sm h-100 border-0" style="background: #ffffff; border-radius: var(--radius-lg, 12px);">
                        <span class="smaller text-uppercase fw-semibold" style="color: var(--maple-gold-600, #6d411b); font-size: 0.7rem; letter-spacing: 0.05em;">In Preparation</span>
                        <h3 class="fw-bold font-playfair mb-0 mt-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-gold-600, #6d411b);">${confirmedCount}</h3>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="card card-maple p-3 shadow-sm h-100 border-0" style="background: #ffffff; border-radius: var(--radius-lg, 12px);">
                        <span class="smaller text-uppercase fw-semibold text-success" style="font-size: 0.7rem; letter-spacing: 0.05em;">Ready for Counter</span>
                        <h3 class="fw-bold font-playfair text-success mb-0 mt-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${readyCount}</h3>
                    </div>
                </div>
            </div>

            <!-- Search and Filter Bar -->
            <div class="row g-3 align-items-center justify-content-between mb-3">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">
                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                        </span>
                        <input type="text" id="bookingSearchInput" class="form-control form-control-maple border-start-0 ps-1" placeholder="Search by booking code, customer, flavor, or status..." onkeyup="filterBookingsTable()" aria-label="Search bookings" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                    </div>
                </div>
                <div class="col-auto d-flex flex-wrap gap-2" role="group" aria-label="Filter Bookings by Status">
                    <button type="button" class="btn btn-sm btn-maple-primary rounded-pill px-3 active" aria-pressed="true" id="bookingFilterAll" onclick="setStatusFilter('ALL', this)">All</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="bookingFilterPending" onclick="setStatusFilter('Pending', this)">Pending</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="bookingFilterConfirmed" onclick="setStatusFilter('Confirmed', this)">Confirmed</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="bookingFilterInPrep" onclick="setStatusFilter('In Preparation', this)">In Preparation</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="bookingFilterReady" onclick="setStatusFilter('Ready for Pickup', this)">Ready for Pickup</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="bookingFilterCompleted" onclick="setStatusFilter('Completed', this)">Completed</button>
                    <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" id="bookingFilterCancelled" onclick="setStatusFilter('Cancelled', this)">Cancelled</button>
                </div>
            </div>

            <!-- Bookings Table Card -->
            <div class="card card-maple shadow-sm p-0 overflow-hidden border-0" style="background: #ffffff; border-radius: var(--radius-lg, 12px); box-shadow: 0 4px 20px rgba(7, 1, 0, 0.05);">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 maple-table" id="bookingsTable">
                        <thead style="background-color: #f7f3ed; color: var(--maple-dark-900, #070100);">
                            <tr>
                                <th class="ps-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Booking Ref</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Customer</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Cake Details</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Royal Inscription</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Pickup Date</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Base Price</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Status</th>
                                <th class="text-end pe-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Update Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty bookings}">
                                    <c:forEach var="b" items="${bookings}">
                                        <tr class="booking-row" data-status="${b.status}" style="border-bottom: 1px solid rgba(43, 24, 16, 0.06);">
                                            <!-- Booking ID -->
                                            <td class="ps-4">
                                                <strong class="font-monospace text-dark small">#${b.bookingId}</strong>
                                            </td>

                                            <!-- Customer -->
                                            <td>
                                                <div class="small fw-semibold text-dark">${b.customerId}</div>
                                            </td>

                                            <!-- Cake Specs -->
                                            <td>
                                                <div class="fw-bold font-playfair text-dark" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${b.flavor}</div>
                                                <div class="smaller text-muted">${b.sizeInches}" Diameter Cake</div>
                                            </td>

                                            <!-- Inscription & Notes -->
                                            <td style="max-width: 240px;">
                                                <div class="small text-truncate fst-italic" title="${b.customMessage}" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">
                                                    <c:choose>
                                                        <c:when test="${not empty b.customMessage}">
                                                            "${b.customMessage}"
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted fst-normal smaller">None</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <!-- Pickup Date -->
                                            <td>
                                                <span class="badge bg-light text-dark border px-2 py-1 small">
                                                    <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-500, #865225);">event</span>${b.pickupDate}
                                                </span>
                                            </td>

                                            <!-- Price -->
                                            <td>
                                                <strong class="font-playfair fs-6" style="color: var(--maple-gold-600, #6d411b);">
                                                    Rs. <fmt:formatNumber value="${b.calculateBasePrice()}" minFractionDigits="2" maxFractionDigits="2" />
                                                </strong>
                                            </td>

                                            <!-- Status Badge -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${b.status == 'Pending'}">
                                                        <span class="badge badge-status-warning px-3 py-1 rounded-pill small">Pending</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'Confirmed'}">
                                                        <span class="badge badge-status-info px-3 py-1 rounded-pill small">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'In Preparation' || b.status == 'Baking'}">
                                                        <span class="badge badge-status-gold px-3 py-1 rounded-pill small">In Preparation</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'Ready for Pickup'}">
                                                        <span class="badge badge-status-success px-3 py-1 rounded-pill small fw-bold">Ready for Pickup</span>
                                                    </c:when>
                                                    <c:when test="${b.status == 'Completed'}">
                                                        <span class="badge badge-status-success px-3 py-1 rounded-pill small">Completed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-status-danger px-3 py-1 rounded-pill small">${b.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Action: Status Dropdown & Update -->
                                            <td class="text-end pe-4 py-3">
                                                <form action="${pageContext.request.contextPath}/updateBookingStatus" method="post" class="d-inline-flex gap-1 align-items-center">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    <select name="status" class="form-select form-select-sm form-control-maple" style="width: 145px; font-size: 0.8rem;" aria-label="Update cake status">
                                                        <option value="Pending" ${b.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="Confirmed" ${b.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                        <option value="In Preparation" ${b.status == 'In Preparation' || b.status == 'Baking' ? 'selected' : ''}>In Preparation</option>
                                                        <option value="Ready for Pickup" ${b.status == 'Ready for Pickup' ? 'selected' : ''}>Ready for Pickup</option>
                                                        <option value="Completed" ${b.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                                        <option value="Cancelled" ${b.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-sm btn-maple-primary rounded-2 px-2 py-1" title="Update Booking Status" aria-label="Confirm status update">
                                                        <span class="material-symbols-outlined fs-6">check</span>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <tr id="noBookingsFoundRow" class="d-none">
                                        <td colspan="8" class="text-center py-5">
                                            <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 56px; height: 56px; background: rgba(134,82,37,0.08); color: var(--maple-gold-500, #865225);">
                                                <span class="material-symbols-outlined fs-2">search_off</span>
                                            </div>
                                            <h5 class="fw-semibold text-dark mb-1 font-playfair">No Matching Reservations</h5>
                                            <p class="text-muted small mb-3">No cake reservations match your search or filter criteria.</p>
                                            <button type="button" class="btn btn-sm btn-maple-secondary" onclick="resetBookingFilters()">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1">replay</span> Reset Filters
                                            </button>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 60px; height: 60px; background: rgba(134,82,37,0.08); color: var(--maple-gold-500, #865225);">
                                                <span class="material-symbols-outlined fs-1">cake</span>
                                            </div>
                                            <div class="fw-semibold text-dark fs-5 mb-1 font-playfair">No custom cake requests found</div>
                                            <p class="small text-muted mb-0">Custom cake inquiries and bakery bookings will appear here.</p>
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
            <div class="card card-maple shadow-sm mx-auto p-5 border-0 rounded-4" style="max-width: 480px; background: #ffffff;">
                <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                    <span class="material-symbols-outlined fs-1">shield_lock</span>
                </div>
                <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Access Restricted</h3>
                <p class="text-muted small mb-4">You must have administrative or staff privileges to view and manage custom cake reservations.</p>
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
