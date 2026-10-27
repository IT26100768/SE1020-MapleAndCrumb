<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"
language="java" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Customer Registration — Maple &amp; Crumb</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,400&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <!-- Google Material Symbols Outlined -->
    <link
      rel="stylesheet"
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
    />
    <!-- Bootstrap 5 CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
    />
    <!-- Maple & Crumb Custom Styling -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/maple-crumb.css"
    />
  </head>
  <body
    class="d-flex flex-column min-vh-100"
    style="background-color: var(--maple-cream-50, #fdfbf7)"
  >
    <jsp:include page="/WEB-INF/includes/navbar.jsp" />

    <main id="main-content" class="container my-auto py-5 flex-grow-1">
      <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-5">
          <!-- Maple & Crumb Register Card -->
          <div
            class="card card-maple maple-auth-card shadow-sm p-4 p-md-5 border-0"
          >
            <div class="text-center mb-4">
              <div class="maple-icon-circle-md mx-auto mb-3">
                <span class="material-symbols-outlined fs-2">person_add</span>
              </div>
              <div
                class="text-uppercase tracking-wider small fw-bold mb-1"
                style="
                  color: var(--maple-gold-500, #865225);
                  letter-spacing: 0.12em;
                  font-size: 0.75rem;
                "
              >
                Customer Registration
              </div>
              <h1
                class="page-title fs-3 mb-1"
                style="
                  font-family: var(
                    --font-playfair,
                    &quot;Playfair Display&quot;,
                    Georgia,
                    serif
                  );
                  color: var(--maple-dark-900, #070100);
                  font-weight: 600;
                "
              >
                Create Your Account
              </h1>
              <p class="text-muted small mb-0">
                Create an account to order bespoke cakes, fresh breads, and
                handcrafted pâtisserie
              </p>
            </div>

            <!-- Error Alerts -->
            <c:if test="${param.error == 'duplicate'}">
              <div
                class="alert alert-danger d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm"
                style="background-color: #fee2e2; color: #991b1b"
                role="alert"
              >
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0"
                  >error</span
                >
                <div class="small fw-medium">
                  An account with this email already exists.
                  <a
                    href="${pageContext.request.contextPath}/comp01-user/login.jsp"
                    class="alert-link text-decoration-underline"
                    >Sign in instead</a
                  >.
                </div>
              </div>
            </c:if>
            <c:if test="${param.error == 'invalid'}">
              <div
                class="alert alert-danger d-flex align-items-center mb-3 rounded-3 py-2 px-3 border-0 shadow-sm"
                style="background-color: #fee2e2; color: #991b1b"
                role="alert"
              >
                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0"
                  >warning</span
                >
                <div class="small fw-medium">
                  Please fill in all required fields accurately.
                </div>
              </div>
            </c:if>

            <form
              action="${pageContext.request.contextPath}/register"
              method="post"
              id="registerForm"
              class="needs-validation"
              novalidate
            >
              <div class="form-group mb-3">
                <label
                  for="regUsername"
                  class="form-label small fw-semibold"
                  style="color: var(--maple-dark-800, #2b1810)"
                  >Full Name or Preferred Username
                  <span class="text-danger">*</span></label
                >
                <div class="input-group">
                  <span
                    class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                    style="
                      border-radius: var(--radius-md, 8px) 0 0
                        var(--radius-md, 8px);
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                    aria-hidden="true"
                  >
                    <span
                      class="material-symbols-outlined fs-5"
                      style="color: var(--maple-gold-500, #865225)"
                      >badge</span
                    >
                  </span>
                  <input
                    type="text"
                    id="regUsername"
                    name="username"
                    class="form-control form-control-maple border-start-0 ps-1"
                    placeholder="e.g. Eleanor Vance"
                    required
                    style="
                      border-radius: 0 var(--radius-md, 8px)
                        var(--radius-md, 8px) 0;
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                  />
                  <div class="invalid-feedback">
                    Please enter your full name or username.
                  </div>
                </div>
              </div>

              <div class="form-group mb-3">
                <label
                  for="regEmail"
                  class="form-label small fw-semibold"
                  style="color: var(--maple-dark-800, #2b1810)"
                  >Email Address <span class="text-danger">*</span></label
                >
                <div class="input-group">
                  <span
                    class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                    style="
                      border-radius: var(--radius-md, 8px) 0 0
                        var(--radius-md, 8px);
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                    aria-hidden="true"
                  >
                    <span
                      class="material-symbols-outlined fs-5"
                      style="color: var(--maple-gold-500, #865225)"
                      >mail</span
                    >
                  </span>
                  <input
                    type="email"
                    id="regEmail"
                    name="email"
                    class="form-control form-control-maple border-start-0 ps-1"
                    placeholder="eleanor@example.com"
                    required
                    style="
                      border-radius: 0 var(--radius-md, 8px)
                        var(--radius-md, 8px) 0;
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                  />
                  <div class="invalid-feedback">
                    Please provide a valid email address.
                  </div>
                </div>
              </div>

              <div class="form-group mb-3">
                <label
                  for="regPassword"
                  class="form-label small fw-semibold"
                  style="color: var(--maple-dark-800, #2b1810)"
                  >Create Password <span class="text-danger">*</span></label
                >
                <div class="input-group">
                  <span
                    class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                    style="
                      border-radius: var(--radius-md, 8px) 0 0
                        var(--radius-md, 8px);
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                    aria-hidden="true"
                  >
                    <span
                      class="material-symbols-outlined fs-5"
                      style="color: var(--maple-gold-500, #865225)"
                      >lock</span
                    >
                  </span>
                  <input
                    type="password"
                    id="regPassword"
                    name="password"
                    class="form-control form-control-maple border-start-0 border-end-0 ps-1"
                    placeholder="Minimum 6 characters"
                    minlength="6"
                    required
                    style="border-color: rgba(43, 24, 16, 0.15)"
                  />
                  <button
                    class="btn btn-outline-secondary border-start-0 bg-light"
                    type="button"
                    data-toggle-password="regPassword"
                    aria-label="Toggle password visibility"
                    style="
                      border-radius: 0 var(--radius-md, 8px)
                        var(--radius-md, 8px) 0;
                      border-color: rgba(43, 24, 16, 0.15);
                      color: #66554e;
                    "
                  >
                    <i class="bi bi-eye"></i>
                  </button>
                  <div class="invalid-feedback">
                    Password must be at least 6 characters.
                  </div>
                </div>
              </div>

              <div class="form-group mb-3">
                <label
                  for="regPhone"
                  class="form-label small fw-semibold"
                  style="color: var(--maple-dark-800, #2b1810)"
                  >Contact Phone <span class="text-danger">*</span></label
                >
                <div class="input-group">
                  <span
                    class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2"
                    style="
                      border-radius: var(--radius-md, 8px) 0 0
                        var(--radius-md, 8px);
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                    aria-hidden="true"
                  >
                    <span
                      class="material-symbols-outlined fs-5"
                      style="color: var(--maple-gold-500, #865225)"
                      >call</span
                    >
                  </span>
                  <input
                    type="tel"
                    id="regPhone"
                    name="phone"
                    class="form-control form-control-maple border-start-0 ps-1"
                    placeholder="+94 77 123 4567"
                    required
                    style="
                      border-radius: 0 var(--radius-md, 8px)
                        var(--radius-md, 8px) 0;
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                  />
                  <div class="invalid-feedback">Contact phone is required.</div>
                </div>
              </div>

              <div class="form-group mb-4">
                <label
                  for="regAddress"
                  class="form-label small fw-semibold"
                  style="color: var(--maple-dark-800, #2b1810)"
                  >Delivery Address <span class="text-danger">*</span></label
                >
                <div class="input-group">
                  <span
                    class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2 align-items-start pt-2"
                    style="
                      border-radius: var(--radius-md, 8px) 0 0
                        var(--radius-md, 8px);
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                    aria-hidden="true"
                  >
                    <span
                      class="material-symbols-outlined fs-5"
                      style="color: var(--maple-gold-500, #865225)"
                      >home_pin</span
                    >
                  </span>
                  <textarea
                    id="regAddress"
                    name="address"
                    class="form-control form-control-maple border-start-0 ps-1"
                    rows="3"
                    placeholder="Apartment / Suite, Street Address, City, Postal Code"
                    required
                    style="
                      border-radius: 0 var(--radius-md, 8px)
                        var(--radius-md, 8px) 0;
                      border-color: rgba(43, 24, 16, 0.15);
                    "
                  ></textarea>
                  <div class="invalid-feedback">
                    Delivery address is required for doorstep orders.
                  </div>
                </div>
              </div>

              <button
                type="submit"
                class="btn btn-maple-primary w-100 py-2 fw-semibold shadow-sm"
                data-loading-text="Creating Account..."
                style="letter-spacing: 0.02em"
              >
                <span class="material-symbols-outlined fs-5 align-middle me-1"
                  >how_to_reg</span
                >
                Complete Registration
              </button>
            </form>

            <div class="text-center mt-4 pt-3 border-top maple-section-divider">
              <p class="small text-muted mb-0">
                Already registered?
                <a
                  href="${pageContext.request.contextPath}/comp01-user/login.jsp"
                  class="fw-semibold text-decoration-none"
                  style="color: var(--maple-gold-600, #6d411b)"
                  >Sign in to account</a
                >
              </p>
            </div>
          </div>

          <!-- Bottom micro-copy -->
          <div class="text-center mt-4">
            <span
              class="small text-muted d-inline-flex align-items-center gap-1"
            >
              <span
                class="material-symbols-outlined fs-6"
                style="color: var(--maple-gold-500, #865225)"
                >verified</span
              >
              By joining, you agree to our handcrafted terms &bull; Maple &amp;
              Crumb
            </span>
          </div>
        </div>
      </div>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />
  </body>
</html>
