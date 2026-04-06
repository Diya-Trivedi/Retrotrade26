<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-store me-2"></i>Retrotrade
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/listings">
                        <i class="fas fa-search me-1"></i>Browse
                    </a>
                </li>
                <!-- Cart and Wishlist for logged-in users -->
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/wishlist">
                            <i class="fas fa-heart me-1"></i>Wishlist
                        </a>
                    </li>
                </c:if>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                                </a>
                            </li>
                        </c:if>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" 
                               data-bs-toggle="dropdown">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.profilePicURL}">
                                        <img src="${sessionScope.user.profilePicURL}" alt="Profile" 
                                             style="width: 30px; height: 30px; border-radius: 50%; margin-right: 5px;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-circle me-1"></i>
                                    </c:otherwise>
                                </c:choose>
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user me-2"></i>My Profile
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/address/list">
                                    <i class="fas fa-map-marker-alt me-2"></i>My Addresses
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/listings/my-listings">
                                    <i class="fas fa-box me-2"></i>My Listings
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/offers/my-offers">
                                    <i class="fas fa-hand-holding-usd me-2"></i>My Offers
                                </a></li>
                                <c:if test="${sessionScope.user.role != 'ADMIN'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/offers/received">
                                        <i class="fas fa-inbox me-2"></i>Received Offers
                                    </a></li>
                                </c:if>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/transactions/my-purchases">
                                    <i class="fas fa-shopping-bag me-2"></i>My Purchases
                                </a></li>
                                <c:if test="${sessionScope.user.role != 'ADMIN'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/transactions/my-sales">
                                        <i class="fas fa-dollar-sign me-2"></i>My Sales
                                    </a></li>
                                </c:if>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/reviews/my-reviews">
                                    <i class="fas fa-star me-2"></i>My Reviews
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/listings/add">
                                    <i class="fas fa-plus-circle me-2"></i>Sell an Item
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                                </a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/signup">
                                <i class="fas fa-user-plus me-1"></i>Sign Up
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>