<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Sales - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .sales-container {
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
            border-left: 4px solid #667eea;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.2);
        }
        
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
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
        
        .buyer-name {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .buyer-name i {
            color: #667eea;
            margin-right: 5px;
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
            display: inline-block;
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
        
        .status-disputed {
            background: #dc3545;
            color: white;
        }
        
        .status-refunded {
            background: #6c757d;
            color: white;
        }
        
        .transaction-amount {
            font-size: 20px;
            font-weight: 700;
            color: #28a745;
            margin-top: 5px;
        }
        
        .transaction-fee {
            font-size: 12px;
            color: #666;
            margin-top: 2px;
        }
        
        .transaction-footer {
            padding: 15px 20px;
            border-top: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f8f9fa;
        }
        
        .delivery-info {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .delivery-status {
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: 600;
            background: #e9ecef;
            color: #495057;
        }
        
        .delivery-status.shipped {
            background: #cff4fc;
            color: #055160;
        }
        
        .delivery-status.delivered {
            background: #d1e7dd;
            color: #0a3622;
        }
        
        .btn-action {
            padding: 8px 20px;
            border-radius: 5px;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.3s;
            margin-left: 10px;
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
        
        .btn-update {
            background: #ffc107;
            color: #333;
        }
        
        .btn-update:hover {
            background: #e0a800;
            transform: translateY(-2px);
            color: #333;
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
        
        .empty-state h4 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #666;
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
        
        .earnings-badge {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 600;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .update-delivery-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .update-delivery-form select {
            padding: 5px 10px;
            border-radius: 5px;
            border: 1px solid #dee2e6;
            font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .transaction-body {
                flex-direction: column;
            }
            
            .product-image {
                margin-bottom: 15px;
                margin-right: 0;
            }
            
            .transaction-status {
                margin-left: 0;
                margin-top: 15px;
                text-align: left;
            }
            
            .transaction-footer {
                flex-direction: column;
                gap: 15px;
            }
            
            .delivery-info {
                width: 100%;
                justify-content: space-between;
            }
            
            .action-buttons {
                width: 100%;
                justify-content: center;
            }
            
            .update-delivery-form {
                flex-direction: column;
                width: 100%;
            }
            
            .update-delivery-form select {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="sales-container">
        <div class="page-header">
            <h2><i class="fas fa-store me-2 text-primary"></i>My Sales</h2>
           
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${totalItems}</div>
                <div class="stat-label">Total Sales</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="completedCount" value="0"/>
                    <c:forEach var="txn" items="${transactions}">
                        <c:if test="${txn.transactionStatus == 'COMPLETED' or txn.transactionStatus == 'DELIVERED'}">
                            <c:set var="completedCount" value="${completedCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${completedCount}
                </div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="pendingCount" value="0"/>
                    <c:forEach var="txn" items="${transactions}">
                        <c:if test="${txn.transactionStatus == 'PENDING' or txn.transactionStatus == 'INITIATED'}">
                            <c:set var="pendingCount" value="${pendingCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${pendingCount}
                </div>
                <div class="stat-label">Pending</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="deliveredCount" value="0"/>
                    <c:forEach var="txn" items="${transactions}">
                        <c:if test="${txn.transactionStatus == 'DELIVERED'}">
                            <c:set var="deliveredCount" value="${deliveredCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${deliveredCount}
                </div>
                <div class="stat-label">Delivered</div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/transactions/my-sales" method="get" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Filter by Status</label>
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="">All Sales</option>
                        <option value="INITIATED" ${selectedStatus == 'INITIATED' ? 'selected' : ''}>Initiated</option>
                        <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="COMPLETED" ${selectedStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        <option value="DELIVERED" ${selectedStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                        <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                        <option value="DISPUTED" ${selectedStatus == 'DISPUTED' ? 'selected' : ''}>Disputed</option>
                    </select>
                </div>
                <div class="col-md-8 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">Apply Filter</button>
                    <a href="${pageContext.request.contextPath}/transactions/my-sales" class="btn btn-outline-secondary ms-2">Clear</a>
                </div>
            </form>
        </div>
        
        <!-- Transactions List -->
        <c:choose>
            <c:when test="${empty transactions}">
                <div class="empty-state">
                    <i class="fas fa-store"></i>
                    <h4>No Sales Yet</h4>
                    <p class="text-muted">You haven't made any sales yet. List your products to start selling!</p>
                    <a href="${pageContext.request.contextPath}/listings/add" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add New Listing
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="transaction" items="${transactions}">
                    <div class="transaction-card">
                        <div class="transaction-header">
                            <span class="transaction-id">
                                <i class="fas fa-receipt me-1"></i>Order #${transaction.transactionId}
                            </span>
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
                                <div class="buyer-name">
                                    <i class="fas fa-user"></i>Buyer: ${transaction.buyer.firstName} ${transaction.buyer.lastName}
                                </div>
                                <div class="transaction-amount">
                                    ₹<fmt:formatNumber value="${transaction.finalPrice}" pattern="#,##0.00"/>
                                    <div class="transaction-fee">
                                        Platform Fee: -₹<fmt:formatNumber value="${transaction.transactionFee}" pattern="#,##0.00"/>
                                        <br>
                                        <strong>Your Payout: ₹<fmt:formatNumber value="${transaction.sellerPayout}" pattern="#,##0.00"/></strong>
                                    </div>
                                </div>
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
                                <c:if test="${not empty transaction.paymentId}">
                                    <div class="mt-1">
                                        <small class="text-muted">
                                            <i class="fas fa-hashtag me-1"></i>${fn:substring(transaction.paymentId, 0, 8)}...
                                        </small>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <div class="transaction-footer">
                            <div class="delivery-info">
                                <c:choose>
                                    <c:when test="${not empty transaction.deliveryStatus}">
                                        <span class="delivery-status ${fn:toLowerCase(transaction.deliveryStatus)}">
                                            <i class="fas fa-truck me-1"></i>${transaction.deliveryStatus}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="delivery-status">
                                            <i class="fas fa-box me-1"></i>Awaiting Shipment
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                
                                <c:if test="${not empty transaction.estimatedDelivery}">
                                    <small class="text-muted">
                                        <i class="far fa-clock me-1"></i>
                                        Est: ${transaction.estimatedDelivery}
                                    </small>
                                </c:if>
                                
                                <c:if test="${not empty transaction.deliveredAt}">
                                    <small class="text-success">
                                        <i class="fas fa-check-circle me-1"></i>
                                        Delivered: ${transaction.deliveredAt}
                                    </small>
                                </c:if>
                            </div>
                            
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/transactions/view/${transaction.transactionId}" 
                                   class="btn-action btn-view">
                                    <i class="fas fa-eye me-1"></i>View Details
                                </a>
                                
                                <c:if test="${transaction.transactionStatus == 'COMPLETED' and empty transaction.deliveryStatus}">
                                    <button class="btn-action btn-update" onclick="showDeliveryForm(${transaction.transactionId})">
                                        <i class="fas fa-truck me-1"></i>Update Delivery
                                    </button>
                                    
                                    <form id="deliveryForm-${transaction.transactionId}" 
                                          action="${pageContext.request.contextPath}/transactions/update-delivery/${transaction.transactionId}" 
                                          method="post" 
                                          style="display: none;">
                                        <div class="update-delivery-form">
                                            <select name="deliveryStatus" class="form-select">
                                                <option value="SHIPPED">Shipped</option>
                                                <option value="IN_TRANSIT">In Transit</option>
                                                <option value="OUT_FOR_DELIVERY">Out for Delivery</option>
                                                <option value="DELIVERED">Delivered</option>
                                            </select>
                                            <button type="submit" class="btn btn-sm btn-success">Update</button>
                                            <button type="button" class="btn btn-sm btn-secondary" onclick="hideDeliveryForm(${transaction.transactionId})">Cancel</button>
                                        </div>
                                    </form>
                                </c:if>
                                
                                <c:if test="${transaction.transactionStatus == 'DELIVERED'}">
                                    <span class="text-success">
                                        <i class="fas fa-check-circle me-1"></i>Completed
                                    </span>
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
    <script>
        function showDeliveryForm(transactionId) {
            document.getElementById('deliveryForm-' + transactionId).style.display = 'block';
        }
        
        function hideDeliveryForm(transactionId) {
            document.getElementById('deliveryForm-' + transactionId).style.display = 'none';
        }
    </script>
</body>
</html>