<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-expand-lg sticky-top maple-navbar">
    <div class="container">
        <a class="navbar-brand logo d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <span class="brand-icon me-2">🧁</span>
            <span class="brand-title">Maple <span>&amp;</span> Crumb</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mapleNav" aria-controls="mapleNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mapleNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-1 my-2 my-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/menu">Menu</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/comp03-custom-cakes/book_cake.jsp">Custom Cake</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/myOrders">My Orders</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/comp06-feedback/promotions.jsp">Promotions</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp">Admin</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-profile-link" href="${pageContext.request.contextPath}/comp01-user/profile.jsp">
                        <i class="bi bi-person-circle me-1"></i>Profile
                    </a>
                </li>
                <li class="nav-item ms-lg-2">
                    <a class="btn btn-sm btn-outline-maple-nav px-3" href="${pageContext.request.contextPath}/comp01-user/login.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>