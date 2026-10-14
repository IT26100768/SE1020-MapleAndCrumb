<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - Maple &amp; Crumb</title>
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
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
            <div class="row justify-content-center">
                <div class="col-12 col-md-10 col-lg-8 col-xl-7">

                    <!-- Breadcrumb Navigation -->
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp02-products/manage_products.jsp">Products</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Add Product</li>
                        </ol>
                    </nav>

                    <!-- Add Product Card -->
                    <div class="card card-maple shadow-sm">
                        <div class="card-maple-header text-center mb-4">
                            <div class="card-maple-icon mx-auto mb-3">
                                <i class="bi bi-box-seam-fill"></i>
                            </div>
                            <h1 class="page-title fs-3 mb-1">Add New Bakery Product</h1>
                            <p class="text-muted small mb-0">Create standard cakes and artisanal pastries for catalogue display</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/addProduct" method="post" id="addProductForm">
                            <div class="row g-3">
                                <!-- Product Name -->
                                <div class="col-12">
                                    <div class="form-group mb-3">
                                        <label for="productName" class="form-label">Product Name</label>
                                        <input type="text" id="productName" name="name" class="form-control" placeholder="e.g. Red Velvet Dream Cake" required>
                                    </div>
                                </div>

                                <!-- Category Selection -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="productCategory" class="form-label">Product Category</label>
                                        <select id="productCategory" name="category" class="form-select form-control" onchange="toggleCategoryFields()" required>
                                            <option value="Cake" selected>Standard Cake</option>
                                            <option value="Pastry">Standard Pastry</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Price -->
                                <div class="col-md-6">
                                    <div class="form-group mb-3">
                                        <label for="productPrice" class="form-label">Unit Price ($)</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white text-muted">$</span>
                                            <input type="number" id="productPrice" name="price" class="form-control" placeholder="0.00" step="0.01" min="0.50" required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Stock Quantity -->
                                <div class="col-12">
                                    <div class="form-group mb-3">
                                        <label for="stockQuantity" class="form-label">Initial Stock Quantity</label>
                                        <input type="number" id="stockQuantity" name="stockQuantity" class="form-control" placeholder="e.g. 15" min="0" required>
                                    </div>
                                </div>

                                <!-- Conditional Section: Cake Specifics -->
                                <div class="col-12" id="cakeFieldsSection">
                                    <div class="p-3 bg-light rounded-3 border">
                                        <h6 class="fw-bold text-dark mb-3"><i class="bi bi-cake2 me-1 text-danger"></i> Cake Specific Attributes</h6>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label for="cakeFlavor" class="form-label">Flavor Profile</label>
                                                <input type="text" id="cakeFlavor" name="flavor" class="form-control" placeholder="e.g. Belgian Truffle / Vanilla">
                                            </div>
                                            <div class="col-md-6">
                                                <label for="cakeSize" class="form-label">Size (Inches)</label>
                                                <select id="cakeSize" name="sizeInches" class="form-select form-control">
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
                                    <div class="p-3 bg-light rounded-3 border">
                                        <h6 class="fw-bold text-dark mb-2"><i class="bi bi-shield-exclamation me-1 text-warning"></i> Allergen Information</h6>
                                        <div class="form-check form-switch mt-2">
                                            <input class="form-check-input" type="checkbox" role="switch" id="containsNutsSwitch" name="containsNuts" value="true">
                                            <label class="form-check-label text-dark fw-semibold" for="containsNutsSwitch">Contains Nuts (Almonds, Pecans, Walnuts)</label>
                                        </div>
                                        <div class="form-text small text-muted">Leave unchecked if this item is guaranteed Nut-Free.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center pt-4 border-top mt-4">
                                <a href="${pageContext.request.contextPath}/comp02-products/manage_products.jsp" class="btn btn-outline-maple">
                                    <i class="bi bi-x-circle me-1"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="bi bi-plus-lg me-1"></i> Save Product
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
                <div class="card card-maple shadow-sm mx-auto p-5" style="max-width: 500px;">
                    <div class="fs-1 text-danger mb-3"><i class="bi bi-shield-lock-fill"></i></div>
                    <h3 class="font-playfair text-dark">Staff Access Only</h3>
                    <p class="text-muted small mb-4">Please log in with appropriate administrative privileges to register new products.</p>
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
    function toggleCategoryFields() {
        const category = document.getElementById('productCategory').value;
        const cakeSection = document.getElementById('cakeFieldsSection');
        const pastrySection = document.getElementById('pastryFieldsSection');

        if (category === 'Cake') {
            cakeSection.classList.remove('d-none');
            pastrySection.classList.add('d-none');
        } else {
            cakeSection.classList.add('d-none');
            pastrySection.classList.remove('d-none');
        }
    }
</script>
</body>
</html>

