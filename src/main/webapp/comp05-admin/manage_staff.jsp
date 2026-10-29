<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Staff Roster — Maple &amp; Crumb</title>
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
if (request.getAttribute("staffList") == null) {
com.mapleandcrumb.dao.comp05.StaffDAO sDao = new com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl();
request.setAttribute("staffList", sDao.getAllStaff());
}
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN'}">
        <div class="mc-admin-layout-wrapper">
            <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                <jsp:param name="activeTab" value="staff" />
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
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Staff Directory</li>
                            </ol>
                        </nav>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/comp05-admin/add_staff.jsp" class="btn btn-sm btn-maple-primary rounded-3 px-3 py-1.5 shadow-sm d-inline-flex align-items-center gap-1">
                            <span class="material-symbols-outlined fs-6">person_add</span> Register New Staff
                        </a>
                    </div>
                </header>

                <main id="main-content" class="mc-admin-main-body p-4 p-md-5">
                    <!-- Breadcrumb Navigation -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb small">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Management</a></li>
                            <li class="breadcrumb-item active text-muted" aria-current="page">Staff Directory</li>
                        </ol>
                    </nav>

                    <!-- Page Header -->
                    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom maple-section-divider">
                        <div>
                            <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                                <span class="material-symbols-outlined fs-6">badge</span> Human Resources &amp; Roster
                            </div>
                            <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                                Staff Directory &amp; Roster
                            </h1>
                            <p class="text-muted small mb-0">Manage internal bakery team members, administrative privileges, and monthly compensation.</p>
                        </div>
                        <div class="mt-3 mt-sm-0">
                            <a href="${pageContext.request.contextPath}/comp05-admin/add_staff.jsp" class="btn btn-maple-primary shadow-sm rounded-3 px-3 py-2 d-inline-flex align-items-center gap-2">
                                <span class="material-symbols-outlined fs-5">person_add</span> Register New Staff
                            </a>
                        </div>
                    </div>

                    <!-- Feedback Alerts -->
                    <c:if test="${param.msg == 'removed'}">
                        <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                            <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                            <div class="small fw-medium"><strong>Staff member removed.</strong> The staff credentials have been decommissioned and access revoked.</div>
                        </div>
                    </c:if>
                    <c:if test="${param.msg == 'added'}">
                        <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                            <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                            <div class="small fw-medium"><strong>Account created!</strong> New bakery staff member was onboarded successfully.</div>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'cannotRemoveSelf'}">
                        <div class="alert alert-warning d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fffbeb; color: #92400e;" role="alert">
                            <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">shield</span>
                            <div class="small fw-medium"><strong>Action restricted:</strong> You cannot decommission your own active administrator account while logged in.</div>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'invalid'}">
                        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                            <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                            <div class="small fw-medium"><strong>Invalid Request:</strong> Staff ID was not found or could not be processed.</div>
                        </div>
                    </c:if>

                    <!-- Metrics Summary Cards -->
                    <c:set var="totalStaffCount" value="${not empty staffList ? staffList.size() : 2}" />
                    <c:set var="adminCount" value="0" />
                    <c:set var="totalPayroll" value="0" />
                    <c:choose>
                        <c:when test="${not empty staffList}">
                            <c:forEach var="st" items="${staffList}">
                                <c:if test="${st.userRole == 'ADMIN'}">
                                    <c:set var="adminCount" value="${adminCount + 1}" />
                                </c:if>
                                <c:set var="totalPayroll" value="${totalPayroll + st.monthlySalary}" />
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:set var="adminCount" value="1" />
                            <c:set var="totalPayroll" value="7700" />
                        </c:otherwise>
                    </c:choose>

                    <div class="row g-3 mb-4">
                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Total Staff</span>
                                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">group</span>
                                </div>
                                <h3 class="font-playfair text-dark mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">${totalStaffCount}</h3>
                                <span class="text-muted fs-xs" style="font-size: 0.75rem;">Active team members</span>
                            </div>
                        </div>
                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="smaller text-uppercase fw-semibold text-danger" style="font-size: 0.7rem; letter-spacing: 0.05em;">Administrators</span>
                                    <span class="material-symbols-outlined fs-5 text-danger">shield_person</span>
                                </div>
                                <h3 class="font-playfair text-danger mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${adminCount}</h3>
                                <span class="text-muted fs-xs" style="font-size: 0.75rem;">Elevated privileges</span>
                            </div>
                        </div>
                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="smaller text-uppercase fw-semibold" style="color: var(--maple-gold-600, #6d411b); font-size: 0.7rem; letter-spacing: 0.05em;">Bakery Staff</span>
                                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">bakery_dining</span>
                                </div>
                                <h3 class="font-playfair mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-gold-600, #6d411b);">${totalStaffCount - adminCount}</h3>
                                <span class="text-muted fs-xs" style="font-size: 0.75rem;">Operations &amp; kitchen</span>
                            </div>
                        </div>
                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card border-0 shadow-sm p-3 h-100">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="smaller text-uppercase fw-semibold text-success" style="font-size: 0.7rem; letter-spacing: 0.05em;">Monthly Payroll</span>
                                    <span class="material-symbols-outlined fs-5 text-success">payments</span>
                                </div>
                                <h3 class="font-playfair text-success mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">Rs. <fmt:formatNumber value="${totalPayroll}" minFractionDigits="2" maxFractionDigits="2"/></h3>
                                <span class="text-muted fs-xs" style="font-size: 0.75rem;">Total compensation allocation</span>
                            </div>
                        </div>
                    </div>

                    <!-- Search & Filter Controls -->
                    <div class="row g-3 align-items-center justify-content-between mb-3">
                        <div class="col-12 col-md-5">
                            <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);">
                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                        </span>
                                <input type="search" id="staffSearchInput" class="form-control form-control-maple border-start-0 ps-1" placeholder="Search by name, ID, or email..." aria-label="Search staff roster" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                            </div>
                        </div>
                        <div class="col-12 col-md-6 text-md-end">
                            <div class="d-inline-flex flex-wrap gap-2" role="group" aria-label="Filter by Role">
                                <button type="button" class="btn btn-sm btn-maple-primary rounded-pill px-3 active" aria-pressed="true" data-role-filter="ALL">All Roles</button>
                                <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" data-role-filter="ADMIN">Admins Only</button>
                                <button type="button" class="btn btn-sm btn-maple-secondary rounded-pill px-3" aria-pressed="false" data-role-filter="STAFF">Bakery Staff</button>
                            </div>
                        </div>
                    </div>

                    <!-- Staff Table Card -->
                    <div class="card card-maple maple-panel-card border-0 shadow-sm p-0 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 maple-table" id="staffTable">
                                <thead style="background-color: #f7f3ed; color: var(--maple-dark-900, #070100);">
                                <tr>
                                    <th scope="col" class="ps-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Staff Member</th>
                                    <th scope="col" class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Role &amp; Access</th>
                                    <th scope="col" class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Contact Information</th>
                                    <th scope="col" class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Monthly Compensation</th>
                                    <th scope="col" class="text-end pe-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Actions</th>
                                </tr>
                                </thead>
                                <tbody id="staffTableBody">
                                <c:choose>
                                    <c:when test="${not empty staffList}">
                                        <c:forEach var="s" items="${staffList}">
                                            <tr class="staff-row" data-role="${s.userRole}" data-search="${s.username} ${s.staffId} ${s.email}" style="border-bottom: 1px solid rgba(43, 24, 16, 0.06);">
                                                <td class="ps-4 py-3">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-xs" style="width: 42px; height: 42px; background: linear-gradient(135deg, var(--maple-gold-600, #6d411b), var(--maple-dark-900, #070100)); font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-size: 1.1rem;">
                                                            ${s.username.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold text-dark mb-0">${s.username}</div>
                                                            <span class="badge-status-gold font-monospace px-2 py-0 rounded-pill small" style="font-size: 0.7rem;">#${s.staffId}</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="py-3">
                                                    <c:choose>
                                                        <c:when test="${s.userRole == 'ADMIN'}">
                                                        <span class="badge badge-status-danger px-2.5 py-1 rounded-pill small">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1">admin_panel_settings</span> Admin
                                                        </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                        <span class="badge badge-status-info px-2.5 py-1 rounded-pill small">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1">person</span> Staff Member
                                                        </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="py-3">
                                                    <div class="small text-dark mb-1">
                                                        <a href="mailto:${s.email}" class="text-decoration-none text-muted">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-600, #6d411b);">mail</span> ${s.email}
                                                        </a>
                                                    </div>
                                                    <div class="small text-muted">
                                                        <a href="tel:${s.phone}" class="text-decoration-none text-muted">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-600, #6d411b);">call</span> ${s.phone}
                                                        </a>
                                                    </div>
                                                </td>
                                                <td class="py-3">
                                                    <span class="fw-bold font-playfair fs-5" style="color: var(--maple-dark-900, #070100);">Rs. <fmt:formatNumber value="${s.monthlySalary}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                                    <span class="text-muted fs-xs"> / mo</span>
                                                </td>
                                                <td class="text-end pe-4 py-3">
                                                    <c:choose>
                                                        <c:when test="${s.userID == sessionScope.loggedInUser.userID}">
                                                        <span class="badge bg-light text-muted border rounded-pill px-3 py-1 small" title="Active signed-in user">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1 text-success">verified</span> Current Account
                                                        </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="${pageContext.request.contextPath}/removeStaff" method="post" class="d-inline" onsubmit="return confirm('Revoke credentials and remove ${s.username} (${s.staffId}) from the staff roster?');">
                                                                <input type="hidden" name="staffId" value="${s.staffId}">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger px-3 rounded-pill d-inline-flex align-items-center gap-1" title="Decommission staff account">
                                                                    <span class="material-symbols-outlined fs-6">delete</span> Remove
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 60px; height: 60px; background: rgba(134,82,37,0.08); color: var(--maple-gold-500, #865225);">
                                                    <span class="material-symbols-outlined fs-1">group</span>
                                                </div>
                                                <div class="fw-semibold text-dark fs-5 mb-1 font-playfair">No staff registered</div>
                                                <p class="small text-muted mb-0">Use the button above to register your first bakery team member.</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                <!-- No Results Matching Search / Filter -->
                                <tr id="noStaffFoundRow" class="d-none">
                                    <td colspan="5" class="text-center py-5">
                                        <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 56px; height: 56px; background: rgba(134,82,37,0.08); color: var(--maple-gold-500, #865225);">
                                            <span class="material-symbols-outlined fs-2">person_search</span>
                                        </div>
                                        <h5 class="fw-semibold text-dark mb-1 font-playfair">No Staff Members Found</h5>
                                        <p class="text-muted small mb-3">No team members match your current search or filter criteria.</p>
                                        <button type="button" class="btn btn-sm btn-maple-secondary" id="resetStaffFilterBtn">
                                            <span class="material-symbols-outlined fs-6 align-middle me-1">replay</span> Reset Filters
                                        </button>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <!-- Unauthorized Access Guard -->
        <main class="container my-5 py-5 flex-grow-1 text-center">
            <div class="card card-maple maple-panel-card shadow-sm mx-auto p-5 border-0 rounded-4" style="max-width: 480px; background: #ffffff;">
                <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                    <span class="material-symbols-outlined fs-1">shield_lock</span>
                </div>
                <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Administrator Access Required</h3>
                <p class="text-muted small mb-4">Access to the bakery staff roster, privileges, and payroll details is restricted to Super Administrators.</p>
                <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2 rounded-pill shadow-sm">
                    <span class="material-symbols-outlined fs-5">login</span> Sign In as Administrator
                </a>
            </div>
        </main>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
