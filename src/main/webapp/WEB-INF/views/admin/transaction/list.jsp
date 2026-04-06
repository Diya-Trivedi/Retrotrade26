<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Transactions - Retrotrade Admin</title>
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
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            position: relative;
            overflow: hidden;
            border-left: 4px solid transparent;
        }
        
        .stat-card.primary {
            border-left-color: #667eea;
        }
        
        .stat-card.success {
            border-left-color: #28a745;
        }
        
        .stat-card.warning {
            border-left-color: #ffc107;
        }
        
        .stat-card.danger {
            border-left-color: #dc3545;
        }
        
        .stat-card.info {
            border-left-color: #17a2b8;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 13px;
            margin-bottom: 5px;
        }
        
        .stat-sub {
            font-size: 12px;
            color: #999;
        }
        
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .table-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
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
        
        .product-thumb {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .btn-action {
            padding: 5px 10px;
            border-radius: 5px;
            margin: 0 2px;
            transition: transform 0.2s;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
        }
        
        .pagination .page-link {
            color: #667eea;
        }
        
        .pagination .active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
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
            .navbar-custom {
                width: 100%;
            }
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="transactions" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h4 class="mb-1"><i class="fas fa-credit-card me-2 text-primary"></i>Transaction Management</h4>
                    <p class="text-muted mb-0">Monitor and manage all marketplace transactions</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/transactions/revenue" class="btn btn-success me-2">
                        <i class="fas fa-chart-line me-2"></i>Revenue Report
                    </a>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-value">${totalTransactions}</div>
                    <div class="stat-label">Total Transactions</div>
                    <div class="stat-sub">All time</div>
                </div>
                <div class="stat-card success">
                    <div class="stat-value">${completedCount}</div>
                    <div class="stat-label">Completed</div>
                    <div class="stat-sub">
                        <fmt:formatNumber value="${completedCount / totalTransactions * 100}" pattern="0.0"/>% of total
                    </div>
                </div>
                <div class="stat-card warning">
                    <div class="stat-value">${pendingCount}</div>
                    <div class="stat-label">Pending</div>
                    <div class="stat-sub">Awaiting completion</div>
                </div>
                <div class="stat-card info">
                    <div class="stat-value">${deliveredCount}</div>
                    <div class="stat-label">Delivered</div>
                    <div class="stat-sub">Successfully delivered</div>
                </div>
                <div class="stat-card danger">
                    <div class="stat-value">${cancelledCount}</div>
                    <div class="stat-label">Cancelled</div>
                    <div class="stat-sub">Failed transactions</div>
                </div>
                <div class="stat-card danger">
                    <div class="stat-value">${disputedCount}</div>
                    <div class="stat-label">Disputed</div>
                    <div class="stat-sub">Under review</div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/transactions" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Filter by Status</label>
                        <select name="status" class="form-select">
                            <option value="">All Status</option>
                            <option value="INITIATED" ${selectedStatus == 'INITIATED' ? 'selected' : ''}>Initiated</option>
                            <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="COMPLETED" ${selectedStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            <option value="DELIVERED" ${selectedStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                            <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                            <option value="REFUNDED" ${selectedStatus == 'REFUNDED' ? 'selected' : ''}>Refunded</option>
                            <option value="DISPUTED" ${selectedStatus == 'DISPUTED' ? 'selected' : ''}>Disputed</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Buyer ID</label>
                        <input type="number" class="form-control" name="buyerId" value="${selectedBuyerId}" placeholder="Enter Buyer ID">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Seller ID</label>
                        <input type="number" class="form-control" name="sellerId" value="${selectedSellerId}" placeholder="Enter Seller ID">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Apply Filters
                        </button>
                    </div>
                </form>
            </div>

            <!-- Transactions Table -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Product</th>
                                <th>Buyer</th>
                                <th>Seller</th>
                                <th>Amount</th>
                                <th>Payment</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="txn" items="${transactions}">
                                <tr>
                                    <td>#${txn.transactionId}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty txn.listing.images and not empty txn.listing.images[0]}">
                                                    <img src="${txn.listing.images[0].imageUrl}" class="product-thumb me-2" alt="${txn.listing.listingName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://via.placeholder.com/40" class="product-thumb me-2" alt="No image">
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <strong>${txn.listing.listingName}</strong>
                                                <br><small class="text-muted">ID: #${txn.listing.listingId}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        ${txn.buyer.firstName} ${txn.buyer.lastName}
                                        <br><small class="text-muted">ID: ${txn.buyer.userId}</small>
                                    </td>
                                    <td>
                                        ${txn.seller.firstName} ${txn.seller.lastName}
                                        <br><small class="text-muted">ID: ${txn.seller.userId}</small>
                                    </td>
                                    <td>
                                        <strong class="text-primary">₹<fmt:formatNumber value="${txn.finalPrice}" pattern="#,##0.00"/></strong>
                                        <br><small class="text-muted">Fee: ₹<fmt:formatNumber value="${txn.transactionFee}" pattern="#,##0.00"/></small>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">${txn.paymentMode}</span>
                                        <br><small class="text-muted">${txn.paymentId}</small>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${fn:toLowerCase(txn.transactionStatus)}">
                                            ${txn.transactionStatus}
                                        </span>
                                    </td>
                                    <td>
                                        ${txn.createdAt}
                                        <br><small class="text-muted">${txn.createdAt}</small>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/transactions/view/${txn.transactionId}" 
                                           class="btn btn-sm btn-info btn-action" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/transactions/delete/${txn.transactionId}" 
                                           class="btn btn-sm btn-danger btn-action" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this transaction?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty transactions}">
                                <tr>
                                    <td colspan="9" class="text-center py-4">
                                        <i class="fas fa-credit-card fa-3x text-muted mb-3"></i>
                                        <h5>No Transactions Found</h5>
                                        <p class="text-muted">No transactions match your filter criteria.</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage-1}&size=10&status=${selectedStatus}&buyerId=${selectedBuyerId}&sellerId=${selectedSellerId}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            
                            <c:forEach begin="0" end="${totalPages-1}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&size=10&status=${selectedStatus}&buyerId=${selectedBuyerId}&sellerId=${selectedSellerId}">${i+1}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages-1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage+1}&size=10&status=${selectedStatus}&buyerId=${selectedBuyerId}&sellerId=${selectedSellerId}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>