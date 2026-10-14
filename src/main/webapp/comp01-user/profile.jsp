<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>My Profile - Maple & Crumb</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">
</head>
<body>
<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container">
    <h1 class="page-title">My Profile</h1>

    <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-success">Profile updated successfully!</div>
    </c:if>

    <div class="card" style="max-width: 550px;">
        <form action="${pageContext.request.contextPath}/updateProfile" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" value="${sessionScope.loggedInUser.username}" readonly style="background:#eee;">
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" value="${sessionScope.loggedInUser.email}" readonly style="background:#eee;">
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input type="tel" name="phone" value="${sessionScope.loggedInUser.phone}" required>
            </div>
            <div class="form-group">
                <label>Delivery Address</label>
                <textarea name="address" rows="3" required>${sessionScope.loggedInUser.deliveryAddress}</textarea>
            </div>
            <button type="submit" class="btn btn-primary">Update Profile</button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp"/>
</body>
</html>