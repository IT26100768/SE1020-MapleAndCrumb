<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product — Maple &amp; Crumb</title>
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
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
            <div class="row justify-content-center">
                <div class="col-12 col-md-10 col-lg-8 col-xl-7">

                    <!-- Breadcrumb Navigation -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb small">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manageProducts" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Products</a></li>
                            <li class="breadcrumb-item active text-muted" aria-current="page">Add Product</li>
                        </ol>
                    </nav>

                    <!-- Add Product Card -->
                    <div class="card card-maple maple-auth-card shadow-sm p-4 p-md-5 border-0">
                        <div class="text-center mb-4">
                            <div class="d-inline-flex align-items-center justify-content-center mb-3 rounded-circle" style="width: 56px; height: 56px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                                <span class="material-symbols-outlined fs-2">add_box</span>
                            </div>
                            <div class="text-uppercase tracking-wider small fw-bold mb-1" style="color: var(--maple-gold-500, #865225); letter-spacing: 0.12em; font-size: 0.75rem;">
                                Inventory Management
                            </div>
                            <h1 class="page-title fs-3 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 600;">
                                Add New Bakery Product
                            </h1>
                            <p class="text-muted small mb-0">Create celebration cakes, artisanal viennoiserie, and crusty sourdough loaves</p>
                        </div>

                        <!-- Error Feedback Banner -->
                        <c:if test="${param.error == 'invalid'}">
                            <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                                <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                                <div class="small fw-medium">Please check your input values. Name, valid price, and stock quantity are required.</div>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/addProduct" method="post" id="addProductForm" class="needs-validation" novalidate>
                            <div class="row g-3">
                                <!-- Product Name -->
                                <div class="col-12">
                                    <div class="form-group mb-2">
                                        <label for="productName" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Product Name <span class="text-danger">*</span></label>
                                        <input type="text" id="productName" name="name" class="form-control form-control-maple" placeholder="e.g. Belgian Dark Chocolate Truffle Cake" required>
                                        <div class="invalid-feedback">Product name is required.</div>
                                    </div>
                                </div>

                                <!-- Category Selection -->
                                <div class="col-md-6">
                                    <div class="form-group mb-2">
                                        <label for="productCategory" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Product Category <span class="text-danger">*</span></label>
                                        <select id="productCategory" name="category" class="form-select form-control-maple" onchange="toggleCategoryFields()" required>
                                            <option value="Cake" selected>Standard Cake</option>
                                            <option value="Pastry">Standard Pastry</option>
                                            <option value="Bread">Artisan Bread</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Price -->
                                <div class="col-md-6">
                                    <div class="form-group mb-2">
                                        <label for="productPrice" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Unit Price (Rs.) <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">Rs.</span>
                                            <input type="number" id="productPrice" name="price" class="form-control form-control-maple border-start-0 ps-1" placeholder="0.00" step="0.01" min="0.50" required style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                            <div class="invalid-feedback">A valid price (min Rs. 0.50) is required.</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Stock Quantity -->
                                <div class="col-12">
                                    <div class="form-group mb-2">
                                        <label for="stockQuantity" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Initial Stock Quantity <span class="text-danger">*</span></label>
                                        <input type="number" id="stockQuantity" name="stockQuantity" class="form-control form-control-maple" placeholder="e.g. 15" min="0" required>
                                        <div class="invalid-feedback">Please enter initial stock quantity.</div>
                                    </div>
                                </div>

                                <!-- Conditional Section: Cake Specifics -->
                                <div class="col-12" id="cakeFieldsSection">
                                    <div class="p-4 rounded-3 border" style="background-color: #faf7f2; border-color: rgba(134,82,37,0.15) !important;">
                                        <h6 class="fw-bold mb-3 d-flex align-items-center gap-2" style="color: var(--maple-dark-900, #070100);">
                                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">cake</span> Cake Specifications
                                        </h6>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label for="cakeFlavor" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Flavor Profile</label>
                                                <input type="text" id="cakeFlavor" name="flavor" class="form-control form-control-maple" placeholder="e.g. Belgian Truffle / Vanilla Raspberry">
                                            </div>
                                            <div class="col-md-6">
                                                <label for="cakeSize" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Diameter (Inches)</label>
                                                <select id="cakeSize" name="sizeInches" class="form-select form-control-maple">
                                                    <option value="6">6-inch (Serves 6–8)</option>
                                                    <option value="8" selected>8-inch (Serves 10–12)</option>
                                                    <option value="10">10-inch (Serves 14–16)</option>
                                                    <option value="12">12-inch (Serves 18–22)</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Conditional Section: Pastry Specifics -->
                                <div class="col-12 d-none" id="pastryFieldsSection">
                                    <div class="p-4 rounded-3 border" style="background-color: #faf7f2; border-color: rgba(134,82,37,0.15) !important;">
                                        <h6 class="fw-bold mb-2 d-flex align-items-center gap-2" style="color: var(--maple-dark-900, #070100);">
                                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">allergy</span> Allergen Guidance
                                        </h6>
                                        <div class="form-check form-switch mt-2">
                                            <input class="form-check-input" type="checkbox" role="switch" id="containsNutsSwitch" name="containsNuts" value="true">
                                            <label class="form-check-label text-dark fw-semibold small" for="containsNutsSwitch">Contains Nuts (Almonds, Pecans, Walnuts, Pistachios)</label>
                                        </div>
                                        <div class="form-text small text-muted">Leave unchecked if this item is strictly Nut-Free.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center pt-4 border-top mt-4" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                <a href="${pageContext.request.contextPath}/manageProducts" class="btn btn-maple-secondary rounded-3 px-3 py-2">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center gap-1 shadow-sm" data-loading-text="Saving Product...">
                                    <span class="material-symbols-outlined fs-5">save</span> Save Product
                                </button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Unauthorized Access Guard -->
            <div class="text-center py-5">
                <div class="card card-maple maple-panel-card shadow-sm mx-auto p-5 border-0" style="max-width: 480px;">
                    <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                        <span class="material-symbols-outlined fs-1">shield_lock</span>
                    </div>
                    <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Staff Access Only</h3>
                    <p class="text-muted small mb-4">Please log in with appropriate administrative privileges to register new products.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2">
                        <span class="material-symbols-outlined fs-5">login</span> Sign In with Staff Account
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
