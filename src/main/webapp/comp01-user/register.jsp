<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register - Maple & Crumb</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body>
<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container">
    <h1 class="page-title">Create Your Account</h1>

    <div class="card" style="max-width: 500px; margin: 0 auto;">
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" name="phone" required>
            </div>
            <div class="form-group">
                <label>Delivery Address</label>
                <textarea name="address" rows="3" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;">Register</button>
        </form>
        <p style="text-align:center; margin-top:1rem;">
            Already have an account? <a href="${pageContext.request.contextPath}/comp01-user/login.jsp"
                                        style="color: var(--brick-red);">Login here</a>
        </p>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>
</body>
</html>