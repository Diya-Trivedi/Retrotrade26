<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Listings - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
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
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        .thumbnail {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="products" scope="request"/>
    <c:set var="subPage" value="${param.status == 'ACTIVE' ? 'active-listings' : 
                                    (param.status == 'SOLD' ? 'sold-listings' : 
                                    (param.status == 'REJECTED' ? 'rejected-listings' : 'all-listings'))}" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-box me-2"></i>Manage Listings</h2>
            </div>

            <!-- Statistics Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-primary">${activeCount}</h3>
                        <p class="text-muted mb-0">Active Listings</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-secondary">${soldCount}</h3>
                        <p class="text-muted mb-0">Sold</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-danger">${rejectedCount}</h3>
                        <p class="text-muted mb-0">Rejected</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-success">${listings.size()}</h3>
                        <p class="text-muted mb-0">Total Displayed</p>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/listings" method="get" class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Filter by Status</label>
                        <select name="status" class="form-select">
                            <option value="">All Status</option>
                            <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="SOLD" ${param.status == 'SOLD' ? 'selected' : ''}>Sold</option>
                            <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Filter by Category</label>
                        <select name="categoryId" class="form-select">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Apply Filters
                        </button>
                    </div>
                </form>
            </div>

            <!-- Listings Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>Image</th>
                            <th>ID</th>
                            <th>Product Name</th>
                            <th>Seller</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Views</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="listing" items="${listings}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty listing.images and not empty listing.images[0]}">
                                            <img src="${listing.images[0].imageUrl}" class="thumbnail" alt="Product">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/50" class="thumbnail" alt="No image">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>#${listing.listingId}</td>
                                <td>
                                    <strong>${listing.listingName}</strong><br>
                                    <small class="text-muted">${listing.brand}</small>
                                </td>
                                <td>
                                    ${listing.seller.firstName} ${listing.seller.lastName}<br>
                                    <small class="text-muted">${listing.seller.email}</small>
                                </td>
                                <td>
                                    <span class="badge bg-info">${listing.category.categoryName}</span><br>
                                    <small>${listing.subCategory.subCategoryName}</small>
                                </td>
                                <td><strong>₹<fmt:formatNumber value="${listing.price}" type="currency" currencySymbol=""/></strong></td>
                                <td>
                                    <span class="status-badge status-${listing.status.toLowerCase()}">
                                        ${listing.status}
                                    </span>
                                </td>
                                <td>${listing.viewCount}</td>
                                <td>${listing.createdAt}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/admin/listings/view/${listing.listingId}" 
                                           class="btn btn-sm btn-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <c:if test="${listing.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/admin/listings/mark-sold/${listing.listingId}" 
                                               class="btn btn-sm btn-success" title="Mark as Sold"
                                               onclick="return confirm('Mark this listing as sold?')">
                                                <i class="fas fa-check-circle"></i>
                                            </a>
                                        </c:if>
                                        <c:if test="${listing.status == 'PENDING'}">
                                            <a href="${pageContext.request.contextPath}/admin/listings/approve/${listing.listingId}" 
                                               class="btn btn-sm btn-success" title="Approve">
                                                <i class="fas fa-check"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/listings/reject/${listing.listingId}" 
                                               class="btn btn-sm btn-danger" title="Reject"
                                               onclick="return confirm('Reject this listing?')">
                                                <i class="fas fa-times"></i>
                                            </a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/admin/listings/delete/${listing.listingId}" 
                                           class="btn btn-sm btn-danger" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this listing?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty listings}">
                            <tr>
                                <td colspan="10" class="text-center py-5">
                                    <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                                    <h5>No Listings Found</h5>
                                    <p class="text-muted">No listings match your filter criteria.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>