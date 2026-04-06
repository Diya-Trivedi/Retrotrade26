<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Transaction - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --sidebar-width: 280px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6f9;
            overflow-x: hidden;
        }
        
        .wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
        }
        
        #sidebar {
            min-width: var(--sidebar-width);
            max-width: var(--sidebar-width);
            background: var(--primary-gradient);
            color: #fff;
            transition: all 0.3s;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }
        
        #sidebar.active {
            margin-left: calc(-1 * var(--sidebar-width));
        }
        
        #sidebar .sidebar-header {
            padding: 25px 20px;
            background: rgba(0, 0, 0, 0.1);
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        #sidebar .sidebar-header h3 {
            margin: 0;
            font-weight: 600;
            font-size: 1.5rem;
        }
        
        #sidebar ul.components {
            padding: 20px 0;
        }
        
        #sidebar ul li a {
            padding: 12px 25px;
            display: block;
            color: #fff;
            text-decoration: none;
        }
        
        #sidebar ul li a i {
            margin-right: 10px;
        }
        
        #sidebar .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
        }
        
        #content {
            width: 100%;
            margin-left: var(--sidebar-width);
            transition: all 0.3s;
        }
        
        .navbar-custom {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 30px;
            position: fixed;
            width: calc(100% - var(--sidebar-width));
            z-index: 100;
        }
        
        .main-content {
            padding: 100px 30px 30px;
            min-height: 100vh;
        }
        
        .page-header {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .view-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .view-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .view-header h3 {
            margin: 0 0 10px 0;
            font-weight: 600;
        }
        
        .view-body {
            padding: 30px;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-initiated {
            background: #6c757d;
            color: white;
        }
        
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        
        .status-completed {
            background: #28a745;
            color: white;
        }
        
        .status-cancelled {
            background: #dc3545;
            color: white;
        }
        
        .status-delivered {
            background: #17a2b8;
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
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
        
        .info-card h6 {
            color: #666;
            margin-bottom: 10px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-card .value {
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .detail-table {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .detail-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            width: 180px;
            color: #666;
            font-weight: 600;
        }
        
        .detail-value {
            flex: 1;
            color: #333;
        }
        
        .product-section {
            display: flex;
            align-items: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 20px;
        }
        
        .user-card {
            display: flex;
            align-items: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
        }
        
        .user-avatar-placeholder {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #667eea;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 600;
            margin-right: 15px;
        }
        
        .timeline {
            margin: 30px 0;
            position: relative;
            padding-left: 30px;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        
        .timeline-item {
            position: relative;
            padding-left: 30px;
            margin-bottom: 25px;
        }
        
        .timeline-icon {
            position: absolute;
            left: -20px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: white;
            border: 2px solid #667eea;
            z-index: 1;
        }
        
        .timeline-icon.completed {
            background: #667eea;
        }
        
        .timeline-content {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
        }
        
        .timeline-content h6 {
            margin-bottom: 5px;
            color: #333;
        }
        
        .timeline-content .time {
            font-size: 12px;
            color: #666;
        }
        
        .btn-action {
            padding: 10px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.3s;
            margin: 0 5px;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 30px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.3s;
        }
        
        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-2px);
            color: white;
        }
        
        @media (max-width: 768px) {
            #sidebar {
                margin-left: calc(-1 * var(--sidebar-width));
            }
            #sidebar.active {
                margin-left: 0;
            }
            #content {
                margin-left: 0;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .detail-row {
                flex-direction: column;
            }
            .detail-label {
                width: 100%;
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="transactions" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumb -->
            <div class="page-header">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/transactions">Transactions</a></li>
                        <li class="breadcrumb-item active">Transaction #${transaction.transactionId}</li>
                    </ol>
                </nav>
            </div>

            <!-- View Card -->
            <div class="view-card">
                <div class="view-header">
                    <h3><i class="fas fa-credit-card me-2"></i>Transaction Details</h3>
                    <span class="status-badge status-${fn:toLowerCase(transaction.transactionStatus)}">
                        ${transaction.transactionStatus}
                    </span>
                </div>
                
                <div class="view-body">
                    <!-- Product Information -->
                    <div class="product-section">
                        <img src="${not empty transaction.listing.images and not empty transaction.listing.images[0] ? transaction.listing.images[0].imageUrl : 'https://via.placeholder.com/80'}" 
                             class="product-image" alt="${transaction.listing.listingName}">
                        <div>
                            <h5>${transaction.listing.listingName}</h5>
                            <p class="text-muted mb-1">Listing ID: #${transaction.listing.listingId}</p>
                            <p class="text-muted mb-0">Category: ${transaction.listing.category.categoryName} > ${transaction.listing.subCategory.subCategoryName}</p>
                        </div>
                    </div>
                    
                    <!-- Price Information -->
                    <div class="info-grid">
                        <div class="info-card">
                            <h6><i class="fas fa-tag me-2"></i>Final Price</h6>
                            <div class="value text-primary">₹<fmt:formatNumber value="${transaction.finalPrice}" pattern="#,##0.00"/></div>
                        </div>
                        <div class="info-card">
                            <h6><i class="fas fa-percent me-2"></i>Platform Fee</h6>
                            <div class="value text-warning">₹<fmt:formatNumber value="${transaction.transactionFee}" pattern="#,##0.00"/></div>
                        </div>
                        <div class="info-card">
                            <h6><i class="fas fa-wallet me-2"></i>Seller Payout</h6>
                            <div class="value text-success">₹<fmt:formatNumber value="${transaction.sellerPayout}" pattern="#,##0.00"/></div>
                        </div>
                        <div class="info-card">
                            <h6><i class="fas fa-credit-card me-2"></i>Payment Mode</h6>
                            <div class="value">${transaction.paymentMode}</div>
                        </div>
                    </div>
                    
                    <!-- Buyer and Seller Information -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h6 class="mb-3"><i class="fas fa-user me-2 text-primary"></i>Buyer Information</h6>
                            <div class="user-card">
                                <c:choose>
                                    <c:when test="${not empty transaction.buyer.profilePicURL}">
                                        <img src="${transaction.buyer.profilePicURL}" class="user-avatar" alt="Buyer">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-avatar-placeholder">
                                            ${fn:substring(transaction.buyer.firstName, 0, 1)}${fn:substring(transaction.buyer.lastName, 0, 1)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <h6 class="mb-1">${transaction.buyer.firstName} ${transaction.buyer.lastName}</h6>
                                    <p class="text-muted mb-1">${transaction.buyer.email}</p>
                                    <p class="text-muted mb-0">Contact: ${transaction.buyer.contactNum}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6 class="mb-3"><i class="fas fa-store me-2 text-primary"></i>Seller Information</h6>
                            <div class="user-card">
                                <c:choose>
                                    <c:when test="${not empty transaction.seller.profilePicURL}">
                                        <img src="${transaction.seller.profilePicURL}" class="user-avatar" alt="Seller">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-avatar-placeholder">
                                            ${fn:substring(transaction.seller.firstName, 0, 1)}${fn:substring(transaction.seller.lastName, 0, 1)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <h6 class="mb-1">${transaction.seller.firstName} ${transaction.seller.lastName}</h6>
                                    <p class="text-muted mb-1">${transaction.seller.email}</p>
                                    <p class="text-muted mb-0">Contact: ${transaction.seller.contactNum}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Detailed Information -->
                    <div class="detail-table">
                        <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Transaction Details</h6>
                        
                        <div class="detail-row">
                            <span class="detail-label">Transaction ID:</span>
                            <span class="detail-value"><strong>#${transaction.transactionId}</strong></span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Payment ID:</span>
                            <span class="detail-value">${transaction.paymentId}</span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Order Date:</span>
                            <span class="detail-value">
                                <i class="far fa-calendar-alt me-2"></i>
                                ${transaction.createdAt}
                            </span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Completion Date:</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty transaction.completedAt}">
                                        ${transaction.completedAt}
                                    </c:when>
                                    <c:otherwise>
                                        Not completed
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Delivery Status:</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty transaction.deliveryStatus}">
                                        ${transaction.deliveryStatus}
                                    </c:when>
                                    <c:otherwise>
                                        Not shipped
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        
                        <c:if test="${not empty transaction.shippingAddress}">
                            <div class="detail-row">
                                <span class="detail-label">Shipping Address:</span>
                                <span class="detail-value">${transaction.shippingAddress}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty transaction.estimatedDelivery}">
                            <div class="detail-row">
                                <span class="detail-label">Estimated Delivery:</span>
                                <span class="detail-value">
                                    ${transaction.estimatedDelivery}
                                </span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty transaction.deliveredAt}">
                            <div class="detail-row">
                                <span class="detail-label">Delivered On:</span>
                                <span class="detail-value">
                                    ${transaction.deliveredAt}
                                </span>
                            </div>
                        </c:if>
                        
                        <div class="detail-row">
                            <span class="detail-label">Last Updated:</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty transaction.updatedAt}">
                                        ${transaction.updatedAt}
                                    </c:when>
                                    <c:otherwise>
                                        Not updated
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Timeline -->
                    <div class="detail-table">
                        <h6 class="mb-3"><i class="fas fa-clock me-2"></i>Transaction Timeline</h6>
                        
                        <div class="timeline">
                            <div class="timeline-item">
                                <div class="timeline-icon completed"></div>
                                <div class="timeline-content">
                                    <h6>Order Placed</h6>
                                    <p class="time mb-0">
                                        ${transaction.createdAt}
                                    </p>
                                </div>
                            </div>
                            
                            <c:if test="${transaction.transactionStatus == 'COMPLETED' or transaction.transactionStatus == 'DELIVERED'}">
                                <div class="timeline-item">
                                    <div class="timeline-icon completed"></div>
                                    <div class="timeline-content">
                                        <h6>Payment Completed</h6>
                                        <p class="time mb-0">
                                            ${transaction.completedAt}
                                        </p>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty transaction.estimatedDelivery}">
                                <div class="timeline-item">
                                    <div class="timeline-icon ${transaction.transactionStatus == 'DELIVERED' ? 'completed' : ''}"></div>
                                    <div class="timeline-content">
                                        <h6>Estimated Delivery</h6>
                                        <p class="time mb-0">
                                            ${transaction.estimatedDelivery}
                                        </p>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:if test="${transaction.transactionStatus == 'DELIVERED'}">
                                <div class="timeline-item">
                                    <div class="timeline-icon completed"></div>
                                    <div class="timeline-content">
                                        <h6>Delivered</h6>
                                        <p class="time mb-0">
                                            ${transaction.deliveredAt}
                                        </p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="text-center mt-4">
                        <form action="${pageContext.request.contextPath}/admin/transactions/update-status/${transaction.transactionId}" method="post" class="d-inline">
                            <select name="status" class="form-select d-inline w-auto me-2" style="width: 150px;">
                                <option value="INITIATED" ${transaction.transactionStatus == 'INITIATED' ? 'selected' : ''}>Initiated</option>
                                <option value="PENDING" ${transaction.transactionStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="COMPLETED" ${transaction.transactionStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                <option value="DELIVERED" ${transaction.transactionStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                <option value="CANCELLED" ${transaction.transactionStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                <option value="REFUNDED" ${transaction.transactionStatus == 'REFUNDED' ? 'selected' : ''}>Refunded</option>
                                <option value="DISPUTED" ${transaction.transactionStatus == 'DISPUTED' ? 'selected' : ''}>Disputed</option>
                            </select>
                            <button type="submit" class="btn btn-warning me-2">
                                <i class="fas fa-sync-alt me-2"></i>Update Status
                            </button>
                        </form>
                        
                        <a href="${pageContext.request.contextPath}/admin/transactions/delete/${transaction.transactionId}" 
                           class="btn btn-danger me-2"
                           onclick="return confirm('Are you sure you want to delete this transaction?')">
                            <i class="fas fa-trash me-2"></i>Delete
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/admin/transactions" class="btn-back">
                            <i class="fas fa-arrow-left me-2"></i>Back to List
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>