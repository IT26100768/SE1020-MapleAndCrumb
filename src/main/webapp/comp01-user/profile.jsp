<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Customer Profile — Maple &amp; Crumb</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,400&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">
    <!-- Google Material Symbols Outlined -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body class="d-flex flex-column min-vh-100" style="background-color: var(--maple-cream-50, #fdfbf7);">
<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<main id="main-content" class="container my-auto py-5 flex-grow-1">
    <c:choose>
        <c:when test="${not empty sessionScope.loggedInUser}">
            <div class="row justify-content-center">
                <div class="col-12 col-md-10 col-lg-8 col-xl-7">
                    <!-- Feedback Alerts -->
                    <c:if test="${param.msg == 'updated'}">
                        <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm"
                             style="background-color: #ecfdf5; color: #065f46;" role="alert">
                            <span class="material-symbols-outlined fs-4 me-3 flex-shrink-0">check_circle</span>
                            <div>
                                <div class="fw-semibold">Profile Updated</div>
                                <div class="small">Your customer contact information has been updated successfully.
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'wrongPassword'}">
                        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm"
                             style="background-color: #fee2e2; color: #991b1b;" role="alert">
                            <span class="material-symbols-outlined fs-4 me-3 flex-shrink-0">lock_reset</span>
                            <div>
                                <strong class="d-block fw-semibold">Incorrect Password</strong>
                                <span class="small">The authorization password entered does not match your account. Your account was not deleted.</span>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'passwordRequired'}">
                        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm"
                             style="background-color: #fee2e2; color: #991b1b;" role="alert">
                            <span class="material-symbols-outlined fs-4 me-3 flex-shrink-0">shield_lock</span>
                            <div>
                                <strong class="d-block fw-semibold">Password Required</strong>
                                <span class="small">You must enter your current account password to authorize permanent deletion.</span>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'deleteFailed'}">
                        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm"
                             style="background-color: #fee2e2; color: #991b1b;" role="alert">
                            <span class="material-symbols-outlined fs-4 me-3 flex-shrink-0">error</span>
                            <div>
                                <strong class="d-block fw-semibold">Deletion Error</strong>
                                <span class="small">We could not process your account deletion at this time. Please try again or contact Maple &amp; Crumb.</span>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'adminCannotDelete'}">
                        <div class="alert alert-warning d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm"
                             style="background-color: #fffbeb; color: #92400e;" role="alert">
                            <span class="material-symbols-outlined fs-4 me-3 flex-shrink-0">admin_panel_settings</span>
                            <div>
                                <strong class="d-block fw-semibold">Action Restricted</strong>
                                <span class="small">Administrator accounts cannot be self-deleted from this customer profile view.</span>
                            </div>
                        </div>
                    </c:if>

                    <!-- Maple & Crumb Profile Card -->
                    <div class="card card-maple maple-panel-card shadow-sm p-4 p-md-5 border-0">
                        <!-- Profile Header -->
                        <div class="d-flex flex-column flex-sm-row align-items-center gap-4 mb-4 pb-4 border-bottom maple-section-divider text-center text-sm-start">
                            <div class="maple-icon-circle-lg flex-shrink-0" aria-hidden="true">
                                <span class="material-symbols-outlined fs-1">account_circle</span>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-sm-start gap-2 mb-1">
                                    <h1 class="page-title fs-2 mb-0"
                                        style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 600;">
                                            ${sessionScope.loggedInUser.username}
                                    </h1>
                                    <span class="badge ${sessionScope.loggedInUser.userRole == 'ADMIN' ? 'badge-status-danger' : (sessionScope.loggedInUser.userRole == 'STAFF' ? 'badge-status-info' : 'badge-status-success')} text-uppercase tracking-wider px-2 py-1"
                                          style="font-size: 0.7rem; letter-spacing: 0.08em;">
                                            ${sessionScope.loggedInUser.userRole}
                                    </span>
                                </div>
                                <p class="text-muted small mb-3">${sessionScope.loggedInUser.email}</p>

                                <c:if test="${sessionScope.loggedInUser.userRole == 'CUSTOMER'}">
                                    <div class="d-flex flex-wrap gap-2 justify-content-center justify-content-sm-start align-items-center">
                                        <a href="${pageContext.request.contextPath}/myBookings"
                                           class="btn btn-sm btn-maple-secondary rounded-pill py-1 px-3 d-inline-flex align-items-center gap-1 text-decoration-none">
                                            <span class="material-symbols-outlined fs-6">cake</span> My Bookings
                                        </a>
                                        <a href="${pageContext.request.contextPath}/myOrders"
                                           class="btn btn-sm btn-maple-secondary rounded-pill py-1 px-3 d-inline-flex align-items-center gap-1 text-decoration-none">
                                            <span class="material-symbols-outlined fs-6">shopping_bag</span> My Orders
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Profile Form -->
                        <form action="${pageContext.request.contextPath}/updateProfile" method="post" id="profileForm"
                              class="needs-validation" novalidate>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-group mb-2">
                                        <label class="form-label small fw-semibold"
                                               style="color: var(--maple-dark-800, #2b1810);">Account Username</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                                                  style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.12);"
                                                  aria-hidden="true">
                                                <span class="material-symbols-outlined fs-5">badge</span>
                                            </span>
                                            <input type="text"
                                                   class="form-control form-control-maple border-start-0 ps-1"
                                                   value="${sessionScope.loggedInUser.username}" readonly
                                                   style="background-color: #faf8f5; border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.12);">
                                        </div>
                                        <div class="form-text text-muted small">Username cannot be altered.</div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group mb-2">
                                        <label class="form-label small fw-semibold"
                                               style="color: var(--maple-dark-800, #2b1810);">Email Address</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                                                  style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.12);"
                                                  aria-hidden="true">
                                                <span class="material-symbols-outlined fs-5">mail</span>
                                            </span>
                                            <input type="email"
                                                   class="form-control form-control-maple border-start-0 ps-1"
                                                   value="${sessionScope.loggedInUser.email}" readonly
                                                   style="background-color: #faf8f5; border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.12);">
                                        </div>
                                        <div class="form-text text-muted small">Primary account identifier.</div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="form-group mb-2">
                                        <label for="profilePhone" class="form-label small fw-semibold"
                                               style="color: var(--maple-dark-800, #2b1810);">Contact Phone <span
                                                class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                                                  style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"
                                                  aria-hidden="true">
                                                <span class="material-symbols-outlined fs-5"
                                                      style="color: var(--maple-gold-500, #865225);">call</span>
                                            </span>
                                            <input type="tel" id="profilePhone" name="phone"
                                                   class="form-control form-control-maple border-start-0 ps-1"
                                                   value="${sessionScope.loggedInUser.phone}" required
                                                   style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                            <div class="invalid-feedback">Phone number is required.</div>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${sessionScope.loggedInUser.userRole == 'CUSTOMER'}">
                                    <div class="col-12">
                                        <div class="form-group mb-2">
                                            <label for="profileAddress" class="form-label small fw-semibold"
                                                   style="color: var(--maple-dark-800, #2b1810);">Delivery Address <span
                                                    class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2 align-items-start pt-2"
                                                      style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"
                                                      aria-hidden="true">
                                                    <span class="material-symbols-outlined fs-5"
                                                          style="color: var(--maple-gold-500, #865225);">home_pin</span>
                                                </span>
                                                <textarea id="profileAddress" name="address"
                                                          class="form-control form-control-maple border-start-0 ps-1"
                                                          rows="3" required
                                                          style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">${sessionScope.loggedInUser.deliveryAddress}</textarea>
                                                <div class="invalid-feedback">Delivery address is required.</div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${sessionScope.loggedInUser.userRole == 'STAFF' || sessionScope.loggedInUser.userRole == 'ADMIN'}">
                                    <div class="col-md-6">
                                        <div class="form-group mb-2">
                                            <label class="form-label small fw-semibold"
                                                   style="color: var(--maple-dark-800, #2b1810);">Staff ID</label>
                                            <input type="text" class="form-control form-control-maple"
                                                   value="${sessionScope.loggedInUser.staffId}" readonly
                                                   style="background-color: #faf8f5;">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-2">
                                            <label class="form-label small fw-semibold"
                                                   style="color: var(--maple-dark-800, #2b1810);">Monthly Salary
                                                (Rs.)</label>
                                            <input type="text" class="form-control form-control-maple"
                                                   value="Rs. ${sessionScope.loggedInUser.monthlySalary}" readonly
                                                   style="background-color: #faf8f5;">
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="d-flex flex-wrap justify-content-between align-items-center pt-4 border-top mt-4 gap-2"
                                 style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                <a href="${pageContext.request.contextPath}/logout"
                                   class="btn btn-outline-danger px-3 d-inline-flex align-items-center gap-1 rounded-3">
                                    <span class="material-symbols-outlined fs-5">logout</span> Sign Out
                                </a>
                                <button type="submit"
                                        class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center gap-1 shadow-sm"
                                        data-loading-text="Saving Changes...">
                                    <span class="material-symbols-outlined fs-5">save</span> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Danger Zone / Delete Account (For Customers) -->
                    <c:if test="${sessionScope.loggedInUser.userRole == 'CUSTOMER'}">
                        <div class="card card-maple border-danger border-opacity-25 shadow-sm mt-4 p-4"
                             style="background: #fffafa; border-radius: var(--radius-xl, 16px);">
                            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3">
                                <div>
                                    <h5 class="card-title text-danger mb-1 font-playfair fs-5 d-flex align-items-center gap-2">
                                        <span class="material-symbols-outlined fs-5">warning</span> Delete Account
                                    </h5>
                                    <p class="card-text text-muted small mb-0">
                                        Permanently delete your Maple &amp; Crumb account, order history, and active
                                        cake bookings.
                                    </p>
                                </div>
                                <div>
                                    <button type="button"
                                            class="btn btn-outline-danger text-nowrap px-3 py-2 d-inline-flex align-items-center gap-1 rounded-3"
                                            data-bs-toggle="modal"
                                            data-bs-target="#deleteAccountModal">
                                        <span class="material-symbols-outlined fs-5">delete_forever</span> Delete
                                        Account
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Modal Dialog for Deleting Account -->
                        <div class="modal fade modal-maple" id="deleteAccountModal" tabindex="-1"
                             aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content border-0 shadow"
                                     style="border-radius: var(--radius-xl, 16px); overflow: hidden;">
                                    <div class="modal-header bg-danger-subtle border-bottom border-danger-subtle px-4 py-3">
                                        <div class="d-flex align-items-center">
                                            <span class="material-symbols-outlined fs-4 text-danger me-2">warning</span>
                                            <h5 class="modal-title font-playfair text-danger mb-0 fs-5"
                                                id="deleteAccountModalLabel">
                                                Delete Account Permanently
                                            </h5>
                                        </div>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/deleteAccount" method="post"
                                          id="deleteAccountForm" onsubmit="return confirmAccountDeletion();">
                                        <div class="modal-body p-4">
                                            <!-- Warning Message Callout -->
                                            <div class="alert alert-danger d-flex align-items-start mb-4 rounded-3 border-0"
                                                 style="background-color: #fee2e2; color: #991b1b;" role="alert">
                                                <span class="material-symbols-outlined fs-3 me-3 flex-shrink-0 text-danger">shield_with_heart</span>
                                                <div>
                                                    <h6 class="alert-heading fw-bold mb-1">Warning: This action cannot
                                                        be undone!</h6>
                                                    <p class="small mb-0">
                                                        You are about to permanently delete your account
                                                        (<strong>${sessionScope.loggedInUser.username}</strong>
                                                        &bull; ${sessionScope.loggedInUser.email}).
                                                        All of your past orders and cake booking requests will be
                                                        permanently deleted from our database.
                                                    </p>
                                                </div>
                                            </div>

                                            <p class="text-muted small mb-3">
                                                To confirm that you really want to delete your account, please enter
                                                your current account password:
                                            </p>

                                            <!-- Password Input Field -->
                                            <div class="form-group mb-2">
                                                <label for="deleteAccountPassword" class="form-label small fw-semibold"
                                                       style="color: var(--maple-dark-800, #2b1810);">
                                                    Current Password <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                                                          style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);"
                                                          aria-hidden="true">
                                                        <span class="material-symbols-outlined fs-5"
                                                              style="color: var(--maple-gold-500, #865225);">key</span>
                                                    </span>
                                                    <input type="password"
                                                           id="deleteAccountPassword"
                                                           name="password"
                                                           class="form-control form-control-maple border-start-0 border-end-0 ps-1"
                                                           placeholder="Enter your current password"
                                                           required
                                                           autocomplete="current-password"
                                                           style="border-color: rgba(43,24,16,0.15);"/>
                                                    <button class="btn btn-outline-secondary border-start-0 bg-light"
                                                            type="button" data-toggle-password="deleteAccountPassword"
                                                            aria-label="Toggle password visibility"
                                                            style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15); color: #66554e;">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </div>
                                                <div class="form-text text-muted small mt-1">
                                                    Password is strictly required to authorize permanent account
                                                    deletion.
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer bg-light px-4 py-3 border-top"
                                             style="border-color: rgba(43,24,16,0.08) !important;">
                                            <button type="button" class="btn btn-secondary px-3 rounded-3"
                                                    data-bs-dismiss="modal">
                                                Cancel &amp; Keep Account
                                            </button>
                                            <button type="submit"
                                                    class="btn btn-danger px-4 rounded-3 d-inline-flex align-items-center gap-1"
                                                    id="confirmDeleteSubmitBtn">
                                                <span class="material-symbols-outlined fs-5">delete_forever</span>
                                                Permanently Delete Account
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>


                    </c:if>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Unauthorized State -->
            <div class="text-center py-5">
                <div class="card card-maple maple-panel-card shadow-sm mx-auto p-5 border-0" style="max-width: 480px;">
                    <div class="maple-icon-circle-lg mx-auto mb-3">
                        <span class="material-symbols-outlined fs-1">shield_lock</span>
                    </div>
                    <h3 class="font-playfair text-dark fs-3 mb-2"
                        style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">
                        Sign In Required</h3>
                    <p class="text-muted small mb-4">Please log in to view and manage your customer profile and active
                        orders.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp"
                       class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In Now
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>
</body>
</html>