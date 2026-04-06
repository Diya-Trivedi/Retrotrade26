<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .dashboard-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.2);
        }
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .quick-action {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            text-decoration: none;
            color: #333;
            border: 1px solid #dee2e6;
            transition: all 0.3s;
        }
        .quick-action:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        .quick-action i {
            font-size: 24px;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="container mt-5">
        <h2 class="mb-4"><i class="fas fa-store me-2 text-primary"></i>Seller Dashboard</h2>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="dashboard-card text-center">
                    <div class="stat-number">${activeCount}</div>
                    <div class="stat-label">Active Listings</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dashboard-card text-center">
                    <div class="stat-number">${pendingCount}</div>
                    <div class="stat-label">Pending Listings</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="dashboard-card text-center">
                    <div class="stat-number">${soldCount}</div>
                    <div class="stat-label">Sold Items</div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <h4 class="mb-3">Quick Actions</h4>
        <div class="row g-3 mb-5">
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/listings/add" class="quick-action d-block">
                    <i class="fas fa-plus-circle"></i>
                    <h6>Add New Listing</h6>
                    <small>List a product</small>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/listings/my-listings" class="quick-action d-block">
                    <i class="fas fa-box"></i>
                    <h6>My Listings</h6>
                    <small>Manage your items</small>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/offers/received" class="quick-action d-block">
                    <i class="fas fa-inbox"></i>
                    <h6>Received Offers</h6>
                    <small>View buyer offers</small>
                </a>
            </div>
            <div class="col-md-3">
                <a href="${pageContext.request.contextPath}/transactions/my-sales" class="quick-action d-block">
                    <i class="fas fa-credit-card"></i>
                    <h6>My Sales</h6>
                    <small>Track sales</small>
                </a>
            </div>
        </div>

        <!-- Recent Offers (from controller) -->
        <h4 class="mb-3">Recent Offers Received</h4>
        <div class="dashboard-card">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Buyer</th>
                        <th>Offer Price</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="offer" items="${recentOffers}">
                        <tr>
                            <td>${offer.listing.listingName}</td>
                            <td>${offer.buyer.firstName} ${offer.buyer.lastName}</td>
                            <td>₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></td>
                            <td><span class="badge bg-${offer.offerStatus == 'PENDING' ? 'warning' : (offer.offerStatus == 'ACCEPTED' ? 'success' : 'secondary')}">${offer.offerStatus}</span></td>
                            <td>${offer.createdAt}</td>
                            <td><a href="${pageContext.request.contextPath}/offers/view/${offer.offerId}" class="btn btn-sm btn-info">View</a></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentOffers}">
                        <tr><td colspan="6" class="text-center py-3">No recent offers</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>