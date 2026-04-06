<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Listings - Retrotrade</title>
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
        .listing-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 10px 20px;
            font-weight: 600;
            transition: transform 0.3s;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .empty-state {
            background: white;
            border-radius: 15px;
            padding: 60px 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .empty-state i {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-box me-2"></i>My Listings</h2>
            <a href="${pageContext.request.contextPath}/listings/add" class="btn btn-primary">
                <i class="fas fa-plus me-2"></i>Add New Listing
            </a>
        </div>

        <c:if test="${empty listings}">
            <div class="empty-state text-center">
                <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                <h4>No Listings Yet</h4>
                <p class="text-muted mb-4">Start selling by adding your first listing.</p>
                <a href="${pageContext.request.contextPath}/listings/add" class="btn btn-primary btn-lg">
                    <i class="fas fa-plus me-2"></i>Add New Listing
                </a>
            </div>
        </c:if>

        <c:if test="${not empty listings}">
            <div class="table-responsive">
                <table class="table table-hover listing-table">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Views</th>
                            <th>Posted</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="listing" items="${listings}">
                            <tr>
                                <td>
                                    <img src="${not empty listing.images and not empty listing.images[0] ? listing.images[0].imageUrl : 'https://via.placeholder.com/50'}" 
                                         class="product-thumb" alt="${listing.listingName}">
                                </td>
                                <td>
                                    <strong>${listing.listingName}</strong>
                                    <c:if test="${not empty listing.brand}">
                                        <br><small class="text-muted">${listing.brand}</small>
                                    </c:if>
                                </td>
                                <td>
                                    <span class="badge bg-info">${listing.category.categoryName}</span>
                                    <br><small>${listing.subCategory.subCategoryName}</small>
                                </td>
                                <td><strong>₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/></strong></td>
                                <td>
                                    <span class="status-badge status-${fn:toLowerCase(listing.status)}">
                                        ${listing.status}
                                    </span>
                                </td>
                                <td>${listing.viewCount}</td>
                                <td>${listing.createdAt}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/listings/${listing.listingId}" class="btn btn-sm btn-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/listings/edit/${listing.listingId}" class="btn btn-sm btn-warning" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/listings/delete/${listing.listingId}" class="btn btn-sm btn-danger" title="Delete" 
                                           onclick="return confirm('Are you sure you want to delete this listing?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <!-- Add fn taglib for toLowerCase function -->
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
</body>
</html>