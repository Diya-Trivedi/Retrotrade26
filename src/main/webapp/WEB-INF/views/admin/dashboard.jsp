<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        
        #sidebar .sidebar-header p {
            margin: 5px 0 0;
            opacity: 0.8;
            font-size: 0.9rem;
        }
        
        #sidebar ul.components {
            padding: 20px 0;
        }
        
        #sidebar ul li {
            list-style: none;
        }
        
        #sidebar ul li a {
            padding: 12px 25px;
            display: block;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }
        
        #sidebar ul li a:hover {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: #fff;
        }
        
        #sidebar ul li.active a {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: #fff;
        }
        
        #sidebar ul li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        #sidebar ul ul a {
            padding-left: 50px;
            background: rgba(0, 0, 0, 0.1);
            font-size: 0.9rem;
        }
        
        #sidebar .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        #sidebar .user-info {
            display: flex;
            align-items: center;
            color: #fff;
        }
        
        #sidebar .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid #fff;
        }
        
        #sidebar .user-info .user-details {
            flex: 1;
        }
        
        #sidebar .user-info .user-details .name {
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        #sidebar .user-info .user-details .role {
            font-size: 0.8rem;
            opacity: 0.8;
        }
        
        #content {
            width: 100%;
            margin-left: var(--sidebar-width);
            transition: all 0.3s;
        }
        
        #content.active {
            margin-left: 0;
        }
        
        .navbar-custom {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 30px;
            position: fixed;
            width: calc(100% - var(--sidebar-width));
            z-index: 100;
            transition: all 0.3s;
        }
        
        .navbar-custom.active {
            width: 100%;
        }
        
        .navbar-custom .sidebar-toggle {
            background: transparent;
            border: none;
            font-size: 1.5rem;
            color: #667eea;
            cursor: pointer;
            margin-right: 20px;
        }
        
        .main-content {
            padding: 100px 30px 30px;
            min-height: 100vh;
        }
        
        .page-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .page-header h2 {
            color: #333;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .page-header p {
            color: #666;
            margin-bottom: 0;
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
            transition: transform 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(102,126,234,0.2);
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            line-height: 50px;
            border-radius: 10px;
            text-align: center;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .stat-link {
            color: #667eea;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
        }
        
        .stat-link:hover {
            text-decoration: underline;
        }
        
        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 25px 20px;
            text-align: center;
            text-decoration: none;
            color: #333;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        
        .action-card:hover {
            background: var(--primary-gradient);
            color: white;
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(102,126,234,0.3);
        }
        
        .action-card i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #667eea;
        }
        
        .action-card:hover i {
            color: white;
        }
        
        .action-card h6 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .action-card small {
            font-size: 0.8rem;
            opacity: 0.8;
        }
        
        .section-title {
            margin: 40px 0 20px;
            position: relative;
        }
        
        .section-title h4 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            display: inline-block;
            padding-bottom: 8px;
            border-bottom: 3px solid #667eea;
        }
        
        .table-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        
        .status-active {
            background: #28a745;
            color: white;
        }
        
        .status-sold {
            background: #6c757d;
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
        
        .status-open {
            background: #ffc107;
            color: #333;
        }
        
        .status-resolved {
            background: #28a745;
            color: white;
        }
        
        .status-initiated, .status-completed, .status-delivered {
            background: #28a745;
            color: white;
        }
        
        .status-pending-transaction {
            background: #ffc107;
            color: #333;
        }
        
        .status-cancelled, .status-refunded {
            background: #dc3545;
            color: white;
        }
        
        .status-disputed {
            background: #fd7e14;
            color: white;
        }
        
        .quick-stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .quick-stat-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
        }
        
        .quick-stat-value {
            font-size: 20px;
            font-weight: 700;
            color: #667eea;
        }
        
        .quick-stat-label {
            font-size: 12px;
            color: #666;
        }
        
        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: 100%;
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
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .quick-actions-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .quick-stats-row {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="dashboard" scope="request"/>
    <jsp:include page="adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="page-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h2><i class="fas fa-tachometer-alt me-2 text-primary"></i>Admin Dashboard</h2>
                        <p class="text-muted">Welcome back, ${sessionScope.user.firstName}! Here's what's happening with your marketplace today.</p>
                    </div>
                    <div class="col-md-4 text-md-end">
                        <span class="badge bg-primary p-2">
                            <i class="far fa-clock me-1"></i>
                            ${sessionScope.lastLoginTime}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Main Statistics Cards -->
            <div class="stats-grid">
                <!-- Users Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(102, 126, 234, 0.1); color: #667eea;">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-value">${totalUsers}</div>
                    <div class="stat-label">Total Users</div>
                    <a href="${pageContext.request.contextPath}/listUser" class="stat-link">
                        View All <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <!-- Categories Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(40, 167, 69, 0.1); color: #28a745;">
                        <i class="fas fa-tags"></i>
                    </div>
                    <div class="stat-value">${totalCategories}</div>
                    <div class="stat-label">Total Categories</div>
                    <a href="${pageContext.request.contextPath}/admin/category/list" class="stat-link">
                        Manage <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <!-- Subcategories Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255, 193, 7, 0.1); color: #ffc107;">
                        <i class="fas fa-sitemap"></i>
                    </div>
                    <div class="stat-value">${totalSubcategories}</div>
                    <div class="stat-label">Total Subcategories</div>
                    <a href="${pageContext.request.contextPath}/admin/subcategory/list" class="stat-link">
                        Manage <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <!-- Listings Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(23, 162, 184, 0.1); color: #17a2b8;">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="stat-value">${totalListings}</div>
                    <div class="stat-label">Total Listings</div>
                    <a href="${pageContext.request.contextPath}/admin/listings" class="stat-link">
                        View All <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <!-- Offers Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(220, 53, 69, 0.1); color: #dc3545;">
                        <i class="fas fa-hand-holding-usd"></i>
                    </div>
                    <div class="stat-value">${totalOffers != null ? totalOffers : '0'}</div>
                    <div class="stat-label">Total Offers</div>
                    <a href="${pageContext.request.contextPath}/admin/offers" class="stat-link">
                        Manage <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <!-- Transactions Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(0, 123, 255, 0.1); color: #007bff;">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <div class="stat-value">${totalTransactions != null ? totalTransactions : fn:length(transactionList)}</div>
                    <div class="stat-label">Transactions</div>
                    <a href="${pageContext.request.contextPath}/admin/transactions" class="stat-link">
                        View <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <!-- Pending Listings Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(255, 193, 7, 0.1); color: #ffc107;">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-value">${pendingListings}</div>
                    <div class="stat-label">Pending Approval</div>
                    <a href="${pageContext.request.contextPath}/admin/listings?status=PENDING" class="stat-link">
                        Review <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <!-- Revenue Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(40, 167, 69, 0.1); color: #28a745;">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-value">₹<fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,##0"/></div>
                    <div class="stat-label">Platform Revenue</div>
                    <a href="${pageContext.request.contextPath}/admin/transactions/revenue" class="stat-link">
                        Report <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <!-- Reports Stat -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(108, 117, 125, 0.1); color: #6c757d;">
                        <i class="fas fa-flag"></i>
                    </div>
                    <div class="stat-value">${totalReports != null ? totalReports : '0'}</div>
                    <div class="stat-label">Total Reports</div>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="stat-link">
                        Manage <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="section-title">
                <h4><i class="fas fa-bolt me-2 text-primary"></i>Quick Actions</h4>
            </div>
            
            <div class="quick-actions-grid">
                <a href="${pageContext.request.contextPath}/admin/category/add" class="action-card">
                    <i class="fas fa-plus-circle"></i>
                    <h6>Add Category</h6>
                    <small>Create new category</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/category/list" class="action-card">
                    <i class="fas fa-list"></i>
                    <h6>View Categories</h6>
                    <small>Manage categories</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/subcategory/add" class="action-card">
                    <i class="fas fa-plus-square"></i>
                    <h6>Add Subcategory</h6>
                    <small>Create new subcategory</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/subcategory/list" class="action-card">
                    <i class="fas fa-sitemap"></i>
                    <h6>View Subcategories</h6>
                    <small>Manage subcategories</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/listings" class="action-card">
                    <i class="fas fa-box"></i>
                    <h6>All Listings</h6>
                    <small>Manage products</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/listings?status=PENDING" class="action-card">
                    <i class="fas fa-clock"></i>
                    <h6>Pending Listings</h6>
                    <small>Awaiting approval</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/offers" class="action-card">
                    <i class="fas fa-hand-holding-usd"></i>
                    <h6>All Offers</h6>
                    <small>Manage offers</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/transactions" class="action-card">
                    <i class="fas fa-credit-card"></i>
                    <h6>Transactions</h6>
                    <small>View all transactions</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/transactions/revenue" class="action-card">
                    <i class="fas fa-chart-line"></i>
                    <h6>Revenue Report</h6>
                    <small>Analytics</small>
                </a>
                
                <a href="${pageContext.request.contextPath}/listUser" class="action-card">
                    <i class="fas fa-users"></i>
                    <h6>Manage Users</h6>
                    <small>View all users</small>
                </a>

                <a href="${pageContext.request.contextPath}/admin/reports" class="action-card">
                    <i class="fas fa-flag"></i>
                    <h6>Manage Reports</h6>
                    <small>Handle user reports</small>
                </a>
                
                <a href="#" class="action-card">
                    <i class="fas fa-user-cog"></i>
                    <h6>Admin Profile</h6>
                    <small>Your account</small>
                </a>
            </div>

            <!-- Charts Section: Listing Distribution and Monthly Revenue -->
            <div class="section-title">
                <h4><i class="fas fa-chart-pie me-2 text-primary"></i>Analytics Dashboard</h4>
            </div>
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-pie me-2 text-primary"></i>Listing Status Distribution</h5>
                        <canvas id="listingPieChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-line me-2 text-primary"></i>Monthly Revenue Trend</h5>
                        <canvas id="revenueLineChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
            </div>

            <!-- Recent Listings -->
            <div class="section-title">
                <h4><i class="fas fa-clock me-2 text-primary"></i>Recent Listings</h4>
            </div>
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr><th>ID</th><th>Product</th><th>Seller</th><th>Category</th><th>Price</th><th>Status</th><th>Created</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="listing" items="${recentListings}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <tr>
                                        <td>#${listing.listingId}</td>
                                        <td><strong>${listing.listingName}</strong><br><small>${listing.brand}</small></td>
                                        <td>${listing.seller.firstName} ${listing.seller.lastName}</td>
                                        <td><span class="badge bg-info">${listing.category.categoryName}</span></td>
                                        <td>₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/></td>
                                        <td><span class="status-badge status-${fn:toLowerCase(listing.status)}">${listing.status}</span></td>
                                        <td>${listing.createdAt}</td>
                                        <td><a href="${pageContext.request.contextPath}/admin/listings/view/${listing.listingId}" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a></td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentListings}"><tr><td colspan="8" class="text-center">No recent listings</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
                <div class="text-end mt-2"><a href="${pageContext.request.contextPath}/admin/listings" class="btn btn-sm btn-outline-primary">View All Listings <i class="fas fa-arrow-right ms-1"></i></a></div>
            </div>

            <!-- Recent Offers -->
            <div class="section-title">
                <h4><i class="fas fa-hand-holding-usd me-2 text-primary"></i>Recent Offers</h4>
            </div>
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr><th>ID</th><th>Product</th><th>Buyer</th><th>Seller</th><th>Offer Price</th><th>Status</th><th>Created</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="offer" items="${recentOffers}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <tr>
                                        <td>#${offer.offerId}</td>
                                        <td>${offer.listing.listingName}</td>
                                        <td>${offer.buyer.firstName} ${offer.buyer.lastName}</td>
                                        <td>${offer.listing.seller.firstName} ${offer.listing.seller.lastName}</td>
                                        <td>₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></td>
                                        <td><span class="status-badge status-${fn:toLowerCase(offer.offerStatus)}">${offer.offerStatus}</span></td>
                                        <td>${offer.createdAt}</td>
                                        <td><a href="${pageContext.request.contextPath}/admin/offers/view/${offer.offerId}" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a></td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentOffers}"><tr><td colspan="8" class="text-center">No recent offers</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
                <div class="text-end mt-2"><a href="${pageContext.request.contextPath}/admin/offers" class="btn btn-sm btn-outline-primary">View All Offers <i class="fas fa-arrow-right ms-1"></i></a></div>
            </div>

            <!-- Recent Transactions -->
            <div class="section-title">
                <h4><i class="fas fa-credit-card me-2 text-primary"></i>Recent Transactions</h4>
            </div>
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr><th>ID</th><th>Product</th><th>Buyer</th><th>Seller</th><th>Amount</th><th>Payment Mode</th><th>Status</th><th>Created</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="transaction" items="${recentTransactions}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <tr>
                                        <td>#${transaction.transactionId}</td>
                                        <td>${transaction.listing.listingName}</td>
                                        <td>${transaction.buyer.firstName} ${transaction.buyer.lastName}</td>
                                        <td>${transaction.seller.firstName} ${transaction.seller.lastName}</td>
                                        <td>₹<fmt:formatNumber value="${transaction.finalPrice}" pattern="#,##0.00"/></td>
                                        <td>${transaction.paymentMode}</td>
                                        <td><span class="status-badge status-${fn:toLowerCase(transaction.transactionStatus)}">${transaction.transactionStatus}</span></td>
                                        <td>${transaction.createdAt}</td>
                                        <td><a href="${pageContext.request.contextPath}/admin/transactions/view/${transaction.transactionId}" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a></td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentTransactions}"><tr><td colspan="9" class="text-center">No recent transactions</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
                <div class="text-end mt-2"><a href="${pageContext.request.contextPath}/admin/transactions" class="btn btn-sm btn-outline-primary">View All Transactions <i class="fas fa-arrow-right ms-1"></i></a></div>
            </div>

            <!-- Recent Reports -->
            <div class="section-title">
                <h4><i class="fas fa-flag me-2 text-primary"></i>Recent Reports</h4>
            </div>
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr><th>ID</th><th>Reported Listing</th><th>Reported By</th><th>Reason</th><th>Status</th><th>Created</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${recentReports}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <tr>
                                        <td>#${report.reportId}</td>
                                        <td>${report.listing.listingName}</td>
                                        <td>${report.reportedBy.firstName} ${report.reportedBy.lastName}</td>
                                        <td>${report.reason}</td>
                                        <td><span class="status-badge status-${fn:toLowerCase(report.status)}">${report.status}</span></td>
                                        <td>${report.createdAt}</td>
                                        <td><a href="${pageContext.request.contextPath}/admin/reports/view/${report.reportId}" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a></td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentReports}"><tr><td colspan="7" class="text-center">No recent reports</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
                <div class="text-end mt-2"><a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-sm btn-outline-primary">View All Reports <i class="fas fa-arrow-right ms-1"></i></a></div>
            </div>

            <!-- Quick Stats Row - Categories and Users -->
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="table-card">
                        <h5 class="mb-3"><i class="fas fa-tags me-2 text-primary"></i>Top Categories</h5>
                        <div class="table-responsive">
                            <table class="table">
                                <thead><tr><th>Category</th><th>Subcategories</th><th>Total Listings</th><th>Status</th></tr></thead>
                                <tbody>
                                    <c:forEach var="category" items="${categoryList}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <tr>
                                                <td><strong>${category.categoryName}</strong></td>
                                                <td><span class="badge bg-info">${fn:length(category.subCategories)}</span></td>
                                                <td><c:set var="totalCatListings" value="0"/><c:forEach var="sub" items="${category.subCategories}"><c:set var="totalCatListings" value="${totalCatListings + fn:length(sub.listings)}"/></c:forEach><span class="badge bg-primary">${totalCatListings}</span></td>
                                                <td><span class="badge ${category.active ? 'bg-success' : 'bg-danger'}">${category.active ? 'Active' : 'Inactive'}</span></td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty categoryList}"><tr><td colspan="4" class="text-center">No categories found</td></tr></c:if>
                                </tbody>
                            </table>
                        </div>
                        <div class="text-end mt-2"><a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-sm btn-outline-primary">View All Categories <i class="fas fa-arrow-right ms-1"></i></a></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="table-card">
                        <h5 class="mb-3"><i class="fas fa-users me-2 text-primary"></i>Recent Users</h5>
                        <div class="table-responsive">
                            <table class="table">
                                <thead><tr><th>Name</th><th>Email</th><th>Role</th><th>Joined</th></tr></thead>
                                <tbody>
                                    <c:forEach var="user" items="${userList}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <tr>
                                                <td>${user.firstName} ${user.lastName}</td>
                                                <td>${user.email}</td>
                                                <td><span class="badge ${user.role == 'ADMIN' ? 'bg-danger' : 'bg-success'}">${user.role}</span></td>
                                                <td>${user.createdAt}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty userList}"><td><td colspan="4" class="text-center">No users found</td></c:if>
                                </tbody>
                            </table>
                        </div>
                        <div class="text-end mt-2"><a href="${pageContext.request.contextPath}/listUser" class="btn btn-sm btn-outline-primary">View All Users <i class="fas fa-arrow-right ms-1"></i></a></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="adminFooter.jsp" />

    <script>
        // Prepare data for charts using backend variables
        const active = ${activeListings};
        const pending = ${pendingListings};
        const sold = ${soldListings};
        const rejected = ${rejectedListings != null ? rejectedListings : 0};

        // Listing status pie chart
        const ctxPie = document.getElementById('listingPieChart').getContext('2d');
        new Chart(ctxPie, {
            type: 'pie',
            data: {
                labels: ['Active', 'Pending', 'Sold', 'Rejected'],
                datasets: [{
                    data: [active, pending, sold, rejected],
                    backgroundColor: ['#28a745', '#ffc107', '#6c757d', '#dc3545'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: { callbacks: { label: (ctx) => `${ctx.label}: ${ctx.raw} listings` } }
                }
            }
        });

        // Monthly revenue line chart (data from backend)
        const monthlyData = [
            <c:forEach var="month" items="${monthlyRevenue}" varStatus="s">
                { month: '${month[0]}/${month[1]}', revenue: ${month[2]} }${!s.last ? ',' : ''}
            </c:forEach>
        ];
        const months = monthlyData.map(d => d.month);
        const revenues = monthlyData.map(d => d.revenue);

        const ctxLine = document.getElementById('revenueLineChart').getContext('2d');
        new Chart(ctxLine, {
            type: 'line',
            data: {
                labels: months,
                datasets: [{
                    label: 'Revenue (₹)',
                    data: revenues,
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    tooltip: { callbacks: { label: (ctx) => `₹ ${ctx.raw.toLocaleString()}` } }
                },
                scales: {
                    y: { beginAtZero: true, ticks: { callback: (val) => '₹' + val.toLocaleString() } }
                }
            }
        });
    </script>
</body>
</html>