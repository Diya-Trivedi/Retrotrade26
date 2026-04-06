<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .confirmation-container {
            max-width: 700px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        .confirmation-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .success-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .success-header i {
            font-size: 60px;
            margin-bottom: 15px;
        }
        
        .success-header h2 {
            margin: 0;
            font-weight: 600;
        }
        
        .confirmation-body {
            padding: 30px;
        }
        
        .order-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .info-row {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            width: 150px;
            color: #666;
            font-weight: 600;
        }
        
        .info-value {
            flex: 1;
            color: #333;
        }
        
        .product-details {
            display: flex;
            align-items: center;
            padding: 15px;
            background: white;
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
        
        .btn-view-order {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            padding: 12px 30px;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.3s;
        }
        
        .btn-view-order:hover {
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }
        
        .btn-continue {
            background: #6c757d;
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            padding: 12px 30px;
            text-decoration: none;
            display: inline-block;
            margin-left: 10px;
            transition: transform 0.3s;
        }
        
        .btn-continue:hover {
            background: #5a6268;
            transform: translateY(-2px);
            color: white;
        }
        
        .estimated-delivery {
            background: #e3f2fd;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            margin-top: 20px;
        }
        
        .estimated-delivery i {
            color: #2196f3;
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="confirmation-container">
        <div class="confirmation-card">
            <div class="success-header">
                <i class="fas fa-check-circle"></i>
                <h2>Order Placed Successfully!</h2>
                <p class="mb-0">Thank you for your purchase</p>
            </div>
            
            <div class="confirmation-body">
                <div class="order-info">
                    <h5 class="mb-3"><i class="fas fa-receipt me-2 text-primary"></i>Order Summary</h5>
                    
                    <div class="info-row">
                        <span class="info-label">Order ID:</span>
                        <span class="info-value"><strong>#${transaction.transactionId}</strong></span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">Order Date:</span>
                        <span class="info-value">${transaction.createdAt}
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">Payment Method:</span>
                        <span class="info-value">${transaction.paymentMode}</span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">Payment ID:</span>
                        <span class="info-value">${transaction.paymentId}</span>
                    </div>
                    
                    <div class="info-row">
                        <span class="info-label">Total Amount:</span>
                        <span class="info-value text-success fw-bold">₹<fmt:formatNumber value="${transaction.finalPrice}" pattern="#,##0.00"/></span>
                    </div>
                </div>
                
                <div class="product-details">
                    <img src="${not empty transaction.listing.images and not empty transaction.listing.images[0] ? transaction.listing.images[0].imageUrl : 'https://via.placeholder.com/80'}" 
                         class="product-image" alt="${transaction.listing.listingName}">
                    <div>
                        <h5>${transaction.listing.listingName}</h5>
                        <p class="text-muted mb-1">Sold by: ${transaction.seller.firstName} ${transaction.seller.lastName}</p>
                        <p class="mb-0">Quantity: 1</p>
                    </div>
                </div>
                
                <div class="estimated-delivery">
                    <i class="fas fa-truck"></i>
                    <strong>Estimated Delivery:</strong> 
                    ${transaction.estimatedDelivery}
                </div>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/transactions/view/${transaction.transactionId}" class="btn-view-order">
                        <i class="fas fa-eye me-2"></i>View Order Details
                    </a>
                    <a href="${pageContext.request.contextPath}/listings" class="btn-continue">
                        <i class="fas fa-shopping-bag me-2"></i>Continue Shopping
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>