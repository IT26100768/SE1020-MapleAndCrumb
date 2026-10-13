<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Maple & Crumb - Freshly Baked with Love</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
    <style>
        /* Hero Section with Background Image Effect */
        .hero {
            background: linear-gradient(135deg, rgba(62, 39, 35, 0.95), rgba(178, 34, 34, 0.9)),
                        url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 600"><rect fill="%233E2723" width="1200" height="600"/><circle fill="%23B22222" opacity="0.1" cx="200" cy="150" r="100"/><circle fill="%23B22222" opacity="0.1" cx="800" cy="400" r="150"/></svg>');
            background-size: cover;
            color: var(--cream);
            text-align: center;
            padding: 6rem 2rem;
            border-radius: 12px;
            margin-bottom: 3rem;
            box-shadow: 0 10px 40px rgba(62, 39, 35, 0.3);
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 248, 231, 0.1) 0%, transparent 70%);
            animation: pulse 15s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 0.8; }
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero h1 {
            font-size: 4rem;
            margin-bottom: 1rem;
            letter-spacing: 3px;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.3);
            animation: fadeInDown 1s ease-out;
        }

        .hero h1 span {
            color: var(--warm-beige);
            font-style: italic;
        }

        .hero .tagline {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            font-style: italic;
            opacity: 0.95;
            animation: fadeInUp 1s ease-out 0.3s both;
        }

        .hero .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeInUp 1s ease-out 0.6s both;
        }

        .hero .btn {
            font-size: 1.2rem;
            padding: 1rem 2.5rem;
            background-color: var(--cream);
            color: var(--brick-red);
            font-weight: bold;
            border-radius: 50px;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .hero .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            background-color: var(--warm-beige);
        }

        .hero .btn-secondary {
            background-color: transparent;
            color: var(--cream);
            border: 2px solid var(--cream);
        }

        .hero .btn-secondary:hover {
            background-color: var(--cream);
            color: var(--brick-red);
        }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Features Section */
        .section-title {
            text-align: center;
            font-size: 2.5rem;
            color: var(--espresso-brown);
            margin-bottom: 1rem;
            position: relative;
            display: inline-block;
            left: 50%;
            transform: translateX(-50%);
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--brick-red);
            border-radius: 2px;
        }

        .section-subtitle {
            text-align: center;
            color: var(--espresso-light);
            font-size: 1.1rem;
            margin-bottom: 3rem;
            font-style: italic;
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin: 3rem 0;
        }

        .feature-card {
            background: var(--warm-beige);
            padding: 2.5rem 2rem;
            border-radius: 12px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.4s;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(178, 34, 34, 0.1), transparent);
            transition: left 0.5s;
        }

        .feature-card:hover::before {
            left: 100%;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(62, 39, 35, 0.2);
            border-color: var(--brick-red);
        }

        .feature-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            display: inline-block;
            transition: transform 0.3s;
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.2) rotate(5deg);
        }

        .feature-card h3 {
            color: var(--brick-red);
            font-size: 1.5rem;
            margin: 1rem 0;
        }

        .feature-card p {
            color: var(--espresso-light);
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        /* Testimonials Section */
        .testimonials {
            background: var(--warm-beige);
            padding: 4rem 2rem;
            border-radius: 12px;
            margin: 3rem 0;
        }

        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .testimonial-card {
            background: var(--cream);
            padding: 2rem;
            border-radius: 8px;
            border-left: 4px solid var(--brick-red);
            box-shadow: 0 4px 15px rgba(62, 39, 35, 0.1);
        }

        .testimonial-card .stars {
            color: #FFD700;
            font-size: 1.3rem;
            margin-bottom: 1rem;
        }

        .testimonial-card p {
            font-style: italic;
            color: var(--espresso-brown);
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .testimonial-card .author {
            font-weight: bold;
            color: var(--brick-red);
        }

        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, var(--espresso-brown), var(--brick-red));
            color: var(--cream);
            text-align: center;
            padding: 4rem 2rem;
            border-radius: 12px;
            margin: 3rem 0;
        }

        .cta-section h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .cta-section p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.95;
        }

        .cta-section .btn {
            font-size: 1.2rem;
            padding: 1rem 3rem;
            background-color: var(--cream);
            color: var(--brick-red);
            font-weight: bold;
            border-radius: 50px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 { font-size: 2.5rem; }
            .hero .tagline { font-size: 1.2rem; }
            .section-title { font-size: 2rem; }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container">
    <!-- Hero Section -->
    <div class="hero">
        <div class="hero-content">
            <h1>Maple <span>&</span> Crumb</h1>
            <p class="tagline">"Where every bite tells a story of warmth and tradition"</p>
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/customer/login.jsp" class="btn">🛒 Order Now</a>
                <a href="${pageContext.request.contextPath}/customer/book_cake.jsp" class="btn btn-secondary">🎂 Custom
                    Cake</a>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <h2 class="section-title">Why Choose Maple & Crumb?</h2>
    <p class="section-subtitle">Experience the art of baking with our premium services</p>

    <div class="features">
        <div class="feature-card" onclick="window.location.href='${pageContext.request.contextPath}/menu'">
            <div class="feature-icon">🥐</div>
            <h3>Fresh Daily Menu</h3>
            <p>Explore our wide selection of freshly baked cakes, pastries, and breads made with the finest ingredients
                every morning.</p>
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Browse Menu</a>
        </div>

        <div class="feature-card"
             onclick="window.location.href='${pageContext.request.contextPath}/customer/book_cake.jsp'">
            <div class="feature-icon">🎂</div>
            <h3>Custom Cake Design</h3>
            <p>Design your dream cake for any occasion. Choose flavors, sizes, and add personalized messages for that
                perfect touch.</p>
            <a href="${pageContext.request.contextPath}/customer/book_cake.jsp" class="btn btn-primary">Book Custom
                Cake</a>
        </div>

        <div class="feature-card"
             onclick="window.location.href='${pageContext.request.contextPath}/customer/login.jsp'">
            <div class="feature-icon">🚚</div>
            <h3>Fast Delivery</h3>
            <p>Get your favorite treats delivered straight to your doorstep. Fresh, fast, and reliable service across
                the city.</p>
            <a href="${pageContext.request.contextPath}/customer/login.jsp" class="btn btn-primary">Order with
                Delivery</a>
        </div>

        <div class="feature-card"
             onclick="window.location.href='${pageContext.request.contextPath}/customer/promotions.jsp'">
            <div class="feature-icon">🎁</div>
            <h3>Exclusive Promotions</h3>
            <p>Enjoy special discounts and seasonal offers. Join our loyalty program and save on every order!</p>
            <a href="${pageContext.request.contextPath}/customer/promotions.jsp" class="btn btn-primary">View Offers</a>
        </div>

        <div class="feature-card"
             onclick="window.location.href='${pageContext.request.contextPath}/customer/register.jsp'">
            <div class="feature-icon">⭐</div>
            <h3>Loyalty Rewards</h3>
            <p>Earn points with every purchase. Redeem them for free treats, discounts, and exclusive member-only
                perks.</p>
            <a href="${pageContext.request.contextPath}/customer/register.jsp" class="btn btn-primary">Join Now</a>
        </div>

        <div class="feature-card"
             onclick="window.location.href='${pageContext.request.contextPath}/customer/product_details.jsp'">
            <div class="feature-icon">💬</div>
            <h3>Customer Reviews</h3>
            <p>Read authentic reviews from our happy customers. Share your experience and help others discover their
                favorites.</p>
            <a href="${pageContext.request.contextPath}/customer/product_details.jsp" class="btn btn-primary">Read
                Reviews</a>
        </div>
    </div>

    <!-- Testimonials Section -->
    <div class="testimonials">
        <h2 class="section-title">What Our Customers Say</h2>
        <p class="section-subtitle">Real stories from our beloved community</p>

        <div class="testimonial-grid">
            <div class="testimonial-card">
                <div class="stars">⭐⭐⭐⭐⭐</div>
                <p>"The custom birthday cake was absolutely stunning! The flavor was incredible and the design exceeded
                    my expectations. Maple & Crumb made my daughter's special day even more magical!"</p>
                <div class="author">— Sarah M., Happy Customer</div>
            </div>

            <div class="testimonial-card">
                <div class="stars">⭐⭐⭐⭐⭐</div>
                <p>"I order from Maple & Crumb every week. Their pastries are always fresh, and the delivery is prompt.
                    The chocolate croissants are to die for!"</p>
                <div class="author">— James L., Regular Customer</div>
            </div>

            <div class="testimonial-card">
                <div class="stars">⭐⭐⭐⭐⭐</div>
                <p>"Best bakery in town! The quality is consistent, prices are fair, and the staff is incredibly
                    friendly. Their loyalty program is a great bonus too!"</p>
                <div class="author">— Emily R., Loyal Member</div>
            </div>
        </div>
    </div>

    <!-- CTA Section -->
    <div class="cta-section">
        <h2>Ready to Taste the Difference?</h2>
        <p>Join thousands of happy customers who trust Maple & Crumb for their daily treats and special occasions.</p>
        <a href="${pageContext.request.contextPath}/customer/register.jsp" class="btn">🎉 Create Your Account</a>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>
</body>
</html>