<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Inventory Management — Maple &amp; Crumb</title>
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
    if (request.getAttribute("products") == null) {
        com.mapleandcrumb.dao.comp02.ProductDAO pDao = new com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl();
        request.setAttribute("products", pDao.getAllProducts());
    }
%>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
        <div class="mc-admin-layout-wrapper">
            <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                <jsp:param name="activeTab" value="products" />
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
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Product Catalogue</li>
                            </ol>
                        </nav>
                    </div>
                </header>

                <main id="main-content" class="mc-admin-main-body p-4 p-md-5">

            <!-- Header with Title & Action Button -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                <div>
                    <nav aria-label="breadcrumb" class="mb-2">
                        <ol class="breadcrumb small mb-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Dashboard</a></li>
                            <li class="breadcrumb-item active text-muted" aria-current="page">Inventory Management</li>
                        </ol>
                    </nav>
                    <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                        Product Inventory Management
                    </h1>
                    <p class="text-muted small mb-0">Monitor catalog items, real-time stock levels, and product availability</p>
                </div>
                <div class="mt-3 mt-sm-0">
                    <a href="${pageContext.request.contextPath}/comp02-products/add_product.jsp" class="btn btn-maple-primary shadow-sm d-inline-flex align-items-center gap-2">
                        <span class="material-symbols-outlined fs-5">add_circle</span> Add New Product
                    </a>
                </div>
            </div>

            <!-- Feedback Messages -->
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                    <div class="small fw-medium">Product was successfully removed from inventory catalogue.</div>
                </div>
            </c:if>
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                    <div class="small fw-medium">New handcrafted product successfully added to catalogue!</div>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #ecfdf5; color: #065f46;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">check_circle</span>
                    <div class="small fw-medium">Product details and pricing successfully updated!</div>
                </div>
            </c:if>
            <c:if test="${param.error == 'notfound'}">
                <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
                    <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
                    <div class="small fw-medium">Product not found or could not be loaded.</div>
                </div>
            </c:if>

            <!-- Table Search & Filter Bar -->
            <div class="row g-3 align-items-center justify-content-between mb-3">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">
                            <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                        </span>
                        <input type="text" id="adminTableSearch" class="form-control form-control-maple border-start-0 ps-1" placeholder="Filter by product name, ID or category..." onkeyup="filterAdminTable()" aria-label="Search product table" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                    </div>
                </div>
                <div class="col-auto text-muted small d-flex align-items-center gap-1">
                    <span class="material-symbols-outlined fs-6" style="color: var(--maple-gold-500, #865225);">inventory</span>
                    <span>Real-time catalogue inventory</span>
                </div>
            </div>

            <!-- Product Management Table Card -->
            <div class="card card-maple maple-panel-card shadow-sm p-0 overflow-hidden border-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 maple-table" id="adminProductTable">
                        <thead style="background-color: #f7f3ed; color: var(--maple-dark-900, #070100);">
                            <tr>
                                <th class="ps-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">ID</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Product Name &amp; Category</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Unit Price</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Stock Status</th>
                                <th class="py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Specifications</th>
                                <th class="text-end pe-4 py-3" style="font-size: 0.75rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--maple-dark-900, #070100);">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty products}">
                                    <c:forEach var="prod" items="${products}">
                                        <tr class="product-row" style="border-bottom: 1px solid rgba(43, 24, 16, 0.06);">
                                            <td class="ps-4 fw-semibold text-secondary prod-id font-monospace small">#${prod.productId}</td>
                                            <td class="prod-info py-3">
                                                <div class="fw-bold prod-name" style="color: var(--maple-dark-900, #070100); font-size: 0.95rem;">${prod.name}</div>
                                                <span class="badge ${prod.category == 'Cake' ? 'badge-status-danger' : (prod.category == 'Bread' ? 'badge-status-info' : 'badge-status-gold')} text-uppercase tracking-wider px-2 py-0 mt-1" style="font-size: 0.65rem; letter-spacing: 0.06em;">
                                                    ${prod.category}
                                                </span>
                                            </td>
                                            <td class="fw-bold font-playfair fs-6" style="color: var(--maple-dark-900, #070100);">
                                                Rs. <fmt:formatNumber value="${prod.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td>
                                                <span class="badge ${prod.stockQuantity > 5 ? 'badge-status-success' : (prod.stockQuantity > 0 ? 'badge-status-warning' : 'badge-status-danger')} px-2 py-1" style="font-size: 0.75rem;">
                                                    <c:choose>
                                                        <c:when test="${prod.stockQuantity > 5}">${prod.stockQuantity} in stock</c:when>
                                                        <c:when test="${prod.stockQuantity > 0}">Low: ${prod.stockQuantity} left</c:when>
                                                        <c:otherwise>Out of stock</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="small text-muted" style="max-width: 280px; line-height: 1.4;">${prod.displayDescription}</td>
                                            <td class="text-end pe-4 py-3">
                                                <div class="d-inline-flex gap-1" role="group" aria-label="Product actions">
                                                    <a href="${pageContext.request.contextPath}/editProduct?productId=${prod.productId}" class="btn btn-sm btn-maple-secondary rounded-2 px-2 py-1 d-inline-flex align-items-center gap-1" title="Edit Product">
                                                        <span class="material-symbols-outlined fs-6">edit</span> Edit
                                                    </a>
                                                    <form action="${pageContext.request.contextPath}/deleteProduct" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete ${prod.name}?');">
                                                        <input type="hidden" name="productId" value="${prod.productId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-2 py-1 d-inline-flex align-items-center gap-1" title="Delete Product" aria-label="Delete ${prod.name}">
                                                            <span class="material-symbols-outlined fs-6">delete</span>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 60px; height: 60px; background: rgba(134,82,37,0.08); color: var(--maple-gold-500, #865225);">
                                                <span class="material-symbols-outlined fs-1">inventory_2</span>
                                            </div>
                                            <div class="fw-semibold text-dark fs-5 mb-1 font-playfair">No products in catalogue</div>
                                            <p class="small text-muted mb-3">Click below to create your first handcrafted bakery product.</p>
                                            <a href="${pageContext.request.contextPath}/comp02-products/add_product.jsp" class="btn btn-sm btn-maple-primary">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1">add_circle</span> Add First Product
                                            </a>
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
        <!-- Unauthorized Access Warning -->
        <main class="container my-5 py-5 flex-grow-1 text-center">
            <div class="card card-maple maple-panel-card shadow-sm mx-auto p-5 border-0 rounded-4" style="max-width: 480px; background: #ffffff;">
                <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                    <span class="material-symbols-outlined fs-1">shield_lock</span>
                </div>
                <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Staff Access Required</h3>
                <p class="text-muted small mb-4">You must be signed in as an authorized Staff member or Administrator to access inventory controls.</p>
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
