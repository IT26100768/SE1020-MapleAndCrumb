<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maple &amp; Crumb - Freshly Baked with Love</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/navbar.jsp" />

    <main class="container my-4 my-md-5">
        <!-- Hero Section -->
        <section class="hero hero-maple text-center">
            <div class="row justify-content-center">
                <div class="col-lg-10 col-xl-8">
                    <div class="hero-pill-badge mb-3">
                        <span>✨</span> Artisanal Bakery &amp; Patisserie
                    </div>
                    <h1 class="display-3 fw-bold mb-3">
                        Maple <span>&amp;</span> Crumb
                    </h1>
                    <p class="tagline mb-4">
                        &ldquo;Where every bite tells a story of warmth and tradition&rdquo;
                    </p>
                    <div class="btn-group-hero d-flex flex-wrap justify-content-center gap-3">
                        <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary btn-lg px-4 shadow">
                            🛒 Order Now
                        </a>
                        <a href="${pageContext.request.contextPath}/comp01-user/register.jsp" class="btn btn-outline-light btn-lg px-4">
                            🎂 Register
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Highlights Bar -->
        <section class="mb-5">
            <div class="row g-3 text-center">
                <div class="col-6 col-md-3">
                    <div class="p-3 bg-white border rounded-3 shadow-sm h-100 d-flex flex-column align-items-center justify-content-center">
                        <span class="fs-3 mb-1">🌾</span>
                        <span class="fw-bold small text-dark">100% Organic Flours</span>
                        <span class="text-muted smaller" style="font-size: 0.8rem;">Stone-milled heritage grain</span>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="p-3 bg-white border rounded-3 shadow-sm h-100 d-flex flex-column align-items-center justify-content-center">
                        <span class="fs-3 mb-1">⏰</span>
                        <span class="fw-bold small text-dark">Baked Fresh Daily</span>
                        <span class="text-muted smaller" style="font-size: 0.8rem;">Every morning at 5:00 AM</span>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="p-3 bg-white border rounded-3 shadow-sm h-100 d-flex flex-column align-items-center justify-content-center">
                        <span class="fs-3 mb-1">🧈</span>
                        <span class="fw-bold small text-dark">Pure Creamery Butter</span>
                        <span class="text-muted smaller" style="font-size: 0.8rem;">Zero artificial additives</span>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="p-3 bg-white border rounded-3 shadow-sm h-100 d-flex flex-column align-items-center justify-content-center">
                        <span class="fs-3 mb-1">⚡</span>
                        <span class="fw-bold small text-dark">Fast Warm Delivery</span>
                        <span class="text-muted smaller" style="font-size: 0.8rem;">Straight to your doorstep</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="my-5">
            <div class="text-center mb-5">
                <h2 class="page-title text-center">Why Choose Maple &amp; Crumb?</h2>
                <p class="page-subtitle text-center">Experience the art of baking with our premium artisanal services</p>
            </div>

            <div class="row g-4 features">
                <!-- Feature 1 -->
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card feature-card-modern" onclick="window.location.href = '${pageContext.request.contextPath}/menu'">
                        <div>
                            <div class="feature-icon feature-icon-wrapper">🥐</div>
                            <h3>Fresh Daily Menu</h3>
                            <p>
                                Explore our wide selection of freshly baked cakes, pastries, and
                                breads made with the finest ingredients every morning.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary w-100">
                            Browse Menu
                        </a>
                    </div>
                </div>

                <!-- Feature 2 -->
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card feature-card-modern" onclick="window.location.href = '${pageContext.request.contextPath}/comp01-user/register.jsp'">
                        <div>
                            <div class="feature-icon feature-icon-wrapper">🎂</div>
                            <h3>Custom Cake Design</h3>
                            <p>
                                Design your dream cake for any occasion. Choose flavors, sizes, and
                                add personalized messages for that perfect touch.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/comp01-user/register.jsp" class="btn btn-primary w-100">
                            Book Custom Cake
                        </a>
                    </div>
                </div>

                <!-- Feature 3 -->
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card feature-card-modern" onclick="window.location.href = '${pageContext.request.contextPath}/comp01-user/login.jsp'">
                        <div>
                            <div class="feature-icon feature-icon-wrapper">🚚</div>
                            <h3>Fast Delivery</h3>
                            <p>
                                Get your favorite treats delivered straight to your doorstep. Fresh,
                                fast, and reliable service across the city.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary w-100">
                            Order with Delivery
                        </a>
                    </div>
                </div>

                <!-- Feature 4 -->
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card feature-card-modern" onclick="window.location.href = '${pageContext.request.contextPath}/comp01-user/login.jsp'">
                        <div>
                            <div class="feature-icon feature-icon-wrapper">🎁</div>
                            <h3>Exclusive Promotions</h3>
                            <p>
                                Enjoy special discounts and seasonal offers. Join our loyalty
                                program and save on every order!
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary w-100">
                            View Offers
                        </a>
                    </div>
                </div>

                <!-- Feature 5 -->
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card feature-card-modern" onclick="window.location.href = '${pageContext.request.contextPath}/comp01-user/register.jsp'">
                        <div>
                            <div class="feature-icon feature-icon-wrapper">⭐</div>
                            <h3>Loyalty Rewards</h3>
                            <p>
                                Earn points with every purchase. Redeem them for free treats,
                                discounts, and exclusive member-only perks.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/comp01-user/register.jsp" class="btn btn-primary w-100">
                            Join Now
                        </a>
                    </div>
                </div>

                <!-- Feature 6 -->
                <div class="col-md-6 col-lg-4">
                    <div class="feature-card feature-card-modern" onclick="window.location.href = '${pageContext.request.contextPath}/comp01-user/login.jsp'">
                        <div>
                            <div class="feature-icon feature-icon-wrapper">💬</div>
                            <h3>Customer Reviews</h3>
                            <p>
                                Read authentic reviews from our happy customers. Share your
                                experience and help others discover their favorites.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/comp01-user/login.jsp" class="btn btn-primary w-100">
                            Read Reviews
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Testimonials Section -->
        <section class="testimonials my-5 p-4 p-md-5 rounded-4" style="background-color: var(--warm-beige);">
            <div class="text-center mb-4">
                <h2 class="page-title text-center">What Our Customers Say</h2>
                <p class="page-subtitle text-center">Real stories from our beloved bakery community</p>
            </div>

            <div class="row g-4 testimonial-grid">
                <div class="col-md-4">
                    <div class="testimonial-card testimonial-card-modern">
                        <div>
                            <div class="stars">⭐⭐⭐⭐⭐</div>
                            <p>
                                &ldquo;The custom birthday cake was absolutely stunning! The flavor was
                                incredible and the design exceeded my expectations. Maple &amp; Crumb
                                made my daughter's special day even more magical!&rdquo;
                            </p>
                        </div>
                        <div class="author mt-2">&mdash; Sarah M., <span class="text-muted fw-normal">Happy Customer</span></div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="testimonial-card testimonial-card-modern">
                        <div>
                            <div class="stars">⭐⭐⭐⭐⭐</div>
                            <p>
                                &ldquo;I order from Maple &amp; Crumb every week. Their pastries are always
                                fresh, and the delivery is prompt. The chocolate croissants are to
                                die for!&rdquo;
                            </p>
                        </div>
                        <div class="author mt-2">&mdash; James L., <span class="text-muted fw-normal">Regular Customer</span></div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="testimonial-card testimonial-card-modern">
                        <div>
                            <div class="stars">⭐⭐⭐⭐⭐</div>
                            <p>
                                &ldquo;Best bakery in town! The quality is consistent, prices are fair,
                                and the staff is incredibly friendly. Their loyalty program is a
                                great bonus too!&rdquo;
                            </p>
                        </div>
                        <div class="author mt-2">&mdash; Emily R., <span class="text-muted fw-normal">Loyal Member</span></div>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section text-center text-white p-5 rounded-4 my-5" style="background: linear-gradient(135deg, var(--mc-espresso) 0%, var(--mc-primary) 100%);">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <h2 class="display-6 fw-bold mb-3 font-playfair">Ready to Taste the Difference?</h2>
                    <p class="lead mb-4 opacity-90">
                        Join thousands of happy customers who trust Maple &amp; Crumb for their
                        daily treats and special occasions.
                    </p>
                    <a href="${pageContext.request.contextPath}/comp01-user/register.jsp" class="btn btn-light btn-lg px-5 py-3 fw-bold shadow" style="color: var(--mc-primary); border-radius: 50px;">
                        🎉 Create Your Account
                    </a>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>
