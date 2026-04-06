<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Wishlist - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .wishlist-container { max-width: 1200px; margin: 50px auto; padding: 0 20px; }
        .wishlist-card { background: white; border-radius: 10px; overflow: hidden; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .wishlist-item-img { width: 100px; height: 100px; object-fit: cover; }
        .empty-wishlist { text-align: center; padding: 50px; background: white; border-radius: 10px; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    <div class="wishlist-container">
        <h2><i class="fas fa-heart me-2 text-danger"></i>My Wishlist</h2>
        <c:choose>
            <c:when test="${empty wishlist}">
                <div class="empty-wishlist">
                    <i class="fas fa-heart-broken fa-4x text-muted mb-3"></i>
                    <h4>Your wishlist is empty</h4>
                    <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary mt-3">Browse Products</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="saved" items="${wishlist}">
                        <div class="col-md-4">
                            <div class="card wishlist-card">
                                <img src="${not empty saved.listing.images ? saved.listing.images[0].imageUrl : 'https://via.placeholder.com/300'}" 
                                     class="card-img-top" style="height: 200px; object-fit: cover;" alt="${saved.listing.listingName}">
                                <div class="card-body">
                                    <h5 class="card-title">${saved.listing.listingName}</h5>
                                    <p class="card-text text-primary fw-bold">₹<fmt:formatNumber value="${saved.listing.price}" pattern="#,##0.00"/></p>
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/listings/${saved.listing.listingId}" class="btn btn-sm btn-primary">View</a>
                                        <a href="${pageContext.request.contextPath}/wishlist/remove/${saved.listing.listingId}" class="btn btn-sm btn-danger">Remove</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <jsp:include page="../common/footer.jsp" />
</body>
</html>