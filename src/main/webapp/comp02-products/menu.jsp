<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bakery Menu - Maple &amp; Crumb</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="container my-4 my-md-5 flex-grow-1">
    <!-- Menu Header Banner -->
    <div class="text-center mb-5">
        <span class="badge bg-light text-dark border px-3 py-2 rounded-pill mb-2">
            <i class="bi bi-stars text-warning me-1"></i> Fresh From The Oven
        </span>
        <h1 class="page-title text-center d-block">Our Bakery Catalogue</h1>
        <p class="page-subtitle text-center">Handcrafted sourdoughs, artisanal pastries, and signature celebration cakes</p>
    </div>

    <!-- Category Filter Controls & Search -->
    <div class="row g-3 align-items-center justify-content-between mb-4">
        <div class="col-md-6">
            <div class="btn-group" role="group" aria-label="Product Category Filter">
                <button type="button" class="btn btn-outline-maple active" id="filterAll" onclick="filterCategory('ALL')">
                    <i class="bi bi-grid-fill me-1"></i> All Products
                </button>
                <button type="button" class="btn btn-outline-maple" id="filterCakes" onclick="filterCategory('Cake')">
                    🎂 Cakes
                </button>
                <button type="button" class="btn btn-outline-maple" id="filterPastries" onclick="filterCategory('Pastry')">
                    🥐 Pastries
                </button>
            </div>
        </div>
        <div class="col-md-4">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0 text-muted">
                    <i class="bi bi-search"></i>
                </span>
                <input type="text" id="menuSearchInput" class="form-control border-start-0 ps-0" placeholder="Search pastries or cakes..." onkeyup="searchProducts()">
            </div>
        </div>
    </div>

    <!-- Product Grid -->
    <div class="row g-4" id="productGrid">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="prod" items="${products}">
                    <div class="col-sm-6 col-lg-4 product-item" data-category="${prod.category}" data-name="${prod.name.toLowerCase()}">
                        <div class="card card-maple h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge ${prod.category == 'Cake' ? 'bg-danger-subtle text-danger' : 'bg-warning-subtle text-warning-emphasis'} px-2 py-1 rounded-pill small">
                                        ${prod.category}
                                    </span>
                                    <span class="badge ${prod.stockQuantity > 5 ? 'bg-success-subtle text-success' : (prod.stockQuantity > 0 ? 'bg-warning-subtle text-dark' : 'bg-danger-subtle text-danger')} px-2 py-1 rounded-pill small">
                                        <c:choose>
                                            <c:when test="${prod.stockQuantity > 5}">In Stock (${prod.stockQuantity})</c:when>
                                            <c:when test="${prod.stockQuantity > 0}">Low Stock (${prod.stockQuantity})</c:when>
                                            <c:otherwise>Sold Out</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <h4 class="font-playfair text-dark mb-1">${prod.name}</h4>
                                <p class="text-muted small mb-3">${prod.displayDescription}</p>
                            </div>
                            <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                                <span class="fs-5 fw-bold text-dark font-playfair">$<fmt:formatNumber value="${prod.price}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                <a href="${pageContext.request.contextPath}/comp04-orders/checkout.jsp?productId=${prod.productId}" class="btn btn-sm btn-primary px-3 ${prod.stockQuantity == 0 ? 'disabled' : ''}">
                                    <i class="bi bi-cart-plus me-1"></i> Order Now
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Fallback Mock Cards for Design Preview if Servlet has not yet loaded database -->
                <div class="col-sm-6 col-lg-4 product-item" data-category="Cake" data-name="classic chocolate fudge cake">
                    <div class="card card-maple h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-danger-subtle text-danger px-2 py-1 rounded-pill small">Cake</span>
                                <span class="badge bg-success-subtle text-success px-2 py-1 rounded-pill small">In Stock (12)</span>
                            </div>
                            <h4 class="font-playfair text-dark mb-1">Chocolate Fudge Cake</h4>
                            <p class="text-muted small mb-3">8-inch Rich Belgian Chocolate Layer Cake with Silky Ganache - $38.50</p>
                        </div>
                        <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                            <span class="fs-5 fw-bold text-dark font-playfair">$38.50</span>
                            <a href="${pageContext.request.contextPath}/comp04-orders/checkout.jsp?productId=P101" class="btn btn-sm btn-primary px-3">
                                <i class="bi bi-cart-plus me-1"></i> Order Now
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-4 product-item" data-category="Cake" data-name="madagascar vanilla bean sponge">
                    <div class="card card-maple h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-danger-subtle text-danger px-2 py-1 rounded-pill small">Cake</span>
                                <span class="badge bg-success-subtle text-success px-2 py-1 rounded-pill small">In Stock (8)</span>
                            </div>
                            <h4 class="font-playfair text-dark mb-1">Vanilla Bean Sponge</h4>
                            <p class="text-muted small mb-3">6-inch Madagascar Vanilla Bean Cake with Swiss Buttercream - $29.00</p>
                        </div>
                        <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                            <span class="fs-5 fw-bold text-dark font-playfair">$29.00</span>
                            <a href="${pageContext.request.contextPath}/comp04-orders/checkout.jsp?productId=P102" class="btn btn-sm btn-primary px-3">
                                <i class="bi bi-cart-plus me-1"></i> Order Now
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-4 product-item" data-category="Pastry" data-name="artisan butter croissant">
                    <div class="card card-maple h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-warning-subtle text-warning-emphasis px-2 py-1 rounded-pill small">Pastry</span>
                                <span class="badge bg-success-subtle text-success px-2 py-1 rounded-pill small">In Stock (24)</span>
                            </div>
                            <h4 class="font-playfair text-dark mb-1">Butter Croissant</h4>
                            <p class="text-muted small mb-3">Classic French Laminated Pastry (Nut-Free) - $4.50</p>
                        </div>
                        <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                            <span class="fs-5 fw-bold text-dark font-playfair">$4.50</span>
                            <a href="${pageContext.request.contextPath}/comp04-orders/checkout.jsp?productId=P201" class="btn btn-sm btn-primary px-3">
                                <i class="bi bi-cart-plus me-1"></i> Order Now
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-4 product-item" data-category="Pastry" data-name="almond frangipane croissant">
                    <div class="card card-maple h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-warning-subtle text-warning-emphasis px-2 py-1 rounded-pill small">Pastry</span>
                                <span class="badge bg-warning-subtle text-dark px-2 py-1 rounded-pill small">Low Stock (3)</span>
                            </div>
                            <h4 class="font-playfair text-dark mb-1">Almond Croissant</h4>
                            <p class="text-muted small mb-3">Twice-baked almond cream croissant (Contains Nuts) - $5.50</p>
                        </div>
                        <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                            <span class="fs-5 fw-bold text-dark font-playfair">$5.50</span>
                            <a href="${pageContext.request.contextPath}/comp04-orders/checkout.jsp?productId=P202" class="btn btn-sm btn-primary px-3">
                                <i class="bi bi-cart-plus me-1"></i> Order Now
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Custom Cake Promotion Card -->
    <div class="mt-5 p-4 p-md-5 rounded-4 text-white text-center" style="background: linear-gradient(135deg, var(--mc-espresso) 0%, var(--mc-primary) 100%);">
        <h3 class="font-playfair mb-2">Looking for a Bespoke Creation?</h3>
        <p class="lead mb-3 opacity-90 small">Personalize your cake flavours, tiers, and hand-piped messages for any special occasion.</p>
        <a href="${pageContext.request.contextPath}/comp03-custom-cakes/book_cake.jsp" class="btn btn-light px-4 py-2 fw-semibold text-danger">
            🎂 Book Custom Cake
        </a>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    function filterCategory(category) {
        document.querySelectorAll('.btn-group button').forEach(b => b.classList.remove('active'));
        if (category === 'ALL') document.getElementById('filterAll').classList.add('active');
        if (category === 'Cake') document.getElementById('filterCakes').classList.add('active');
        if (category === 'Pastry') document.getElementById('filterPastries').classList.add('active');

        const items = document.querySelectorAll('.product-item');
        items.forEach(item => {
            if (category === 'ALL' || item.getAttribute('data-category').toLowerCase() === category.toLowerCase()) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }

    function searchProducts() {
        const query = document.getElementById('menuSearchInput').value.toLowerCase();
        const items = document.querySelectorAll('.product-item');
        items.forEach(item => {
            const name = item.getAttribute('data-name');
            if (name.includes(query)) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>

