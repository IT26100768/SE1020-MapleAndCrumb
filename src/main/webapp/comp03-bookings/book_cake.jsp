<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artisanal Custom Cake Studio â€” Maple &amp; Crumb</title>
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
    <!-- Maple & Crumb Global Stylesheet Suite -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <!-- Custom Cake Studio Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/cake-booking.css">
</head>
<body class="d-flex flex-column min-vh-100" style="background-color: var(--maple-cream-50, #fdfbf7);">
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main id="main-content" class="container my-4 my-md-5 flex-grow-1">
    <!-- Breadcrumb & Header -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu" class="text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Menu</a></li>
            <li class="breadcrumb-item active text-muted" aria-current="page">Custom Cake Studio</li>
        </ol>
    </nav>

    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
        <div>
            <div class="d-inline-flex align-items-center gap-1 badge-status-gold px-3 py-1 rounded-pill mb-2" style="font-size: 0.72rem; letter-spacing: 0.12em; text-transform: uppercase;">
                <span class="material-symbols-outlined fs-6">palette</span> Maple &amp; Crumb Cake Studio
            </div>
            <h1 class="page-title fs-2 mb-1" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100); font-weight: 700;">
                Artisanal Custom Cake Studio
            </h1>
            <p class="text-muted small mb-0">Handcrafted celebration cakes baked with heritage grains, churned French butter &amp; personal devotion</p>
        </div>
        <div class="mt-3 mt-sm-0">
            <a href="${pageContext.request.contextPath}/myBookings" class="btn btn-sm btn-maple-secondary rounded-3 px-3 py-2 d-inline-flex align-items-center gap-1">
                <span class="material-symbols-outlined fs-6">calendar_month</span> My Reservations
            </a>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <c:if test="${param.error == 'missing_info'}">
        <div class="alert alert-danger d-flex align-items-center mb-4 rounded-3 py-3 px-4 border-0 shadow-sm" style="background-color: #fee2e2; color: #991b1b;" role="alert">
            <span class="material-symbols-outlined fs-5 me-2 flex-shrink-0">error</span>
            <div class="small fw-medium">Please ensure all required booking fields and contact details are properly filled out.</div>
        </div>
    </c:if>

    <div class="row justify-content-center">
        <!-- Bespoke Custom Cake Form -->
        <div class="col-12 col-md-10 col-lg-8">
            <div class="card card-maple shadow-sm p-4 p-md-5 border-0" style="background: #ffffff; border-radius: var(--radius-xl, 16px); box-shadow: 0 10px 32px rgba(7, 1, 0, 0.05);">
                <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom" style="border-color: rgba(43, 24, 16, 0.08) !important;">
                    <div class="d-inline-flex align-items-center justify-content-center rounded-circle flex-shrink-0" style="width: 48px; height: 48px; background: rgba(134,82,37,0.1); color: var(--maple-gold-600, #6d411b);">
                        <span class="material-symbols-outlined fs-4">cake</span>
                    </div>
                    <div>
                        <h4 class="font-playfair text-dark mb-0 fs-5 fw-bold" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); color: var(--maple-dark-900, #070100);">Design Your Bespoke Cake</h4>
                        <span class="text-muted small">Select your flavor profile, size, celebration details and preferred collection window</span>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/bookCake" method="post" id="cakeBookingForm" class="needs-validation" novalidate>
                    <!-- User Account Details -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <div class="alert alert-success d-flex align-items-center gap-3 mb-4 rounded-3 py-3 px-4 border-0" style="background-color: #ecfdf5; color: #065f46;">
                                <span class="material-symbols-outlined fs-4 text-success flex-shrink-0">account_circle</span>
                                <div class="small">
                                    Booking as Customer: <strong>${sessionScope.loggedInUser.username}</strong> (${sessionScope.loggedInUser.email}) &bull;
                                    <span class="text-muted">ID #${sessionScope.loggedInUser.userID}</span>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="card border p-3 mb-4 rounded-3" style="background-color: #faf8f5; border-color: rgba(134,82,37,0.15) !important;">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="font-playfair text-dark mb-0 fw-bold d-flex align-items-center gap-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif);">
                                        <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-500, #865225);">badge</span> Guest Contact Details
                                    </h6>
                                    <a href="${pageContext.request.contextPath}/comp01-user/login.jsp?redirect=bookCake" class="small fw-semibold text-decoration-none" style="color: var(--maple-gold-600, #6d411b);">Already have an account? Sign In</a>
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="customerName" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Full Name <span class="text-danger">*</span></label>
                                        <input type="text" id="customerName" name="customerName" class="form-control form-control-maple" required placeholder="e.g. Eleanor Vance">
                                        <div class="invalid-feedback">Please enter your full name.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="customerEmail" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Email Address <span class="text-danger">*</span></label>
                                        <input type="email" id="customerEmail" name="customerEmail" class="form-control form-control-maple" required placeholder="eleanor@example.com">
                                        <div class="invalid-feedback">Please enter a valid email address.</div>
                                    </div>
                                    <div class="col-12">
                                        <label for="customerPhone" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Contact Phone <span class="text-danger">*</span></label>
                                        <input type="tel" id="customerPhone" name="customerPhone" class="form-control form-control-maple" required placeholder="+94 77 123 4567">
                                        <div class="invalid-feedback">Please provide a contact phone number.</div>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Cake Specifications -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="cakeFlavor" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Flavor Profile <span class="text-danger">*</span></label>
                            <select id="cakeFlavor" name="flavor" class="form-select form-control-maple" required>
                                <option value="Belgian Chocolate Truffle" ${param.flavor == 'Belgian Chocolate Truffle' ? 'selected' : ''}>Belgian Chocolate Truffle (70% Ganache)</option>
                                <option value="Madagascar Bourbon Vanilla" ${param.flavor == 'Madagascar Bourbon Vanilla' ? 'selected' : ''}>Madagascar Bourbon Vanilla Sponge</option>
                                <option value="Wild Strawberry Cloud" ${param.flavor == 'Wild Strawberry Cloud' ? 'selected' : ''}>Wild Strawberry Chiffon Cloud</option>
                                <option value="Swiss Red Velvet" ${param.flavor == 'Swiss Red Velvet' ? 'selected' : ''}>Swiss Red Velvet with Cream Cheese</option>
                                <option value="Spiced Carrot & Maple Pecan" ${param.flavor == 'Spiced Carrot & Maple Pecan' ? 'selected' : ''}>Spiced Carrot &amp; Maple Pecan</option>
                                <option value="Salted Caramel & Espresso" ${param.flavor == 'Salted Caramel & Espresso' ? 'selected' : ''}>Salted Caramel &amp; Espresso</option>
                            </select>
                            <div class="form-text small text-muted">All sponges made fresh with cultured cream and slow-churned butter.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="cakeSize" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Diameter &amp; Servings <span class="text-danger">*</span></label>
                            <select id="cakeSize" name="size" class="form-select form-control-maple" required>
                                <option value="6" ${param.size == '6' ? 'selected' : ''}>6-Inch (Serves 6 - 8 Guests) &mdash; Rs. 4,500.00</option>
                                <option value="8" ${empty param.size || param.size == '8' ? 'selected' : ''}>8-Inch (Serves 8 - 12 Guests) &mdash; Rs. 6,500.00</option>
                                <option value="10" ${param.size == '10' ? 'selected' : ''}>10-Inch (Serves 14 - 18 Guests) &mdash; Rs. 8,500.00</option>
                                <option value="12" ${param.size == '12' ? 'selected' : ''}>12-Inch (Serves 20 - 26 Guests) &mdash; Rs. 11,000.00</option>
                            </select>
                            <div class="form-text small text-muted">Tiered artisanal base rates starting from Rs. 4,500.00.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="cakeOccasion" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Celebration Occasion</label>
                            <select id="cakeOccasion" name="occasion" class="form-select form-control-maple">
                                <option value="Birthday" selected>Birthday Celebration</option>
                                <option value="Wedding / Engagement">Wedding / Engagement</option>
                                <option value="Anniversary">Anniversary Celebration</option>
                                <option value="Graduation">Graduation / Milestone</option>
                                <option value="Baby Shower">Baby Shower / Gathering</option>
                                <option value="Corporate Gala">Corporate Gala</option>
                                <option value="Special Celebration">Special Everyday Milestone</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="pickupDate" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Collection Date <span class="text-danger">*</span></label>
                            <input type="date" id="pickupDate" name="pickupDate" class="form-control form-control-maple" required>
                            <div class="invalid-feedback">Please select a pickup date.</div>
                            <div class="form-text small text-muted">Requires minimum 24 hours advance baking notice.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="pickupTime" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Preferred Time Window <span class="text-danger">*</span></label>
                            <select id="pickupTime" name="pickupTime" class="form-select form-control-maple" required>
                                <option value="Morning (9:00 AM - 12:00 PM)" selected>Morning (9:00 AM &ndash; 12:00 PM)</option>
                                <option value="Afternoon (1:00 PM - 4:00 PM)">Afternoon (1:00 PM &ndash; 4:00 PM)</option>
                                <option value="Evening (4:00 PM - 7:30 PM)">Evening (4:00 PM &ndash; 7:30 PM)</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label for="customMessage" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Piped Royal Icing Inscription (Optional)</label>
                            <input type="text" id="customMessage" name="customMessage" class="form-control form-control-maple" maxlength="60" placeholder="e.g. Happy 30th Birthday Eleanor! âœ¨" value="<c:out value="${param.message}" />">
                            <div class="form-text small text-muted">Piped with pure Madagascar vanilla royal icing (max 60 characters).</div>
                        </div>

                        <div class="col-12">
                            <label for="specialNotes" class="form-label small fw-semibold" style="color: var(--maple-dark-800, #2b1810);">Dietary Needs, Color Theme &amp; Garnish Details</label>
                            <textarea id="specialNotes" name="specialNotes" class="form-control form-control-maple" rows="3" placeholder="e.g. Nut allergy caution, please add edible gold leaf accents and fresh seasonal berries..."></textarea>
                        </div>
                    </div>

                    <!-- Fulfillment Method Selection -->
                    <div class="mb-4">
                        <label class="form-label small fw-semibold d-block" style="color: var(--maple-dark-800, #2b1810);">Fulfillment Method <span class="text-danger">*</span></label>
                        <div class="row g-3">
                            <div class="col-sm-6">
                                <div class="p-3 rounded-3 h-100 transition-all maple-selectable-card active" id="cakePickupOptionWrapper" onclick="selectCakeOrderType('Pickup')">
                                    <div class="d-flex align-items-center justify-content-between mb-1">
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-check-input mt-0" type="radio" name="orderType" id="cakeOrderTypePickup" value="Pickup" checked>
                                            <label class="form-check-label fw-bold small text-dark mb-0" for="cakeOrderTypePickup" style="cursor: pointer;">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-600, #6d411b);">storefront</span> Bakery Counter Pickup
                                            </label>
                                        </div>
                                        <span id="cakePickupSelectedBadge" class="badge rounded-pill text-white selected-pill small px-2 py-0.5" style="background-color: var(--maple-gold-600, #865225); font-size: 0.7rem;">Selected</span>
                                    </div>
                                    <div class="small text-muted ps-4">Collect boxed cake at our bakery counter. <strong class="text-success">Free</strong></div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="p-3 rounded-3 h-100 transition-all maple-selectable-card" id="cakeDeliveryOptionWrapper" onclick="selectCakeOrderType('Delivery')">
                                    <div class="d-flex align-items-center justify-content-between mb-1">
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-check-input mt-0" type="radio" name="orderType" id="cakeOrderTypeDelivery" value="Delivery">
                                            <label class="form-check-label fw-bold small text-dark mb-0" for="cakeOrderTypeDelivery" style="cursor: pointer;">
                                                <span class="material-symbols-outlined fs-6 align-middle me-1" style="color: var(--maple-gold-600, #6d411b);">local_shipping</span> Doorstep Delivery
                                            </label>
                                        </div>
                                        <span id="cakeDeliverySelectedBadge" class="badge rounded-pill text-white selected-pill small px-2 py-0.5 d-none" style="background-color: var(--maple-gold-600, #865225); font-size: 0.7rem; display: none;">Selected</span>
                                    </div>
                                    <div class="small text-muted ps-4">Delivered warm by local courier. <strong style="color: var(--maple-gold-600, #6d411b);">+Rs. 500.00 flat fee</strong></div>
                                </div>
                            </div>
                        </div>

                        <div id="cakeDeliveryAddressSection" class="d-none mt-3 p-3 rounded-3" style="background-color: #faf7f2; border: 1px dashed rgba(134,82,37,0.2);">
                            <label for="cakeDeliveryAddressInput" class="form-label fw-semibold small" style="color: var(--maple-dark-800, #2b1810);">Delivery Street Address &amp; Unit <span class="text-danger">*</span></label>
                            <textarea id="cakeDeliveryAddressInput" name="deliveryAddress" class="form-control form-control-maple" rows="2" placeholder="e.g. 142 Elmwood Street, Suite 4B, Colombo 03"></textarea>
                            <div class="invalid-feedback">Please provide your delivery street address.</div>
                            <div class="form-text small text-muted">Special celebration cakes are dispatched in temperature-controlled pastry boxes.</div>
                        </div>
                    </div>

                    <!-- Booking Summary Section (Review selections before final booking action) -->
                    <div class="card p-4 rounded-3 mb-4 shadow-xs" id="bookingSummaryCard" style="background-color: #faf8f5; border: 1.5px solid rgba(134,82,37,0.2);">
                        <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom" style="border-color: rgba(43,24,16,0.1) !important;">
                            <h6 class="font-playfair text-dark mb-0 fw-bold d-flex align-items-center gap-2" style="font-family: var(--font-playfair, 'Playfair Display', Georgia, serif); font-size: 1.05rem;">
                                <span class="material-symbols-outlined fs-5" style="color: var(--maple-gold-600, #6d411b);">receipt_long</span>
                                Booking Summary
                            </h6>
                            <span class="badge px-2.5 py-1 rounded-pill small" style="background: rgba(134,82,37,0.1); color: var(--maple-gold-600, #6d411b);">
                                Live Price &amp; Specification
                            </span>
                        </div>

                        <div class="row g-3 small">
                            <div class="col-md-6">
                                <div class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Flavor &amp; Cake Type</div>
                                <div class="fw-bold text-dark mt-0.5" id="summaryFlavor">Belgian Chocolate Truffle</div>
                                <div class="smaller text-muted">Heritage sponge &bull; Churned cultured cream</div>
                            </div>

                            <div class="col-md-6">
                                <div class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Selected Size &amp; Servings</div>
                                <div class="fw-bold text-dark mt-0.5" id="summarySize">8-Inch (Serves 8 - 12 Guests)</div>
                            </div>

                            <div class="col-md-6">
                                <div class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Occasion &amp; Inscription</div>
                                <div class="fw-bold text-dark mt-0.5" id="summaryOccasion">Birthday Celebration</div>
                                <div class="fst-italic text-secondary mt-0.5" id="summaryInscription">None provided</div>
                            </div>

                            <div class="col-md-6">
                                <div class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Schedule &amp; Fulfillment</div>
                                <div class="fw-bold text-dark mt-0.5" id="summarySchedule">Required Date &amp; Time Window</div>
                                <div class="d-flex align-items-center gap-1 mt-0.5" id="summaryFulfillmentMode">
                                    <span class="badge bg-secondary-subtle text-secondary-emphasis border px-2 py-0.5">Bakery Counter Pickup</span>
                                </div>
                                <div class="smaller text-primary mt-1 d-none" id="summaryDeliveryAddressRow">
                                    <span class="material-symbols-outlined fs-6 align-middle me-0.5 text-primary">pin_drop</span>
                                    <span id="summaryDeliveryAddressText"></span>
                                </div>
                            </div>

                            <div class="col-12 d-none" id="summaryNotesRow">
                                <div class="text-muted smaller text-uppercase fw-semibold" style="font-size: 0.7rem; letter-spacing: 0.05em;">Special Notes &amp; Dietary Requests</div>
                                <div class="text-dark mt-0.5 p-2 rounded bg-white border" style="font-size: 0.82rem;" id="summaryNotesText"></div>
                            </div>
                        </div>

                        <!-- Price Breakdown Strip -->
                        <div class="mt-3 pt-3 border-top" style="border-color: rgba(43,24,16,0.1) !important;">
                            <div class="d-flex justify-content-between mb-1 small text-muted">
                                <span>Cake Base Subtotal:</span>
                                <span class="fw-semibold text-dark" id="summarySubtotal">Rs. 6,500.00</span>
                            </div>
                            <div class="d-flex justify-content-between mb-1 small text-muted">
                                <span>Delivery Fee:</span>
                                <span class="fw-semibold text-dark" id="summaryDeliveryFee">Rs. 0.00</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center pt-2 border-top mt-1" style="border-color: rgba(43,24,16,0.08) !important;">
                                <span class="fw-bold font-playfair fs-6 text-dark">Estimated Grand Total:</span>
                                <span class="fw-bold font-playfair fs-4" style="color: var(--maple-gold-600, #6d411b);" id="summaryGrandTotal">Rs. 6,500.00</span>
                            </div>
                        </div>

                        <div class="smaller text-muted mt-2 d-flex align-items-center gap-1" style="font-size: 0.75rem;">
                            <span class="material-symbols-outlined fs-6 text-success">verified</span>
                            <span>No upfront deposit required. Quoted total payable upon collection / delivery.</span>
                        </div>
                    </div>

                    <hr class="my-4" style="border-color: rgba(43, 24, 16, 0.08) !important;">

                    <!-- Actions -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-maple-secondary rounded-3 px-3 py-2">
                            Back to Menu
                        </a>
                        <button type="submit" class="btn btn-maple-primary px-4 py-2 fw-semibold shadow-sm d-inline-flex align-items-center gap-2" id="submitBookingBtn" data-loading-text="Submitting Booking...">
                            <span class="material-symbols-outlined fs-5">check_circle</span> Confirm &amp; Submit Booking
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
