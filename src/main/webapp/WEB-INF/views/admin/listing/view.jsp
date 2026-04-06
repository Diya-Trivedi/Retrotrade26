<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Listing - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
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
        .status-sold {
            background: #6c757d;
            color: white;
        }
        .status-rejected {
            background: #dc3545;
            color: white;
        }
        .product-image {
            width: 100%;
            height: 300px;
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
        }
        .thumbnail-image:hover {
            border-color: #667eea;
        }
        .thumbnail-image.active {
            border-color: #667eea;
        }
        .info-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="products" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/listings">Listings</a></li>
                    <li class="breadcrumb-item active">${listing.listingName}</li>
                </ol>
            </nav>

            <div class="row">
                <!-- Product Images -->
                <div class="col-md-6">
                    <div class="card mb-3">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Product Images</h5>
                            
                            <!-- Main Image -->
                            <img id="mainImage" src="${not empty listing.images ? listing.images[0].imageUrl : 'https://via.placeholder.com/600x400'}" 
                                 class="product-image mb-3" alt="Product">
                            
                            <!-- Thumbnails -->
                            <div class="d-flex gap-2 flex-wrap">
                                <c:forEach var="img" items="${listing.images}">
                                    <img src="${img.imageUrl}" 
                                         class="thumbnail-image ${img.isPrimary ? 'active' : ''}" 
                                         onclick="document.getElementById('mainImage').src='${img.imageUrl}'"
                                         alt="Thumbnail">
                                </c:forEach>
                                <c:if test="${empty listing.images}">
                                    <p class="text-muted">No images uploaded</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product Details -->
                <div class="col-md-6">
                    <div class="card mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <h3 class="card-title">${listing.listingName}</h3>
                                <span class="status-badge status-${listing.status.toLowerCase()}">
                                    ${listing.status}
                                </span>
                            </div>
                            
                            <div class="info-section">
                                <h6 class="mb-3">Basic Information</h6>
                                <table class="table table-borderless">
                                    <tr>
                                        <th style="width: 150px;">Listing ID:</th>
                                        <td>#${listing.listingId}</td>
                                    </tr>
                                    <tr>
                                        <th>Price:</th>
                                        <td><h4 class="text-primary">₹<fmt:formatNumber value="${listing.price}" type="currency" currencySymbol=""/></h4></td>
                                    </tr>
                                    <tr>
                                        <th>Brand:</th>
                                        <td>${listing.brand != null ? listing.brand : 'Not specified'}</td>
                                    </tr>
                                    <tr>
                                        <th>Condition:</th>
                                        <td><span class="badge bg-info">${listing.condition}</span></td>
                                    </tr>
                                    <tr>
                                        <th>Location:</th>
                                        <td>${listing.location != null ? listing.location : 'Not specified'}</td>
                                    </tr>
                                    <tr>
                                        <th>Negotiable:</th>
                                        <td>
                                            <span class="badge ${listing.negotiable ? 'bg-success' : 'bg-secondary'}">
                                                ${listing.negotiable ? 'Yes' : 'No'}
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <div class="info-section">
                                <h6 class="mb-3">Category Information</h6>
                                <table class="table table-borderless">
                                    <tr>
                                        <th style="width: 150px;">Category:</th>
                                        <td><span class="badge bg-primary">${listing.category.categoryName}</span></td>
                                    </tr>
                                    <tr>
                                        <th>Subcategory:</th>
                                        <td><span class="badge bg-info">${listing.subCategory.subCategoryName}</span></td>
                                    </tr>
                                </table>
                            </div>

                            <div class="info-section">
                                <h6 class="mb-3">Seller Information</h6>
                                <table class="table table-borderless">
                                    <tr>
                                        <th style="width: 150px;">Name:</th>
                                        <td>${listing.seller.firstName} ${listing.seller.lastName}</td>
                                    </tr>
                                    <tr>
                                        <th>Email:</th>
                                        <td>${listing.seller.email}</td>
                                    </tr>
                                    <tr>
                                        <th>Contact:</th>
                                        <td>${listing.seller.contactNum}</td>
                                    </tr>
                                </table>
                            </div>

                            <div class="info-section">
                                <h6 class="mb-3">Description</h6>
                                <p>${listing.description != null ? listing.description : 'No description provided'}</p>
                            </div>

                            <div class="info-section">
                                <h6 class="mb-3">Statistics</h6>
                                <table class="table table-borderless">
                                    <tr>
                                        <th style="width: 150px;">Views:</th>
                                        <td>${listing.viewCount}</td>
                                    </tr>
                                    <tr>
                                        <th>Created:</th>
                                        <td>${listing.createdAt}</td>
                                    </tr>
                                    <tr>
                                        <th>Offers:</th>
                                        <td>${listing.offers.size()}</td>
                                    </tr>
                                </table>
                            </div>

                            <!-- Action Buttons -->
                            <div class="mt-4">
                                <c:if test="${listing.status == 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/admin/listings/approve/${listing.listingId}" 
                                       class="btn btn-success">
                                        <i class="fas fa-check me-2"></i>Approve
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/listings/reject/${listing.listingId}" 
                                       class="btn btn-danger"
                                       onclick="return confirm('Reject this listing?')">
                                        <i class="fas fa-times me-2"></i>Reject
                                    </a>
                                </c:if>
                                
                                <c:if test="${listing.status == 'ACTIVE'}">
                                    <a href="${pageContext.request.contextPath}/admin/listings/mark-sold/${listing.listingId}" 
                                       class="btn btn-success"
                                       onclick="return confirm('Mark this listing as sold?')">
                                        <i class="fas fa-check-circle me-2"></i>Mark as Sold
                                    </a>
                                </c:if>
                                
                                <a href="${pageContext.request.contextPath}/admin/listings/delete/${listing.listingId}" 
                                   class="btn btn-danger"
                                   onclick="return confirm('Are you sure you want to delete this listing?')">
                                    <i class="fas fa-trash me-2"></i>Delete
                                </a>
                                
                                <a href="${pageContext.request.contextPath}/admin/listings" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Back
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>