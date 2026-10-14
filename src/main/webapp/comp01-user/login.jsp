<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - Maple & Crumb</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body>
<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container">
    <h1 class="page-title">Welcome Back</h1>

    <% if (request.getParameter("error") != null) { %>
    <div class="alert alert-error">Invalid email or password.</div>
    <% } %>
    <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("success")) { %>
    <div class="alert alert-success">Registration successful! Please login.</div>
    <% } %>

    <div class="card" style="max-width: 450px; margin: 0 auto;">
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;">Login</button>
        </form>
        <p style="text-align:center; margin-top:1rem;">
            New customer? <a href="${pageContext.request.contextPath}/comp01-user/register.jsp"
                             style="color: var(--brick-red);">Register here</a>
        </p>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>
</body>
</html>