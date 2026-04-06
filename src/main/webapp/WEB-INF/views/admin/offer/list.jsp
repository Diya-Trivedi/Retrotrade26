<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Offers - Retrotrade Admin</title>
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
        
        #sidebar .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
            border-top: 1px solid rgba(255,255,255,0.1);
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
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card .count {
            font-size: 28px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-card .label {
            color: #666;
            font-size: 14px;
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
        
        .status-expired {
            background: #6c757d;
            color: white;
        }
        
        .status-withdrawn {
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
            #content.active {
                margin-left: var(--sidebar-width);
            }
            .navbar-custom {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="offers" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="page-header">
                <h4 class="mb-1"><i class="fas fa-hand-holding-usd me-2 text-primary"></i>Offer Management</h4>
                <p class="text-muted mb-0">Monitor and manage all buyer offers</p>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="count">${pendingCount}</div>
                    <div class="label">Pending</div>
                </div>
                <div class="stat-card">
                    <div class="count">${acceptedCount}</div>
                    <div class="label">Accepted</div>
                </div>
                <div class="stat-card">
                    <div class="count">${rejectedCount}</div>
                    <div class="label">Rejected</div>
                </div>
                <div class="stat-card">
                    <div class="count">${counteredCount}</div>
                    <div class="label">Countered</div>
                </div>
                <div class="stat-card">
                    <div class="count">${expiredCount}</div>
                    <div class="label">Expired</div>
                </div>
                <div class="stat-card">
                    <div class="count">${withdrawnCount}</div>
                    <div class="label">Withdrawn</div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/offers" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Filter by Status</label>
                        <select name="status" class="form-select">
                            <option value="">All Status</option>
                            <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="ACCEPTED" ${selectedStatus == 'ACCEPTED' ? 'selected' : ''}>Accepted</option>
                            <option value="REJECTED" ${selectedStatus == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                            <option value="COUNTERED" ${selectedStatus == 'COUNTERED' ? 'selected' : ''}>Countered</option>
                            <option value="EXPIRED" ${selectedStatus == 'EXPIRED' ? 'selected' : ''}>Expired</option>
                            <option value="WITHDRAWN" ${selectedStatus == 'WITHDRAWN' ? 'selected' : ''}>Withdrawn</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Listing ID</label>
                        <input type="number" class="form-control" name="listingId" value="${selectedListingId}" placeholder="Enter Listing ID">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Buyer ID</label>
                        <input type="number" class="form-control" name="buyerId" value="${selectedBuyerId}" placeholder="Enter Buyer ID">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Apply Filters
                        </button>
                    </div>
                </form>
            </div>

            <!-- Offers Table -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Product</th>
                                <th>Buyer</th>
                                <th>Seller</th>
                                <th>Offer Price</th>
                                <th>Asking Price</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="offer" items="${offers}">
                                <tr>
                                    <td>#${offer.offerId}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty offer.listing.images and not empty offer.listing.images[0]}">
                                                    <img src="${offer.listing.images[0].imageUrl}" class="product-thumb me-2" alt="${offer.listing.listingName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://via.placeholder.com/40" class="product-thumb me-2" alt="No image">
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <strong>${offer.listing.listingName}</strong>
                                                <br><small class="text-muted">ID: #${offer.listing.listingId}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        ${offer.buyer.firstName} ${offer.buyer.lastName}
                                        <br><small class="text-muted">${offer.buyer.email}</small>
                                    </td>
                                    <td>
                                        ${offer.listing.seller.firstName} ${offer.listing.seller.lastName}
                                    </td>
                                    <td>
                                        <strong class="text-primary">₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></strong>
                                        <c:if test="${not empty offer.counterPrice}">
                                            <br><small class="text-info">Counter: ₹<fmt:formatNumber value="${offer.counterPrice}" pattern="#,##0.00"/></small>
                                        </c:if>
                                    </td>
                                    <td>₹<fmt:formatNumber value="${offer.listing.price}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="status-badge status-${offer.offerStatus.toString().toLowerCase()}">
                                            ${offer.offerStatus}
                                        </span>
                                    </td>
                                    <td>
                                        ${offer.createdAt}
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/offers/view/${offer.offerId}" 
                                           class="btn btn-sm btn-info btn-action" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/offers/delete/${offer.offerId}" 
                                           class="btn btn-sm btn-danger btn-action" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this offer?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty offers}">
                                <tr>
                                    <td colspan="9" class="text-center py-4">
                                        <i class="fas fa-hand-holding-usd fa-3x text-muted mb-3"></i>
                                        <h5>No Offers Found</h5>
                                        <p class="text-muted">No offers match your filter criteria.</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>