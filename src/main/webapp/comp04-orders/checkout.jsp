<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Maple &amp; Crumb</title>
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
        <div class="col-12 col-lg-9 col-xl-8">

            <div class="d-flex align-items-center mb-4 pb-2 border-bottom">
                <i class="bi bi-cart-check-fill fs-2 text-danger me-2"></i>
                <div>
                    <h1 class="page-title fs-2 mb-0">Secure Bakery Checkout</h1>
                    <p class="text-muted small mb-0">Review your order items, select pickup or delivery, and finalize your order</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                <div class="row g-4">
                    <!-- Left Column: Fulfillment Details -->
                    <div class="col-md-7">
                        <div class="card card-maple shadow-sm mb-4">
                            <h5 class="font-playfair text-dark mb-3"><i class="bi bi-truck me-2 text-danger"></i> Fulfillment Method</h5>

                            <!-- Fulfillment Radio Options -->
                            <div class="form-check p-3 border rounded-3 mb-3 bg-light">
                                <input class="form-check-input ms-0 me-2" type="radio" name="orderType" id="typePickup" value="PICKUP" onchange="toggleFulfillment('PICKUP')" checked>
                                <label class="form-check-label fw-bold text-dark" for="typePickup">
                                    🏪 In-Store Bakery Pickup <span class="badge bg-success-subtle text-success ms-1">FREE</span>
                                </label>
                                <div class="form-text small text-muted ms-4">Collect fresh from our bakery counter at Artisan Bakery Lane. Ready in ~30 mins.</div>
                            </div>

                            <div class="form-check p-3 border rounded-3 mb-3 bg-light">
                                <input class="form-check-input ms-0 me-2" type="radio" name="orderType" id="typeDelivery" value="DELIVERY" onchange="toggleFulfillment('DELIVERY')">
                                <label class="form-check-label fw-bold text-dark" for="typeDelivery">
                                    🚚 Warm Doorstep Delivery <span class="badge bg-secondary-subtle text-secondary ms-1">+$5.00</span>
                                </label>
                                <div class="form-text small text-muted ms-4">Hand-delivered safely in temperature-insulated bakery carriers within the city.</div>
                            </div>

                            <!-- Conditional Delivery Address -->
                            <div id="deliveryAddressSection" class="d-none mt-3">
                                <div class="form-group mb-3">
                                    <label for="checkoutAddress" class="form-label">Delivery Destination</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white text-muted border-end-0 align-items-start pt-2">
                                            <i class="bi bi-geo-alt"></i>
                                        </span>
                                        <textarea id="checkoutAddress" name="deliveryAddress" rows="3" class="form-control border-start-0 ps-0" placeholder="Street address, apartment or suite, city, postal code">${sessionScope.loggedInUser.deliveryAddress}</textarea>
                                    </div>
                                    <div class="form-text small text-muted">Auto-filled from your profile preferences. You can update this for this delivery.</div>
                                </div>
                            </div>
                        </div>

                        <!-- Payment & Notes -->
                        <div class="card card-maple shadow-sm">
                            <h5 class="font-playfair text-dark mb-3"><i class="bi bi-credit-card-2-front me-2 text-danger"></i> Payment Preference</h5>
                            <div class="p-3 border rounded-3 bg-light mb-3">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="payCounter" value="COUNTER" checked>
                                    <label class="form-check-label fw-medium text-dark" for="payCounter">Pay upon Pickup / Cash or Card on Delivery</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="payOnline" value="ONLINE">
                                    <label class="form-check-label fw-medium text-dark" for="payOnline">Online Card / Digital Wallet (Terminal on arrival)</label>
                                </div>
                            </div>

                            <div class="form-group mb-0">
                                <label for="specialInstructions" class="form-label">Special Bakery Notes (Optional)</label>
                                <textarea id="specialInstructions" name="notes" rows="2" class="form-control" placeholder="e.g. Please slice sourdough bread; candle pack requested"></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Order Summary -->
                    <div class="col-md-5">
                        <div class="card card-maple shadow-sm">
                            <h5 class="font-playfair text-dark mb-3"><i class="bi bi-receipt me-2 text-danger"></i> Order Summary</h5>

                            <div class="d-flex justify-content-between py-2 border-bottom small">
                                <span class="text-dark">Artisan Pastries / Cakes</span>
                                <span class="fw-semibold text-dark">$38.50</span>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom small">
                                <span class="text-dark">Subtotal</span>
                                <span class="fw-semibold text-dark">$38.50</span>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom small">
                                <span class="text-dark">Fulfillment Fee</span>
                                <span class="fw-semibold text-success" id="deliveryFeeDisplay">$0.00</span>
                            </div>

                            <div class="d-flex justify-content-between py-3 my-2 border-bottom">
                                <span class="fs-5 fw-bold text-dark font-playfair">Total Amount</span>
                                <span class="fs-4 fw-bold text-dark font-playfair" id="orderTotalDisplay">$38.50</span>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-3 fw-bold shadow-sm mt-3">
                                <i class="bi bi-shield-check me-1"></i> Place Order Now
                            </button>

                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/comp02-products/menu.jsp" class="small text-muted text-decoration-none">
                                    <i class="bi bi-arrow-left me-1"></i> Add More Items From Menu
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

<script>
    function toggleFulfillment(type) {
        const addressSection = document.getElementById('deliveryAddressSection');
        const deliveryFeeDisplay = document.getElementById('deliveryFeeDisplay');
        const totalDisplay = document.getElementById('orderTotalDisplay');
        const baseSubtotal = 38.50;

        if (type === 'DELIVERY') {
            addressSection.classList.remove('d-none');
            deliveryFeeDisplay.innerText = '$5.00';
            deliveryFeeDisplay.className = 'fw-semibold text-danger';
            totalDisplay.innerText = '$' + (baseSubtotal + 5.00).toFixed(2);
        } else {
            addressSection.classList.add('d-none');
            deliveryFeeDisplay.innerText = '$0.00';
            deliveryFeeDisplay.className = 'fw-semibold text-success';
            totalDisplay.innerText = '$' + baseSubtotal.toFixed(2);
        }
    }
</script>
</body>
</html>