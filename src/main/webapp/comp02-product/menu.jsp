<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bakery Menu &amp; Pâtisserie Catalogue — Maple &amp; Crumb</title>
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

<main id="main-content" class="container my-4 my-md-5 flex-grow-1">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Menu Catalogue</li>
        </ol>
    </nav>

    <!-- Menu Header Banner -->
    <div class="text-center mb-5">
        <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-3" style="font-size: 0.75rem; letter-spacing: 0.12em; text-transform: uppercase;">
            <span class="material-symbols-outlined fs-6">bakery_dining</span> Fresh From Our Ovens Daily
        </div>
        <h1 class="page-title text-center fs-1 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
            Our Bakery Catalogue
        </h1>
        <p class="page-subtitle text-center mx-auto text-muted mb-4" style="max-width: 580px; font-size: 1.05rem; line-height: 1.6;">
            Handcrafted sourdoughs, artisanal viennoiserie, and signature celebration cakes baked fresh with heritage grains and slow fermentation.
        </p>

        <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
            <div class="d-inline-flex align-items-center gap-3 p-2 ps-3 pe-2 rounded-pill bg-white border shadow-sm" style="border-color: rgba(134,82,37,0.2) !important;">
                <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">shopping_basket</span>
                <span class="small fw-semibold" style="color: var(--maple-dark-900, #070100);">You have ${sessionScope.cart.size()} item(s) in your basket</span>
                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-sm btn-maple-primary rounded-pill px-3 py-1">
                    Checkout &rarr;
                </a>
            </div>
        </c:if>
    </div>

    <!-- Category Filter Controls & Search -->
    <div class="row g-3 align-items-center justify-content-between mb-4 pb-2">
        <div class="col-lg-7">
            <div class="d-flex flex-wrap gap-2" role="group" aria-label="Product Category Filter">
                <button type="button" class="btn btn-sm ${empty selectedCategory || selectedCategory == 'ALL' ? 'btn-maple-primary' : 'btn-maple-secondary'} rounded-pill px-3 py-2" id="filterAll" onclick="filterCategory('ALL')">
                    <span class="material-symbols-outlined fs-6 align-middle me-1">apps</span> All Items
                </button>
                <button type="button" class="btn btn-sm ${selectedCategory == 'Cake' ? 'btn-maple-primary' : 'btn-maple-secondary'} rounded-pill px-3 py-2" id="filterCakes" onclick="filterCategory('Cake')">
                    <span class="material-symbols-outlined fs-6 align-middle me-1">cake</span> Cakes
                </button>
                <button type="button" class="btn btn-sm ${selectedCategory == 'Pastry' ? 'btn-maple-primary' : 'btn-maple-secondary'} rounded-pill px-3 py-2" id="filterPastries" onclick="filterCategory('Pastry')">
                    <span class="material-symbols-outlined fs-6 align-middle me-1">cookie</span> Pastries
                </button>
                <button type="button" class="btn btn-sm ${selectedCategory == 'Bread' ? 'btn-maple-primary' : 'btn-maple-secondary'} rounded-pill px-3 py-2" id="filterBreads" onclick="filterCategory('Bread')">
                    <span class="material-symbols-outlined fs-6 align-middle me-1">bakery_dining</span> Breads
                </button>
            </div>
        </div>
        <div class="col-lg-5 col-xl-4">
            <form action="${pageContext.request.contextPath}/menu" method="get" class="d-flex">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);" aria-hidden="true">
                        <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                    </span>
                    <input type="text" name="search" id="menuSearchInput" class="form-control form-control-maple border-start-0 ps-1"
                           placeholder="Search pastries, cakes, bread..." value="${searchQuery}" onkeyup="searchProducts()" aria-label="Search pastries, cakes, bread"
                           style="border-color: rgba(43,24,16,0.15);">
                    <c:if test="${not empty selectedCategory && selectedCategory != 'ALL'}">
                        <input type="hidden" name="category" value="${selectedCategory}">
                    </c:if>
                    <button class="btn btn-maple-primary" type="submit" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0;">Search</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Product Grid -->
    <div class="row g-4" id="productGrid">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="prod" items="${products}">
                    <div class="col-sm-6 col-lg-4 product-item" data-category="${prod.category}" data-name="${prod.name.toLowerCase()}">
                        <div class="card card-maple card-maple-product maple-kpi-card h-100 d-flex flex-column justify-content-between p-4 border-0 shadow-sm">
                            <div>
                                <!-- Category & Stock Badges -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span class="badge ${prod.category == 'Cake' ? 'badge-status-danger' : (prod.category == 'Bread' ? 'badge-status-info' : 'badge-status-gold')} text-uppercase tracking-wider px-2 py-1" style="font-size: 0.68rem; letter-spacing: 0.06em;">
                                        ${prod.category}
                                    </span>
                                    <span class="badge ${prod.stockQuantity > 5 ? 'badge-status-success' : (prod.stockQuantity > 0 ? 'badge-status-warning' : 'badge-status-danger')} px-2 py-1" style="font-size: 0.72rem;">
                                        <c:choose>
                                            <c:when test="${prod.stockQuantity > 5}">In Stock (${prod.stockQuantity})</c:when>
                                            <c:when test="${prod.stockQuantity > 0}">Low Stock (${prod.stockQuantity})</c:when>
                                            <c:otherwise>Sold Out</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <!-- Icon Illustration Cloche -->
                                <div class="text-center my-3 py-2" aria-hidden="true">
                                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                                        <c:choose>
                                            <c:when test="${prod.category == 'Cake'}"><span class="material-symbols-outlined fs-1">cake</span></c:when>
                                            <c:when test="${prod.category == 'Bread'}"><span class="material-symbols-outlined fs-1">bakery_dining</span></c:when>
                                            <c:otherwise><span class="material-symbols-outlined fs-1">cookie</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <h4 class="font-playfair text-dark mb-1 fs-5 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">${prod.name}</h4>
                                <div class="mb-2">
                                    <a href="${pageContext.request.contextPath}/viewReviews?productId=${prod.productId}" class="text-decoration-none d-inline-flex align-items-center gap-1 smaller" style="color: var(--maple-gold-600, #6d411b); font-size: 0.75rem;">
                                        <span class="material-symbols-outlined fs-6" style="color: #c5a059;">star</span>
                                        <span>Reviews</span>
                                    </a>
                                </div>
                                <p class="text-muted small mb-3" style="line-height: 1.5; min-height: 38px;">${prod.displayDescription}</p>
                            </div>

                            <div class="pt-3 border-top d-flex align-items-center justify-content-between" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                <div>
                                    <span class="small text-muted d-block" style="font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em;">Price</span>
                                    <span class="fs-4 fw-bold font-playfair" style="color: var(--maple-dark-900, #070100);">Rs. <fmt:formatNumber value="${prod.price}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                </div>
                                <c:choose>
                                    <c:when test="${prod.stockQuantity > 0}">
                                        <a href="${pageContext.request.contextPath}/checkout?action=add&productId=${prod.productId}" class="btn btn-sm btn-maple-primary d-inline-flex align-items-center gap-1 shadow-sm px-3 py-2 rounded-3">
                                            <span class="material-symbols-outlined fs-6">shopping_bag</span> Order
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-light text-muted border px-3 py-2 rounded-3 small">Sold Out</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center py-5" id="noProductsFound">
                    <div class="card card-maple maple-panel-card maple-empty-state p-5 mx-auto border-0 shadow-sm" style="max-width: 480px;">
                        <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                            <span class="material-symbols-outlined fs-1">inventory_2</span>
                        </div>
                        <h4 class="font-playfair fs-4 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Products Found</h4>
                        <p class="text-muted small mb-4">No bakery items matched your selected category filter or search keyword.</p>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-secondary d-inline-flex align-items-center justify-content-center gap-1 mx-auto">
                            <span class="material-symbols-outlined fs-5">replay</span> View Full Menu
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Client-side No Results Placeholder (hidden by default) -->
    <div class="col-12 text-center py-5 d-none" id="clientSideNoResults">
        <div class="card card-maple maple-empty-state p-5 mx-auto border-0 shadow-sm" style="max-width: 480px; background: #ffffff; border-radius: var(--radius-xl, 16px);">
            <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 72px; height: 72px; background: rgba(134, 82, 37, 0.08); color: var(--maple-gold-600, #6d411b);">
                <span class="material-symbols-outlined fs-1">search_off</span>
            </div>
            <h4 class="font-playfair fs-4 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">No Matching Items</h4>
            <p class="text-muted small mb-4">Try checking your spelling or clearing the category filter to see our full catalogue.</p>
            <button type="button" class="btn btn-maple-secondary d-inline-flex align-items-center justify-content-center gap-1 mx-auto" onclick="resetFilters()">
                <span class="material-symbols-outlined fs-5">filter_alt_off</span> Reset Filters
            </button>
        </div>
    </div>

    <!-- Bakery Artisanal Callout (Warm Maple & Crumb Palette) -->
    <div class="mt-5 p-4 p-md-5 rounded-4 text-white text-center shadow" style="background: linear-gradient(135deg, var(--maple-dark-900, #070100) 0%, var(--maple-dark-800, #2b1810) 100%); border: 1px solid rgba(134, 82, 37, 0.25); border-radius: var(--radius-xl, 16px);">
        <div class="d-inline-flex align-items-center gap-1 px-3 py-1 rounded-pill mb-3" style="background: rgba(253, 184, 130, 0.15); color: var(--maple-apricot-400, #fdb882); font-size: 0.75rem; letter-spacing: 0.12em; text-transform: uppercase; font-weight: 600;">
            <span class="material-symbols-outlined fs-6">auto_awesome</span> MADE FOR YOUR SPECIAL MOMENTS
        </div>
        <h3 class="font-playfair mb-2 text-white fs-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-weight: 600;">Your Vision, Our Craft</h3>
        <p class="lead mb-4 text-white-50 small mx-auto" style="max-width: 620px; font-size: 0.95rem; line-height: 1.6;">
            Celebrate birthdays, weddings, and life's special moments with a handcrafted cake designed just for you. Explore your options and book your custom cake with Maple &amp; Crumb.
        </p>
        <div class="d-flex flex-wrap justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/bookCake" class="btn btn-maple-gold px-4 py-2 fw-semibold">
                <span class="material-symbols-outlined fs-5 align-middle me-1">cake</span> Book Your Custom Cake
            </a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const initialCat = '${selectedCategory != null ? selectedCategory : "ALL"}';
        if (initialCat !== 'ALL') {
            filterCategory(initialCat);
        }
    });
</script>
</body>
</html>
