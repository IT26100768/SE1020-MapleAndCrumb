<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Staff - Maple &amp; Crumb</title>
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
    <!-- Strict Role Guard: Admin Only -->
    <c:choose>
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN'}">
            <!-- Header -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-2 border-bottom">
                <div>
                    <h1 class="page-title fs-2 mb-1">Staff Directory &amp; Roles</h1>
                    <p class="text-muted small mb-0">Manage internal bakery team members, administrative privileges, and compensation</p>
                </div>
                <div class="mt-2 mt-sm-0">
                    <a href="${pageContext.request.contextPath}/comp05-admin/add_staff.jsp" class="btn btn-primary shadow-sm">
                        <i class="bi bi-person-plus me-1"></i> Register New Staff
                    </a>
                </div>
            </div>

            <!-- Feedback Alerts -->
            <c:if test="${param.msg == 'removed'}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                    <div>Staff record was successfully decommissioned.</div>
                </div>
            </c:if>
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                    <div>New staff member registered successfully!</div>
                </div>
            </c:if>

            <!-- Staff Table Card -->
            <div class="card card-maple shadow-sm p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark" style="background-color: var(--mc-espresso);">
                            <tr>
                                <th class="ps-4">Staff ID</th>
                                <th>Name &amp; Role</th>
                                <th>Email</th>
                                <th>Contact Phone</th>
                                <th>Monthly Salary</th>
                                <th class="text-end pe-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty staffList}">
                                    <c:forEach var="s" items="${staffList}">
                                        <tr>
                                            <td class="ps-4 fw-semibold text-secondary">${s.staffId}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${s.username}</div>
                                                <span class="badge ${s.userRole == 'ADMIN' ? 'bg-danger text-white' : 'bg-secondary-subtle text-secondary'} rounded-pill small">
                                                    ${s.userRole}
                                                </span>
                                            </td>
                                            <td class="small text-muted">${s.email}</td>
                                            <td class="small">${s.phone}</td>
                                            <td class="fw-bold text-dark font-playfair">$<fmt:formatNumber value="${s.monthlySalary}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td class="text-end pe-4">
                                                <form action="${pageContext.request.contextPath}/removeStaff" method="post" class="d-inline" onsubmit="return confirm('Revoke credentials for ${s.username}?');">
                                                    <input type="hidden" name="staffId" value="${s.staffId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                                        <i class="bi bi-trash3 me-1"></i> Remove
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Fallback Sample Rows -->
                                    <tr>
                                        <td class="ps-4 fw-semibold text-secondary">STF-101</td>
                                        <td>
                                            <div class="fw-bold text-dark">Hannah Abbot</div>
                                            <span class="badge bg-danger text-white rounded-pill small">ADMIN</span>
                                        </td>
                                        <td class="small text-muted">hannah@mapleandcrumb.com</td>
                                        <td class="small">+1 (555) 329-8812</td>
                                        <td class="fw-bold text-dark font-playfair">$4,500.00</td>
                                        <td class="text-end pe-4">
                                            <form action="${pageContext.request.contextPath}/removeStaff" method="post" class="d-inline" onsubmit="return confirm('Remove Hannah Abbot?');">
                                                <input type="hidden" name="staffId" value="STF-101">
                                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash3 me-1"></i> Remove</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ps-4 fw-semibold text-secondary">STF-104</td>
                                        <td>
                                            <div class="fw-bold text-dark">Liam Gallagher</div>
                                            <span class="badge bg-secondary-subtle text-secondary rounded-pill small">STAFF</span>
                                        </td>
                                        <td class="small text-muted">liam@mapleandcrumb.com</td>
                                        <td class="small">+1 (555) 781-9943</td>
                                        <td class="fw-bold text-dark font-playfair">$3,200.00</td>
                                        <td class="text-end pe-4">
                                            <form action="${pageContext.request.contextPath}/removeStaff" method="post" class="d-inline" onsubmit="return confirm('Remove Liam Gallagher?');">
                                                <input type="hidden" name="staffId" value="STF-104">
                                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash3 me-1"></i> Remove</button>
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
                    <h3 class="font-playfair text-dark">Head Administrator Privileges Required</h3>
                    <p class="text-muted small mb-4">Access to the staff roster and payroll console is restricted to Super Administrators.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary px-4">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Log In with Admin Account
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>

