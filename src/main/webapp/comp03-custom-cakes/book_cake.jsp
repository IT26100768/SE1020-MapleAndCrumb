<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Custom Cake - Maple &amp; Crumb</title>
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
    <div class="row justify-content-center">
        <div class="col-12 col-lg-8 col-xl-7">

            <!-- Cake Designer Card -->
            <div class="card card-maple shadow-sm">
                <div class="card-maple-header text-center mb-4">
                    <div class="card-maple-icon mx-auto mb-3">
                        <i class="bi bi-cake2-fill"></i>
                    </div>
                    <h1 class="page-title fs-3 mb-1">Design Your Custom Cake</h1>
                    <p class="text-muted small mb-0">Crafted by master bakers for weddings, birthdays, and celebrations</p>
                </div>

                <!-- Live Price Estimate Banner -->
                <div class="d-flex align-items-center justify-content-between p-3 rounded-3 mb-4 border" style="background-color: var(--mc-gold-light);">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-tag-fill fs-4 text-dark me-2"></i>
                        <div>
                            <span class="fw-bold text-dark d-block">Estimated Base Price</span>
                            <span class="text-muted smaller" style="font-size: 0.8rem;">Calculated at $15.00 per diameter inch</span>
                        </div>
                    </div>
                    <div class="text-end">
                        <span class="fs-3 fw-bold text-dark font-playfair" id="cakePriceDisplay">$120.00</span>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/bookCake" method="post" id="bookCakeForm">
                    <div class="row g-3">
                        <!-- Flavor Selection -->
                        <div class="col-md-6">
                            <div class="form-group mb-3">
                                <label for="cakeFlavorSelect" class="form-label">Artisan Cake Flavor</label>
                                <select id="cakeFlavorSelect" name="flavor" class="form-select form-control" required>
                                    <option value="Belgian Chocolate Truffle">Belgian Chocolate Truffle</option>
                                    <option value="Madagascar Vanilla Bean">Madagascar Vanilla Bean</option>
                                    <option value="Red Velvet & Cream Cheese">Red Velvet &amp; Cream Cheese</option>
                                    <option value="Salted Caramel Praline">Salted Caramel Praline</option>
                                    <option value="Wild Berry Shortcake">Wild Berry Shortcake</option>
                                    <option value="Maple Walnut Crunch">Maple Walnut Crunch</option>
                                </select>
                            </div>
                        </div>

                        <!-- Size in Inches -->
                        <div class="col-md-6">
                            <div class="form-group mb-3">
                                <label for="cakeSizeSelect" class="form-label">Cake Size (Diameter)</label>
                                <select id="cakeSizeSelect" name="sizeInches" class="form-select form-control" onchange="calculateCakePrice()" required>
                                    <option value="6">6-inch (Serves 6–8) &mdash; $90.00</option>
                                    <option value="8" selected>8-inch (Serves 10–12) &mdash; $120.00</option>
                                    <option value="10">10-inch (Serves 14–16) &mdash; $150.00</option>
                                    <option value="12">12-inch (Serves 18–22) &mdash; $180.00</option>
                                </select>
                            </div>
                        </div>

                        <!-- Pickup Date -->
                        <div class="col-12">
                            <div class="form-group mb-3">
                                <label for="cakePickupDate" class="form-label">Desired Pickup Date</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white text-muted border-end-0">
                                        <i class="bi bi-calendar3"></i>
                                    </span>
                                    <input type="date" id="cakePickupDate" name="pickupDate" class="form-control border-start-0 ps-0" required>
                                </div>
                                <div class="form-text small text-muted">Custom cakes require at least 24 hours of advance preparation.</div>
                            </div>
                        </div>

                        <!-- Custom Message / Inscription -->
                        <div class="col-12">
                            <div class="form-group mb-4">
                                <label for="cakeCustomMessage" class="form-label">Custom Hand-Piped Inscription (Optional)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white text-muted border-end-0 align-items-start pt-2">
                                        <i class="bi bi-pen"></i>
                                    </span>
                                    <textarea id="cakeCustomMessage" name="customMessage" rows="3" class="form-control border-start-0 ps-0" placeholder="e.g. Happy 30th Birthday Eleanor!"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 mb-3">
                        <i class="bi bi-check2-circle me-1"></i> Submit Custom Cake Booking
                    </button>
                </form>

                <div class="text-center pt-3 border-top mt-2">
                    <p class="text-muted small mb-0">
                        View your previously booked custom orders? 
                        <a href="${pageContext.request.contextPath}/comp03-custom-cakes/my_bookings.jsp" class="fw-semibold" style="color: var(--brick-red);">
                            My Bookings History
                        </a>
                    </p>
                </div>
            </div>

        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    function calculateCakePrice() {
        const size = parseInt(document.getElementById('cakeSizeSelect').value) || 8;
        const total = size * 15;
        document.getElementById('cakePriceDisplay').innerText = '$' + total.toFixed(2);
    }

    // Set minimum date to tomorrow
    document.addEventListener('DOMContentLoaded', function() {
        const dateInput = document.getElementById('cakePickupDate');
        if (dateInput) {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            dateInput.min = tomorrow.toISOString().split('T')[0];
        }
        calculateCakePrice();
    });
</script>
</body>
</html>

