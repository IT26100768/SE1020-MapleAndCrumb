<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff - Maple &amp; Crumb</title>
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
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN'}">
            <div class="row justify-content-center">
                <div class="col-12 col-md-10 col-lg-8 col-xl-7">

                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/manage_staff.jsp">Staff Directory</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Register Staff</li>
                        </ol>
                    </nav>

                    <!-- Add Staff Card -->
                    <div class="card card-maple shadow-sm">
                        <div class="card-maple-header text-center mb-4">
                            <div class="card-maple-icon mx-auto mb-3">
                                <i class="bi bi-person-fill-gear"></i>
                            </div>
                            <h1 class="page-title fs-3 mb-1">Create Staff Account</h1>
                            <p class="text-muted small mb-0">Register internal bakery personnel and configure administrative tiers</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/addStaff" method="post" id="addStaffForm">
                            <div class="row g-3">
                                <!-- Full Name / Username -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="staffUsername" class="form-label">Full Name / Username</label>
                                        <input type="text" id="staffUsername" name="username" class="form-control" placeholder="e.g. Liam Gallagher" required>
                                    </div>
                                </div>

                                <!-- Email -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="staffEmail" class="form-label">Work Email</label>
                                        <input type="email" id="staffEmail" name="email" class="form-control" placeholder="liam@mapleandcrumb.com" required>
                                    </div>
                                </div>

                                <!-- Password (min 8 chars as per Staff model) -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="staffPassword" class="form-label">Initial Password</label>
                                        <input type="password" id="staffPassword" name="password" class="form-control" placeholder="Minimum 8 characters" minlength="8" required>
                                    </div>
                                </div>

                                <!-- Phone -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="staffPhone" class="form-label">Contact Phone</label>
                                        <input type="tel" id="staffPhone" name="phone" class="form-control" placeholder="+1 (555) 781-9943" required>
                                    </div>
                                </div>

                                <!-- Staff ID -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="staffIdInput" class="form-label">Assigned Staff ID</label>
                                        <input type="text" id="staffIdInput" name="staffId" class="form-control" placeholder="e.g. STF-105" required>
                                    </div>
                                </div>

                                <!-- Monthly Salary -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="staffSalary" class="form-label">Monthly Salary ($)</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white text-muted">$</span>
                                            <input type="number" id="staffSalary" name="monthlySalary" class="form-control" placeholder="3200.00" step="50" min="500" required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Role Selection -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="staffRoleSelect" class="form-label">System Role</label>
                                        <select id="staffRoleSelect" name="role" class="form-select form-control" onchange="toggleAdminTier()" required>
                                            <option value="STAFF" selected>Bakery Staff Member</option>
                                            <option value="ADMIN">System Administrator</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Conditional Admin Level -->
                                <div class="col-md-6 d-none" id="adminLevelGroup">
                                    <div class="form-group mb-3">
                                        <label for="adminLevelSelect" class="form-label">Administrator Level</label>
                                        <select id="adminLevelSelect" name="adminLevel" class="form-select form-control">
                                            <option value="LEVEL_1">Level 1 (Shift Supervisor)</option>
                                            <option value="LEVEL_2">Level 2 (Store Manager)</option>
                                            <option value="SUPER_ADMIN" selected>Super Admin (Full System Access)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center pt-4 border-top mt-4">
                                <a href="${pageContext.request.contextPath}/comp05-admin/manage_staff.jsp" class="btn btn-outline-maple">
                                    <i class="bi bi-x-circle me-1"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="bi bi-check-lg me-1"></i> Create Staff Member
                                </button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Unauthorized Guard -->
            <div class="text-center py-5">
                <div class="card card-maple shadow-sm mx-auto p-5" style="max-width: 500px;">
                    <div class="fs-1 text-danger mb-3"><i class="bi bi-shield-lock-fill"></i></div>
                    <h3 class="font-playfair text-dark">Super Admin Privileges Required</h3>
                    <p class="text-muted small mb-4">You must be logged in as an Administrator to onboard new staff.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary px-4">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Login
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    function toggleAdminTier() {
        const role = document.getElementById('staffRoleSelect').value;
        const adminGroup = document.getElementById('adminLevelGroup');
        if (role === 'ADMIN') {
            adminGroup.classList.remove('d-none');
        } else {
            adminGroup.classList.add('d-none');
        }
    }
</script>
</body>
</html>

