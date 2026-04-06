<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale-1.0">
    <title>Received Offers - Retrotrade</title>
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
            margin-bottom: 30px;
        }
        
        .page-header h2 {
            color: #333;
            font-weight: 600;
        }
        
        .listing-group {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .listing-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .listing-header h5 {
            margin: 0;
        }
        
        .listing-header .badge {
            background: rgba(255,255,255,0.2);
            color: white;
            font-size: 14px;
            padding: 5px 10px;
        }
        
        .offers-list {
            padding: 20px;
        }
        
        .offer-card {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }
        
        .offer-card:hover {
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .offer-card.pending {
            border-left: 4px solid #ffc107;
        }
        
        .offer-card.accepted {
            border-left: 4px solid #28a745;
        }
        
        .offer-card.rejected {
            border-left: 4px solid #dc3545;
        }
        
        .buyer-info {
            display: flex;
            align-items: center;
        }
        
        .buyer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
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
        
        .price-comparison {
            display: flex;
            gap: 20px;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }
        
        .price-item {
            flex: 1;
            text-align: center;
        }
        
        .price-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .price-value {
            font-size: 18px;
            font-weight: 700;
        }
        
        .price-value.asking {
            color: #28a745;
        }
        
        .price-value.offer {
            color: #667eea;
        }
        
        .price-value.counter {
            color: #17a2b8;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 8px 20px;
            border-radius: 5px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
        }
        
        .empty-state {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-state i {
            font-size: 60px;
            color: #ddd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="offers-container">
        <div class="page-header">
            <h2><i class="fas fa-inbox me-2"></i>Received Offers</h2>
            <p class="text-muted">Offers from buyers on your listings</p>
        </div>
        
        <c:choose>
            <c:when test="${empty offers}">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h4>No Offers Received</h4>
                    <p class="text-muted">You haven't received any offers yet.</p>
                    <a href="${pageContext.request.contextPath}/listings/my-listings" class="btn btn-primary">
                        <i class="fas fa-box me-2"></i>View My Listings
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Group offers by listing -->
                <c:forEach var="offer" items="${offers}" varStatus="status">
                    <c:if test="${status.first or offer.listing.listingId != previousListingId}">
                        <c:set var="previousListingId" value="${offer.listing.listingId}"/>
                        <div class="listing-group">
                            <div class="listing-header" onclick="toggleOffers(${offer.listing.listingId})">
                                <div>
                                    <h5><i class="fas fa-box me-2"></i>${offer.listing.listingName}</h5>
                                    <small>Asking: ₹<fmt:formatNumber value="${offer.listing.price}" pattern="#,##0.00"/></small>
                                </div>
                                <span class="badge" id="badge-${offer.listing.listingId}">Show Offers</span>
                            </div>
                            <div class="offers-list" id="offers-${offer.listing.listingId}" style="display: none;">
                    </c:if>
                    
                    <div class="offer-card ${fn:toLowerCase(offer.offerStatus)}">
                        <div class="row align-items-center">
                            <div class="col-md-3">
                                <div class="buyer-info">
                                    <c:choose>
                                        <c:when test="${not empty offer.buyer.profilePicURL}">
                                            <img src="${offer.buyer.profilePicURL}" class="buyer-avatar" alt="${offer.buyer.firstName}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="buyer-avatar bg-secondary d-flex align-items-center justify-content-center">
                                                <i class="fas fa-user text-white"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <strong>${offer.buyer.firstName} ${offer.buyer.lastName}</strong>
                                        <br><small class="text-muted">${offer.buyer.email}</small>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-3">
                                <span class="status-badge status-${fn:toLowerCase(offer.offerStatus)}">
                                    ${offer.offerStatus}
                                </span>
                                <br>
                                <small class="text-muted">
                                    <i class="far fa-clock me-1"></i>
                                    ${offer.createdAt}
                                </small>
                            </div>
                            
                            <div class="col-md-3">
                                <div class="price-comparison">
                                    <div class="price-item">
                                        <div class="price-label">Offered</div>
                                        <div class="price-value offer">₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></div>
                                    </div>
                                    <c:if test="${offer.offerStatus == 'COUNTERED' and not empty offer.counterPrice}">
                                        <div class="price-item">
                                            <div class="price-label">Counter</div>
                                            <div class="price-value counter">₹<fmt:formatNumber value="${offer.counterPrice}" pattern="#,##0.00"/></div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="col-md-3">
                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/offers/view/${offer.offerId}" 
                                       class="btn btn-sm btn-info btn-action">
                                        <i class="fas fa-eye me-1"></i>View
                                    </a>
                                    <c:if test="${offer.offerStatus == 'PENDING'}">
                                        <button class="btn btn-sm btn-success btn-action" 
                                                onclick="respondToOffer(${offer.offerId}, 'accept')">
                                            <i class="fas fa-check me-1"></i>Accept
                                        </button>
                                        <button class="btn btn-sm btn-danger btn-action" 
                                                onclick="respondToOffer(${offer.offerId}, 'reject')">
                                            <i class="fas fa-times me-1"></i>Reject
                                        </button>
                                        <button class="btn btn-sm btn-warning btn-action" 
                                                onclick="showCounterModal(${offer.offerId})">
                                            <i class="fas fa-hand-holding-usd me-1"></i>Counter
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty offer.message}">
                            <div class="mt-2 p-2 bg-light rounded">
                                <small><i class="fas fa-quote-left text-muted me-1"></i>${offer.message}</small>
                            </div>
                        </c:if>
                    </div>
                    
                    <c:if test="${status.last or offers[status.index+1].listing.listingId != previousListingId}">
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Counter Offer Modal -->
    <div class="modal fade" id="counterModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Make Counter Offer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="counterForm" method="post">
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
        function toggleOffers(listingId) {
            var offersDiv = document.getElementById('offers-' + listingId);
            var badge = document.getElementById('badge-' + listingId);
            
            if (offersDiv.style.display === 'none') {
                offersDiv.style.display = 'block';
                badge.textContent = 'Hide Offers';
            } else {
                offersDiv.style.display = 'none';
                badge.textContent = 'Show Offers';
            }
        }
        
        function respondToOffer(offerId, action) {
            var form = document.createElement('form');
            form.method = 'post';
            form.action = '${pageContext.request.contextPath}/offers/respond/' + offerId;
            
            var actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = action;
            
            form.appendChild(actionInput);
            document.body.appendChild(form);
            form.submit();
        }
        
        function showCounterModal(offerId) {
            var form = document.getElementById('counterForm');
            form.action = '${pageContext.request.contextPath}/offers/respond/' + offerId;
            
            var actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'counter';
            form.appendChild(actionInput);
            
            var modal = new bootstrap.Modal(document.getElementById('counterModal'));
            modal.show();
        }
    </script>
</body>
</html>