<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction Details - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .details-container {
            max-width: 900px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        .details-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .details-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .details-header h2 {
            margin: 0;
            font-weight: 600;
        }
        
        .details-body {
            padding: 30px;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 14px;
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
        
        .product-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }
        
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 10px;
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
            font-size: 1.3rem;
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
        
        .timeline {
            margin: 30px 0;
            position: relative;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 20px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        
        .timeline-item {
            position: relative;
            padding-left: 50px;
            margin-bottom: 25px;
        }
        
        .timeline-icon {
            position: absolute;
            left: 11px;
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
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn-action {
            padding: 10px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: transform 0.3s;
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
    <jsp:include page="../common/header.jsp" />
    
    <div class="details-container">
        <div class="details-card">
            <div class="details-header">
                <h2><i class="fas fa-receipt me-2"></i>Transaction Details</h2>
                <span class="status-badge status-${fn:toLowerCase(transaction.transactionStatus)} mt-3">
                    ${transaction.transactionStatus}
                </span>
            </div>
            
            <div class="details-body">
                <!-- Product Section -->
                <div class="product-section">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center">
                            <img src="${not empty transaction.listing.images and not empty transaction.listing.images[0] ? transaction.listing.images[0].imageUrl : 'https://via.placeholder.com/100'}" 
                                 class="product-image" alt="${transaction.listing.listingName}">
                        </div>
                        <div class="col-md-6">
                            <h5>${transaction.listing.listingName}</h5>
                            <p class="text-muted mb-1">Brand: ${transaction.listing.brand != null ? transaction.listing.brand : 'N/A'}</p>
                            <p class="text-muted mb-0">Condition: ${transaction.listing.condition}</p>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <div class="h4 text-primary">₹<fmt:formatNumber value="${transaction.finalPrice}" pattern="#,##0.00"/></div>
                        </div>
                    </div>
                </div>
                
                <!-- Price Breakdown -->
                <div class="info-grid">
                    <div class="info-card">
                        <h6><i class="fas fa-tag me-2"></i>Item Price</h6>
                        <div class="value">₹<fmt:formatNumber value="${transaction.finalPrice}" pattern="#,##0.00"/></div>
                    </div>
                    <div class="info-card">
                        <h6><i class="fas fa-hand-holding-usd me-2"></i>Platform Fee</h6>
                        <div class="value">₹<fmt:formatNumber value="${transaction.transactionFee}" pattern="#,##0.00"/></div>
                    </div>
                    <div class="info-card">
                        <h6><i class="fas fa-wallet me-2"></i>Seller Payout</h6>
                        <div class="value">₹<fmt:formatNumber value="${transaction.sellerPayout}" pattern="#,##0.00"/></div>
                    </div>
                    <div class="info-card">
                        <h6><i class="fas fa-credit-card me-2"></i>Payment Mode</h6>
                        <div class="value">${transaction.paymentMode}</div>
                    </div>
                </div>
                
                <!-- Transaction Details -->
                <div class="detail-table">
                    <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Transaction Information</h6>
                    
                    <div class="detail-row">
                        <span class="detail-label">Transaction ID:</span>
                        <span class="detail-value">#${transaction.transactionId}</span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Payment ID:</span>
                        <span class="detail-value">${transaction.paymentId}</span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Buyer:</span>
                        <span class="detail-value">
                            ${transaction.buyer.firstName} ${transaction.buyer.lastName} (${transaction.buyer.email})
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Seller:</span>
                        <span class="detail-value">
                            ${transaction.seller.firstName} ${transaction.seller.lastName}
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Order Date:</span>
                        <span class="detail-value">
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
                </div>
                
                <!-- Action Buttons -->
                <div class="action-buttons">
                    <c:choose>
                        <c:when test="${isBuyer}">
                            <a href="${pageContext.request.contextPath}/transactions/my-purchases" class="btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Back to My Purchases
                            </a>
                            <c:if test="${transaction.transactionStatus == 'COMPLETED' and not alreadyReviewed}">
                                <a href="${pageContext.request.contextPath}/reviews/submit/${transaction.seller.userId}" class="btn btn-primary">
                                    <i class="fas fa-star me-2"></i>Write a Review
                                </a>
                            </c:if>
                        </c:when>
                        <c:when test="${isSeller}">
                            <c:if test="${transaction.transactionStatus == 'COMPLETED'}">
                                <form method="post" action="${pageContext.request.contextPath}/transactions/update-delivery/${transaction.transactionId}" class="d-inline">
                                    <select name="deliveryStatus" class="form-select d-inline w-auto me-2">
                                        <option value="SHIPPED" ${transaction.deliveryStatus == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                        <option value="IN_TRANSIT" ${transaction.deliveryStatus == 'IN_TRANSIT' ? 'selected' : ''}>In Transit</option>
                                        <option value="OUT_FOR_DELIVERY" ${transaction.deliveryStatus == 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                        <option value="DELIVERED" ${transaction.deliveryStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                    </select>
                                    <button type="submit" class="btn btn-success btn-action">
                                        <i class="fas fa-truck me-2"></i>Update Delivery
                                    </button>
                                </form>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/transactions/my-sales" class="btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Back to My Sales
                            </a>
                        </c:when>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>