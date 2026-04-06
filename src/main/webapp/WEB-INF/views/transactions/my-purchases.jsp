<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Purchases - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .purchases-container {
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
        
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            margin-bottom: 20px;
        }
        
        .stats-card .value {
            font-size: 28px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stats-card .label {
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
        
        .transaction-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.3s;
        }
        
        .transaction-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.2);
        }
        
        .transaction-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .transaction-id {
            font-weight: 600;
            color: #667eea;
        }
        
        .transaction-date {
            color: #666;
            font-size: 14px;
        }
        
        .transaction-body {
            padding: 20px;
            display: flex;
            flex-wrap: wrap;
        }
        
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 20px;
        }
        
        .product-info {
            flex: 1;
        }
        
        .product-name {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .seller-name {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .transaction-status {
            margin-left: auto;
            text-align: right;
        }
        
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-completed {
            background: #28a745;
            color: white;
        }
        
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        
        .status-cancelled {
            background: #dc3545;
            color: white;
        }
        
        .status-delivered {
            background: #17a2b8;
            color: white;
        }
        
        .status-initiated {
            background: #6c757d;
            color: white;
        }
        
        .transaction-amount {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-top: 5px;
        }
        
        .transaction-footer {
            padding: 15px 20px;
            border-top: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .btn-action {
            padding: 8px 20px;
            border-radius: 5px;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.3s;
        }
        
        .btn-view {
            background: #667eea;
            color: white;
        }
        
        .btn-view:hover {
            background: #5a67d8;
            transform: translateY(-2px);
            color: white;
        }
        
        .btn-outline-primary {
            background: transparent;
            border: 1px solid #667eea;
            color: #667eea;
        }
        
        .btn-outline-primary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-track {
            background: #17a2b8;
            color: white;
            margin-left: 10px;
        }
        
        .btn-track:hover {
            background: #138496;
            transform: translateY(-2px);
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
        
        @media (max-width: 768px) {
            .transaction-footer {
                flex-direction: column;
                align-items: stretch;
            }
            .transaction-footer > div {
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="purchases-container">
        <div class="page-header">
            <h2><i class="fas fa-shopping-bag me-2"></i>My Purchases</h2>
            <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary">
                <i class="fas fa-search me-2"></i>Continue Shopping
            </a>
        </div>
        
        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="value">${totalItems}</div>
                    <div class="label">Total Orders</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="value">₹<fmt:formatNumber value="${totalSpent}" pattern="#,##0"/></div>
                    <div class="label">Total Spent</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stats-card">
                    <div class="value">${pendingCount}</div>
                    <div class="label">Pending</div>
                </div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/transactions/my-purchases" method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Filter by Status</label>
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="">All Orders</option>
                        <option value="INITIATED" ${selectedStatus == 'INITIATED' ? 'selected' : ''}>Initiated</option>
                        <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="COMPLETED" ${selectedStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        <option value="DELIVERED" ${selectedStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                        <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </div>
                <div class="col-md-8 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">Apply Filter</button>
                    <a href="${pageContext.request.contextPath}/transactions/my-purchases" class="btn btn-outline-secondary ms-2">Clear</a>
                </div>
            </form>
        </div>
        
        <!-- Transactions List -->
        <c:choose>
            <c:when test="${empty transactions}">
                <div class="empty-state">
                    <i class="fas fa-shopping-bag"></i>
                    <h4>No Purchases Yet</h4>
                    <p class="text-muted">You haven't made any purchases yet.</p>
                    <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary">
                        <i class="fas fa-search me-2"></i>Browse Products
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="transaction" items="${transactions}">
                    <div class="transaction-card">
                        <div class="transaction-header">
                            <span class="transaction-id">Order #${transaction.transactionId}</span>
                            <span class="transaction-date">
                                <i class="far fa-calendar-alt me-1"></i>
                                ${transaction.createdAt}
                            </span>
                        </div>
                        
                        <div class="transaction-body">
                            <img src="${not empty transaction.listing.images and not empty transaction.listing.images[0] ? transaction.listing.images[0].imageUrl : 'https://via.placeholder.com/80'}" 
                                 class="product-image" alt="${transaction.listing.listingName}">
                            
                            <div class="product-info">
                                <div class="product-name">${transaction.listing.listingName}</div>
                                <div class="seller-name">
                                    <i class="fas fa-store me-1"></i>Sold by: ${transaction.seller.firstName} ${transaction.seller.lastName}
                                </div>
                                <div class="transaction-amount">₹<fmt:formatNumber value="${transaction.finalPrice}" pattern="#,##0.00"/></div>
                            </div>
                            
                            <div class="transaction-status">
                                <span class="status-badge status-${fn:toLowerCase(transaction.transactionStatus)}">
                                    ${transaction.transactionStatus}
                                </span>
                                <div class="mt-2">
                                    <small class="text-muted">
                                        <i class="fas fa-credit-card me-1"></i>${transaction.paymentMode}
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="transaction-footer">
                            <div>
                                <c:if test="${transaction.transactionStatus == 'DELIVERED'}">
                                    <span class="text-success">
                                        <i class="fas fa-check-circle me-1"></i>Delivered on 
                                        ${transaction.deliveredAt}
                                    </span>
                                </c:if>
                                <c:if test="${transaction.transactionStatus == 'COMPLETED' && not empty transaction.estimatedDelivery}">
                                    <span class="text-info">
                                        <i class="fas fa-truck me-1"></i>Est. delivery: 
                                        ${transaction.estimatedDelivery}
                                    </span>
                                </c:if>
                            </div>
                            
                            <div>
                                <a href="${pageContext.request.contextPath}/transactions/view/${transaction.transactionId}" 
                                   class="btn-action btn-view">
                                    <i class="fas fa-eye me-1"></i>View Details
                                </a>
                                <c:if test="${transaction.transactionStatus == 'COMPLETED' and not reviewExistsMap[transaction.transactionId]}">
                                    <a href="${pageContext.request.contextPath}/reviews/submit/${transaction.seller.userId}" 
                                       class="btn-action btn-outline-primary">
                                        <i class="fas fa-star me-1"></i>Write Review
                                    </a>
                                </c:if>
                                <c:if test="${transaction.transactionStatus == 'COMPLETED'}">
                                    <a href="#" class="btn-action btn-track">
                                        <i class="fas fa-truck me-1"></i>Track Order
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
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
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>