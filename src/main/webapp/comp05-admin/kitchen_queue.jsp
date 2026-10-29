<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Production &amp; Kitchen Operations Queue — Maple &amp; Crumb</title>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css?v=2.1">
</head>
<body class="d-flex flex-column min-vh-100" style="background-color: var(--maple-cream-50, #fdfbf7);">

<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<c:choose>
    <c:when test="${not empty sessionScope.loggedInUser && (sessionScope.loggedInUser.userRole == 'ADMIN' || sessionScope.loggedInUser.userRole == 'STAFF')}">
        <div class="mc-admin-layout-wrapper">
            <jsp:include page="/WEB-INF/includes/admin_sidebar.jsp">
                <jsp:param name="activeTab" value="kitchen" />
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
                                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Kitchen Operations</li>
                            </ol>
                        </nav>
                    </div>
                </header>

                <main id="main-content" class="mc-admin-main-body p-4 p-md-5">

                    <!-- Page Header -->
                    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom gap-3" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                        <div>
                            <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                                <span class="material-symbols-outlined fs-6">soup_kitchen</span> Bakery Kitchen Operations
                            </div>
                            <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                                Production &amp; Kitchen Queue
                            </h1>
                            <p class="text-muted small mb-0">Sequence daily pastry batches, assign chefs to baking benches, track preparation stages, and generate physical tickets.</p>
                        </div>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="${pageContext.request.contextPath}/comp05-admin/dashboard.jsp" class="btn btn-sm btn-maple-secondary rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                                <span class="material-symbols-outlined fs-6">dashboard</span> Hub
                            </a>
                            <button type="button" class="btn btn-sm btn-maple-primary rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1 shadow-sm" onclick="window.location.reload();">
                                <span class="material-symbols-outlined fs-6">refresh</span> Refresh Queue
                            </button>
                        </div>
                    </div>

                    <!-- Flash Notifications -->
                    <c:if test="${param.error == 'ticket_not_found'}">
                        <div class="alert alert-warning d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" role="alert" style="background-color: #fef3c7; color: #92400e;">
                            <span class="material-symbols-outlined fs-4 me-3 text-warning flex-shrink-0">warning</span>
                            <div class="small fw-medium">The requested kitchen ticket could not be found. Please select an active task from the operations queue.</div>
                        </div>
                    </c:if>
                    <c:if test="${param.msg == 'baker_assigned'}">
                        <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" role="alert" style="background-color: #ecfdf5; color: #065f46;">
                            <span class="material-symbols-outlined fs-4 me-3 text-success flex-shrink-0">check_circle</span>
                            <div class="small fw-medium">Baker has been assigned to the workstation successfully.</div>
                        </div>
                    </c:if>
                    <c:if test="${param.msg == 'stage_updated'}">
                        <div class="alert alert-success d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" role="alert" style="background-color: #ecfdf5; color: #065f46;">
                            <span class="material-symbols-outlined fs-4 me-3 text-success flex-shrink-0">check_circle</span>
                            <div class="small fw-medium">Preparation stage updated in production records.</div>
                        </div>
                    </c:if>
                    <c:if test="${param.msg == 'priority_updated'}">
                        <div class="alert alert-info d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" role="alert" style="background-color: #e0f2fe; color: #0369a1;">
                            <span class="material-symbols-outlined fs-4 me-3 text-info flex-shrink-0">flag</span>
                            <div class="small fw-medium">Operational priority updated.</div>
                        </div>
                    </c:if>

                    <!-- Operational Metrics Summary Cards -->
                    <div class="row g-3 mb-4">
                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card p-3 shadow-sm h-100 border-0 ${currentDateFilter == 'today' ? 'border border-primary' : ''}">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Today's Due</span>
                                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">today</span>
                                </div>
                                <h3 class="fw-bold font-playfair mb-0 text-dark" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${todayCount}</h3>
                                <a href="${pageContext.request.contextPath}/kitchenQueue?date=today" class="smaller text-decoration-none text-muted mt-1 d-block" style="font-size: 0.72rem;">View today's queue &rarr;</a>
                            </div>
                        </div>

                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card p-3 shadow-sm h-100 border-0 ${currentDateFilter == 'tomorrow' ? 'border border-primary' : ''}">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Due Tomorrow</span>
                                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">event_upcoming</span>
                                </div>
                                <h3 class="fw-bold font-playfair mb-0 text-dark" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${tomorrowCount}</h3>
                                <a href="${pageContext.request.contextPath}/kitchenQueue?date=tomorrow" class="smaller text-decoration-none text-muted mt-1 d-block" style="font-size: 0.72rem;">View tomorrow's batch &rarr;</a>
                            </div>
                        </div>

                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card p-3 shadow-sm h-100 border-0">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="smaller text-uppercase fw-semibold" style="color: var(--maple-gold-600, #6d411b); font-size: 0.7rem; letter-spacing: 0.05em;">Custom Cakes</span>
                                    <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">cake</span>
                                </div>
                                <h3 class="fw-bold font-playfair mb-0" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-gold-600, #6d411b);">${cakeInPrepCount}</h3>
                                <span class="text-muted smaller mt-1 d-block" style="font-size: 0.72rem;">In active decorating</span>
                            </div>
                        </div>

                        <div class="col-6 col-lg-3">
                            <div class="card card-maple maple-kpi-card p-3 shadow-sm h-100 border-0 ${overdueCount > 0 ? 'bg-danger bg-opacity-10 border border-danger' : ''}">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="smaller text-uppercase fw-semibold ${overdueCount > 0 ? 'text-danger' : 'text-muted'}" style="font-size: 0.7rem; letter-spacing: 0.05em;">Overdue Prep</span>
                                    <span class="material-symbols-outlined fs-5 ${overdueCount > 0 ? 'text-danger' : 'text-muted'}">warning</span>
                                </div>
                                <h3 class="fw-bold font-playfair mb-0 ${overdueCount > 0 ? 'text-danger' : 'text-dark'}" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">${overdueCount}</h3>
                                <a href="${pageContext.request.contextPath}/kitchenQueue?date=overdue" class="smaller text-decoration-none ${overdueCount > 0 ? 'text-danger fw-bold' : 'text-muted'} mt-1 d-block" style="font-size: 0.72rem;">
                                    ${overdueCount > 0 ? 'Urgent attention required &rarr;' : 'All deadlines met'}
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Filter & Search Toolbar -->
                    <div class="card card-maple p-3 mb-4 shadow-sm border-0 rounded-3" style="background: #ffffff;">
                        <div class="row g-3 align-items-center justify-content-between">
                            <!-- Search Input -->
                            <div class="col-md-4 col-lg-4">
                                <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted ps-3 pe-2" style="border-radius: var(--radius-md, 8px) 0 0 var(--radius-md, 8px); border-color: rgba(43,24,16,0.15);">
                                <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">search</span>
                            </span>
                                    <input type="text" id="kitchenSearchInput" class="form-control form-control-maple border-start-0 ps-1" placeholder="Search order code, customer, flavor..." onkeyup="filterKitchenCards()" aria-label="Search kitchen tasks" style="border-radius: 0 var(--radius-md, 8px) var(--radius-md, 8px) 0; border-color: rgba(43,24,16,0.15);">
                                </div>
                            </div>

                            <!-- Filter Pills -->
                            <div class="col-md-8 col-lg-8 d-flex flex-wrap gap-2 justify-content-md-end align-items-center">
                                <!-- Date Filter Buttons -->
                                <div class="btn-group btn-group-sm" role="group" aria-label="Date Filters">
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=all&channel=${currentChannelFilter}&stage=${currentStageFilter}" class="btn ${currentDateFilter == 'all' ? 'btn-maple-primary' : 'btn-outline-secondary'}">All</a>
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=today&channel=${currentChannelFilter}&stage=${currentStageFilter}" class="btn ${currentDateFilter == 'today' ? 'btn-maple-primary' : 'btn-outline-secondary'}">Today</a>
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=tomorrow&channel=${currentChannelFilter}&stage=${currentStageFilter}" class="btn ${currentDateFilter == 'tomorrow' ? 'btn-maple-primary' : 'btn-outline-secondary'}">Tomorrow</a>
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=overdue&channel=${currentChannelFilter}&stage=${currentStageFilter}" class="btn ${currentDateFilter == 'overdue' ? 'btn-danger' : 'btn-outline-danger'}">Overdue (${overdueCount})</a>
                                </div>

                                <!-- Channel Filters -->
                                <div class="btn-group btn-group-sm" role="group" aria-label="Channel Filters">
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=all&stage=${currentStageFilter}" class="btn ${currentChannelFilter == 'all' ? 'btn-maple-secondary' : 'btn-outline-secondary'}">All Channels</a>
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=pickup&stage=${currentStageFilter}" class="btn ${currentChannelFilter == 'pickup' ? 'btn-maple-secondary' : 'btn-outline-secondary'}">Pickup</a>
                                    <a href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=delivery&stage=${currentStageFilter}" class="btn ${currentChannelFilter == 'delivery' ? 'btn-maple-secondary' : 'btn-outline-secondary'}">Delivery</a>
                                </div>

                                <!-- Stage Filter Dropdown -->
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle d-inline-flex align-items-center gap-1" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <span class="material-symbols-outlined fs-6">filter_list</span> Stage: <strong class="text-capitalize ms-1">${currentStageFilter}</strong>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                        <li><a class="dropdown-item ${currentStageFilter == 'all' ? 'active' : ''}" href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=${currentChannelFilter}&stage=all">All Active Stages</a></li>
                                        <li><a class="dropdown-item ${currentStageFilter == 'pending' ? 'active' : ''}" href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=${currentChannelFilter}&stage=pending">Pending Bench</a></li>
                                        <li><a class="dropdown-item ${currentStageFilter == 'in_prep' ? 'active' : ''}" href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=${currentChannelFilter}&stage=in_prep">In Preparation</a></li>
                                        <li><a class="dropdown-item ${currentStageFilter == 'ready' ? 'active' : ''}" href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=${currentChannelFilter}&stage=ready">Ready for Counter</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item ${currentStageFilter == 'completed' ? 'active' : ''}" href="${pageContext.request.contextPath}/kitchenQueue?date=${currentDateFilter}&channel=${currentChannelFilter}&stage=completed">Archived Completed</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Queue Tasks Cards Listing -->
                    <c:choose>
                        <c:when test="${not empty tasks}">
                            <div class="row g-4" id="kitchenTasksContainer">
                                <c:forEach var="t" items="${tasks}">
                                    <div class="col-12 col-lg-6 kitchen-card-item" data-search="${t.referenceCode} ${t.customerName} ${t.customCakeFlavor} ${t.prepStage} ${t.fulfillmentType}">
                                        <div class="card card-maple shadow-sm h-100 border-0 p-4 rounded-4 position-relative ${t.overdue ? 'border border-2 border-danger' : ''}" style="background: #ffffff; box-shadow: 0 6px 20px rgba(7, 1, 0, 0.05);">

                                            <!-- Card Header: Code, Badges, Due Time -->
                                            <div class="d-flex flex-wrap justify-content-between align-items-start pb-3 border-bottom gap-2 mb-3" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                                                <div>
                                                    <div class="d-flex align-items-center gap-2">
                                                <span class="badge-status-gold font-monospace fs-6 px-3 py-1 rounded-pill fw-bold">
                                                    #${t.referenceCode}
                                                </span>
                                                        <!-- Custom Cake vs Pastry Badge -->
                                                        <c:choose>
                                                            <c:when test="${t.taskType == 'CUSTOM_CAKE'}">
                                                        <span class="badge rounded-pill px-2.5 py-1 small" style="background: rgba(134,82,37,0.12); color: var(--maple-gold-600, #6d411b);">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1">cake</span> Bespoke Cake
                                                        </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                        <span class="badge rounded-pill px-2.5 py-1 small" style="background: rgba(7,1,0,0.06); color: var(--maple-dark-900, #070100);">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1">bakery_dining</span> Pastry Batch
                                                        </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <!-- Customer Contact Details -->
                                                    <div class="mt-2 small text-muted">
                                                        <span class="material-symbols-outlined fs-6 align-middle me-1">person</span> Customer: <strong class="text-dark">${not empty t.customerName ? t.customerName : 'Walk-in Patron'}</strong>
                                                        <c:if test="${not empty t.customerPhone}">
                                                            &bull; <a href="tel:${t.customerPhone}" class="text-decoration-none text-muted"><span class="material-symbols-outlined fs-6 align-middle me-1">call</span>${t.customerPhone}</a>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <!-- Due Datetime & Status Pills -->
                                                <div class="text-end">
                                                    <c:if test="${t.overdue}">
                                                <span class="badge badge-status-danger px-2.5 py-1 rounded-pill small d-inline-flex align-items-center gap-1 mb-1 animate-pulse">
                                                    <span class="material-symbols-outlined fs-6">warning</span> OVERDUE
                                                </span>
                                                    </c:if>
                                                    <div class="badge bg-light text-dark border px-2 py-1 rounded-pill small">
                                                        <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-500, #865225);">event</span>
                                                        ${t.formattedShortDueDatetime}
                                                    </div>
                                                    <div class="mt-1">
                                                        <c:choose>
                                                            <c:when test="${t.fulfillmentType == 'Delivery'}">
                                                        <span class="badge rounded-pill px-2 py-0.5 small" style="background: #e0f2fe; color: #0369a1;">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1">local_shipping</span> Delivery
                                                        </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                        <span class="badge rounded-pill px-2 py-0.5 small" style="background: #fef3c7; color: #92400e;">
                                                            <span class="material-symbols-outlined fs-6 align-middle me-1">storefront</span> Counter Pickup
                                                        </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Card Body: Production Specification Details -->
                                            <div class="mb-3">
                                                <c:choose>
                                                    <c:when test="${t.taskType == 'CUSTOM_CAKE'}">
                                                        <!-- Bespoke Custom Cake Details -->
                                                        <div class="p-3 rounded-3 mb-2" style="background-color: #faf7f2; border: 1px dashed rgba(134,82,37,0.25);">
                                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                                <strong class="font-playfair fs-6" style="color: var(--maple-dark-900, #070100);">
                                                                    ${t.customCakeSizeInches}-Inch ${t.customCakeFlavor}
                                                                </strong>
                                                                <span class="badge-status-gold small px-2 py-0.5 rounded-pill">Cake Studio</span>
                                                            </div>
                                                            <c:if test="${not empty t.customCakeMessage}">
                                                                <div class="small text-muted mt-1">
                                                                    <span class="fw-semibold text-dark">Specifications:</span> ${t.customCakeMessage}
                                                                </div>
                                                            </c:if>
                                                            <c:if test="${not empty t.timeSlot}">
                                                                <div class="small text-muted mt-1">
                                                                    <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-600, #6d411b);">schedule</span> Slot: <strong>${t.timeSlot}</strong>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- Regular Pastry Orders Items Table -->
                                                        <div class="table-responsive mb-2">
                                                            <table class="table table-sm align-middle mb-0" style="font-size: 0.85rem;">
                                                                <thead class="text-muted" style="border-bottom: 1px solid rgba(43,24,16,0.08);">
                                                                <tr>
                                                                    <th>Item Description</th>
                                                                    <th class="text-center" style="width: 50px;">Qty</th>
                                                                    <th class="text-end" style="width: 80px;">Subtotal</th>
                                                                </tr>
                                                                </thead>
                                                                <tbody>
                                                                <c:forEach var="it" items="${t.items}">
                                                                    <tr>
                                                                        <td class="fw-medium text-dark py-1">${it.productName}</td>
                                                                        <td class="text-center fw-bold py-1">${it.quantity}</td>
                                                                        <td class="text-end text-muted py-1">Rs. <fmt:formatNumber value="${it.subtotal}" minFractionDigits="2"/></td>
                                                                    </tr>
                                                                </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                        <c:if test="${t.fulfillmentType == 'Delivery' && not empty t.deliveryAddress}">
                                                            <div class="small p-2 rounded-2 mb-2" style="background: #f0fdf4; color: #166534;">
                                                                <span class="material-symbols-outlined fs-6 align-middle me-1">location_on</span> Destination: <strong>${t.deliveryAddress}</strong>
                                                            </div>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>

                                                <!-- Allergen Warning Box if contains nuts -->
                                                <c:if test="${t.containsNuts || (not empty t.kitchenNotes && t.kitchenNotes.toLowerCase().contains('nut'))}">
                                                    <div class="alert alert-warning py-1.5 px-3 mb-2 rounded-2 small d-flex align-items-center gap-2 border-0" style="background: #fef3c7; color: #92400e;">
                                                        <span class="material-symbols-outlined fs-5 text-warning flex-shrink-0">report</span>
                                                        <span><strong>Allergen Caution:</strong> Contains nuts / bakery allergen note. Handle with designated prep utensils.</span>
                                                    </div>
                                                </c:if>

                                                <!-- Kitchen Special Instructions Note -->
                                                <c:if test="${not empty t.kitchenNotes}">
                                                    <div class="small text-muted p-2 rounded-2" style="background: #faf8f5;">
                                                        <span class="material-symbols-outlined fs-6 align-middle me-1 text-muted">edit_note</span> Notes: ${t.kitchenNotes}
                                                    </div>
                                                </c:if>
                                            </div>

                                            <!-- Card Footer: Workstation & Baker Assignment Controls -->
                                            <div class="pt-3 border-top d-flex flex-wrap justify-content-between align-items-center gap-2" style="border-color: rgba(43, 24, 16, 0.08) !important;">

                                                <!-- Baker Assignment Dropdown -->
                                                <form action="${pageContext.request.contextPath}/kitchenQueue" method="post" class="d-inline-flex align-items-center gap-1">
                                                    <input type="hidden" name="action" value="assignBaker">
                                                    <input type="hidden" name="taskId" value="${t.taskId}">
                                                    <span class="material-symbols-outlined fs-5 text-muted" title="Assigned Baker">person</span>
                                                    <select name="bakerId" class="form-select form-select-sm form-control-maple" style="width: 140px; font-size: 0.78rem;" onchange="this.form.submit()" aria-label="Assign Baker">
                                                        <option value="-1" ${t.assignedBakerId == null ? 'selected' : ''}>-- Unassigned --</option>
                                                        <c:forEach var="st" items="${staffList}">
                                                            <option value="${st.userID}" ${t.isAssignedTo(st.userID) ? 'selected' : ''}>
                                                            ${st.username}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </form>

                                                <!-- Stage Transition & Ticket Actions -->
                                                <div class="d-flex align-items-center gap-2">
                                                    <!-- Preparation Stage Dropdown -->
                                                    <form action="${pageContext.request.contextPath}/kitchenQueue" method="post" class="d-inline-flex align-items-center gap-1">
                                                        <input type="hidden" name="action" value="updateStage">
                                                        <input type="hidden" name="taskId" value="${t.taskId}">
                                                        <select name="stage" class="form-select form-select-sm form-control-maple fw-semibold" style="width: 155px; font-size: 0.78rem;" onchange="this.form.submit()" aria-label="Update Stage">
                                                            <option value="PENDING" ${t.prepStage == 'PENDING' ? 'selected' : ''}>Pending Bench</option>
                                                            <option value="IN_PREPARATION" ${t.prepStage == 'IN_PREPARATION' ? 'selected' : ''}>In Preparation</option>
                                                            <option value="READY_FOR_PICKUP" ${t.prepStage == 'READY_FOR_PICKUP' ? 'selected' : ''}>Ready for Counter</option>
                                                            <option value="COMPLETED" ${t.prepStage == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                                        </select>
                                                    </form>

                                                    <!-- Print Kitchen Ticket CTA -->
                                                    <a href="${pageContext.request.contextPath}/kitchenTicket?taskId=${t.taskId}" target="_blank" class="btn btn-sm btn-maple-secondary rounded-2 px-2.5 py-1 d-inline-flex align-items-center gap-1" title="Print Kitchen Ticket">
                                                        <span class="material-symbols-outlined fs-6">receipt_long</span> Ticket
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State -->
                            <div class="card card-maple text-center py-5 border-0 shadow-sm rounded-4" style="background: #ffffff;">
                                <div class="d-inline-flex align-items-center justify-content-center mx-auto mb-3 rounded-circle" style="width: 64px; height: 64px; background: rgba(134,82,37,0.1); color: var(--maple-gold-600, #6d411b);">
                                    <span class="material-symbols-outlined fs-2">soup_kitchen</span>
                                </div>
                                <h4 class="font-playfair text-dark mb-1 fs-5 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">Kitchen Queue is Clear</h4>
                                <p class="text-muted small mb-3">No active baking tasks match your current filter criteria.</p>
                                <a href="${pageContext.request.contextPath}/kitchenQueue" class="btn btn-sm btn-maple-secondary mx-auto rounded-3 px-3 py-2">
                                    Reset Filters
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
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
                <h3 class="font-playfair text-dark fs-3 mb-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Staff Access Required</h3>
                <p class="text-muted small mb-4">You must be logged in as an authorized Bakery Staff member or Administrator to access kitchen operations.</p>
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

