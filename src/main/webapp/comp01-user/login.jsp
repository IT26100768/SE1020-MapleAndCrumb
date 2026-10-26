<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Customer &amp; Staff Login — Maple &amp; Crumb</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,400&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Google Material Symbols Outlined -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css" />
  </head>
  <body class="d-flex flex-column min-vh-100" style="background-color: var(--maple-cream-50, #fdfbf7);">
    <jsp:include page="/WEB-INF/includes/navbar.jsp" />

    <main id="main-content" class="container my-auto py-5 flex-grow-1">
      <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-5 col-xl-4">
          
          <!-- Maple & Crumb Auth Card -->
          <div class="card card-maple maple-auth-card shadow-sm p-4 p-md-5 border-0">
            
            <div class="text-center mb-4">
              <div class="maple-icon-circle-md mx-auto mb-3">
                <span class="material-symbols-outlined fs-2">lock_open</span>
              </div>
              <div class="text-uppercase tracking-wider small fw-bold mb-1" style="color: var(--maple-gold-500, #865225); letter-spacing: 0.12em; font-size: 0.75rem;">
                Maple &amp; Crumb Pâtisserie
              </div>
              <h1 class="page-title fs-3 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 600;">
                Welcome Back
              </h1>
              <p class="text-muted small mb-0">
                Sign in to manage your orders, custom cakes, and rewards
              </p>
            </div>

            <!-- Feedback Alerts -->
            <c:if test="${not empty sessionScope.loggedInUser}">
              <div class="alert alert-info d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm" style="background-color: #e0f2fe; color: #0369a1;" role="alert">
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">account_circle</span>
                <div class="small fw-medium">
                  Currently signed in as <strong><c:out value="${sessionScope.loggedInUser.username}" /></strong> (${sessionScope.loggedInUser.userRole}).
                  <c:choose>
                    <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
                      <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="alert-link text-decoration-underline ms-1">Operations Hub</a>
                    </c:when>
                    <c:otherwise>
                      <a href="${pageContext.request.contextPath}/comp01-user/profile.jsp" class="alert-link text-decoration-underline ms-1">My Profile</a>
                    </c:otherwise>
                  </c:choose>
                  or <a href="${pageContext.request.contextPath}/logout" class="alert-link text-decoration-underline ms-1">Sign Out</a>.
                </div>
              </div>
            </c:if>
            <c:if test="${param.error == 'invalid'}">
              <div class="alert alert-danger d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                <div class="small fw-medium">Invalid email or password. Please verify and try again.</div>
              </div>
            </c:if>
            <c:if test="${param.error == 'unauthorized'}">
              <div class="alert alert-danger d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">shield_lock</span>
                <div class="small fw-medium">Please sign in with appropriate privileges to continue.</div>
              </div>
            </c:if>
            <c:if test="${param.msg == 'success'}">
              <div class="alert alert-success d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                <div class="small fw-medium">Account created successfully! You may now sign in.</div>
              </div>
            </c:if>
            <c:if test="${param.msg == 'loggedOut'}">
              <div class="alert alert-success d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm" style="background-color: #f5efe6; color: var(--maple-gold-600, #6d411b);" role="alert">
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">waving_hand</span>
                <div class="small fw-medium">You have been safely signed out. See you again soon!</div>
              </div>
            </c:if>
            <c:if test="${param.msg == 'accountDeleted'}">
              <div class="alert alert-warning d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm" style="background-color: #fffbeb; color: #92400e;" role="alert">
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">info</span>
                <div class="small fw-medium">Your account has been deleted. We are sorry to see you go!</div>
              </div>
            </c:if>

            <form
              action="${pageContext.request.contextPath}/login"
              method="post"
              id="loginForm"
              class="needs-validation"
              novalidate
            >
              <div class="form-group mb-3">
                <label for="loginEmail" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Email Address or Username</label>
                <div class="input-group">
                  <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">
                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">person</span>
                  </span>
                  <input
                    type="text"
                    id="loginEmail"
                    name="email"
                    class="form-control form-control-maple border-start-0 ps-1"
                    placeholder="e.g. Eleanor or customer@example.com"
                    required
                    autofocus
                    style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);"
                  />
                  <div class="invalid-feedback">Please enter your email or username.</div>
                </div>
              </div>

              <div class="form-group mb-4">
                <div class="d-flex justify-content-between align-items-center mb-1">
                  <label for="loginPassword" class="form-label small fw-semibold mb-0" style="color: var(--maple-dark-800, #2b1810);">Password</label>
                </div>
                <div class="input-group">
                  <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">
                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">key</span>
                  </span>
                  <input
                    type="password"
                    id="loginPassword"
                    name="password"
                    class="form-control form-control-maple border-start-0 border-end-0 ps-1"
                    placeholder="Enter your password"
                    required
                    style="border-color: rgba(43,24,16,0.15);"
                  />
                  <button class="btn btn-outline-secondary border-start-0 bg-light" type="button" data-toggle-password="loginPassword" aria-label="Toggle password visibility" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15); color: #66554e;">
                    <i class="bi bi-eye"></i>
                  </button>
                  <div class="invalid-feedback">Password is required.</div>
                </div>
              </div>

              <button
                type="submit"
                class="btn btn-maple-primary w-100 py-2 fw-semibold shadow-sm"
                data-loading-text="Signing In..."
                style="letter-spacing: 0.02em;"
              >
                <span class="material-symbols-outlined fs-5 align-middle me-1">login</span> Sign In to Account
              </button>
            </form>

            <div class="text-center mt-4 pt-3 border-top maple-section-divider">
              <p class="small text-muted mb-0">
                New to Maple &amp; Crumb?
                <a
                  href="${pageContext.request.contextPath}/comp01-user/register.jsp"
                  class="fw-semibold text-decoration-none"
                  style="color: var(--maple-gold-600, #6d411b);"
                >Create customer account</a>
              </p>
            </div>
          </div>

          <!-- Bottom micro-copy -->
          <div class="text-center mt-4">
            <span class="small text-muted d-inline-flex align-items-center gap-1">
              <span class="material-symbols-outlined fs-6" style="color: var(--maple-gold-500, #865225);">verified</span>
              Secure customer access &bull; Maple &amp; Crumb
            </span>
          </div>

        </div>
      </div>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />
  </body>
</html>
