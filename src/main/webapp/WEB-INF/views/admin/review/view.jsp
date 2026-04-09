<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Details - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .rating-stars { color: #ffc107; font-size: 20px; }
        .review-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .info-row { margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
        .info-label { font-weight: 600; color: #333; width: 150px; display: inline-block; }
        .product-thumb { width: 80px; height: 80px; object-fit: cover; border-radius: 10px; }
        .avatar { width: 60px; height: 60px; border-radius: 50%; object-fit: cover; }
    </style>
</head>
<body>
    <c:set var="activePage" value="reviews" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-star me-2"></i>Review Details</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Back to Reviews
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/reviews/delete/${review.reviewId}" 
                       class="btn btn-danger ms-2"
                       onclick="return confirm('Are you sure you want to delete this review?')">
                        <i class="fas fa-trash me-2"></i>Delete Review
                    </a>
                </div>
            </div>

            <div class="review-card">
                <div class="row">
                    <!-- Left Column - Product Info -->
                    <div class="col-md-4 text-center border-end">
                        <c:choose>
                            <c:when test="${not empty review.listing.images and not empty review.listing.images[0]}">
                                <img src="${review.listing.images[0].imageUrl}" class="product-thumb mb-3" alt="Product">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/80" class="product-thumb mb-3" alt="No image">
                            </c:otherwise>
                        </c:choose>
                        <h5>${review.listing.listingName}</h5>
                        <p class="text-muted">Product ID: #${review.listing.listingId}</p>
                        <a href="${pageContext.request.contextPath}/listings/${review.listing.listingId}" 
                           class="btn btn-sm btn-outline-primary" target="_blank">
                            <i class="fas fa-external-link-alt me-1"></i>View Product
                        </a>
                    </div>

                    <!-- Right Column - Review Details -->
                    <div class="col-md-8">
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-tag me-2"></i>Review ID:</span>
                            <span>#${review.reviewId}</span>
                        </div>

                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-store me-2"></i>Seller:</span>
                            <span>
                                <strong>${review.seller.firstName} ${review.seller.lastName}</strong>
                                <br><small class="text-muted">Email: ${review.seller.email}</small>
                                <br><small class="text-muted">User ID: ${review.seller.userId}</small>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-user me-2"></i>Buyer:</span>
                            <span>
                                <strong>${review.buyer.firstName} ${review.buyer.lastName}</strong>
                                <br><small class="text-muted">Email: ${review.buyer.email}</small>
                                <br><small class="text-muted">User ID: ${review.buyer.userId}</small>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-star me-2"></i>Rating:</span>
                            <span>
                                <div class="rating-stars">
                                    <c:forEach begin="1" end="${review.rating}">
                                        <i class="fas fa-star"></i>
                                    </c:forEach>
                                    <c:forEach begin="${review.rating + 1}" end="5">
                                        <i class="far fa-star"></i>
                                    </c:forEach>
                                </div>
                                <span class="ms-2">${review.rating}/5</span>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-comment me-2"></i>Review Comment:</span>
                            <div class="mt-2 p-3 bg-light rounded">
                                "${review.comment}"
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-calendar me-2"></i>Created At:</span>
                            <span>${review.createdAt}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>