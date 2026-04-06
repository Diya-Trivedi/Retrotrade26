<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .checkout-container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 0 20px;
        }
        
        .checkout-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .checkout-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .checkout-header h2 {
            margin: 0;
            font-weight: 600;
        }
        
        .checkout-body {
            padding: 30px;
        }
        
        .product-summary {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }
        
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
        }
        
        .price-breakdown {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .price-row.total {
            border-bottom: none;
            font-size: 18px;
            font-weight: 700;
            color: #667eea;
        }
        
        .payment-methods {
            margin-bottom: 25px;
        }
        
        .payment-option {
            border: 2px solid #dee2e6;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .payment-option:hover {
            border-color: #667eea;
        }
        
        .payment-option.selected {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .payment-option input[type="radio"] {
            margin-right: 10px;
        }
        
        .card-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 15px;
            display: none;
        }
        
        .address-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            border: 2px solid transparent;
            cursor: pointer;
        }
        
        .address-card.selected {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .address-card .default-badge {
            background: #667eea;
            color: white;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 11px;
            margin-left: 10px;
        }
        
        .btn-place-order {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 18px;
            font-weight: 600;
            padding: 15px;
            width: 100%;
            cursor: pointer;
            transition: transform 0.3s;
        }
        
        .btn-place-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }
        
        .secure-badge {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .secure-badge i {
            color: #28a745;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="checkout-container">
        <div class="checkout-card">
            <div class="checkout-header">
                <h2><i class="fas fa-lock me-2"></i>Secure Checkout</h2>
            </div>
            
            <div class="checkout-body">
                <!-- Display error message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <div class="row">
                    <div class="col-md-7">
                        <h5 class="mb-3">1. Delivery Address</h5>
                        <div class="mb-4">
                            <c:choose>
                                <c:when test="${not empty defaultAddress}">
                                    <div class="address-card selected" onclick="selectAddress(${defaultAddress.addressId})">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <strong>${defaultAddress.fullName}</strong>
                                                <span class="default-badge">Default</span>
                                            </div>
                                        </div>
                                        <p class="mb-1">${defaultAddress.addressLine1}</p>
                                        <p class="mb-1">${defaultAddress.city}, ${defaultAddress.state} - ${defaultAddress.pincode}</p>
                                        <p class="mb-0">Phone: ${defaultAddress.mobileNo}</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        No address found. <a href="${pageContext.request.contextPath}/address/add">Add a new address</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <a href="${pageContext.request.contextPath}/address/list" class="btn btn-outline-primary btn-sm mt-2">
                                <i class="fas fa-plus me-1"></i>Add New Address
                            </a>
                        </div>
                        
                        <h5 class="mb-3">2. Payment Method</h5>
                        <div class="payment-methods">
                            <div class="payment-option selected" onclick="selectPayment('CARD')">
                                <input type="radio" name="paymentMode" value="CARD" checked> 
                                <i class="fas fa-credit-card me-2 text-primary"></i>
                                Credit / Debit Card
                            </div>
                            
                            <div id="cardDetails" class="card-details" style="display: block;">
                                <div class="row">
                                    <div class="col-12 mb-3">
                                        <label class="form-label">Card Number</label>
                                        <input type="text" class="form-control" id="cardNumber" placeholder="1234 5678 9012 3456">
                                    </div>
                                    <div class="col-12 mb-3">
                                        <label class="form-label">Cardholder Name</label>
                                        <input type="text" class="form-control" id="cardName" placeholder="John Doe">
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Expiry Date</label>
                                        <input type="text" class="form-control" id="cardExpiry" placeholder="MM/YY">
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label">CVV</label>
                                        <input type="password" class="form-control" id="cardCvv" placeholder="123">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="payment-option" onclick="selectPayment('UPI')">
                                <input type="radio" name="paymentMode" value="UPI"> 
                                <i class="fas fa-mobile-alt me-2 text-success"></i>
                                UPI
                            </div>
                            
                            <div class="payment-option" onclick="selectPayment('NET_BANKING')">
                                <input type="radio" name="paymentMode" value="NET_BANKING"> 
                                <i class="fas fa-university me-2 text-info"></i>
                                Net Banking
                            </div>
                            
                            <div class="payment-option" onclick="selectPayment('WALLET')">
                                <input type="radio" name="paymentMode" value="WALLET"> 
                                <i class="fas fa-wallet me-2 text-warning"></i>
                                Wallet
                            </div>
                            
                            <div class="payment-option" onclick="selectPayment('CASH')">
                                <input type="radio" name="paymentMode" value="CASH"> 
                                <i class="fas fa-money-bill-wave me-2 text-success"></i>
                                Cash on Delivery
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-5">
                        <div class="product-summary">
                            <h5 class="mb-3">Order Summary</h5>
                            <div class="d-flex mb-3">
                                <c:choose>
                                    <c:when test="${not empty listing.images and not empty listing.images[0]}">
                                        <img src="${listing.images[0].imageUrl}" class="product-image me-3" alt="${listing.listingName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/80" class="product-image me-3" alt="Product">
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <h6>${listing.listingName}</h6>
                                    <p class="text-muted mb-1">Condition: ${listing.condition}</p>
                                    <p class="text-muted mb-0">Seller: ${listing.seller.firstName}</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="price-breakdown">
                            <h5 class="mb-3">Price Details</h5>
                            <div class="price-row">
                                <span>Price (1 item)</span>
                                <span>₹<fmt:formatNumber value="${price}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="price-row">
                                <span>Delivery Charges</span>
                                <span class="text-success">Free</span>
                            </div>
                            <div class="price-row">
                                <span>Platform Fee</span>
                                <span>₹<fmt:formatNumber value="${price * 0.05}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="price-row total">
                                <span>Total Amount</span>
                                <span class="text-primary">₹<fmt:formatNumber value="${price + (price * 0.05)}" pattern="#,##0.00"/></span>
                            </div>
                        </div>
                        
                        <form id="checkoutForm" action="${pageContext.request.contextPath}/transactions/process" method="post">
                            <input type="hidden" name="listingId" value="${listing.listingId}">
                            <c:if test="${not empty acceptedOffer}">
                                <input type="hidden" name="offerId" value="${acceptedOffer.offerId}">
                            </c:if>
                            <input type="hidden" name="finalPrice" value="${price}">
                            <input type="hidden" name="paymentMode" id="selectedPaymentMode" value="CARD">
                            <input type="hidden" name="shippingAddress" id="shippingAddress" value="${defaultAddress.addressLine1}, ${defaultAddress.city}, ${defaultAddress.state} - ${defaultAddress.pincode}">
                            <input type="hidden" name="cardNumber" id="hiddenCardNumber">
                            <input type="hidden" name="cardName" id="hiddenCardName">
                            <input type="hidden" name="cardExpiry" id="hiddenCardExpiry">
                            <input type="hidden" name="cardCvv" id="hiddenCardCvv">
                            
                            <button type="submit" class="btn-place-order" onclick="return validateForm()">
                                <i class="fas fa-lock me-2"></i>Place Order
                            </button>
                        </form>
                        
                        <div class="secure-badge">
                            <i class="fas fa-shield-alt"></i>
                            Secure checkout powered by Retrotrade
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectPayment(method) {
            document.querySelectorAll('.payment-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');
            
            var radio = event.currentTarget.querySelector('input[type="radio"]');
            radio.checked = true;
            document.getElementById('selectedPaymentMode').value = method;
            
            // Show/hide card details
            if (method === 'CARD') {
                document.getElementById('cardDetails').style.display = 'block';
            } else {
                document.getElementById('cardDetails').style.display = 'none';
            }
        }
        
        function selectAddress(addressId) {
            document.querySelectorAll('.address-card').forEach(addr => {
                addr.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');
            
            // Update shipping address hidden field
            var addressText = event.currentTarget.innerText.trim();
            document.getElementById('shippingAddress').value = addressText;
        }
        
        function validateForm() {
            var paymentMode = document.getElementById('selectedPaymentMode').value;
            
            if (paymentMode === 'CARD') {
                var cardNumber = document.getElementById('cardNumber').value;
                var cardName = document.getElementById('cardName').value;
                var cardExpiry = document.getElementById('cardExpiry').value;
                var cardCvv = document.getElementById('cardCvv').value;
                
                if (!cardNumber || !cardName || !cardExpiry || !cardCvv) {
                    alert('Please fill in all card details');
                    return false;
                }
                
                // Set hidden fields
                document.getElementById('hiddenCardNumber').value = cardNumber;
                document.getElementById('hiddenCardName').value = cardName;
                document.getElementById('hiddenCardExpiry').value = cardExpiry;
                document.getElementById('hiddenCardCvv').value = cardCvv;
            }
            
            return confirm('Confirm order? This action cannot be undone.');
        }
    </script>
</body>
</html>