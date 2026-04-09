<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* ... existing styles ... (keep as is) */
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .hero-section {
            background: var(--primary-gradient);
            color: white;
            padding: 80px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%23ffffff" fill-opacity="0.1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
            opacity: 0.1;
        }
        
        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            position: relative;
        }
        
        .hero-section p {
            font-size: 1.2rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }
        
        .features-section {
            padding: 60px 0;
        }
        
        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s;
            height: 100%;
            border-bottom: 3px solid transparent;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            border-bottom-color: #667eea;
            box-shadow: 0 10px 30px rgba(102,126,234,0.2);
        }
        
        .feature-icon {
            width: 80px;
            height: 80px;
            line-height: 80px;
            border-radius: 50%;
            background: var(--primary-gradient);
            color: white;
            font-size: 2rem;
            margin: 0 auto 20px;
        }
        
        <c:if test="${not empty sessionScope.user}">
        .welcome-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            border-left: 5px solid #667eea;
        }
        </c:if>
        
        .section-title {
            position: relative;
            margin-bottom: 40px;
            text-align: center;
        }
        
        .section-title h2 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #333;
            display: inline-block;
            padding-bottom: 10px;
            border-bottom: 3px solid #667eea;
        }
        
        <c:if test="${not empty sessionScope.user}">
        .quick-links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .quick-link-card {
            background: white;
            border-radius: 15px;
            padding: 25px 20px;
            text-align: center;
            text-decoration: none;
            color: #333;
            box-shadow: 0 3px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .quick-link-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
            transform: scaleX(0);
            transition: transform 0.3s;
        }
        
        .quick-link-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(102,126,234,0.3);
        }
        
        .quick-link-card:hover::before {
            transform: scaleX(1);
        }
        
        .quick-link-card i {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: #667eea;
        }
        
        .quick-link-card h6 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .quick-link-card small {
            font-size: 0.8rem;
            color: #666;
        }
        </c:if>
        
        .category-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }
        
        .category-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }
        
        .category-item:hover {
            background: var(--primary-gradient);
            color: white;
            transform: translateY(-3px);
        }
        
        .category-item i {
            font-size: 1.5rem;
            margin-bottom: 8px;
            color: #667eea;
        }
        
        .category-item:hover i {
            color: white;
        }
        
        .featured-listings {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .listing-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 3px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .listing-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(102,126,234,0.3);
        }
        
        .listing-image {
            height: 180px;
            background-size: cover;
            background-position: center;
            position: relative;
        }
        
        .listing-condition {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255,255,255,0.9);
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            color: #667eea;
        }
        
        .listing-details {
            padding: 15px;
        }
        
        .listing-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #333;
        }
        
        .listing-price {
            font-size: 18px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .listing-meta {
            display: flex;
            justify-content: space-between;
            color: #666;
            font-size: 12px;
        }
        
        .action-buttons {
            margin-top: 12px;
            display: flex;
            gap: 10px;
            justify-content: space-between;
        }
        
        .btn-sm-custom {
            padding: 5px 12px;
            font-size: 12px;
            border-radius: 20px;
        }
        
        .btn-cart:hover {
            background: #218838;
        }
        
        .btn-wishlist {
            background: transparent;
            border: 1px solid #dc3545;
            color: #dc3545;
        }
        
        .btn-wishlist:hover {
            background: #dc3545;
            color: white;
        }
        
        .stats-section {
            background: var(--primary-gradient);
            padding: 50px 0;
            color: white;
            margin-bottom: 40px;
            border-radius: 15px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            text-align: center;
        }
        
        .stat-item h3 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stat-item p {
            font-size: 1rem;
            opacity: 0.9;
            margin: 0;
        }
        
        .auth-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn-login {
            background: white;
            color: #667eea;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.3s;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(255,255,255,0.3);
            color: #667eea;
        }
        
        .btn-signup {
            background: transparent;
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            border: 2px solid white;
            transition: transform 0.3s;
        }
        
        .btn-signup:hover {
            transform: translateY(-2px);
            background: white;
            color: #667eea;
        }
        
        @media (max-width: 768px) {
            .hero-section h1 {
                font-size: 2.5rem;
            }
            <c:if test="${not empty sessionScope.user}">
            .quick-links-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            </c:if>
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <h1><i class="fas fa-store me-3"></i>Welcome to Retrotrade</h1>
            <p>Your trusted second-hand marketplace for quality pre-owned items</p>
            
            <c:if test="${empty sessionScope.user}">
                <div class="auth-buttons">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">
                        <i class="fas fa-sign-in-alt me-2"></i>Login
                    </a>
                    <a href="${pageContext.request.contextPath}/signup" class="btn-signup">
                        <i class="fas fa-user-plus me-2"></i>Sign Up
                    </a>
                </div>
            </c:if>
        </div>
    </div>
    
    <div class="container mt-5">
        <!-- Welcome Card for Logged-in Users -->
        <c:if test="${not empty sessionScope.user}">
            <div class="welcome-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3>Welcome back, ${sessionScope.user.firstName}!</h3>
                        <p class="text-muted">Explore our marketplace and find great deals. Your next treasure is just a click away.</p>
                    </div>
                    <div class="col-md-4 text-md-end">
                        <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Browse Products
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Quick Links Section - All User Entities -->
            <div class="section-title">
                <h2>Quick Actions</h2>
            </div>
            
            <div class="quick-links-grid">
                <!-- Browse Products -->
                <a href="${pageContext.request.contextPath}/listings" class="quick-link-card">
                    <i class="fas fa-search"></i>
                    <h6>Browse Products</h6>
                    <small>Explore listings</small>
                </a>
                
                <!-- Wishlist -->
                <a href="${pageContext.request.contextPath}/wishlist" class="quick-link-card">
                    <i class="fas fa-heart"></i>
                    <h6>Wishlist</h6>
                    <small>Saved items</small>
                </a>
                
                <!-- My Listings (Seller) -->
                <a href="${pageContext.request.contextPath}/listings/my-listings" class="quick-link-card">
                    <i class="fas fa-box"></i>
                    <h6>My Listings</h6>
                    <small>Manage your products</small>
                </a>
                
                <!-- My Offers (Buyer) -->
                <a href="${pageContext.request.contextPath}/offers/my-offers" class="quick-link-card">
                    <i class="fas fa-hand-holding-usd"></i>
                    <h6>My Offers</h6>
                    <small>Offers you made</small>
                </a>
                
                <!-- Received Offers (Seller) -->
                <a href="${pageContext.request.contextPath}/offers/received" class="quick-link-card">
                    <i class="fas fa-inbox"></i>
                    <h6>Received Offers</h6>
                    <small>Offers on your items</small>
                </a>
                
                <!-- My Addresses -->
                <a href="${pageContext.request.contextPath}/address/list" class="quick-link-card">
                    <i class="fas fa-map-marker-alt"></i>
                    <h6>My Addresses</h6>
                    <small>Manage delivery locations</small>
                </a>
                
                <!-- My Profile -->
                <a href="${pageContext.request.contextPath}/profile" class="quick-link-card">
                    <i class="fas fa-user"></i>
                    <h6>My Profile</h6>
                    <small>View & edit profile</small>
                </a>
                
                <!-- Seller Dashboard -->
                <a href="${pageContext.request.contextPath}/listings/seller/dashboard" class="quick-link-card">
                    <i class="fas fa-chart-line"></i>
                    <h6>Seller Dashboard</h6>
                    <small>Track your sales</small>
                </a>
                
                <!-- My Purchases -->
                <a href="${pageContext.request.contextPath}/transactions/my-purchases" class="quick-link-card">
                    <i class="fas fa-shopping-bag"></i>
                    <h6>My Purchases</h6>
                    <small>Your orders</small>
                </a>
                
                <!-- My Sales (Seller) -->
                <a href="${pageContext.request.contextPath}/transactions/my-sales" class="quick-link-card">
                    <i class="fas fa-dollar-sign"></i>
                    <h6>My Sales</h6>
                    <small>Items sold</small>
                </a>
                
                <!-- My Reviews -->
                <a href="${pageContext.request.contextPath}/reviews/my-reviews" class="quick-link-card">
                    <i class="fas fa-star"></i>
                    <h6>My Reviews</h6>
                    <small>Reviews you've written</small>
                </a>
                
                <!-- Report an Issue -->
                <a href="${pageContext.request.contextPath}/reports/my-reports" class="quick-link-card">
                    <i class="fas fa-flag"></i>
                    <h6>Report an Issue List</h6>
                    <small>Flag a problem</small>
                </a>
                
            </div>
        </c:if>
        
        <!-- Features Section (For non-logged in users) -->
        <c:if test="${empty sessionScope.user}">
            <div class="features-section">
                <div class="section-title">
                    <h2>Why Choose Retrotrade?</h2>
                </div>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <h5>Secure Transactions</h5>
                            <p class="text-muted">Your safety is our priority with secure payment processing</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-hand-holding-usd"></i>
                            </div>
                            <h5>Best Prices</h5>
                            <p class="text-muted">Get the best deals on quality pre-owned items</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <h5>Trusted Community</h5>
                            <p class="text-muted">Join thousands of satisfied buyers and sellers</p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Categories Section -->
        <div class="category-section">
            <h4 class="mb-4"><i class="fas fa-tags me-2 text-primary"></i>Browse by Category</h4>
            <div class="category-grid">
                <c:forEach var="category" items="${categoryList}" varStatus="status">
                    <a href="${pageContext.request.contextPath}/listings?categoryId=${category.categoryId}" class="category-item">
                        <i class="fas fa-${status.index % 6 == 0 ? 'mobile-alt' : 
                                                   (status.index % 6 == 1 ? 'laptop' : 
                                                   (status.index % 6 == 2 ? 'tshirt' : 
                                                   (status.index % 6 == 3 ? 'book' : 
                                                   (status.index % 6 == 4 ? 'couch' : 'gamepad'))))}"></i>
                        <div>${category.categoryName}</div>
                    </a>
                </c:forEach>
            </div>
        </div>
        
        <!-- Featured Listings (only ACTIVE listings) -->
        <div class="section-title">
            <h2>Featured Products</h2>
        </div>
        
        <div class="featured-listings">
            <c:forEach var="listing" items="${featuredListings}" varStatus="status">
                <c:if test="${status.index < 8}">
                    <div class="listing-card">
                        <a href="${pageContext.request.contextPath}/listings/${listing.listingId}" style="text-decoration: none; color: inherit;">
                            <div class="listing-image" style="background-image: url('${not empty listing.images and not empty listing.images[0] ? listing.images[0].imageUrl : 'https://via.placeholder.com/300x200'}');">
                                <span class="listing-condition">${listing.condition}</span>
                            </div>
                            <div class="listing-details">
                                <div class="listing-title">${listing.listingName}</div>
                                <div class="listing-price">₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/></div>
                                <div class="listing-meta">
                                    <span><i class="fas fa-map-marker-alt me-1"></i>${listing.location != null ? listing.location : 'Location N/A'}</span>
                                    <span><i class="fas fa-eye me-1"></i>${listing.viewCount}</span>
                                </div>
                            </div>
                        </a>
                        <!-- Action buttons (only for logged-in users) -->
                        <c:if test="${not empty sessionScope.user}">
                            <div class="action-buttons px-3 pb-3">
                                <button onclick="addToWishlist(${listing.listingId})" class="btn btn-sm btn-wishlist btn-sm-custom">
                                    <i class="fas fa-heart"></i> Wishlist
                                </button>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </c:forEach>
        </div>
        
        <!-- Call to Action -->
        <c:if test="${not empty sessionScope.user}">
            <div class="text-center my-5">
                <h3 class="mb-4">Ready to sell your items?</h3>
                <a href="${pageContext.request.contextPath}/listings/add" class="btn btn-lg btn-primary px-5">
                    <i class="fas fa-plus-circle me-2"></i>Create New Listing
                </a>
            </div>
        </c:if>
        
        <c:if test="${empty sessionScope.user}">
            <div class="text-center my-5">
                <h3 class="mb-4">Join our community today!</h3>
                <a href="${pageContext.request.contextPath}/signup" class="btn btn-lg btn-primary px-5">
                    <i class="fas fa-user-plus me-2"></i>Sign Up Now
                </a>
            </div>
        </c:if>
    </div>
    
    <jsp:include page="common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>

        function addToWishlist(listingId) {
            fetch('${pageContext.request.contextPath}/wishlist/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'listingId=' + listingId
            })
            .then(response => {
                if (response.ok) {
                    alert('Added to wishlist!');
                } else {
                    alert('Please login to add to wishlist.');
                }
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>