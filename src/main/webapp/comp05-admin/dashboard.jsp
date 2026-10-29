<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
com.mapleandcrumb.model.comp01.User loggedUser = (com.mapleandcrumb.model.comp01.User) session.getAttribute("loggedInUser");
if (loggedUser != null && ("ADMIN".equals(loggedUser.getUserRole()) || "STAFF".equals(loggedUser.getUserRole()))) {
com.mapleandcrumb.dao.comp02.ProductDAO prodDao = new com.mapleandcrumb.dao.impl.comp02.ProductDAOImpl();
com.mapleandcrumb.dao.comp05.StaffDAO stfDao = new com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl();
com.mapleandcrumb.dao.comp01.UserDAO usrDao = new com.mapleandcrumb.dao.impl.comp01.UserDAOImpl();
com.mapleandcrumb.dao.comp03.CustomCakeDAO cakeDao = new com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl();
com.mapleandcrumb.dao.comp04.OrderDAO ordDao = new com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl();
com.mapleandcrumb.dao.comp06.PromotionDAO promoDao = new com.mapleandcrumb.dao.impl.comp06.PromotionDAOImpl();
com.mapleandcrumb.dao.comp06.ReviewDAO revDao = new com.mapleandcrumb.dao.impl.comp06.ReviewDAOImpl();
com.mapleandcrumb.dao.comp05.KitchenTaskDAO kitchenDao = new com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl();

request.setAttribute("kpiProductCount", prodDao.getProductCount());
request.setAttribute("kpiStaffCount", stfDao.getStaffCount());
request.setAttribute("kpiUserCount", usrDao.getUserCount());
request.setAttribute("kpiBookingCount", cakeDao.getBookingCount());
request.setAttribute("kpiOrderCount", ordDao.getOrderCount());
request.setAttribute("kpiActivePromos", promoDao.getAllActivePromotions().size());

java.util.List<com.mapleandcrumb.model.comp06.Review> allReviews = revDao.getAllReviews();
    request.setAttribute("kpiReviewCount", allReviews.size());
    double avgRating = 5.0;
    if (!allReviews.isEmpty()) {
    int sumRating = 0;
    for (com.mapleandcrumb.model.comp06.Review r : allReviews) {
    sumRating += r.getRating();
    }
    avgRating = Math.round(((double) sumRating / allReviews.size()) * 10.0) / 10.0;
    }
    request.setAttribute("averageRating", avgRating);

    // Kitchen Operations Metrics & Sync
    kitchenDao.syncMissingTasks();
    request.setAttribute("kpiActiveTasks", kitchenDao.getActiveTaskCount());
    request.setAttribute("kpiTodayTasks", kitchenDao.getTodayTaskCount());
    request.setAttribute("kpiTomorrowTasks", kitchenDao.getTomorrowTaskCount());
    request.setAttribute("kpiCakeInPrep", kitchenDao.getCustomCakesInPrepCount());
    request.setAttribute("kpiOverdueTasks", kitchenDao.getOverdueTaskCount());

    // Kitchen Queue Tasks & Filtering
    String dateFilter = request.getParameter("date") != null ? request.getParameter("date").trim() : "all";
    String channelFilter = request.getParameter("channel") != null ? request.getParameter("channel").trim() : "all";
    String stageFilter = request.getParameter("stage") != null ? request.getParameter("stage").trim() : "all";
    String searchQ = request.getParameter("q") != null ? request.getParameter("q").trim() : null;

    request.setAttribute("currentDateFilter", dateFilter);
    request.setAttribute("currentChannelFilter", channelFilter);
    request.setAttribute("currentStageFilter", stageFilter);
    request.setAttribute("searchKeyword", searchQ);

    request.setAttribute("tasks", kitchenDao.getTasksByFilter(dateFilter, channelFilter, stageFilter, searchQ));
    request.setAttribute("staffList", stfDao.getAllStaff());
    }
    %>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Maple &amp; Crumb Haute-Pâtisserie — Admin Suite</title>
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com" rel="preconnect">
        <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&amp;family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Tailwind CSS with custom configuration (Preflight disabled to protect Bootstrap & navbar) -->
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <script id="tailwind-config">
            tailwind.config = {
                corePlugins: {
                    preflight: false
                },
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "secondary-fixed-dim": "#fdb882",
                            "outline-variant": "#d3c3be",
                            "tertiary-fixed": "#ffdea5",
                            "surface-container-highest": "#e6e2da",
                            "on-background": "#1c1c17",
                            "on-primary-fixed-variant": "#5a4137",
                            "on-tertiary-fixed-variant": "#5d4201",
                            "secondary": "#865225",
                            "surface": "#fdf9f1",
                            "error": "#ba1a1a",
                            "on-error": "#ffffff",
                            "primary-container": "#2b1810",
                            "inverse-surface": "#31302b",
                            "inverse-primary": "#e2bfb2",
                            "on-secondary-container": "#78471b",
                            "surface-tint": "#73584e",
                            "on-error-container": "#93000a",
                            "surface-variant": "#e6e2da",
                            "on-tertiary-container": "#a17f3c",
                            "on-tertiary-fixed": "#261900",
                            "on-primary-container": "#9c7e73",
                            "on-secondary-fixed": "#2f1500",
                            "on-primary-fixed": "#2a170f",
                            "primary": "#070100",
                            "error-container": "#ffdad6",
                            "on-secondary-fixed-variant": "#6a3b10",
                            "outline": "#817470",
                            "tertiary-container": "#281a00",
                            "on-surface-variant": "#4f4440",
                            "tertiary-fixed-dim": "#e9c176",
                            "on-secondary": "#ffffff",
                            "on-primary": "#ffffff",
                            "tertiary": "#030200",
                            "secondary-fixed": "#ffdcc3",
                            "primary-fixed-dim": "#e2bfb2",
                            "surface-container": "#f1ede6",
                            "surface-container-lowest": "#ffffff",
                            "surface-container-high": "#ece8e0",
                            "inverse-on-surface": "#f4f0e8",
                            "on-tertiary": "#ffffff",
                            "background": "#fdf9f1",
                            "on-surface": "#1c1c17",
                            "surface-container-low": "#f7f3eb",
                            "secondary-container": "#fdb882",
                            "primary-fixed": "#ffdbcd",
                            "surface-dim": "#dddad2",
                            "surface-bright": "#fdf9f1"
                        },
                        "borderRadius": {
                            "DEFAULT": "1rem",
                            "lg": "2rem",
                            "xl": "3rem",
                            "full": "9999px"
                        },
                        "fontFamily": {
                            "headline-sm": ["Playfair Display"],
                            "body-lg": ["Outfit"],
                            "headline-lg": ["Playfair Display"],
                            "body-sm": ["Outfit"],
                            "body-md": ["Outfit"]
                        }
                    }
                }
            }
        </script>
        <!-- Maple & Crumb Custom Styling -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                display: inline-block;
                vertical-align: middle;
                line-height: 1;
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100 bg-surface text-on-surface font-body-md antialiased">

    <jsp:include page="/WEB-INF/includes/navbar.jsp" />

    <c:choose>
        <c:when test="${not empty sessionScope.loggedInUser && (sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF')}">
            <div class="mc-admin-layout-wrapper">
                <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                    <jsp:param name="activeTab" value="dashboard" />
                </jsp:include>
                <!-- Main Content Canvas -->
                <div class="mc-admin-content-canvas">
                    <!-- Top Navigation & Actions Bar -->
                    <header class="mc-admin-header px-4 sm:px-6 py-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-3">
                            <button type="button" class="d-lg-none btn btn-sm btn-maple-secondary rounded-3 px-2.5 py-1.5 d-inline-flex align-items-center gap-1 shadow-sm" onclick="toggleAdminSidebar()" aria-label="Toggle Admin Menu">
                                <span class="material-symbols-outlined fs-5">menu</span>
                                <span class="small fw-semibold">Console</span>
                            </button>
                            <div>
                                <div class="flex items-center gap-2">
                                    <span class="font-label-md text-label-md uppercase tracking-wider text-secondary font-semibold">Maple and Crumb Operations &amp; Kitchen Hub</span>
                                </div>
                                <h2 class="font-headline-sm text-xl text-primary font-bold mb-0">Administrative Operations Suite</h2>
                            </div>
                        </div>
                        <div class="flex items-center gap-2.5">
                            <a href="${pageContext.request.contextPath}/comp02-products/add_product.jsp" class="inline-flex items-center gap-1.5 px-4 py-2 rounded-DEFAULT bg-primary text-surface hover:bg-primary-container transition-colors text-xs font-semibold shadow-sm text-decoration-none">
                                <span class="material-symbols-outlined text-base">add</span>
                                + New Product
                            </a>
                        </div>
                    </header>

                    <main class="flex-1 max-w-[1360px] w-full mx-auto p-6 lg:p-8 space-y-8">
                        <!-- Section 1: Executive Overview Counters -->
                        <section aria-label="Executive Overview" class="w-full">
                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 sm:gap-6">
                                <!-- Metric 1: Today's Due -->
                                <div class="bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 p-5 shadow-sm hover:border-secondary/40 transition-colors flex flex-col justify-between">
                                    <div>
                                        <div class="flex items-center justify-between text-on-surface-variant mb-2">
                                            <span class="text-xs tracking-wider uppercase font-semibold text-on-surface-variant">TODAY'S DUE</span>
                                            <span class="material-symbols-outlined text-secondary text-xl">today</span>
                                        </div>
                                        <div class="flex items-baseline gap-2">
                                            <span class="text-3xl font-bold font-serif text-primary">${kpiTodayTasks}</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=today" class="text-xs font-medium text-secondary hover:underline flex items-center gap-1 mt-3 text-decoration-none">
                                        View today's queue →
                                    </a>
                                </div>

                                <!-- Metric 2: Due Tomorrow -->
                                <div class="bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 p-5 shadow-sm hover:border-secondary/40 transition-colors flex flex-col justify-between">
                                    <div>
                                        <div class="flex items-center justify-between text-on-surface-variant mb-2">
                                            <span class="text-xs tracking-wider uppercase font-semibold text-on-surface-variant">DUE TOMORROW</span>
                                            <span class="material-symbols-outlined text-secondary text-xl">event_upcoming</span>
                                        </div>
                                        <div class="flex items-baseline gap-2">
                                            <span class="text-3xl font-bold font-serif text-primary">${kpiTomorrowTasks}</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=tomorrow" class="text-xs font-medium text-secondary hover:underline flex items-center gap-1 mt-3 text-decoration-none">
                                        View tomorrow's batch →
                                    </a>
                                </div>

                                <!-- Metric 3: Custom Cakes -->
                                <div class="bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 p-5 shadow-sm hover:border-secondary/40 transition-colors flex flex-col justify-between">
                                    <div>
                                        <div class="flex items-center justify-between text-on-surface-variant mb-2">
                                            <span class="text-xs tracking-wider uppercase font-semibold text-on-surface-variant">CUSTOM CAKES</span>
                                            <span class="material-symbols-outlined text-secondary text-xl">cake</span>
                                        </div>
                                        <div class="flex items-baseline gap-2">
                                            <span class="text-3xl font-bold font-serif text-primary">${kpiCakeInPrep}</span>
                                        </div>
                                    </div>
                                    <span class="text-xs font-medium text-on-surface-variant mt-3">In active decorating</span>
                                </div>

                                <!-- Metric 4: Overdue Prep -->
                                <div class="bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 p-5 shadow-sm hover:border-secondary/40 transition-colors flex flex-col justify-between ${kpiOverdueTasks > 0 ? 'border-red-400 bg-red-50/20' : ''}">
                                    <div>
                                        <div class="flex items-center justify-between text-on-surface-variant mb-2">
                                            <span class="text-xs tracking-wider uppercase font-semibold ${kpiOverdueTasks > 0 ? 'text-red-700 font-bold' : 'text-on-surface-variant'}">OVERDUE PREP</span>
                                            <span class="material-symbols-outlined ${kpiOverdueTasks > 0 ? 'text-red-600' : 'text-error'} text-xl">warning</span>
                                        </div>
                                        <div class="flex items-baseline gap-2">
                                            <span class="text-3xl font-bold font-serif ${kpiOverdueTasks > 0 ? 'text-red-700' : 'text-primary'}">${kpiOverdueTasks}</span>
                                        </div>
                                    </div>
                                    <span class="text-xs font-medium ${kpiOverdueTasks > 0 ? 'text-red-700 font-semibold' : 'text-secondary'} mt-3">
                                    ${kpiOverdueTasks > 0 ? 'Requires immediate action' : 'All deadlines met'}
                                </span>
                                </div>
                            </div>
                        </section>

                        <!-- Section 2: Dedicated Kitchen Operations Suite -->
                        <div class="space-y-6" id="live-kitchen-section">
                            <!-- Header -->
                            <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
                                <div>
                                    <span class="font-label-md text-label-md uppercase tracking-wider text-secondary font-semibold">Daily Production &amp; Kitchen Queue Monitor</span>
                                    <h2 class="font-headline-lg text-2xl sm:text-3xl font-headline-sm text-primary mt-1 mb-0">Live Bakery Baking Schedule</h2>
                                    <p class="font-body-md text-body-md text-on-surface-variant mt-1 mb-0 max-w-2xl">
                                        Track today's pastry batches, monitor sponge cooling, and assign pastry chefs to workstations.
                                    </p>
                                </div>
                                <div class="flex items-center gap-2">
                                    <a href="${pageContext.request.contextPath}/kitchenQueue" class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-DEFAULT bg-surface-container-low border border-outline-variant/30 text-on-surface hover:bg-surface-container transition-colors text-xs font-medium shadow-sm text-decoration-none">
                                        <span class="material-symbols-outlined text-sm">view_kanban</span>
                                        Open Full Queue
                                    </a>
                                </div>
                            </div>

                            <!-- Flash / Dynamic Status Banners -->
                            <c:if test="${param.msg == 'baker_assigned'}">
                                <div class="flex items-center gap-3 px-4 py-3 bg-[#e8f8f0] border border-[#bbf0d8] rounded-DEFAULT text-[#166534] text-xs font-medium shadow-sm">
                                    <span class="material-symbols-outlined text-lg text-emerald-600">check_circle</span>
                                    <span>Baker has been assigned to the workstation successfully.</span>
                                </div>
                            </c:if>
                            <c:if test="${param.msg == 'stage_updated'}">
                                <div class="flex items-center gap-3 px-4 py-3 bg-[#e8f8f0] border border-[#bbf0d8] rounded-DEFAULT text-[#166534] text-xs font-medium shadow-sm">
                                    <span class="material-symbols-outlined text-lg text-emerald-600">check_circle</span>
                                    <span>Preparation stage updated in production records.</span>
                                </div>
                            </c:if>
                            <div id="kitchenSuccessBanner" class="d-none flex items-center gap-3 px-4 py-3 bg-[#e8f8f0] border border-[#bbf0d8] rounded-DEFAULT text-[#166534] text-xs font-medium shadow-sm">
                                <span class="material-symbols-outlined text-lg text-emerald-600">check_circle</span>
                                <span class="banner-msg">Workstation updated successfully.</span>
                            </div>

                            <!-- Search and Filter Bar -->
                            <div class="bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 p-3 shadow-sm flex flex-wrap items-center justify-between gap-3">
                                <!-- Search Input -->
                                <div class="relative flex-1 min-w-[280px] max-w-md">
                                    <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-lg">search</span>
                                    <input type="text" id="kitchenSearchInput" onkeyup="filterKitchenCards()" placeholder="Search order code, customer, flavor..." class="w-full pl-9 pr-4 py-2 bg-surface-container-low border border-outline-variant/30 rounded-DEFAULT text-xs text-on-surface placeholder:text-on-surface-variant/70 focus:outline-none focus:border-secondary/60 transition-colors">
                                </div>

                                <!-- Filter Pills -->
                                <div class="flex flex-wrap items-center gap-1.5 text-xs font-medium">
                                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp?date=all&channel=${currentChannelFilter}&stage=${currentStageFilter}#live-kitchen-section" class="px-3 py-1.5 rounded-DEFAULT ${currentDateFilter == 'all' ? 'bg-primary text-surface font-semibold shadow-sm text-white' : 'bg-surface-container-low border border-outline-variant/30 text-on-surface hover:bg-surface-container'} transition-colors text-decoration-none">All</a>
                                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp?date=today&channel=${currentChannelFilter}&stage=${currentStageFilter}#live-kitchen-section" class="px-3 py-1.5 rounded-DEFAULT ${currentDateFilter == 'today' ? 'bg-primary text-surface font-semibold shadow-sm text-white' : 'bg-surface-container-low border border-outline-variant/30 text-on-surface hover:bg-surface-container'} transition-colors text-decoration-none">Today</a>
                                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp?date=tomorrow&channel=${currentChannelFilter}&stage=${currentStageFilter}#live-kitchen-section" class="px-3 py-1.5 rounded-DEFAULT ${currentDateFilter == 'tomorrow' ? 'bg-primary text-surface font-semibold shadow-sm text-white' : 'bg-surface-container-low border border-outline-variant/30 text-on-surface hover:bg-surface-container'} transition-colors text-decoration-none">Tomorrow</a>
                                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp?date=overdue&channel=${currentChannelFilter}&stage=${currentStageFilter}#live-kitchen-section" class="px-3 py-1.5 rounded-DEFAULT ${currentDateFilter == 'overdue' ? 'bg-red-700 text-white font-semibold shadow-sm' : 'bg-surface-container-low border border-outline-variant/30 text-red-700 hover:bg-red-50'} transition-colors text-decoration-none">Overdue (${kpiOverdueTasks})</a>

                                    <div class="h-4 w-[1px] bg-outline-variant/40 mx-1"></div>

                                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp?date=${currentDateFilter}&channel=all&stage=${currentStageFilter}#live-kitchen-section" class="px-3 py-1.5 rounded-DEFAULT ${currentChannelFilter == 'all' ? 'bg-primary text-surface font-semibold shadow-sm text-white' : 'bg-surface-container-low border border-outline-variant/30 text-on-surface hover:bg-surface-container'} transition-colors text-decoration-none">All Channels</a>
                                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp?date=${currentDateFilter}&channel=pickup&stage=${currentStageFilter}#live-kitchen-section" class="px-3 py-1.5 rounded-DEFAULT ${currentChannelFilter == 'pickup' ? 'bg-primary text-surface font-semibold shadow-sm text-white' : 'bg-surface-container-low border border-outline-variant/30 text-on-surface hover:bg-surface-container'} transition-colors text-decoration-none">Pickup</a>
                                    <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp?date=${currentDateFilter}&channel=delivery&stage=${currentStageFilter}#live-kitchen-section" class="px-3 py-1.5 rounded-DEFAULT ${currentChannelFilter == 'delivery' ? 'bg-primary text-surface font-semibold shadow-sm text-white' : 'bg-surface-container-low border border-outline-variant/30 text-on-surface hover:bg-surface-container'} transition-colors text-decoration-none">Delivery</a>
                                </div>
                            </div>

                            <!-- Ticket Cards Grid -->
                            <c:choose>
                                <c:when test="${not empty tasks}">
                                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6" id="kitchenTasksContainer">
                                        <c:forEach var="t" items="${tasks}">
                                            <div class="kitchen-card-item bg-surface-container-lowest rounded-DEFAULT border ${t.overdue ? 'border-red-400' : 'border-outline-variant/30'} p-5 shadow-sm space-y-4 hover:border-secondary/40 transition-colors" data-search="${t.referenceCode} ${t.customerName} ${t.customCakeFlavor} ${t.prepStage} ${t.fulfillmentType}">
                                                <!-- Top Badges & Timing Header -->
                                                <div class="flex items-center justify-between flex-wrap gap-2">
                                                    <div class="flex items-center gap-2">
                                                        <span class="px-2.5 py-1 rounded-DEFAULT bg-[#ffe0b2] text-[#6d3800] font-mono font-bold text-xs tracking-tight">#${t.referenceCode}</span>
                                                        <c:choose>
                                                            <c:when test="${t.taskType == 'CUSTOM_CAKE'}">
                                                            <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-surface-container-low border border-outline-variant/30 text-xs font-medium text-on-surface-variant">
                                                                <span class="material-symbols-outlined text-xs text-secondary">cake</span>
                                                                Bespoke Cake
                                                            </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                            <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-surface-container-low border border-outline-variant/30 text-xs font-medium text-on-surface-variant">
                                                                <span class="material-symbols-outlined text-xs text-secondary">local_fire_department</span>
                                                                Pastry Batch
                                                            </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="flex items-center gap-2">
                                                    <span class="inline-flex items-center gap-1 text-xs text-on-surface-variant font-medium bg-surface-container-low/70 px-2.5 py-0.5 rounded-DEFAULT border border-outline-variant/20">
                                                        <span class="material-symbols-outlined text-xs text-secondary">calendar_today</span>
                                                        ${t.formattedShortDueDatetime}
                                                    </span>
                                                        <c:choose>
                                                            <c:when test="${t.fulfillmentType == 'Delivery'}">
                                                            <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-DEFAULT bg-[#e0f2fe] text-[#0369a1] font-medium text-xs border border-[#bae6fd]">
                                                                <span class="material-symbols-outlined text-xs">local_shipping</span>
                                                                Express Dispatch
                                                            </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                            <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-DEFAULT bg-[#fff3e0] text-[#b45309] font-medium text-xs border border-[#fed7aa]">
                                                                <span class="material-symbols-outlined text-xs">storefront</span>
                                                                Counter Pickup
                                                            </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <!-- Customer Row -->
                                                <div class="flex items-center gap-1.5 text-xs text-on-surface-variant">
                                                    <span class="material-symbols-outlined text-sm text-secondary">person</span>
                                                    <span>Customer: <strong class="text-primary font-semibold">${not empty t.customerName ? t.customerName : 'Walk-in Patron'}</strong> <c:if test="${not empty t.customerPhone}">• ${t.customerPhone}</c:if></span>
                                                </div>

                                                <!-- Inner Product Spec Card -->
                                                <div class="p-4 rounded-DEFAULT bg-surface-container-low/40 border border-dashed border-outline-variant/40 space-y-2.5">
                                                    <c:choose>
                                                        <c:when test="${t.taskType == 'CUSTOM_CAKE'}">
                                                            <div class="flex items-start justify-between gap-2">
                                                                <h4 class="font-headline-sm text-base text-primary font-bold mb-0">${t.customCakeSizeInches}-Inch ${t.customCakeFlavor}</h4>
                                                                <span class="px-2 py-0.5 rounded-DEFAULT bg-[#ffecb3] text-[#78350f] text-[11px] font-semibold shrink-0">Cake Studio</span>
                                                            </div>
                                                            <div class="text-xs text-on-surface-variant space-y-1">
                                                                <c:if test="${not empty t.customCakeMessage}">
                                                                    <p class="mb-0"><span class="font-semibold text-primary">Specifications:</span> ${t.customCakeMessage}</p>
                                                                </c:if>
                                                                <c:if test="${not empty t.timeSlot}">
                                                                    <div class="flex items-center gap-1 text-xs text-on-surface-variant font-medium pt-0.5">
                                                                        <span class="material-symbols-outlined text-xs text-secondary">schedule</span>
                                                                        <span>Slot: <strong class="text-primary font-semibold">${t.timeSlot}</strong></span>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="flex items-start justify-between gap-2">
                                                                <h4 class="font-headline-sm text-base text-primary font-bold mb-0">Pastry Batch Order</h4>
                                                                <span class="px-2 py-0.5 rounded-DEFAULT bg-[#ffdad6] text-[#ba1a1a] text-[11px] font-semibold shrink-0">Baking Deck</span>
                                                            </div>
                                                            <div class="text-xs text-on-surface-variant space-y-1">
                                                                <c:forEach var="it" items="${t.items}">
                                                                    <p class="flex justify-between mb-0">
                                                                        <span>• ${it.productName} (x${it.quantity})</span>
                                                                        <span class="text-primary font-semibold">Rs. <fmt:formatNumber value="${it.subtotal}" minFractionDigits="2"/></span>
                                                                    </p>
                                                                </c:forEach>
                                                                <c:if test="${t.fulfillmentType == 'Delivery' && not empty t.deliveryAddress}">
                                                                    <div class="flex items-center gap-1 text-xs text-on-surface-variant font-medium pt-0.5">
                                                                        <span class="material-symbols-outlined text-xs text-secondary">location_on</span>
                                                                        <span>Destination: <strong class="text-primary font-semibold">${t.deliveryAddress}</strong></span>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Notes Row -->
                                                <c:if test="${not empty t.kitchenNotes}">
                                                    <div class="flex items-start gap-1.5 text-xs text-on-surface-variant bg-surface-container-low/20 p-2.5 rounded-DEFAULT">
                                                        <span class="material-symbols-outlined text-sm text-secondary shrink-0 mt-0.5">notes</span>
                                                        <p class="leading-relaxed mb-0">Notes: ${t.kitchenNotes}</p>
                                                    </div>
                                                </c:if>

                                                <!-- Bottom Actions Toolbar -->
                                                <div class="pt-2 border-t border-outline-variant/20 flex items-center justify-between gap-3 flex-wrap">
                                                    <div class="flex items-center gap-2">
                                                        <!-- Chef Select -->
                                                        <form action="${pageContext.request.contextPath}/kitchenQueue" method="post" class="relative inline-flex items-center mb-0">
                                                            <input type="hidden" name="action" value="assignBaker">
                                                            <input type="hidden" name="taskId" value="${t.taskId}">
                                                            <span class="material-symbols-outlined absolute left-2.5 text-sm text-on-surface-variant pointer-events-none">person</span>
                                                            <select name="bakerId" onchange="submitKitchenAction(this)" class="pl-8 pr-7 py-1.5 bg-surface-container-low border border-outline-variant/30 rounded-DEFAULT text-xs text-on-surface font-medium appearance-none focus:outline-none focus:border-secondary/60 cursor-pointer">
                                                                <option value="-1" ${t.assignedBakerId == null ? 'selected' : ''}>-- Assign Baker --</option>
                                                                <c:forEach var="st" items="${staffList}">
                                                                    <option value="${st.userID}" ${t.isAssignedTo(st.userID) ? 'selected' : ''}>
                                                                    ${st.username}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                            <span class="material-symbols-outlined absolute right-2 text-xs text-on-surface-variant pointer-events-none">expand_more</span>
                                                        </form>

                                                        <!-- Status Select -->
                                                        <form action="${pageContext.request.contextPath}/kitchenQueue" method="post" class="relative inline-flex items-center mb-0">
                                                            <input type="hidden" name="action" value="updateStage">
                                                            <input type="hidden" name="taskId" value="${t.taskId}">
                                                            <select name="stage" onchange="submitKitchenAction(this)" class="px-3 pr-7 py-1.5 bg-surface-container-low border border-outline-variant/30 rounded-DEFAULT text-xs text-on-surface font-medium appearance-none focus:outline-none focus:border-secondary/60 cursor-pointer">
                                                                <option value="PENDING" ${t.prepStage == 'PENDING' ? 'selected' : ''}>Pending Bench</option>
                                                                <option value="IN_PREPARATION" ${t.prepStage == 'IN_PREPARATION' ? 'selected' : ''}>In Preparation</option>
                                                                <option value="READY_FOR_PICKUP" ${t.prepStage == 'READY_FOR_PICKUP' ? 'selected' : ''}>Ready for Counter</option>
                                                                <option value="COMPLETED" ${t.prepStage == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                                            </select>
                                                            <span class="material-symbols-outlined absolute right-2 text-xs text-on-surface-variant pointer-events-none">expand_more</span>
                                                        </form>
                                                    </div>

                                                    <!-- Ticket Print Button -->
                                                    <a href="${pageContext.request.contextPath}/kitchenTicket?taskId=${t.taskId}" target="_blank" class="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-DEFAULT bg-primary text-surface hover:bg-primary-container transition-colors text-xs font-semibold shadow-sm text-decoration-none text-white">
                                                        <span class="material-symbols-outlined text-sm">confirmation_number</span>
                                                        Ticket
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Empty State -->
                                    <div class="bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 p-8 text-center space-y-3 shadow-sm">
                                        <div class="w-12 h-12 rounded-full bg-secondary-fixed/40 text-secondary mx-auto flex items-center justify-center">
                                            <span class="material-symbols-outlined text-2xl">soup_kitchen</span>
                                        </div>
                                        <h3 class="font-headline-sm text-lg text-primary font-bold mb-0">Kitchen Queue is Clear</h3>
                                        <p class="text-xs text-on-surface-variant max-w-sm mx-auto mb-0">No baking tasks currently match your filter criteria.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
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
                    // Fallback to standard form submission if AJAX fails
                    form.submit();
                });
        }
    </script>
    </body>
    </html>
