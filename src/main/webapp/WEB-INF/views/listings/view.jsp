<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${listing.listingName} - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .product-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }
        .thumbnail-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.3s;
        }
        .thumbnail-image:hover, .thumbnail-image.active {
            border-color: #667eea;
        }
        .product-price {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
        }
        .info-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .seller-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        .status-active {
            background: #28a745;
            color: white;
        }
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        .status-sold {
            background: #6c757d;
            color: white;
        }
        .status-rejected {
            background: #dc3545;
            color: white;
        }
        .negotiable-badge {
            background: #17a2b8;
            color: white;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
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
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container mt-5">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listings">Listings</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listings?categoryId=${listing.category.categoryId}">${listing.category.categoryName}</a></li>
                <li class="breadcrumb-item active">${listing.listingName}</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Product Images -->
            <div class="col-md-6">
                <img id="mainImage" src="${not empty listing.images and not empty listing.images[0] ? listing.images[0].imageUrl : 'https://via.placeholder.com/600x400'}" 
                     class="product-image mb-3" alt="${listing.listingName}">
                
                <c:if test="${not empty listing.images and listing.images.size() > 1}">
                    <div class="d-flex gap-2 flex-wrap">
                        <c:forEach var="img" items="${listing.images}" varStatus="status">
                            <img src="${img.imageUrl}" 
                                 class="thumbnail-image ${status.first ? 'active' : ''}" 
                                 onclick="document.getElementById('mainImage').src='${img.imageUrl}'; 
                                          document.querySelectorAll('.thumbnail-image').forEach(i => i.classList.remove('active'));
                                          this.classList.add('active');"
                                 alt="Thumbnail">
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <!-- Product Details -->
            <div class="col-md-6">
                <div class="seller-card">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <h2>${listing.listingName}</h2>
                            <p class="text-muted">
                                <i class="fas fa-tag me-1"></i>${listing.category.categoryName} 
                                <i class="fas fa-angle-right mx-1"></i> 
                                ${listing.subCategory.subCategoryName}
                            </p>
                        </div>
                        <span class="status-badge status-${listing.status.toLowerCase()}">${listing.status}</span>
                    </div>
                    
                    <div class="product-price mb-3">
                        ₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/>
                        <c:if test="${listing.negotiable}">
                            <span class="negotiable-badge ms-2">Negotiable</span>
                        </c:if>
                    </div>
                    
                    <div class="info-section">
                        <h5 class="mb-3">Product Details</h5>
                        <table class="table table-borderless">
                            <tr>
                                <th style="width: 120px;">Brand:</th>
                                <td>${listing.brand != null ? listing.brand : 'Not specified'}</td>
                            </tr>
                            <tr>
                                <th>Condition:</th>
                                <td><span class="badge bg-info">${listing.condition}</span></td>
                            </tr>
                            <tr>
                                <th>Location:</th>
                                <td><i class="fas fa-map-marker-alt me-1"></i>${listing.location != null ? listing.location : 'Not specified'}</td>
                            </tr>
                            <tr>
                                <th>Views:</th>
                                <td><i class="fas fa-eye me-1"></i>${listing.viewCount}</td>
                            </tr>
                            <tr>
                                <th>Posted:</th>
                                <td><i class="far fa-clock me-1"></i>${listing.createdAt}</td>
                            </tr>
                        </table>
                    </div>
                    
                    <div class="info-section">
                        <h5 class="mb-3">Description</h5>
                        <p>${listing.description != null ? listing.description : 'No description provided'}</p>
                    </div>
                    
                    <!-- Seller Information -->
                    <div class="info-section">
                        <h5 class="mb-3">Seller Information</h5>
                        <div class="d-flex align-items-center">
                            <c:choose>
                                <c:when test="${not empty listing.seller.profilePicURL}">
                                    <img src="${listing.seller.profilePicURL}" class="rounded-circle me-3" width="50" height="50" alt="Seller">
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px;">
                                        <i class="fas fa-user text-white fa-2x"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <h6 class="mb-1">${listing.seller.firstName} ${listing.seller.lastName}</h6>
                                <p class="text-muted mb-0"><i class="fas fa-phone me-1"></i>${listing.seller.contactNum}</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons - UPDATED WITH CORRECT LINKS -->
                    <div class="d-flex gap-2">
    <c:choose>
        <c:when test="${empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/login?redirect=/listings/${listing.listingId}" class="btn btn-primary flex-grow-1">
                <i class="fas fa-sign-in-alt me-2"></i>Login to Contact
            </a>
        </c:when>
        
        <c:when test="${sessionScope.user.userId == listing.seller.userId}">
            <a href="${pageContext.request.contextPath}/listings/edit/${listing.listingId}" class="btn btn-warning flex-grow-1">
                <i class="fas fa-edit me-2"></i>Edit Listing
            </a>
            <a href="${pageContext.request.contextPath}/offers/received?listingId=${listing.listingId}" class="btn btn-info">
                <i class="fas fa-inbox"></i> Offers
            </a>
        </c:when>
        
        <c:when test="${listing.status != 'ACTIVE'}">
            <button class="btn btn-secondary flex-grow-1" disabled>
                <i class="fas fa-ban me-2"></i>Not Available
            				</button>
        				</c:when>
        
        					<c:otherwise>
            					<a href="#" class="btn btn-primary flex-grow-1" onclick="openContactModal()">
               						 <i class="fas fa-comment me-2"></i>Contact Seller
           						 </a>
           						 <a href="${pageContext.request.contextPath}/offers/make/${listing.listingId}" class="btn btn-outline-primary">
               						 <i class="fas fa-hand-holding-usd"></i> Make Offer
           		 				</a>
            					<a href="${pageContext.request.contextPath}/transactions/buy/${listing.listingId}" class="btn btn-success">
               		 				<i class="fas fa-bolt"></i> Buy Now
            					</a>
            					<a href="#" class="btn btn-outline-danger" onclick="addToWishlist(${listing.listingId})">
                				<i class="fas fa-heart"></i> Wishlist
            					</a>
            					<!-- NEW REPORT BUTTON -->
            					<a href="${pageContext.request.contextPath}/reports/submit/${listing.listingId}" class="btn btn-outline-danger">
                					<i class="fas fa-flag"></i> Report
            					</a>
        					</c:otherwise>
    					</c:choose>
					</div>
                </div>
            </div>
        </div>

        <!-- Related Listings -->
        <c:if test="${not empty relatedListings}">
            <div class="row mt-5">
                <div class="col-12">
                    <h4 class="mb-4">Related Products</h4>
                </div>
                <c:forEach var="related" items="${relatedListings}">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/listings/${related.listingId}" class="product-card">
                            <img src="${not empty related.images and not empty related.images[0] ? related.images[0].imageUrl : 'https://via.placeholder.com/300x200'}" 
                                 class="product-image" style="height: 150px;" alt="${related.listingName}">
                            <div class="product-details p-2">
                                <h6 class="product-title">${related.listingName}</h6>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="product-price" style="font-size: 16px;">₹<fmt:formatNumber value="${related.price}" pattern="#,##0.00"/></span>
                                    <span class="product-condition" style="font-size: 11px;">${related.condition}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
    
    <!-- Contact Modal -->
    <div class="modal fade" id="contactModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-comment"></i> Contact Seller
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <div class="bg-secondary rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3" style="width: 80px; height: 80px;">
                            <c:choose>
                                <c:when test="${not empty listing.seller.profilePicURL}">
                                    <img src="${listing.seller.profilePicURL}" alt="${listing.seller.firstName}" style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-user text-white fa-3x"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h5>${listing.seller.firstName} ${listing.seller.lastName}</h5>
                    </div>
                    
                    <div class="list-group">
                        <div class="list-group-item">
                            <i class="fas fa-envelope me-2"></i> ${listing.seller.email}
                        </div>
                        <div class="list-group-item">
                            <i class="fas fa-phone me-2"></i> ${listing.seller.contactNum}
                        </div>
                    </div>
                    
                    <div class="mt-4">
                        <a href="mailto:${listing.seller.email}" class="btn btn-primary w-100">
                            <i class="fas fa-envelope"></i> Send Email
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openContactModal() {
            new bootstrap.Modal(document.getElementById('contactModal')).show();
        }
        function addToCart(listingId) {
            fetch('${pageContext.request.contextPath}/cart/add', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'listingId=' + listingId + '&quantity=1'
            }).then(() => alert('Added to cart!'));
        }
        function addToWishlist(listingId) {
            fetch('${pageContext.request.contextPath}/wishlist/add', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'listingId=' + listingId
            }).then(() => alert('Added to wishlist!'));
        }
    </script>
</body>
</html>