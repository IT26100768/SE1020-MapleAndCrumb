<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    com.mapleandcrumb.model.comp01.User loggedUser = (com.mapleandcrumb.model.comp01.User) session.getAttribute("loggedInUser");
    if (loggedUser != null && ("ADMIN".equals(loggedUser.getUserRole()) || "STAFF".equals(loggedUser.getUserRole()))) {
        int kpiProductCount = 0;
        int kpiStaffCount = 0;
        int kpiUserCount = 0;
        int kpiBookingCount = 0;
        int kpiOrderCount = 0;
        int kpiActivePromos = 0;
        int kpiReviewCount = 0;
        double averageRating = 5.0;
        int reviewPct5 = 100, reviewPct4 = 0, reviewPct3 = 0, reviewPct2 = 0, reviewPct1 = 0;
        int positiveSentiment = 100;
        double todayRevenue = 0.0;
        double yesterdayRevenue = 0.0;
        double revenueGrowth = 0.0;
        int todayOrders = 0;
        int todayPickup = 0;
        int todayDelivery = 0;
        int outOfStockCount = 0;
        int lowStockCount = 0;
        int belowThresholdCount = 0;
        double avgDailyRevenue = 0.0;
        double maxRev = 5000.0;
        int[] chartX = {60, 153, 246, 340, 433, 526, 620};
        int[] chartY = {195, 195, 195, 195, 195, 195, 195};
        String[] dayLabels = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun (Today)"};
        Double[] chartVals = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        String chartLinePath = "M 60 195 L 620 195";
        String chartAreaPath = "M 60 195 L 620 195 L 620 200 L 60 200 Z";
        int kpiActiveTasks = 0;
        int kpiTodayTasks = 0;
        int kpiTomorrowTasks = 0;
        int kpiCakeInPrep = 0;
        int kpiOverdueTasks = 0;
        java.util.List<com.mapleandcrumb.model.comp02.Product> watchProducts = new java.util.ArrayList<>();
        java.util.List<com.mapleandcrumb.model.comp05.KitchenTask> upcomingPickups = new java.util.ArrayList<>();
        java.util.List<java.util.Map<String, String>> alertItems = new java.util.ArrayList<>();
        java.util.List<java.util.Map<String, String>> activityItems = new java.util.ArrayList<>();
        java.util.Map<String, String> productInitials = new java.util.HashMap<>();
        java.util.Map<Object, String> taskCustomerInitials = new java.util.HashMap<>();

        try {
            com.mapleandcrumb.dao.comp02.ProductDAO prodDao = new com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl();
            com.mapleandcrumb.dao.comp05.StaffDAO stfDao = new com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl();
            com.mapleandcrumb.dao.comp01.UserDAO usrDao = new com.mapleandcrumb.dao.impl.comp01.UserDAOImpl();
            com.mapleandcrumb.dao.comp03.CustomCakeDAO cakeDao = new com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl();
            com.mapleandcrumb.dao.comp04.OrderDAO ordDao = new com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl();
            com.mapleandcrumb.dao.comp06.PromotionDAO promoDao = new com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl();
            com.mapleandcrumb.dao.comp06.ReviewDAO revDao = new com.mapleandcrumb.dao.impl.comp06.ReviewDAOImpl();
            com.mapleandcrumb.dao.comp05.KitchenTaskDAO kitchenDao = new com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl();

            // 1. Sidebar Counter Badges
            kpiProductCount = prodDao.getProductCount();
            kpiStaffCount = stfDao.getStaffCount();
            kpiUserCount = usrDao.getUserCount();
            kpiBookingCount = cakeDao.getBookingCount();
            kpiOrderCount = ordDao.getOrderCount();
            java.util.List<?> promos = promoDao.getAllActivePromotions();
            kpiActivePromos = promos != null ? promos.size() : 0;

            // 2. Customer Reviews & Sentiment Distribution
            java.util.List<com.mapleandcrumb.model.comp06.Review> allReviews = revDao.getAllReviews();
            if (allReviews != null && !allReviews.isEmpty()) {
                kpiReviewCount = allReviews.size();
                int count5 = 0, count4 = 0, count3 = 0, count2 = 0, count1 = 0;
                int sumRating = 0;
                for (com.mapleandcrumb.model.comp06.Review r : allReviews) {
                    int stars = r.getRating();
                    sumRating += stars;
                    if (stars == 5) count5++;
                    else if (stars == 4) count4++;
                    else if (stars == 3) count3++;
                    else if (stars == 2) count2++;
                    else if (stars == 1) count1++;
                }
                averageRating = Math.round(((double) sumRating / kpiReviewCount) * 10.0) / 10.0;
                reviewPct5 = (int) Math.round((double) count5 / kpiReviewCount * 100.0);
                reviewPct4 = (int) Math.round((double) count4 / kpiReviewCount * 100.0);
                reviewPct3 = (int) Math.round((double) count3 / kpiReviewCount * 100.0);
                reviewPct2 = (int) Math.round((double) count2 / kpiReviewCount * 100.0);
                reviewPct1 = (int) Math.round((double) count1 / kpiReviewCount * 100.0);
                positiveSentiment = (int) Math.round(((double) (count5 + count4) / kpiReviewCount) * 100.0);
            }

            // 3. Today's Revenue & Growth
            todayRevenue = ordDao.getTodayRevenue();
            yesterdayRevenue = ordDao.getYesterdayRevenue();
            if (yesterdayRevenue > 0) {
                revenueGrowth = Math.round(((todayRevenue - yesterdayRevenue) / yesterdayRevenue * 100.0) * 10.0) / 10.0;
            } else if (todayRevenue > 0) {
                revenueGrowth = 100.0;
            }

            // 4. Orders Today
            todayOrders = ordDao.getTodayOrderCount();
            todayPickup = ordDao.getTodayOrderCountByType("Pickup");
            todayDelivery = ordDao.getTodayOrderCountByType("Delivery");

            // 5. Low-Stock & Vitrine Watch Products
            outOfStockCount = prodDao.getLowStockCount(0);
            lowStockCount = prodDao.getLowStockCount(5);
            belowThresholdCount = Math.max(0, lowStockCount - outOfStockCount);

            java.util.List<com.mapleandcrumb.model.comp02.Product> rawWatchProds = prodDao.getLowStockProducts(3);
            if (rawWatchProds == null || rawWatchProds.isEmpty()) {
                java.util.List<com.mapleandcrumb.model.comp02.Product> allProds = prodDao.getAllProducts();
                if (allProds != null && !allProds.isEmpty()) {
                    rawWatchProds = allProds.subList(0, Math.min(3, allProds.size()));
                }
            }
            if (rawWatchProds != null) {
                watchProducts = rawWatchProds;
                for (com.mapleandcrumb.model.comp02.Product p : watchProducts) {
                    String ini = "MC";
                    if (p.getName() != null && !p.getName().trim().isEmpty()) {
                        String nm = p.getName().trim();
                        ini = nm.length() >= 2 ? nm.substring(0, 2).toUpperCase() : nm.toUpperCase();
                    }
                    productInitials.put(p.getProductId(), ini);
                }
            }

            // 6. Multi-Day Revenue Trajectory & Dynamic SVG Curve
            java.util.Map<String, Double> dailyRevenueMap = ordDao.getDailyRevenueLast7Days();
            double sum7 = 0.0;
            if (dailyRevenueMap != null) {
                for (Double rev : dailyRevenueMap.values()) {
                    if (rev != null) {
                        sum7 += rev;
                        if (rev > maxRev) maxRev = rev;
                    }
                }
                avgDailyRevenue = Math.round((sum7 / 7.0) * 10.0) / 10.0;

                java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("EEE");
                int cIdx = 0;
                for (java.util.Map.Entry<String, Double> entry : dailyRevenueMap.entrySet()) {
                    if (cIdx >= 7) break;
                    double val = entry.getValue() != null ? entry.getValue() : 0.0;
                    chartVals[cIdx] = val;
                    chartY[cIdx] = (int) (195 - (val / maxRev * 165.0));
                    try {
                        java.time.LocalDate ld = java.time.LocalDate.parse(entry.getKey());
                        dayLabels[cIdx] = (cIdx == 6) ? ld.format(dtf) + " (Today)" : ld.format(dtf);
                    } catch (Exception ignored) {
                        dayLabels[cIdx] = "Day " + (cIdx + 1);
                    }
                    cIdx++;
                }

                StringBuilder pathBuilder = new StringBuilder();
                StringBuilder areaBuilder = new StringBuilder();
                pathBuilder.append("M ").append(chartX[0]).append(" ").append(chartY[0]);
                areaBuilder.append("M ").append(chartX[0]).append(" ").append(chartY[0]);
                for (int i = 1; i < 7; i++) {
                    int prevX = chartX[i-1];
                    int prevY = chartY[i-1];
                    int curX = chartX[i];
                    int curY = chartY[i];
                    int cX1 = prevX + (curX - prevX) / 2;
                    int cY1 = prevY;
                    int cX2 = prevX + (curX - prevX) / 2;
                    int cY2 = curY;
                    pathBuilder.append(" C ").append(cX1).append(" ").append(cY1).append(", ").append(cX2).append(" ").append(cY2).append(", ").append(curX).append(" ").append(curY);
                    areaBuilder.append(" C ").append(cX1).append(" ").append(cY1).append(", ").append(cX2).append(" ").append(cY2).append(", ").append(curX).append(" ").append(curY);
                }
                areaBuilder.append(" L 620 200 L 60 200 Z");
                chartLinePath = pathBuilder.toString();
                chartAreaPath = areaBuilder.toString();
            }

            // 7. Kitchen Operations Metrics & Sync
            try {
                kitchenDao.syncMissingTasks();
            } catch (Exception ignored) {}
            kpiActiveTasks = kitchenDao.getActiveTaskCount();
            kpiTodayTasks = kitchenDao.getTodayTaskCount();
            kpiTomorrowTasks = kitchenDao.getTomorrowTaskCount();
            kpiCakeInPrep = kitchenDao.getCustomCakesInPrepCount();
            kpiOverdueTasks = kitchenDao.getOverdueTaskCount();

            java.util.List<com.mapleandcrumb.model.comp05.KitchenTask> todayTasks = kitchenDao.getTasksByFilter("today", "all", "all", null);
            if (todayTasks != null) {
                upcomingPickups = todayTasks;
                for (com.mapleandcrumb.model.comp05.KitchenTask t : upcomingPickups) {
                    String cIni = "CU";
                    if (t.getCustomerName() != null && !t.getCustomerName().trim().isEmpty()) {
                        String cn = t.getCustomerName().trim();
                        cIni = cn.length() >= 2 ? cn.substring(0, 2).toUpperCase() : cn.toUpperCase();
                    }
                    taskCustomerInitials.put(t.getTaskId(), cIni);
                    taskCustomerInitials.put(String.valueOf(t.getTaskId()), cIni);
                }
            }

            // 8. Needs Attention Priority Alerts
            java.util.List<com.mapleandcrumb.model.comp02.Product> lowStockProds = prodDao.getLowStockProducts(5);
            if (lowStockProds != null) {
                for (com.mapleandcrumb.model.comp02.Product p : lowStockProds) {
                    if (p.getStockQuantity() == 0) {
                        java.util.Map<String, String> alert = new java.util.HashMap<>();
                        alert.put("type", "Out of Stock");
                        alert.put("badgeClass", "mc-alert-badge-error");
                        alert.put("sub", "0 units left");
                        alert.put("title", p.getName() != null ? p.getName() : "Pastry Item");
                        alert.put("desc", (p.getCategory() != null ? p.getCategory() : "Boutique") + " Â· Replenishment needed");
                        alert.put("actionLabel", "Update Stock");
                        alert.put("actionUrl", request.getContextPath() + "/manageProducts");
                        alertItems.add(alert);
                        if (alertItems.size() >= 2) break;
                    }
                }
            }
            java.util.List<com.mapleandcrumb.model.comp05.KitchenTask> overdueTasks = kitchenDao.getTasksByFilter("overdue", "all", "all", null);
            if (overdueTasks != null && !overdueTasks.isEmpty()) {
                for (com.mapleandcrumb.model.comp05.KitchenTask ot : overdueTasks) {
                    java.util.Map<String, String> alert = new java.util.HashMap<>();
                    alert.put("type", "Overdue Task");
                    alert.put("badgeClass", "mc-alert-badge-warn");
                    alert.put("sub", ot.getFormattedShortDueDatetime() != null ? ot.getFormattedShortDueDatetime() : "Immediate");
                    String tType = ot.getTaskType();
                    alert.put("title", "#" + ot.getReferenceCode() + " Â· " + ("CUSTOM_CAKE".equals(tType) ? ot.getCustomCakeFlavor() : "Pastry Batch"));
                    alert.put("desc", "Kitchen station Â· " + (ot.getFulfillmentType() != null ? ot.getFulfillmentType() : "Fulfillment"));
                    alert.put("actionLabel", "Review Order");
                    alert.put("actionUrl", request.getContextPath() + "/kitchenQueue?date=overdue");
                    alertItems.add(alert);
                    if (alertItems.size() >= 3) break;
                }
            }
            java.util.List<com.mapleandcrumb.model.comp03.CustomCakeOrder> allBookings = cakeDao.getAllBookings();
            if (alertItems.size() < 3 && allBookings != null) {
                for (com.mapleandcrumb.model.comp03.CustomCakeOrder b : allBookings) {
                    if ("Pending".equalsIgnoreCase(b.getStatus())) {
                        java.util.Map<String, String> alert = new java.util.HashMap<>();
                        alert.put("type", "Order Hold");
                        alert.put("badgeClass", "mc-alert-badge-gold");
                        alert.put("sub", "Pending approval");
                        alert.put("title", "#" + b.getBookingId() + " Â· " + (b.getFlavor() != null ? b.getFlavor() : "Bespoke Cake"));
                        alert.put("desc", "Cake Studio Â· Requires pastry chef review");
                        alert.put("actionLabel", "View in Queue");
                        alert.put("actionUrl", request.getContextPath() + "/manageBookings");
                        alertItems.add(alert);
                        if (alertItems.size() >= 3) break;
                    }
                }
            }

            // 9. Recent Business Activity Timeline
            java.util.List<com.mapleandcrumb.model.comp04.Order> allOrders = ordDao.getAllOrders();
            if (allOrders != null && !allOrders.isEmpty()) {
                for (int i = 0; i < Math.min(2, allOrders.size()); i++) {
                    com.mapleandcrumb.model.comp04.Order o = allOrders.get(i);
                    java.util.Map<String, String> act = new java.util.HashMap<>();
                    act.put("icon", "receipt_long");
                    act.put("iconBg", "mc-act-icon-secondary");
                    act.put("title", "New Order #" + o.getOrderId() + " placed");
                    act.put("sub", "Rs. " + String.format("%.2f", o.calculateFinalTotal()) + " Â· Status: " + (o.getStatus() != null ? o.getStatus() : "Active"));
                    activityItems.add(act);
                }
            }
            if (allBookings != null && !allBookings.isEmpty()) {
                com.mapleandcrumb.model.comp03.CustomCakeOrder b = allBookings.get(0);
                java.util.Map<String, String> act = new java.util.HashMap<>();
                act.put("icon", "cake");
                act.put("iconBg", "mc-act-icon-amber");
                act.put("title", "Bespoke Cake Booking #" + b.getBookingId() + " confirmed");
                act.put("sub", b.getSizeInches() + "-Inch " + (b.getFlavor() != null ? b.getFlavor() : "Bespoke") + " (Rs. " + String.format("%.2f", b.getQuotedPrice()) + ")");
                activityItems.add(act);
            }
            if (allReviews != null && !allReviews.isEmpty()) {
                com.mapleandcrumb.model.comp06.Review rev = allReviews.get(0);
                java.util.Map<String, String> act = new java.util.HashMap<>();
                act.put("icon", "star");
                act.put("iconBg", "mc-act-icon-gold");
                act.put("title", rev.getRating() + "â˜… Review submitted");
                act.put("sub", rev.getComment() != null ? rev.getComment() : "Customer review");
                activityItems.add(act);
            }
        } catch (Throwable t) {
            System.err.println("dashboard.jsp scriptlet handled error: " + t.getMessage());
            t.printStackTrace();
        }

        request.setAttribute("kpiProductCount", kpiProductCount);
        request.setAttribute("kpiStaffCount", kpiStaffCount);
        request.setAttribute("kpiUserCount", kpiUserCount);
        request.setAttribute("kpiBookingCount", kpiBookingCount);
        request.setAttribute("kpiOrderCount", kpiOrderCount);
        request.setAttribute("kpiActivePromos", kpiActivePromos);
        request.setAttribute("kpiReviewCount", kpiReviewCount);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("reviewPct5", reviewPct5);
        request.setAttribute("reviewPct4", reviewPct4);
        request.setAttribute("reviewPct3", reviewPct3);
        request.setAttribute("reviewPct2", reviewPct2);
        request.setAttribute("reviewPct1", reviewPct1);
        request.setAttribute("positiveSentiment", positiveSentiment);
        request.setAttribute("kpiTodayRevenue", todayRevenue);
        request.setAttribute("kpiYesterdayRevenue", yesterdayRevenue);
        request.setAttribute("kpiRevenueGrowth", revenueGrowth);
        request.setAttribute("kpiTodayOrders", todayOrders);
        request.setAttribute("kpiTodayPickup", todayPickup);
        request.setAttribute("kpiTodayDelivery", todayDelivery);
        request.setAttribute("kpiOutOfStockCount", outOfStockCount);
        request.setAttribute("kpiBelowThresholdCount", belowThresholdCount);
        request.setAttribute("kpiTotalLowStockCount", lowStockCount);
        request.setAttribute("avgDailyRevenue", avgDailyRevenue);
        request.setAttribute("chartMaxRev", maxRev);
        request.setAttribute("chartX", chartX);
        request.setAttribute("chartY", chartY);
        request.setAttribute("chartVals", chartVals);
        request.setAttribute("chartDayLabels", dayLabels);
        request.setAttribute("chartLinePath", chartLinePath);
        request.setAttribute("chartAreaPath", chartAreaPath);
        request.setAttribute("kpiActiveTasks", kpiActiveTasks);
        request.setAttribute("kpiTodayTasks", kpiTodayTasks);
        request.setAttribute("kpiTomorrowTasks", kpiTomorrowTasks);
        request.setAttribute("kpiCakeInPrep", kpiCakeInPrep);
        request.setAttribute("kpiOverdueTasks", kpiOverdueTasks);
        request.setAttribute("watchProducts", watchProducts);
        request.setAttribute("upcomingPickups", upcomingPickups);
        request.setAttribute("alertItems", alertItems);
        request.setAttribute("activityItems", activityItems);
        request.setAttribute("productInitials", productInitials);
        request.setAttribute("taskCustomerInitials", taskCustomerInitials);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Maple &amp; Crumb Haute-PÃ¢tisserie â€” Operations Hub</title>
    <!-- Google Fonts: Playfair Display & Outfit -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&amp;family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400&amp;display=swap" rel="stylesheet">
    <!-- Material Symbols Outlined -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Maple & Crumb Global Stylesheet Suite -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <!-- Admin Operations Hub Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/admin.css">
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${not empty sessionScope.loggedInUser && (sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF')}">
        <div class="mc-admin-layout-wrapper">
            <!-- Persistent Left Sidebar (Preserved 100% Unchanged) -->
            <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                <jsp:param name="activeTab" value="dashboard" />
            </jsp:include>

            <!-- Main Content Canvas -->
            <div class="mc-admin-content-canvas">
                <!-- Top Navigation & Actions Bar -->
                <header class="mc-admin-header px-4 py-3 d-flex flex-wrap align-items-center justify-content-between gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <button type="button" class="d-lg-none btn btn-sm btn-maple-secondary rounded-3 px-2.5 py-1.5 d-inline-flex align-items-center gap-1 shadow-sm" onclick="toggleAdminSidebar()" aria-label="Toggle Admin Menu">
                            <span class="material-symbols-outlined fs-5">menu</span>
                            <span class="small fw-semibold">Console</span>
                        </button>
                        <div>
                            <h1 class="font-playfair text-primary-container fs-3 fw-bold mb-0">Operations &amp; Business Overview</h1>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="${pageContext.request.contextPath}/comp02-products/add_product.jsp" class="btn btn-sm btn-maple-primary rounded-pill px-4 py-2 d-inline-flex align-items-center gap-2 shadow-sm text-decoration-none">
                            <span class="material-symbols-outlined fs-6">add</span>
                            <span>New Product</span>
                        </a>
                    </div>
                </header>

                <main class="mc-ops-main">
                    <!-- 1. Row 1: Business KPI Cards (4 compact cards in a 4-column desktop grid) -->
                    <section class="mc-kpi-grid">
                        <!-- Card 1: Today's Revenue -->
                        <div class="mc-atelier-card mc-atelier-card-hover">
                            <div class="d-flex align-items-start justify-content-between">
                                <span class="small fw-semibold text-outline">Today's Revenue</span>
                                <div class="mc-kpi-icon-pill">
                                    <span class="material-symbols-outlined">account_balance_wallet</span>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="font-playfair fs-3 fw-bold text-primary-container">
                                    Rs. <fmt:formatNumber value="${kpiTodayRevenue}" minFractionDigits="2"/>
                                </div>
                                <div class="d-flex align-items-center gap-2 mt-2">
                                    <span class="mc-growth-pill ${kpiRevenueGrowth >= 0 ? 'mc-growth-positive' : 'mc-growth-negative'}">
                                        <span class="material-symbols-outlined" style="font-size: 14px; margin-right: 2px;">${kpiRevenueGrowth >= 0 ? 'trending_up' : 'trending_down'}</span>
                                        ${kpiRevenueGrowth >= 0 ? '+' : ''}${kpiRevenueGrowth}%
                                    </span>
                                    <span class="small text-muted" style="font-size: 0.75rem;">vs yesterday</span>
                                </div>
                            </div>
                        </div>

                        <!-- Card 2: Orders Today -->
                        <div class="mc-atelier-card mc-atelier-card-hover">
                            <div class="d-flex align-items-start justify-content-between">
                                <span class="small fw-semibold text-outline">Orders Today</span>
                                <div class="mc-kpi-icon-pill">
                                    <span class="material-symbols-outlined">shopping_bag</span>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="font-playfair fs-3 fw-bold text-primary-container">
                                    ${kpiTodayOrders} Orders
                                </div>
                                <div class="d-flex align-items-center gap-2 mt-2">
                                    <span class="small text-muted" style="font-size: 0.78rem;">
                                        <strong class="text-secondary">${kpiTodayPickup}</strong> Pickup <span class="text-outline-variant mx-1">Â·</span> <strong class="text-secondary">${kpiTodayDelivery}</strong> Delivery
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Card 3: Low-Stock Products -->
                        <div class="mc-atelier-card mc-atelier-card-hover">
                            <div class="d-flex align-items-start justify-content-between">
                                <span class="small fw-semibold text-outline">Low-Stock Watch</span>
                                <div class="mc-kpi-icon-pill">
                                    <span class="material-symbols-outlined">inventory_2</span>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="font-playfair fs-3 fw-bold text-primary-container">
                                    ${kpiTotalLowStockCount} Items
                                </div>
                                <div class="d-flex align-items-center gap-2 mt-2">
                                    <span class="small text-muted" style="font-size: 0.78rem;">
                                        <strong class="text-danger">${kpiOutOfStockCount}</strong> Out of Stock <span class="text-outline-variant mx-1">Â·</span> <strong>${kpiBelowThresholdCount}</strong> Low
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Card 4: Customer Rating -->
                        <div class="mc-atelier-card mc-atelier-card-hover">
                            <div class="d-flex align-items-start justify-content-between">
                                <span class="small fw-semibold text-outline">Guest Experience</span>
                                <div class="mc-kpi-icon-pill">
                                    <span class="material-symbols-outlined">star</span>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="font-playfair fs-3 fw-bold text-primary-container">${averageRating}</span>
                                    <div class="d-flex" style="color: #f59e0b;">
                                        <c:forEach var="s" begin="1" end="5">
                                            <span class="material-symbols-outlined" style="font-size: 18px; font-variation-settings: 'FILL' ${averageRating >= s ? 1 : 0};">star</span>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="small text-muted mt-2" style="font-size: 0.75rem;">
                                    Based on <strong>${kpiReviewCount}</strong> verified evaluations
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- 2. Row 2: 2-Column Section (65% / 35%) -->
                    <section class="mc-grid-revenue-alerts">
                        <!-- Left (65%): Revenue Overview Card with Dynamic SVG Curve -->
                        <div class="mc-atelier-card">
                            <div>
                                <!-- Header with Title & Period Telemetry -->
                                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 pb-3 border-bottom" style="border-color: rgba(211, 195, 190, 0.3) !important;">
                                    <div>
                                        <h2 class="font-playfair fs-5 fw-bold text-primary-container mb-1">
                                            Revenue Overview
                                        </h2>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="small text-muted">Daily Sales Total (LKR)</span>
                                            <span class="text-outline-variant">â€¢</span>
                                            <span class="small text-secondary fw-bold">Rs. <fmt:formatNumber value="${avgDailyRevenue}" minFractionDigits="2"/> daily avg</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="badge rounded-pill bg-dark text-white px-3 py-1.5 fw-semibold" style="font-size: 0.72rem; letter-spacing: 0.05em;">
                                            Last 7 Days
                                        </div>
                                        <a href="${pageContext.request.contextPath}/viewOrders?view=manage" class="small fw-semibold text-secondary text-decoration-none">
                                            Manage Orders â†’
                                        </a>
                                    </div>
                                </div>

                                <!-- Dynamic SVG Line & Area Chart with Atelier Gradient Fill -->
                                <div class="position-relative w-100 mt-4" style="height: 250px;">
                                    <svg class="w-100 h-100 overflow-visible" preserveAspectRatio="none" viewBox="0 0 650 220">
                                        <defs>
                                            <linearGradient id="revenueGradient" x1="0%" x2="0%" y1="0%" y2="100%">
                                                <stop offset="0%" stop-color="#C88A58" stop-opacity="0.35"></stop>
                                                <stop offset="60%" stop-color="#C88A58" stop-opacity="0.10"></stop>
                                                <stop offset="100%" stop-color="#C88A58" stop-opacity="0.0"></stop>
                                            </linearGradient>
                                        </defs>

                                        <!-- Dotted Horizontal Grid Lines -->
                                        <line stroke="#e8e1d5" stroke-dasharray="3,3" stroke-width="1" x1="50" x2="630" y1="25" y2="25"></line>
                                        <line stroke="#e8e1d5" stroke-dasharray="3,3" stroke-width="1" x1="50" x2="630" y1="67" y2="67"></line>
                                        <line stroke="#e8e1d5" stroke-dasharray="3,3" stroke-width="1" x1="50" x2="630" y1="110" y2="110"></line>
                                        <line stroke="#e8e1d5" stroke-dasharray="3,3" stroke-width="1" x1="50" x2="630" y1="152" y2="152"></line>
                                        <line stroke="#e8e1d5" stroke-dasharray="3,3" stroke-width="1" x1="50" x2="630" y1="195" y2="195"></line>

                                        <!-- Y-Axis Scale Labels -->
                                        <text fill="#817470" font-family="Outfit" font-size="10" text-anchor="end" x="42" y="28">Rs. <fmt:formatNumber value="${chartMaxRev}" maxFractionDigits="0"/></text>
                                        <text fill="#817470" font-family="Outfit" font-size="10" text-anchor="end" x="42" y="71">Rs. <fmt:formatNumber value="${chartMaxRev * 0.75}" maxFractionDigits="0"/></text>
                                        <text fill="#817470" font-family="Outfit" font-size="10" text-anchor="end" x="42" y="114">Rs. <fmt:formatNumber value="${chartMaxRev * 0.5}" maxFractionDigits="0"/></text>
                                        <text fill="#817470" font-family="Outfit" font-size="10" text-anchor="end" x="42" y="156">Rs. <fmt:formatNumber value="${chartMaxRev * 0.25}" maxFractionDigits="0"/></text>
                                        <text fill="#817470" font-family="Outfit" font-size="10" text-anchor="end" x="42" y="198">Rs. 0</text>

                                        <!-- Filled Dynamic Area Under Curve -->
                                        <path d="${chartAreaPath}" fill="url(#revenueGradient)"></path>

                                        <!-- Main Dynamic Trajectory Curve -->
                                        <path d="${chartLinePath}" fill="none" stroke="#2B1810" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"></path>

                                        <!-- Interactive Data Points for each day -->
                                        <c:forEach var="i" begin="0" end="6">
                                            <circle cx="${chartX[i]}" cy="${chartY[i]}" fill="${i == 6 ? '#2B1810' : '#FAF6EE'}" r="${i == 6 ? '6' : '4.5'}" stroke="${i == 6 ? '#FAF6EE' : '#2B1810'}" stroke-width="2">
                                                <title>${chartDayLabels[i]}: Rs. ${chartVals[i]}</title>
                                            </circle>
                                        </c:forEach>
                                    </svg>
                                </div>

                                <!-- X-Axis Labels (Chronological 7 Days) -->
                                <div class="d-grid text-center pt-2 border-top" style="grid-template-columns: repeat(7, 1fr); border-color: rgba(211, 195, 190, 0.3) !important; margin-left: 45px;">
                                    <c:forEach var="lbl" items="${chartDayLabels}" varStatus="status">
                                        <span class="small ${status.last ? 'text-secondary fw-bold' : 'text-muted'}" style="font-size: 0.72rem;">${lbl}</span>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Right (35%): Needs Attention Priority Ledger -->
                        <div class="mc-atelier-card">
                            <div>
                                <div class="d-flex align-items-center justify-content-between pb-3 border-bottom" style="border-color: rgba(211, 195, 190, 0.3) !important;">
                                    <h2 class="font-playfair fs-5 fw-bold text-primary-container mb-0">Needs Attention</h2>
                                    <span class="badge rounded-pill bg-danger-subtle text-danger border border-danger-subtle px-2.5 py-1 fw-bold" style="font-size: 0.72rem;">
                                        <span class="material-symbols-outlined" style="font-size: 13px; margin-right: 2px;">priority_high</span>
                                        ${fn:length(alertItems)} Alerts
                                    </span>
                                </div>

                                <div class="mt-2">
                                    <c:choose>
                                        <c:when test="${not empty alertItems}">
                                            <c:forEach var="al" items="${alertItems}">
                                                <div class="mc-list-item-row">
                                                    <div class="min-w-0 flex-grow-1">
                                                        <div class="d-flex align-items-center gap-2 mb-1">
                                                            <span class="mc-alert-badge ${al.badgeClass}">
                                                                ${al.type}
                                                            </span>
                                                            <span class="small text-muted" style="font-size: 0.72rem;">${al.sub}</span>
                                                        </div>
                                                        <div class="fw-semibold text-primary-container text-truncate small" style="font-size: 0.82rem;">${al.title}</div>
                                                        <div class="text-muted text-truncate" style="font-size: 0.72rem;">${al.desc}</div>
                                                    </div>
                                                    <a href="${al.actionUrl}" class="flex-shrink-0 small fw-bold text-secondary text-decoration-none">
                                                        ${al.actionLabel}
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-5 text-center text-muted">
                                                <span class="material-symbols-outlined text-success fs-2 mb-2">task_alt</span>
                                                <p class="mb-0 small fw-semibold">All operations running smoothly with zero bottlenecks.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="mt-4 pt-3 border-top d-flex align-items-center justify-content-between small text-muted" style="border-color: rgba(211, 195, 190, 0.25) !important; font-size: 0.72rem;">
                                <span>Production &amp; Inventory Watchdog</span>
                                <span class="material-symbols-outlined text-success" style="font-size: 16px;">check_circle</span>
                            </div>
                        </div>
                    </section>

                    <!-- 3. Row 3: 2-Column Section (50% / 50%) -->
                    <section class="mc-grid-equal-2col">
                        <!-- Left: Recent Business Activity -->
                        <div class="mc-atelier-card">
                            <div>
                                <div class="d-flex align-items-center justify-content-between pb-3 border-bottom" style="border-color: rgba(211, 195, 190, 0.3) !important;">
                                    <h2 class="font-playfair fs-5 fw-bold text-primary-container mb-0">
                                        Recent Business Activity
                                    </h2>
                                </div>

                                <div class="mt-3">
                                    <c:choose>
                                        <c:when test="${not empty activityItems}">
                                            <c:forEach var="act" items="${activityItems}">
                                                <div class="mc-list-item-row">
                                                    <div class="mc-act-icon ${act.iconBg}">
                                                        <span class="material-symbols-outlined" style="font-size: 16px;">${act.icon}</span>
                                                    </div>
                                                    <div class="flex-grow-1 min-w-0">
                                                        <div class="fw-semibold text-primary-container text-truncate small" style="font-size: 0.82rem;">
                                                            ${act.title}
                                                        </div>
                                                        <div class="text-secondary small mt-0.5" style="font-size: 0.75rem;">${act.sub}</div>
                                                        <c:if test="${not empty act.meta}">
                                                            <div class="text-muted" style="font-size: 0.7rem;">${act.meta}</div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-4 text-center text-muted small">No recent activity recorded.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Customer Insights & Rating Breakdown -->
                        <div class="mc-atelier-card">
                            <div>
                                <div class="d-flex align-items-center justify-content-between pb-3 border-bottom" style="border-color: rgba(211, 195, 190, 0.3) !important;">
                                    <div>
                                        <h2 class="font-playfair fs-5 fw-bold text-primary-container mb-0">
                                            Customer Insights
                                        </h2>
                                    </div>
                                    <a class="small fw-semibold text-secondary text-decoration-none" href="${pageContext.request.contextPath}/viewReviews">
                                        All Reviews (${kpiReviewCount}) â†’
                                    </a>
                                </div>

                                <!-- Overall Rating Hero -->
                                <div class="mt-3 p-3 rounded-3 d-flex flex-wrap align-items-center justify-content-between gap-3" style="background-color: var(--mc-surface-low); border: 1px solid rgba(211, 195, 190, 0.3);">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="font-playfair fs-1 fw-bold text-primary-container leading-none">
                                            ${averageRating}
                                        </div>
                                        <div>
                                            <div class="d-flex" style="color: #f59e0b;">
                                                <c:forEach var="s" begin="1" end="5">
                                                    <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' ${averageRating >= s ? 1 : 0};">star</span>
                                                </c:forEach>
                                            </div>
                                            <div class="text-muted mt-1" style="font-size: 0.72rem;">Customer Rating</div>
                                        </div>
                                    </div>
                                    <div class="badge rounded-pill bg-success-subtle text-success border border-success-subtle px-3 py-1.5 fw-bold d-inline-flex align-items-center gap-1" style="font-size: 0.75rem;">
                                        <span class="material-symbols-outlined" style="font-size: 14px;">thumb_up</span>
                                        <span>${positiveSentiment}% Positive Sentiment</span>
                                    </div>
                                </div>

                                <!-- Rating Breakdown Progress Bars -->
                                <div class="mt-3 d-flex flex-column gap-2">
                                    <div class="d-flex align-items-center gap-3 small" style="font-size: 0.75rem;">
                                        <span class="text-muted fw-semibold" style="width: 48px; text-align: right;">5 Star</span>
                                        <div class="mc-progress-track">
                                            <div class="mc-progress-fill-5" style="width: ${reviewPct5}%;"></div>
                                        </div>
                                        <span class="text-muted fw-semibold" style="width: 36px; text-align: right;">${reviewPct5}%</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-3 small" style="font-size: 0.75rem;">
                                        <span class="text-muted fw-semibold" style="width: 48px; text-align: right;">4 Star</span>
                                        <div class="mc-progress-track">
                                            <div class="mc-progress-fill-4" style="width: ${reviewPct4}%;"></div>
                                        </div>
                                        <span class="text-muted fw-semibold" style="width: 36px; text-align: right;">${reviewPct4}%</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-3 small" style="font-size: 0.75rem;">
                                        <span class="text-muted fw-semibold" style="width: 48px; text-align: right;">3 Star</span>
                                        <div class="mc-progress-track">
                                            <div class="mc-progress-fill-3" style="width: ${reviewPct3}%;"></div>
                                        </div>
                                        <span class="text-muted fw-semibold" style="width: 36px; text-align: right;">${reviewPct3}%</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-3 small" style="font-size: 0.75rem;">
                                        <span class="text-muted fw-semibold" style="width: 48px; text-align: right;">2 Star</span>
                                        <div class="mc-progress-track">
                                            <div class="mc-progress-fill-2" style="width: ${reviewPct2}%;"></div>
                                        </div>
                                        <span class="text-muted fw-semibold" style="width: 36px; text-align: right;">${reviewPct2}%</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-3 small" style="font-size: 0.75rem;">
                                        <span class="text-muted fw-semibold" style="width: 48px; text-align: right;">1 Star</span>
                                        <div class="mc-progress-track">
                                            <div class="mc-progress-fill-1" style="width: ${reviewPct1}%;"></div>
                                        </div>
                                        <span class="text-muted fw-semibold" style="width: 36px; text-align: right;">${reviewPct1}%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- 4. Row 4: Compact Summary Section (2-Column: 50% / 50%) -->
                    <section class="mc-grid-equal-2col pb-4">
                        <!-- Left: Inventory Overview -->
                        <div class="mc-atelier-card">
                            <div>
                                <div class="d-flex align-items-center justify-content-between pb-3 border-bottom" style="border-color: rgba(211, 195, 190, 0.3) !important;">
                                    <div>
                                        <h2 class="font-playfair fs-5 fw-bold text-primary-container mb-0">
                                            Inventory Overview
                                        </h2>
                                    </div>
                                    <a class="small fw-semibold text-secondary text-decoration-none" href="${pageContext.request.contextPath}/manageProducts">
                                        Full Catalogue â†’
                                    </a>
                                </div>

                                <div class="mt-2">
                                    <c:choose>
                                        <c:when test="${not empty watchProducts}">
                                            <c:forEach var="p" items="${watchProducts}">
                                                <div class="mc-list-item-row">
                                                    <div class="d-flex align-items-center gap-3 min-w-0">
                                                        <div class="rounded-3 d-flex align-items-center justify-content-center text-white fw-bold font-playfair flex-shrink-0" style="width: 40px; height: 40px; background-color: var(--mc-primary-container); font-size: 0.85rem;">
                                                            ${productInitials[p.productId]}
                                                        </div>
                                                        <div class="min-w-0">
                                                            <div class="fw-semibold text-primary-container text-truncate small" style="font-size: 0.85rem;">
                                                                ${p.name}
                                                            </div>
                                                            <div class="text-muted text-truncate" style="font-size: 0.72rem;">
                                                                ${not empty p.flavor ? p.flavor : p.category}
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="text-end flex-shrink-0">
                                                        <div class="fw-bold text-primary-container small" style="font-size: 0.85rem;">
                                                            Rs. <fmt:formatNumber value="${p.price}" minFractionDigits="2"/>
                                                        </div>
                                                        <c:choose>
                                                            <c:when test="${p.stockQuantity == 0}">
                                                                <span class="badge rounded-pill bg-danger-subtle text-danger border border-danger-subtle px-2 py-0.5" style="font-size: 0.7rem;">
                                                                    Out of Stock
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${p.stockQuantity <= 5}">
                                                                <span class="badge rounded-pill bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-0.5" style="font-size: 0.7rem;">
                                                                    Low Stock (${p.stockQuantity} left)
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge rounded-pill bg-success-subtle text-success border border-success-subtle px-2 py-0.5" style="font-size: 0.7rem;">
                                                                    In Stock (${p.stockQuantity})
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-4 text-center text-muted small">No products in catalogue watch.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="mt-4 pt-3 border-top d-flex align-items-center justify-content-end small text-muted" style="border-color: rgba(211, 195, 190, 0.25) !important; font-size: 0.72rem;">
                                <a href="${pageContext.request.contextPath}/comp02-products/add_product.jsp" class="text-secondary fw-bold text-decoration-none">+ Add Item</a>
                            </div>
                        </div>

                        <!-- Right: Order Fulfillment -->
                        <div class="mc-atelier-card">
                            <div>
                                <div class="d-flex align-items-center justify-content-between pb-3 border-bottom" style="border-color: rgba(211, 195, 190, 0.3) !important;">
                                    <div>
                                        <h2 class="font-playfair fs-5 fw-bold text-primary-container mb-0">
                                            Order Fulfillment
                                        </h2>
                                    </div>
                                    <a class="small fw-semibold text-secondary text-decoration-none" href="${pageContext.request.contextPath}/kitchenQueue">
                                        Kitchen Board â†’
                                    </a>
                                </div>

                                <div class="mt-2">
                                    <c:choose>
                                        <c:when test="${not empty upcomingPickups}">
                                            <c:forEach var="t" items="${upcomingPickups}" begin="0" end="2">
                                                <div class="mc-list-item-row">
                                                    <div class="d-flex align-items-center gap-3 min-w-0">
                                                        <div class="rounded-circle d-flex align-items-center justify-content-center text-secondary fw-bold flex-shrink-0" style="width: 38px; height: 38px; background-color: rgba(134, 82, 37, 0.12); font-size: 0.75rem;">
                                                            ${taskCustomerInitials[t.taskId]}
                                                        </div>
                                                        <div class="min-w-0">
                                                            <div class="fw-semibold text-primary-container text-truncate small" style="font-size: 0.85rem;">
                                                                ${not empty t.customerName ? t.customerName : 'Walk-in Patron'}
                                                            </div>
                                                            <div class="text-muted text-truncate" style="font-size: 0.72rem;">
                                                                #${t.referenceCode} Â· ${t.taskType == 'CUSTOM_CAKE' ? t.customCakeFlavor : 'Pastry Batch'}
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="text-end flex-shrink-0">
                                                        <div class="fw-semibold text-primary-container small" style="font-size: 0.82rem;">
                                                            ${not empty t.timeSlot ? t.timeSlot : t.formattedShortDueDatetime}
                                                        </div>
                                                        <c:choose>
                                                            <c:when test="${t.fulfillmentType == 'Delivery'}">
                                                                <span class="badge rounded-pill bg-info-subtle text-info-emphasis border border-info-subtle px-2 py-0.5" style="font-size: 0.7rem;">
                                                                    Delivery
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge rounded-pill bg-light text-dark border px-2 py-0.5" style="font-size: 0.7rem;">
                                                                    Pickup
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="py-5 text-center text-muted">
                                                <span class="material-symbols-outlined text-secondary fs-2 mb-2">check_circle</span>
                                                <p class="mb-0 small fw-semibold">No pending pickups or deliveries scheduled for today.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="mt-4 pt-3 border-top d-flex align-items-center justify-content-end small text-muted" style="border-color: rgba(211, 195, 190, 0.25) !important; font-size: 0.72rem;">
                                <a href="${pageContext.request.contextPath}/kitchenQueue" class="text-secondary fw-bold text-decoration-none">Full Production Schedule â†’</a>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <!-- Unauthorized Access Guard -->
        <main class="container my-5 py-5 flex-grow-1 text-center">
            <div class="card card-maple maple-panel-card shadow-sm mx-auto p-5 border-0 rounded-4" style="max-width: 480px; background: #ffffff;">
                <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134, 82, 37, 0.1); color: var(--maple-gold-500, #865225);">
                    <span class="material-symbols-outlined fs-1">shield_lock</span>
                </div>
                <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Administrator Access Required</h3>
                <p class="text-muted small mb-4">You must be logged in as an authorized Staff member or Administrator to access the administrative operations hub.</p>
                <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-maple-primary px-4 py-2 d-inline-flex align-items-center justify-content-center gap-2 rounded-pill shadow-sm">
                    <span class="material-symbols-outlined fs-5">login</span> Sign In with Staff Account
                </a>
            </div>
        </main>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    function submitKitchenAction(selectEl) {
        const form = selectEl.closest('form');
        if (!form) return;
        const formData = new FormData(form);
        fetch(form.action, {
            method: 'POST',
            body: new URLSearchParams(formData),
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error('Action failed');
        })
        .then(data => {
            const banner = document.getElementById('kitchenSuccessBanner');
            if (banner) {
                banner.classList.remove('d-none');
                banner.querySelector('.banner-msg').textContent = data.message || 'Workstation updated successfully.';
                setTimeout(() => {
                    banner.classList.add('d-none');
                }, 4000);
            }
        })
        .catch(err => {
            form.submit();
        });
    }
</script>
</body>
</html>
