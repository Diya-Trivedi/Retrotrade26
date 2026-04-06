<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make an Offer - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 40px 0;
        }
        
        .navbar {
            background: var(--primary-gradient);
            box-shadow: 0 2px 10px rgba(102, 126, 234, 0.3);
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
        }
        
        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 700;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255,255,255,0.9) !important;
            font-weight: 500;
        }
        
        .offer-container {
            max-width: 900px;
            margin: 80px auto 0;
            padding: 20px;
            width: 100%;
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .card-header {
            background: var(--primary-gradient);
            color: white;
            padding: 25px 30px;
            border-bottom: none;
        }
        
        .card-header h3 {
            margin: 0;
            font-weight: 600;
        }
        
        .card-header p {
            margin: 10px 0 0;
            opacity: 0.9;
            font-size: 14px;
        }
        
        .card-body {
            padding: 40px;
            background: white;
        }
        
        .listing-summary {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            border-left: 4px solid #667eea;
        }
        
        .listing-image {
            width: 100px;
            height: 100px;
            border-radius: 10px;
            overflow: hidden;
            flex-shrink: 0;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .listing-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .listing-info {
            flex: 1;
        }
        
        .listing-info h4 {
            margin: 0 0 10px;
            font-weight: 600;
            color: #333;
        }
        
        .listing-info .price {
            font-size: 24px;
            font-weight: 700;
            color: #667eea;
            margin: 0;
        }
        
        .listing-info .price i {
            font-size: 20px;
        }
        
        .listing-meta {
            margin-top: 10px;
            color: #6c757d;
            font-size: 14px;
        }
        
        .listing-meta i {
            margin-right: 5px;
            color: #667eea;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .form-label .text-danger {
            color: #dc3545;
        }
        
        .form-control {
            border-radius: 30px;
            padding: 12px 20px;
            border: 2px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25);
        }
        
        textarea.form-control {
            border-radius: 15px;
            resize: vertical;
            min-height: 100px;
        }
        
        .input-group-text {
            border-radius: 30px 0 0 30px;
            border: 2px solid #e0e0e0;
            border-right: none;
            background: white;
            color: #667eea;
            font-weight: 600;
        }
        
        .input-group .form-control {
            border-radius: 0 30px 30px 0;
        }
        
        .price-hint {
            background: rgba(102,126,234,0.1);
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            font-size: 14px;
        }
        
        .price-hint i {
            color: #667eea;
            margin-right: 10px;
        }
        
        .btn-submit {
            background: var(--primary-gradient);
            color: white;
            border: none;
            border-radius: 30px;
            padding: 14px 30px;
            font-weight: 600;
            font-size: 18px;
            width: 100%;
            transition: all 0.3s;
            margin-top: 20px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102,126,234,0.4);
        }
        
        .btn-submit i {
            margin-right: 10px;
        }
        
        .btn-cancel {
            border-radius: 30px;
            padding: 12px 30px;
            border: 2px solid #e0e0e0;
            color: #333;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-cancel:hover {
            background: #f8f9fa;
            color: #dc3545;
            border-color: #dc3545;
        }
        
        .alert {
            border-radius: 30px;
            padding: 15px 20px;
            margin-bottom: 25px;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }
        
        .progress-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
        }
        
        .progress-steps:before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 2px;
            background: #e0e0e0;
            z-index: 1;
        }
        
        .step {
            position: relative;
            z-index: 2;
            background: white;
            padding: 0 10px;
            text-align: center;
            flex: 1;
        }
        
        .step-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 2px solid #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            font-weight: 600;
        }
        
        .step.active .step-icon {
            background: var(--primary-gradient);
            border-color: transparent;
            color: white;
        }
        
        .step.completed .step-icon {
            background: #28a745;
            border-color: #28a745;
            color: white;
        }
        
        .step-label {
            font-size: 12px;
            color: #6c757d;
        }
        
        .step.active .step-label {
            color: #667eea;
            font-weight: 600;
        }
        
        .info-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .info-text i {
            color: #667eea;
        }
        
        /* Mobile Responsive Styles */
        @media (max-width: 768px) {
            body {
                padding: 20px 0;
            }
            
            .offer-container {
                margin-top: 60px;
                padding: 10px;
            }
            
            .card-header {
                padding: 20px;
            }
            
            .card-header h3 {
                font-size: 1.5rem;
            }
            
            .card-body {
                padding: 20px;
            }
            
            .listing-summary {
                flex-direction: column;
                text-align: center;
                gap: 15px;
                padding: 15px;
            }
            
            .listing-image {
                width: 120px;
                height: 120px;
                margin: 0 auto;
            }
            
            .listing-info h4 {
                font-size: 1.2rem;
            }
            
            .listing-info .price {
                font-size: 1.5rem;
            }
            
            .listing-meta {
                display: flex;
                flex-direction: column;
                gap: 5px;
                align-items: center;
            }
            
            .progress-steps {
                margin-bottom: 20px;
            }
            
            .step-label {
                font-size: 10px;
            }
            
            .step-icon {
                width: 30px;
                height: 30px;
                font-size: 14px;
            }
            
            .progress-steps:before {
                top: 15px;
            }
            
            .form-control {
                padding: 10px 15px;
            }
            
            textarea.form-control {
                min-height: 80px;
            }
            
            .price-hint {
                padding: 12px;
                font-size: 13px;
            }
            
            .btn-submit, .btn-cancel {
                padding: 10px 20px;
                font-size: 16px;
            }
            
            .d-flex.gap-3 {
                flex-direction: column;
                gap: 10px !important;
            }
            
            .btn-cancel {
                width: 100%;
            }
            
            /* Help section responsive */
            .row.mt-3 {
                flex-direction: column;
                gap: 20px;
            }
            
            .col-md-4 {
                width: 100%;
            }
            
            .col-md-4 .text-center {
                border-bottom: 1px solid #eee;
                padding-bottom: 15px;
            }
            
            .col-md-4:last-child .text-center {
                border-bottom: none;
                padding-bottom: 0;
            }
        }

        /* Small mobile devices */
        @media (max-width: 480px) {
            .card-header h3 {
                font-size: 1.2rem;
            }
            
            .card-header p {
                font-size: 12px;
            }
            
            .listing-info h4 {
                font-size: 1.1rem;
            }
            
            .listing-info .price {
                font-size: 1.3rem;
            }
            
            .listing-image {
                width: 100px;
                height: 100px;
            }
            
            .step-label {
                font-size: 9px;
            }
            
            .step-icon {
                width: 25px;
                height: 25px;
                font-size: 12px;
            }
            
            .progress-steps:before {
                top: 12px;
            }
            
            .form-label {
                font-size: 14px;
            }
            
            .info-text {
                font-size: 11px;
            }
            
            .price-hint {
                font-size: 12px;
            }
            
            .btn-submit, .btn-cancel {
                font-size: 14px;
                padding: 8px 15px;
            }
        }

        /* Tablet devices */
        @media (min-width: 769px) and (max-width: 992px) {
            .offer-container {
                max-width: 700px;
            }
            
            .card-body {
                padding: 30px;
            }
            
            .listing-summary {
                padding: 15px;
            }
            
            .listing-image {
                width: 80px;
                height: 80px;
            }
            
            .listing-info h4 {
                font-size: 1.1rem;
            }
            
            .listing-info .price {
                font-size: 1.3rem;
            }
        }

        /* Landscape orientation on mobile */
        @media (max-height: 600px) and (orientation: landscape) {
            body {
                padding: 60px 0 20px;
            }
            
            .offer-container {
                margin-top: 20px;
            }
            
            .listing-summary {
                padding: 10px;
            }
            
            .listing-image {
                width: 70px;
                height: 70px;
            }
            
            .listing-info h4 {
                margin-bottom: 5px;
            }
            
            .listing-meta {
                margin-top: 5px;
            }
            
            textarea.form-control {
                min-height: 60px;
            }
        }

        /* Footer styles */
        .footer {
            background: white;
            color: #333;
            padding: 30px 0;
            margin-top: 50px;
        }

        /* Ensure proper spacing for fixed navbar */
        .navbar {
            padding: 10px 20px;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
        }
        
        @media (max-width: 768px) {
            .navbar-brand {
                font-size: 1.2rem;
            }
            
            .navbar {
                padding: 8px 15px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="offer-container">
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-tag"></i> Make an Offer</h3>
                <p>Submit your best price for this item</p>
            </div>
            
            <div class="card-body">
                <!-- Progress Steps -->
                <div class="progress-steps">
                    <div class="step active">
                        <div class="step-icon">1</div>
                        <div class="step-label">Make Offer</div>
                    </div>
                    <div class="step">
                        <div class="step-icon">2</div>
                        <div class="step-label">Seller Responds</div>
                    </div>
                    <div class="step">
                        <div class="step-icon">3</div>
                        <div class="step-label">Complete Purchase</div>
                    </div>
                </div>
                
                <!-- Alert Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle me-2"></i> ${error}
                    </div>
                </c:if>
                
                <!-- Listing Summary -->
                <div class="listing-summary">
                    <div class="listing-image">
                        <c:choose>
                            <c:when test="${not empty listing.images}">
                                <img src="${listing.images[0].imageUrl}" alt="${listing.listingName}">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/100" alt="No image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="listing-info">
                        <h4>${listing.listingName}</h4>
                        <p class="price">
                            <i class="fas fa-rupee-sign"></i> <fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/>
                        </p>
                        <div class="listing-meta">
                            <span><i class="fas fa-user"></i> ${listing.seller.firstName} ${listing.seller.lastName}</span>
                            <span><i class="fas fa-map-marker-alt"></i> ${listing.location}</span>
                            <span><i class="fas fa-tag"></i> ${listing.condition}</span>
                        </div>
                    </div>
                </div>
                
                <!-- Offer Form -->
                <form action="${pageContext.request.contextPath}/offers/make" method="post" id="offerForm">
                    <input type="hidden" name="listingId" value="${listing.listingId}">
                    
                    <div class="mb-4">
                        <label class="form-label">Your Offer Price <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-rupee-sign"></i></span>
                            <input type="number" 
                                   name="offeredPrice" 
                                   id="offeredPrice"
                                   class="form-control" 
                                   step="0.01" 
                                   min="0.01" 
                                   max="${listing.price}"
                                   required 
                                   placeholder="Enter your offer amount">
                        </div>
                        <small class="info-text">
                            <i class="fas fa-info-circle"></i> 
                            Listing price: <i class="fas fa-rupee-sign"></i> <fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/>
                            (Minimum allowed: <i class="fas fa-rupee-sign"></i> <fmt:formatNumber value="${listing.price * 0.1}" pattern="#,##0.00"/>)
                        </small>
                    </div>
                    
                    <div class="price-hint">
                        <i class="fas fa-lightbulb"></i>
                        <strong>Pro Tip:</strong> Consider offering between 70-90% of the listing price for better chances of acceptance. 
                        The seller can accept, reject, or counter your offer.
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">Message to Seller (Optional)</label>
                        <textarea name="message" 
                                  class="form-control" 
                                  rows="4" 
                                  placeholder="Add a personal message to the seller... (e.g., reason for offer, questions about the item)"></textarea>
                    </div>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-clock"></i>
                        <strong>Note:</strong> Your offer will expire in 7 days. The seller will be notified immediately.
                    </div>
                    
                    <div class="d-flex gap-3">
                        <a href="${pageContext.request.contextPath}/listings/${listing.listingId}" class="btn-cancel flex-grow-1">
                            <i class="fas fa-times-circle"></i> Cancel
                        </a>
                        <button type="submit" class="btn-submit flex-grow-1">
                            <i class="fas fa-paper-plane"></i> Submit Offer
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Help Section -->
        <div class="card mt-4">
            <div class="card-body">
                <h6><i class="fas fa-question-circle"></i> How Offers Work</h6>
                <div class="row mt-3">
                    <div class="col-md-4">
                        <div class="text-center">
                            <i class="fas fa-paper-plane text-primary" style="font-size: 30px;"></i>
                            <h6 class="mt-2">1. Submit Offer</h6>
                            <small class="text-muted">Enter your best price and message</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center">
                            <i class="fas fa-hourglass-half text-warning" style="font-size: 30px;"></i>
                            <h6 class="mt-2">2. Wait for Response</h6>
                            <small class="text-muted">Seller responds within 7 days</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-center">
                            <i class="fas fa-check-circle text-success" style="font-size: 30px;"></i>
                            <h6 class="mt-2">3. Complete Purchase</h6>
                            <small class="text-muted">If accepted, proceed to payment</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            const listingPrice = ${listing.price};
            const minPrice = listingPrice * 0.1;
            
            $('#offeredPrice').on('input', function() {
                let value = parseFloat($(this).val());
                
                if (value > listingPrice) {
                    $(this).val(listingPrice);
                } else if (value < minPrice && value > 0) {
                    $(this).val(minPrice);
                }
            });
            
            $('#offerForm').on('submit', function(e) {
                let price = parseFloat($('#offeredPrice').val());
                
                if (isNaN(price) || price <= 0) {
                    e.preventDefault();
                    alert('Please enter a valid offer price!');
                } else if (price < minPrice) {
                    e.preventDefault();
                    alert('Offer price cannot be less than 10% of listing price!');
                } else if (price > listingPrice) {
                    e.preventDefault();
                    alert('Offer price cannot exceed the listing price!');
                }
            });
        });
    </script>
</body>
</html>