<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${category.categoryName} - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .product-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            height: 100%;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.3);
        }
        .category-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container mt-5">
        <!-- Category Header -->
        <div class="category-header">
            <h1><i class="fas fa-tag me-2"></i>${category.categoryName}</h1>
            <p class="mb-0">Browse all products in ${category.categoryName}</p>
        </div>

        <!-- Results Info -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4>Products</h4>
            <p class="text-muted">Showing ${listings.size()} of ${totalItems} results</p>
        </div>

        <!-- Products Grid -->
        <div class="row g-4">
            <c:forEach var="listing" items="${listings}">
                <div class="col-md-3">
                    <a href="${pageContext.request.contextPath}/listings/${listing.listingId}" class="product-card">
                        <img src="${not empty listing.images and not empty listing.images[0] ? listing.images[0].imageUrl : 'https://via.placeholder.com/300x200'}" 
                             class="card-img-top" style="height: 200px; object-fit: cover;" alt="${listing.listingName}">
                        <div class="card-body p-3">
                            <h6 class="card-title">${listing.listingName}</h6>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="h5 text-primary">₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/></span>
                                <span class="badge bg-info">${listing.condition}</span>
                            </div>
                            <small class="text-muted">
                                <i class="fas fa-eye me-1"></i>${listing.viewCount} views
                            </small>
                        </div>
                    </a>
                </div>
            </c:forEach>

            <c:if test="${empty listings}">
                <div class="col-12 text-center py-5">
                    <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                    <h5>No Products Found</h5>
                    <p class="text-muted">No products available in this category yet.</p>
                </div>
            </c:if>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-5">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage-1}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                    
                    <c:forEach begin="0" end="${totalPages-1}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i+1}</a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages-1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage+1}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>