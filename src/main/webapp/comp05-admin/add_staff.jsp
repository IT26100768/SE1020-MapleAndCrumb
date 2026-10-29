<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Staff Member — Maple &amp; Crumb</title>
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
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main id="main-content" class="container my-4 my-md-5 flex-grow-1">
    <c:choose>
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN'}">
            <div class="row justify-content-center">
                <div class="col-12 col-md-10 col-lg-8 col-xl-7">

                    <!-- Breadcrumb Navigation -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb small">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Management</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/manage_staff.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Staff Directory</a></li>
                            <li class="breadcrumb-item active text-muted" aria-current="page">Register Staff</li>
                        </ol>
                    </nav>

                    <!-- Feedback Alert -->
                    <c:if test="${param.error == 'invalid'}">
                        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                            <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                            <div class="small fw-medium">
                                <strong>Registration Failed:</strong> Please verify all required fields. Password must contain at least 8 characters and monthly compensation must be greater than zero.
                            </div>
                        </div>
                    </c:if>

                    <!-- Add Staff Card -->
                    <div class="card card-maple maple-auth-card border-0 shadow-sm p-4 p-md-5">
                        <div class="text-center mb-4">
                            <div class="d-inline-flex align-items-center justify-content-center mb-3 rounded-circle" style="width: 56px; height: 56px; background: rgba(134,82,37,0.1); color: var(--maple-gold-600, #6d411b);" aria-hidden="true">
                                <span class="material-symbols-outlined fs-2">person_add</span>
                            </div>
                            <div class="text-uppercase tracking-wider small fw-bold mb-1" style="color: var(--maple-gold-500, #865225); letter-spacing: 0.12em; font-size: 0.75rem;">
                                Human Resources
                            </div>
                            <h1 class="font-playfair text-dark mb-1 fs-3 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Onboard Team Member</h1>
                            <p class="text-muted small mb-0">Register internal bakery personnel, allocate monthly compensation, and assign system access tiers.</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/addStaff" method="post" id="addStaffForm" class="needs-validation" novalidate>
                            <div class="row g-3">
                                <!-- Full Name / Username -->
                                <div class="col-md-6">
                                    <label for="staffUsername" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Full Name / Username <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">badge</span></span>
                                        <input type="text" id="staffUsername" name="username" class="form-control form-control-maple border-start-0 ps-1" placeholder="e.g. Liam Gallagher" required style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                        <div class="invalid-feedback">Please enter the employee's full name.</div>
                                    </div>
                                </div>

                                <!-- Work Email -->
                                <div class="col-md-6">
                                    <label for="staffEmail" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Work Email Address <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">mail</span></span>
                                        <input type="email" id="staffEmail" name="email" class="form-control form-control-maple border-start-0 ps-1" placeholder="liam@mapleandcrumb.lk" required style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                        <div class="invalid-feedback">Please provide a valid work email address.</div>
                                    </div>
                                </div>

                                <!-- Password (min 8 chars) -->
                                <div class="col-md-6">
                                    <label for="staffPassword" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Initial Password <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">key</span></span>
                                        <input type="password" id="staffPassword" name="password" class="form-control form-control-maple border-start-0 border-end-0 ps-1" placeholder="Minimum 8 characters" minlength="8" required style="border-color: rgba(43,24,16,0.15);">
                                        <button class="btn btn-outline-secondary border-start-0 bg-light password-toggle-btn" type="button" data-toggle-password="staffPassword" aria-label="Toggle password visibility" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15); color: #66554e;">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <div class="invalid-feedback">Password must be at least 8 characters long.</div>
                                    </div>
                                    <div class="form-text fs-xs text-muted">A minimum of 8 characters is strictly required for staff accounts.</div>
                                </div>

                                <!-- Contact Phone -->
                                <div class="col-md-6">
                                    <label for="staffPhone" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Contact Phone <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">call</span></span>
                                        <input type="tel" id="staffPhone" name="phone" class="form-control form-control-maple border-start-0 ps-1" placeholder="+94 77 781 9943" required style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                        <div class="invalid-feedback">Please provide a contact phone number.</div>
                                    </div>
                                </div>

                                <!-- Staff ID -->
                                <div class="col-md-6">
                                    <label for="staffIdInput" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Assigned Staff ID <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">pin</span></span>
                                        <input type="text" id="staffIdInput" name="staffId" class="form-control form-control-maple border-start-0 ps-1 font-monospace" placeholder="e.g. STF-105" required style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                        <div class="invalid-feedback">Please enter a staff ID.</div>
                                    </div>
                                    <div class="form-text fs-xs text-muted">Format: STF-XXX or unique identifier.</div>
                                </div>

                                <!-- Monthly Salary -->
                                <div class="col-md-6">
                                    <label for="staffSalary" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Monthly Salary (Rs. / LKR) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2 fw-semibold" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);">Rs.</span>
                                        <input type="number" id="staffSalary" name="monthlySalary" class="form-control form-control-maple border-start-0 border-end-0 ps-1" placeholder="3200.00" step="50" min="500" required style="border-color: rgba(43,24,16,0.15);">
                                        <span class="input-group-text bg-light border-start-0 text-muted fs-xs pe-3" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">/ month</span>
                                        <div class="invalid-feedback">Please enter a valid monthly salary (min Rs. 500).</div>
                                    </div>
                                    <div class="form-text fs-xs text-muted">Gross monthly compensation allocation.</div>
                                </div>

                                <!-- System Role -->
                                <div class="col-md-6">
                                    <label for="staffRoleSelect" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">System Role <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">manage_accounts</span></span>
                                        <select id="staffRoleSelect" name="role" class="form-select form-control-maple border-start-0 ps-1" onchange="toggleAdminTier()" required style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                            <option value="STAFF" selected>Bakery Staff Member</option>
                                            <option value="ADMIN">System Administrator</option>
                                        </select>
                                    </div>
                                    <div class="form-text fs-xs text-muted">Staff handles daily inventory &amp; bookings; Admins have system-wide controls.</div>
                                </div>

                                <!-- Conditional Admin Level -->
                                <div class="col-md-6 d-none" id="adminLevelGroup">
                                    <label for="adminLevelSelect" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Administrator Level <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"><span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">shield_lock</span></span>
                                        <select id="adminLevelSelect" name="adminLevel" class="form-select form-control-maple border-start-0 ps-1" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                            <option value="LEVEL_1">Level 1 (Shift Supervisor)</option>
                                            <option value="LEVEL_2">Level 2 (Store Manager)</option>
                                            <option value="SUPER_ADMIN" selected>Super Admin (Full System Access)</option>
                                        </select>
                                    </div>
                                    <div class="form-text fs-xs text-muted">Specifies permission depth across reports and payroll.</div>
                                </div>
                            </div>

                            <!-- Role Info Notice Card -->
                            <div class="p-3 mt-4 rounded-3 d-flex align-items-center gap-2" style="background-color: #faf7f2; border: 1px solid rgba(134,82,37,0.15);">
                                <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">info</span>
                                <div class="small text-muted">
                                    Team accounts are activated immediately upon submission. Staff members can sign in using their registered work email and initial password.
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="d-flex justify-content-between align-items-center pt-4 border-top mt-4" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                <a href="${pageContext.request.contextPath}/comp05-admin/manage_staff.jsp" class="btn btn-maple-secondary px-4 rounded-3">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-maple-primary px-4 shadow-sm rounded-3 d-inline-flex align-items-center gap-2" id="submitStaffBtn" data-loading-text="Onboarding Staff...">
                                    <span class="material-symbols-outlined fs-5">person_add</span> Register Staff Member
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
                <div class="card card-maple maple-panel-card border-0 shadow-sm mx-auto p-4 p-md-5" style="max-width: 480px;">
                    <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                        <span class="material-symbols-outlined fs-1">shield_lock</span>
                    </div>
                    <h3 class="font-playfair text-dark mb-2 fs-3" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Super Admin Privileges Required</h3>
                    <p class="text-muted small mb-4">You must be authenticated with Administrator privileges to onboard new staff team members.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In as Administrator
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
