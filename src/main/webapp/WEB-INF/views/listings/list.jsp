<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Listings - Retrotrade</title>
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
        .product-image {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }
        .product-details {
            padding: 15px;
        }
        .product-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #333;
        }
        .product-price {
            font-size: 20px;
            font-weight: 700;
            color: #667eea;
        }
        .product-condition {
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 20px;
            background: #e9ecef;
        }
        .filter-sidebar {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 20px;
        }
        .pagination .page-link {
            color: #667eea;
        }
        .pagination .active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
            color: white;
        }
        .no-results {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container mt-5">
        <div class="row">
            <!-- Sidebar Filters -->
            <div class="col-md-3">
                <div class="filter-sidebar">
                    <h5 class="mb-3"><i class="fas fa-filter me-2"></i>Filters</h5>
                    
                    <form action="${pageContext.request.contextPath}/listings" method="get" id="filterForm">
                        <!-- Search -->
                        <div class="mb-3">
                            <label class="form-label">Search</label>
                            <input type="text" class="form-control" name="search" value="${searchKeyword}" placeholder="Search products...">
                        </div>
                        
                        <!-- Category -->
                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <select class="form-select" name="categoryId" onchange="this.form.submit()">
                                <option value="">All Categories</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}" ${selectedCategory == cat.categoryId ? 'selected' : ''}>
                                        ${cat.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- Price Range -->
                        <div class="mb-3">
                            <label class="form-label">Price Range</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="number" class="form-control" name="minPrice" value="${minPrice}" placeholder="Min">
                                </div>
                                <div class="col-6">
                                    <input type="number" class="form-control" name="maxPrice" value="${maxPrice}" placeholder="Max">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Sort -->
                        <div class="mb-3">
                            <label class="form-label">Sort By</label>
                            <select class="form-select" name="sort" onchange="this.form.submit()">
                                <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Newest First</option>
                                <option value="oldest" ${sort == 'oldest' ? 'selected' : ''}>Oldest First</option>
                                <option value="price_low" ${sort == 'price_low' ? 'selected' : ''}>Price: Low to High</option>
                                <option value="price_high" ${sort == 'price_high' ? 'selected' : ''}>Price: High to Low</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-2"></i>Apply Filters
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/listings" class="btn btn-outline-secondary w-100 mt-2">
                            <i class="fas fa-redo me-2"></i>Reset
                        </a>
                    </form>
                </div>
            </div>

            <!-- Listings Grid -->
            <div class="col-md-9">
                <!-- Results Info -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4>Browse Products</h4>
                    <p class="text-muted">Showing ${listings.size()} of ${totalItems} results</p>
                </div>

                <!-- Products Grid -->
                <div class="row g-4">
                    <c:forEach var="listing" items="${listings}">
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/listings/${listing.listingId}" class="product-card">
                                <img src="${not empty listing.images and not empty listing.images[0] ? listing.images[0].imageUrl : 'https://via.placeholder.com/300x200'}" 
                                     class="product-image" alt="${listing.listingName}">
                                <div class="product-details">
                                    <h6 class="product-title">${listing.listingName}</h6>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="product-price">₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/></span>
                                        <span class="product-condition">${listing.condition}</span>
                                    </div>
                                    <div class="d-flex justify-content-between mt-2">
                                        <small class="text-muted">
                                            <i class="fas fa-map-marker-alt me-1"></i>${listing.location != null ? listing.location : 'Location N/A'}
                                        </small>
                                        <small class="text-muted">
                                            <i class="fas fa-eye me-1"></i>${listing.viewCount}
                                        </small>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>

                    <c:if test="${empty listings}">
                        <div class="col-12">
                            <div class="no-results">
                                <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                                <h5>No Listings Found</h5>
                                <p class="text-muted">Try adjusting your filters or check back later.</p>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-5">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage-1}&size=12&categoryId=${selectedCategory}&subCategoryId=${selectedSubCategory}&search=${searchKeyword}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sort}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            
                            <c:forEach begin="0" end="${totalPages-1}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&size=12&categoryId=${selectedCategory}&subCategoryId=${selectedSubCategory}&search=${searchKeyword}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sort}">
                                        ${i+1}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages-1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage+1}&size=12&categoryId=${selectedCategory}&subCategoryId=${selectedSubCategory}&search=${searchKeyword}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sort}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script>
        // Auto-submit form when category or sort changes
        document.querySelectorAll('select[name="categoryId"], select[name="sort"]').forEach(select => {
            select.addEventListener('change', function() {
                document.getElementById('filterForm').submit();
            });
        });
    </script>
</body>
</html>