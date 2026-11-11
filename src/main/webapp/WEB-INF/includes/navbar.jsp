<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="currentURI" value="${requestScope['jakarta.servlet.forward.request_uri'] != null ? requestScope['jakarta.servlet.forward.request_uri'] : pageContext.request.requestURI}" />
<%
    String navURI = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    if (navURI == null) {
        navURI = request.getRequestURI();
    }
    String navCtx = request.getContextPath();
    String navPath = navURI;
    if (navCtx != null && !navCtx.isEmpty() && navPath.startsWith(navCtx)) {
        navPath = navPath.substring(navCtx.length());
    }
    int navQ = navPath.indexOf('?');
    if (navQ >= 0) {
        navPath = navPath.substring(0, navQ);
    }
    if (navPath.length() > 1 && navPath.endsWith("/")) {
        navPath = navPath.substring(0, navPath.length() - 1);
    }
    request.setAttribute("navCleanPath", navPath);
%>

<!-- Core Stylesheet Guarantee -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">

<!-- Top Navigation Bar -->
<header class="maple-header-wrap">
  <div class="maple-header-container">
    <!-- Brand Logo & Identity -->
    <a class="maple-brand-link" href="${pageContext.request.contextPath}/index.jsp">
      <span class="maple-brand-name">
        Maple &amp; Crumb
      </span>
    </a>

    <!-- Desktop Navigation Links -->
    <nav class="maple-desktop-nav" aria-label="Main Navigation">
      <c:set var="isHomeActive" value="${navCleanPath == '/' || navCleanPath == '/index.jsp'}" />
      <c:set var="isShopActive" value="${navCleanPath == '/menu' || navCleanPath.startsWith('/comp02-products/menu')}" />
      <c:set var="isCakesActive" value="${navCleanPath == '/bookCake' || navCleanPath.startsWith('/comp03-bookings/book_cake')}" />
      <c:set var="isPromoActive" value="${navCleanPath == '/comp06-reviews/promotions.jsp' || navCleanPath == '/promotions'}" />
      <c:set var="isReviewsActive" value="${navCleanPath == '/viewReviews' || navCleanPath == '/reviews' || navCleanPath == '/comp06-reviews/view_reviews.jsp'}" />
      <c:set var="isOpsActive" value="${navCleanPath.startsWith('/comp05-admin') || navCleanPath == '/kitchenQueue' || navCleanPath == '/kitchenTicket' || navCleanPath == '/manageProducts' || navCleanPath == '/manageBookings' || navCleanPath == '/managePromotions' || navCleanPath == '/addPromo' || navCleanPath.startsWith('/viewOrders') || navCleanPath.startsWith('/viewStaff') || navCleanPath == '/comp06-reviews/manage_promotions.jsp'}" />

      <a class="maple-nav-anchor ${isHomeActive ? 'active' : ''}" aria-current="${isHomeActive ? 'page' : 'false'}" href="${pageContext.request.contextPath}/index.jsp">Home</a>
      <a class="maple-nav-anchor ${isShopActive ? 'active' : ''}" aria-current="${isShopActive ? 'page' : 'false'}" href="${pageContext.request.contextPath}/menu">Shop</a>
      <a class="maple-nav-anchor ${isCakesActive ? 'active' : ''}" aria-current="${isCakesActive ? 'page' : 'false'}" href="${pageContext.request.contextPath}/bookCake">Custom Cakes</a>
      <a class="maple-nav-anchor ${isPromoActive ? 'active' : ''}" aria-current="${isPromoActive ? 'page' : 'false'}" href="${pageContext.request.contextPath}/comp06-reviews/promotions.jsp">Promotions</a>
      <a class="maple-nav-anchor ${isReviewsActive ? 'active' : ''}" aria-current="${isReviewsActive ? 'page' : 'false'}" href="${pageContext.request.contextPath}/viewReviews">Reviews</a>
      <c:if test="${not empty sessionScope.loggedInUser && (sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF')}">
        <a class="maple-nav-anchor ${isOpsActive ? 'active' : ''}" aria-current="${isOpsActive ? 'page' : 'false'}" href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" style="color: #865225; font-weight: 600;">
          <span class="material-symbols-outlined" style="font-size: 18px; margin-right: 4px;">admin_panel_settings</span>
          Operations
        </a>
      </c:if>
    </nav>

    <!-- Right Utility Cluster & CTAs -->
    <div class="maple-utility-group">
      <!-- Search Trigger -->
      <a href="${pageContext.request.contextPath}/menu" aria-label="Search pastries and bespoke cakes" class="maple-icon-btn">
        <span class="material-symbols-outlined" style="font-size: 22px;">search</span>
      </a>

      <!-- Shopping Cart Icon with Badge -->
      <a href="${pageContext.request.contextPath}/checkout" class="maple-icon-btn" aria-label="Shopping Cart">
        <span class="material-symbols-outlined" style="font-size: 22px;">shopping_bag</span>
        <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
          <span class="maple-cart-pill">
            ${sessionScope.cart.size()}
          </span>
        </c:if>
      </a>

      <!-- Account Link / User Profile Dropdown -->
      <c:choose>
        <c:when test="${not empty sessionScope.loggedInUser}">
          <div class="maple-user-wrapper">
            <button id="mapleUserMenuBtn" onclick="toggleMapleUserDropdown(event)" type="button" class="maple-user-btn" aria-expanded="false" aria-haspopup="true">
              <span class="material-symbols-outlined" style="font-size: 22px; color: #865225;">account_circle</span>
              <span style="max-width: 120px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                <c:out value="${not empty sessionScope.loggedInUser.username ? sessionScope.loggedInUser.username : sessionScope.loggedInUser.email}" />
              </span>
              <span class="material-symbols-outlined" style="font-size: 16px;">expand_more</span>
            </button>
            <div id="mapleUserDropdown" class="maple-dropdown-panel">
              <div class="maple-dropdown-header">
                <p style="font-size: 13px; font-weight: 600; color: #070100; margin: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                  <c:out value="${not empty sessionScope.loggedInUser.username ? sessionScope.loggedInUser.username : sessionScope.loggedInUser.email}" />
                </p>
                <span style="display: inline-block; font-size: 10px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; background: #ece8e0; color: #865225; padding: 2px 6px; border-radius: 9999px; margin-top: 3px;">
                  ${sessionScope.loggedInUser.userRole}
                </span>
              </div>
              <c:choose>
                <c:when test="${sessionScope.loggedInUser.userRole == 'ADMIN'}">
                  <a href="${pageContext.request.contextPath}/comp01-user/profile.jsp" class="maple-dropdown-item">
                    <span class="material-symbols-outlined" style="font-size: 18px;">person</span>
                    <span>My Profile</span>
                  </a>
                  <div class="maple-dropdown-divider"></div>
                  <a href="${pageContext.request.contextPath}/logout" class="maple-dropdown-item danger">
                    <span class="material-symbols-outlined" style="font-size: 18px;">logout</span>
                    <span>Sign Out</span>
                  </a>
                </c:when>
                <c:otherwise>
                  <c:if test="${sessionScope.loggedInUser.userRole == 'STAFF'}">
                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="maple-dropdown-item" style="color: #865225; font-weight: 600;">
                      <span class="material-symbols-outlined" style="font-size: 18px;">dashboard</span>
                      <span>Operations Hub</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/kitchenQueue" class="maple-dropdown-item" style="color: #6d411b; font-weight: 500;">
                      <span class="material-symbols-outlined" style="font-size: 18px;">soup_kitchen</span>
                      <span>Kitchen Queue</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/manageProducts" class="maple-dropdown-item">
                      <span class="material-symbols-outlined" style="font-size: 18px;">inventory_2</span>
                      <span>Product Inventory</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/manageBookings" class="maple-dropdown-item">
                      <span class="material-symbols-outlined" style="font-size: 18px;">event</span>
                      <span>Cake Bookings</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/viewOrders?view=manage" class="maple-dropdown-item">
                      <span class="material-symbols-outlined" style="font-size: 18px;">local_shipping</span>
                      <span>Orders &amp; Dispatch</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/managePromotions" class="maple-dropdown-item">
                      <span class="material-symbols-outlined" style="font-size: 18px;">local_offer</span>
                      <span>Manage Promotions</span>
                    </a>
                    <div class="maple-dropdown-divider"></div>
                  </c:if>
                  <a href="${pageContext.request.contextPath}/comp01-user/profile.jsp" class="maple-dropdown-item">
                    <span class="material-symbols-outlined" style="font-size: 18px;">person</span>
                    <span>My Profile</span>
                  </a>
                  <a href="${pageContext.request.contextPath}/viewReviews" class="maple-dropdown-item">
                    <span class="material-symbols-outlined" style="font-size: 18px;">rate_review</span>
                    <span>Customer Reviews</span>
                  </a>
                  <c:if test="${sessionScope.loggedInUser.userRole == 'CUSTOMER'}">
                    <a href="${pageContext.request.contextPath}/myOrders" class="maple-dropdown-item">
                      <span class="material-symbols-outlined" style="font-size: 18px;">receipt_long</span>
                      <span>My Orders</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/myBookings" class="maple-dropdown-item">
                      <span class="material-symbols-outlined" style="font-size: 18px;">cake</span>
                      <span>My Cake Bookings</span>
                    </a>
                  </c:if>
                  <div class="maple-dropdown-divider"></div>
                  <a href="${pageContext.request.contextPath}/logout" class="maple-dropdown-item danger">
                    <span class="material-symbols-outlined" style="font-size: 18px;">logout</span>
                    <span>Sign Out</span>
                  </a>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <a class="maple-user-btn" href="${pageContext.request.contextPath}/comp01-user/login.jsp">
            <span class="material-symbols-outlined" style="font-size: 20px;">person</span>
            <span>Sign In</span>
          </a>
        </c:otherwise>
      </c:choose>

      <!-- Order Now CTA Button -->
      <a class="maple-order-cta" href="${pageContext.request.contextPath}/menu">
        Order Now
      </a>

      <!-- Mobile Hamburger Button -->
      <button id="mapleMobileMenuBtn" onclick="toggleMapleMobileMenu()" type="button" aria-label="Toggle navigation menu" class="maple-mobile-btn">
        <span class="material-symbols-outlined" style="font-size: 24px;">menu</span>
      </button>
    </div>
  </div>

  <!-- Mobile Navigation Drawer -->
  <div id="mapleMobileDrawer" class="maple-mobile-drawer">
    <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
    <a href="${pageContext.request.contextPath}/menu">Shop Catalogue</a>
    <a href="${pageContext.request.contextPath}/bookCake">Custom Cake Studio</a>
    <a href="${pageContext.request.contextPath}/comp06-reviews/promotions.jsp">Promotions &amp; Vouchers</a>
    <a href="${pageContext.request.contextPath}/viewReviews">Customer Reviews</a>
    <c:choose>
      <c:when test="${not empty sessionScope.loggedInUser}">
        <c:if test="${sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF'}">
          <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" style="color: #865225; font-weight: 600;">Operations Hub</a>
          <a href="${pageContext.request.contextPath}/kitchenQueue" style="color: #6d411b; font-weight: 600;">Kitchen Queue</a>
          <a href="${pageContext.request.contextPath}/managePromotions" style="color: #865225;">Manage Promotions</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/comp01-user/profile.jsp">My Profile</a>
        <c:if test="${sessionScope.loggedInUser.userRole == 'CUSTOMER'}">
          <a href="${pageContext.request.contextPath}/myOrders">My Orders</a>
          <a href="${pageContext.request.contextPath}/myBookings">My Cake Bookings</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/logout" style="color: #ba1a1a;">Sign Out</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/comp01-user/login.jsp">Sign In / Register</a>
      </c:otherwise>
    </c:choose>
    <div style="padding-top: 12px;">
      <a class="maple-mobile-cta" href="${pageContext.request.contextPath}/menu">
        Order Now
      </a>
    </div>
  </div>
</header>
