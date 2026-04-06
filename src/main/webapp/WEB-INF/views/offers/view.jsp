<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Offer Details - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .offer-container {
    		max-width: 900px;
    		margin: 50px auto;
    		padding: 0 20px;
    		overflow-y: auto;    /* Ensures scrolling if content overflows */
   			height: auto;        /* No fixed height */
		}
.offer-card {
    background: white;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    overflow: visible;   /* Changed from hidden to visible */
}
.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 25px;
}
@media (max-width: 768px) {
    .info-grid {
        grid-template-columns: 1fr;
    }
    .detail-row {
        flex-direction: column;
    }
}
        
        .offer-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .offer-header h2 {
            margin: 0;
            font-weight: 600;
        }
        
        .offer-body {
            padding: 30px;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 14px;
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
        
        .product-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
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
        
        .info-card .value.asking {
            color: #28a745;
        }
        
        .info-card .value.offer {
            color: #667eea;
        }
        
        .info-card .value.counter {
            color: #17a2b8;
        }
        
        .detail-table {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .detail-row {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            width: 150px;
            color: #666;
            font-weight: 600;
        }
        
        .detail-value {
            flex: 1;
            color: #333;
        }
        
        .message-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .message-box h6 {
            color: #666;
            margin-bottom: 10px;
        }
        
        .message-content {
            background: white;
            border-radius: 8px;
            padding: 15px;
            border-left: 3px solid #667eea;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: center;
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
    
    <div class="offer-container">
        <div class="offer-card">
            <div class="offer-header">
                <h2><i class="fas fa-hand-holding-usd me-2"></i>Offer Details</h2>
                <span class="status-badge status-${fn:toLowerCase(offer.offerStatus)} mt-3">
                    ${offer.offerStatus}
                </span>
            </div>
            
            <div class="offer-body">
                <!-- Product Information -->
                <div class="product-info">
                    <h5 class="mb-3"><i class="fas fa-box me-2"></i>Product Details</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Product:</strong> ${offer.listing.listingName}</p>
                            <p><strong>Category:</strong> ${offer.listing.category.categoryName} > ${offer.listing.subCategory.subCategoryName}</p>
                            <p><strong>Condition:</strong> <span class="badge bg-info">${offer.listing.condition}</span></p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Seller:</strong> ${offer.listing.seller.firstName} ${offer.listing.seller.lastName}</p>
                            <p><strong>Listed Price:</strong> <span class="text-success fw-bold">₹<fmt:formatNumber value="${offer.listing.price}" pattern="#,##0.00"/></span></p>
                            <p><strong>Listed on:</strong>${offer.listing.createdAt}
                        </div>
                    </div>
                </div>
                
                <!-- Price Comparison -->
                <div class="info-grid">
                    <div class="info-card">
                        <h6><i class="fas fa-tag me-2"></i>Asking Price</h6>
                        <div class="value asking">₹<fmt:formatNumber value="${offer.listing.price}" pattern="#,##0.00"/></div>
                    </div>
                    <div class="info-card">
                        <h6><i class="fas fa-hand-holding-usd me-2"></i>Your Offer</h6>
                        <div class="value offer">₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></div>
                    </div>
                    <c:if test="${not empty offer.counterPrice}">
                        <div class="info-card">
                            <h6><i class="fas fa-exchange-alt me-2"></i>Counter Offer</h6>
                            <div class="value counter">₹<fmt:formatNumber value="${offer.counterPrice}" pattern="#,##0.00"/></div>
                        </div>
                    </c:if>
                    <div class="info-card">
                        <h6><i class="far fa-clock me-2"></i>Expires On</h6>
                        <div class="value">${offer.expiryDate}
                    </div>
                </div>
                
                <!-- Detailed Information -->
                <div class="detail-table">
                    <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Offer Information</h6>
                    
                    <div class="detail-row">
                        <span class="detail-label">Offer ID:</span>
                        <span class="detail-value">#${offer.offerId}</span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Buyer:</span>
                        <span class="detail-value">
                            ${offer.buyer.firstName} ${offer.buyer.lastName} (${offer.buyer.email})
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Seller:</span>
                        <span class="detail-value">
                            ${offer.listing.seller.firstName} ${offer.listing.seller.lastName}
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Status:</span>
                        <span class="detail-value">
                            <span class="status-badge status-${fn:toLowerCase(offer.offerStatus)}">
                                ${offer.offerStatus}
                            </span>
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Made On:</span>
                        <span class="detail-value">
                            <i class="far fa-calendar-alt me-2"></i>
                            ${offer.createdAt}
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Last Updated:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty offer.updatedAt}">
                                    ${offer.updatedAt}
                                </c:when>
                                <c:otherwise>
                                    Not updated
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Expiry Date:</span>
                        <span class="detail-value">
                            ${offer.expiryDate}
                            <c:if test="${offer.expiryDate != null and offer.expiryDate < offer.createdAt}">
                                <span class="badge bg-warning ms-2">Expired</span>
                            </c:if>
                        </span>
                    </div>
                </div>
                
                <!-- Message -->
                <c:if test="${not empty offer.message}">
                    <div class="message-box">
                        <h6><i class="fas fa-envelope me-2"></i>Message</h6>
                        <div class="message-content">
                            <p class="mb-0">${offer.message}</p>
                        </div>
                    </div>
                </c:if>
                
                <!-- Action Buttons -->
                <div class="action-buttons mt-4">
                    <c:choose>
                        <c:when test="${isSeller}">
                            <c:if test="${offer.offerStatus == 'PENDING'}">
                                <button class="btn btn-success btn-action" onclick="respondToOffer('accept')">
                                    <i class="fas fa-check me-2"></i>Accept
                                </button>
                                <button class="btn btn-danger btn-action" onclick="respondToOffer('reject')">
                                    <i class="fas fa-times me-2"></i>Reject
                                </button>
                                <button class="btn btn-warning btn-action" onclick="showCounterModal()">
                                    <i class="fas fa-hand-holding-usd me-2"></i>Counter
                                </button>
                            </c:if>
                        </c:when>
                        <c:when test="${isBuyer}">
                            <c:if test="${offer.offerStatus == 'PENDING'}">
                                <button class="btn btn-warning btn-action" onclick="withdrawOffer()">
                                    <i class="fas fa-times-circle me-2"></i>Withdraw
                                </button>
                            </c:if>
                            <!-- ADD PAY NOW BUTTON FOR ACCEPTED OFFER -->
                            <c:if test="${offer.offerStatus == 'ACCEPTED'}">
                                <a href="${pageContext.request.contextPath}/transactions/buy/${offer.listing.listingId}?offerId=${offer.offerId}" 
                                   class="btn btn-success btn-action">
                                    <i class="fas fa-credit-card me-2"></i>Pay Now
                                </a>
                            </c:if>
                        </c:when>
                    </c:choose>
                    
                    <c:choose>
                        <c:when test="${isSeller}">
                            <a href="${pageContext.request.contextPath}/offers/received" class="btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Back to Offers
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/offers/my-offers" class="btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Back to My Offers
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Response Forms -->
    <form id="responseForm" method="post" style="display: none;">
        <input type="hidden" name="action" id="responseAction">
    </form>
    
    <!-- Counter Offer Modal -->
    <div class="modal fade" id="counterModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Make Counter Offer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/offers/respond/${offer.offerId}">
                    <input type="hidden" name="action" value="counter">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Counter Price</label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <input type="number" class="form-control" name="counterPrice" step="0.01" min="1" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Message (Optional)</label>
                            <textarea class="form-control" name="message" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Send Counter Offer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function respondToOffer(action) {
            if (action === 'accept' && !confirm('Are you sure you want to accept this offer?')) {
                return;
            }
            if (action === 'reject' && !confirm('Are you sure you want to reject this offer?')) {
                return;
            }
            
            var form = document.getElementById('responseForm');
            form.action = '${pageContext.request.contextPath}/offers/respond/${offer.offerId}';
            document.getElementById('responseAction').value = action;
            form.submit();
        }
        
        function showCounterModal() {
            var modal = new bootstrap.Modal(document.getElementById('counterModal'));
            modal.show();
        }
        
        function withdrawOffer() {
            if (confirm('Are you sure you want to withdraw this offer?')) {
                var form = document.getElementById('responseForm');
                form.action = '${pageContext.request.contextPath}/offers/withdraw/${offer.offerId}';
                document.getElementById('responseAction').value = 'withdraw';
                form.submit();
            }
        }
    </script>
</body>
</html>