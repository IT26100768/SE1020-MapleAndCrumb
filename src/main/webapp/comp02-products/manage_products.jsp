<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Maple &amp; Crumb</title>
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
    <!-- Role-Based Access Guard -->
    <c:choose>
        <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
            <!-- Header with Title & Action Button -->
            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-2 border-bottom">
                <div>
                    <h1 class="page-title fs-2 mb-1">Product Inventory Management</h1>
                    <p class="text-muted small mb-0">Monitor catalog items, real-time stock levels, and product availability</p>
                </div>
                <div class="mt-2 mt-sm-0">
                    <a href="${pageContext.request.contextPath}/comp02-products/add_product.jsp" class="btn btn-primary shadow-sm">
                        <i class="bi bi-plus-circle me-1"></i> Add New Product
                    </a>
                </div>
            </div>

            <!-- Feedback Messages -->
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                    <div>Product was successfully removed from inventory.</div>
                </div>
            </c:if>
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                    <div>New product successfully added to catalogue!</div>
                </div>
            </c:if>

            <!-- Product Management Table Card -->
            <div class="card card-maple shadow-sm p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark" style="background-color: var(--mc-espresso);">
                            <tr>
                                <th class="ps-4">Product ID</th>
                                <th>Name &amp; Category</th>
                                <th>Unit Price</th>
                                <th>Stock Status</th>
                                <th>Product Details</th>
                                <th class="text-end pe-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty products}">
                                    <c:forEach var="prod" items="${products}">
                                        <tr>
                                            <td class="ps-4 fw-semibold text-secondary">${prod.productId}</td>
                                            <td>
                                                <div class="fw-bold text-dark">${prod.name}</div>
                                                <span class="badge ${prod.category == 'Cake' ? 'bg-danger-subtle text-danger' : 'bg-warning-subtle text-warning-emphasis'} rounded-pill small">
                                                    ${prod.category}
                                                </span>
                                            </td>
                                            <td class="fw-semibold text-dark">$<fmt:formatNumber value="${prod.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td>
                                                <span class="badge ${prod.stockQuantity > 5 ? 'bg-success-subtle text-success' : (prod.stockQuantity > 0 ? 'bg-warning-subtle text-dark' : 'bg-danger-subtle text-danger')} rounded-pill px-2 py-1">
                                                    ${prod.stockQuantity} in stock
                                                </span>
                                            </td>
                                            <td class="small text-muted">${prod.displayDescription}</td>
                                            <td class="text-end pe-4">
                                                <form action="${pageContext.request.contextPath}/deleteProduct" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete ${prod.name}?');">
                                                    <input type="hidden" name="productId" value="${prod.productId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                                        <i class="bi bi-trash3 me-1"></i> Delete
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Fallback sample rows if servlet hasn't populated request scope -->
                                    <tr>
                                        <td class="ps-4 fw-semibold text-secondary">P101</td>
                                        <td>
                                            <div class="fw-bold text-dark">Chocolate Fudge Cake</div>
                                            <span class="badge bg-danger-subtle text-danger rounded-pill small">Cake</span>
                                        </td>
                                        <td class="fw-semibold text-dark">$38.50</td>
                                        <td><span class="badge bg-success-subtle text-success rounded-pill px-2 py-1">12 in stock</span></td>
                                        <td class="small text-muted">8-inch Belgian Chocolate Cake</td>
                                        <td class="text-end pe-4">
                                            <form action="${pageContext.request.contextPath}/deleteProduct" method="post" class="d-inline" onsubmit="return confirm('Delete Chocolate Fudge Cake?');">
                                                <input type="hidden" name="productId" value="P101">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="bi bi-trash3 me-1"></i> Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ps-4 fw-semibold text-secondary">P201</td>
                                        <td>
                                            <div class="fw-bold text-dark">Artisan Butter Croissant</div>
                                            <span class="badge bg-warning-subtle text-warning-emphasis rounded-pill small">Pastry</span>
                                        </td>
                                        <td class="fw-semibold text-dark">$4.50</td>
                                        <td><span class="badge bg-success-subtle text-success rounded-pill px-2 py-1">24 in stock</span></td>
                                        <td class="small text-muted">Nut-Free Butter Laminated Dough</td>
                                        <td class="text-end pe-4">
                                            <form action="${pageContext.request.contextPath}/deleteProduct" method="post" class="d-inline" onsubmit="return confirm('Delete Butter Croissant?');">
                                                <input type="hidden" name="productId" value="P201">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="bi bi-trash3 me-1"></i> Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Unauthorized Access Warning -->
            <div class="text-center py-5">
                <div class="card card-maple shadow-sm mx-auto p-5" style="max-width: 500px;">
                    <div class="fs-1 text-danger mb-3"><i class="bi bi-shield-lock-fill"></i></div>
                    <h3 class="font-playfair text-dark">Administrator Access Required</h3>
                    <p class="text-muted small mb-4">You must be logged in as an authorized Staff member or Administrator to access product management tools.</p>
                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary px-4">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Log In with Staff Account
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>

