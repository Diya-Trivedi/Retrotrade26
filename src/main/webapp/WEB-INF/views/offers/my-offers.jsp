<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Offers - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .offers-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .page-header h2 {
            color: #333;
            font-weight: 600;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card .count {
            font-size: 28px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-card .label {
            color: #666;
            font-size: 14px;
        }
        
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        
        .status-accepted {
            background: #28a745;
            color: white;
        }
        
        .status-rejected {
            background: #dc3545;
            color: white;
        }
        
        .status-countered {
            background: #17a2b8;
            color: white;
        }
        
        .status-expired {
            background: #6c757d;
            color: white;
        }
        
        .status-withdrawn {
            background: #6c757d;
            color: white;
        }
        
        .table-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
        }
        
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .btn-action {
            padding: 5px 10px;
            border-radius: 5px;
            margin: 0 2px;
            font-size: 12px;
            transition: transform 0.2s;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
        }
        
        .empty-state {
            text-align: center;
            padding: 50px;
        }
        
        .empty-state i {
            font-size: 60px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .pagination .page-link {
            color: #667eea;
        }
        
        .pagination .active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="offers-container">
        <!-- Page Header -->
        <div class="page-header">
            <h2><i class="fas fa-hand-holding-usd me-2"></i>My Offers</h2>
            <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary">
                <i class="fas fa-search me-2"></i>Browse More Items
            </a>
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="count">${pendingCount}</div>
                <div class="label">Pending</div>
            </div>
            <div class="stat-card">
                <div class="count">${acceptedCount}</div>
                <div class="label">Accepted</div>
            </div>
            <div class="stat-card">
                <div class="count">${rejectedCount}</div>
                <div class="label">Rejected</div>
            </div>
            <div class="stat-card">
                <div class="count">${totalItems}</div>
                <div class="label">Total</div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/offers/my-offers" method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Filter by Status</label>
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="">All Offers</option>
                        <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="ACCEPTED" ${selectedStatus == 'ACCEPTED' ? 'selected' : ''}>Accepted</option>
                        <option value="REJECTED" ${selectedStatus == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                        <option value="COUNTERED" ${selectedStatus == 'COUNTERED' ? 'selected' : ''}>Countered</option>
                        <option value="EXPIRED" ${selectedStatus == 'EXPIRED' ? 'selected' : ''}>Expired</option>
                        <option value="WITHDRAWN" ${selectedStatus == 'WITHDRAWN' ? 'selected' : ''}>Withdrawn</option>
                    </select>
                </div>
                <div class="col-md-8 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">Apply Filter</button>
                    <a href="${pageContext.request.contextPath}/offers/my-offers" class="btn btn-outline-secondary ms-2">Clear</a>
                </div>
            </form>
        </div>
        
        <!-- Offers Table -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty offers}">
                    <div class="empty-state">
                        <i class="fas fa-hand-holding-usd"></i>
                        <h4>No Offers Found</h4>
                        <p class="text-muted">You haven't made any offers yet.</p>
                        <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Browse Items
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Seller</th>
                                    <th>Asking Price</th>
                                    <th>Your Offer</th>
                                    <th>Status</th>
                                    <th>Expires</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="offer" items="${offers}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${not empty offer.listing.images and not empty offer.listing.images[0]}">
                                                        <img src="${offer.listing.images[0].imageUrl}" class="product-thumb me-2" alt="${offer.listing.listingName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/50" class="product-thumb me-2" alt="No image">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <strong>${offer.listing.listingName}</strong>
                                                    <br><small class="text-muted">ID: #${offer.listing.listingId}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            ${offer.listing.seller.firstName} ${offer.listing.seller.lastName}
                                        </td>
                                        <td>
                                            <strong>₹<fmt:formatNumber value="${offer.listing.price}" pattern="#,##0.00"/></strong>
                                        </td>
                                        <td>
                                            <strong class="text-primary">₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></strong>
                                            <c:if test="${offer.offerStatus == 'COUNTERED' and not empty offer.counterPrice}">
                                                <br><small class="text-info">Counter: ₹<fmt:formatNumber value="${offer.counterPrice}" pattern="#,##0.00"/></small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="status-badge status-${fn:toLowerCase(offer.offerStatus)}">
                                                ${offer.offerStatus}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${offer.expiryDate != null}">
                                                    ${offer.expiryDate}
                                                    <c:if test="${offer.offerStatus == 'PENDING'}">
                                                        <br><small class="text-muted">${offer.expiryDate}</small>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/offers/view/${offer.offerId}" 
                                                   class="btn btn-sm btn-info btn-action" title="View">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <c:if test="${offer.offerStatus == 'PENDING'}">
                                                    <a href="#" onclick="withdrawOffer(${offer.offerId})" 
                                                       class="btn btn-sm btn-warning btn-action" title="Withdraw">
                                                        <i class="fas fa-times-circle"></i>
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage-1}&size=10&status=${selectedStatus}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                
                                <c:forEach begin="0" end="${totalPages-1}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&size=10&status=${selectedStatus}">${i+1}</a>
                                    </li>
                                </c:forEach>
                                
                                <li class="page-item ${currentPage == totalPages-1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage+1}&size=10&status=${selectedStatus}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- Withdraw Form (Hidden) -->
    <form id="withdrawForm" method="post" style="display: none;">
        <input type="hidden" name="_method" value="post">
    </form>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function withdrawOffer(offerId) {
            if (confirm('Are you sure you want to withdraw this offer?')) {
                var form = document.getElementById('withdrawForm');
                form.action = '${pageContext.request.contextPath}/offers/withdraw/' + offerId;
                form.submit();
            }
        }
    </script>
</body>
</html>