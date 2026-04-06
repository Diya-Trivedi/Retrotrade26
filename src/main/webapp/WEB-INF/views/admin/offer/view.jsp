<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Offer - Retrotrade Admin</title>
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
        
        #sidebar ul.components {
            padding: 20px 0;
        }
        
        #sidebar ul li a {
            padding: 12px 25px;
            display: block;
            color: #fff;
            text-decoration: none;
        }
        
        #sidebar ul li a i {
            margin-right: 10px;
        }
        
        #sidebar .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
        }
        
        #content {
            width: 100%;
            margin-left: var(--sidebar-width);
            transition: all 0.3s;
        }
        
        .navbar-custom {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 30px;
            position: fixed;
            width: calc(100% - var(--sidebar-width));
            z-index: 100;
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
        
        .view-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .view-header {
            background: var(--primary-gradient);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .view-body {
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
        }
        
        .info-card .value {
            font-size: 1.5rem;
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
        
        .btn-back {
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 30px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            background: #5a6268;
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
    <c:set var="activePage" value="offers" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumb -->
            <div class="page-header">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/offers">Offers</a></li>
                        <li class="breadcrumb-item active">Offer #${offer.offerId}</li>
                    </ol>
                </nav>
            </div>

            <!-- View Card -->
            <div class="view-card">
                <div class="view-header">
                    <h3><i class="fas fa-hand-holding-usd me-2"></i>Offer Details</h3>
                    <span class="status-badge status-${offer.offerStatus.toString().toLowerCase()} mt-3">
                        ${offer.offerStatus}
                    </span>
                </div>
                
                <div class="view-body">
                    <!-- Price Comparison -->
                    <div class="info-grid">
                        <div class="info-card">
                            <h6><i class="fas fa-tag me-2"></i>Asking Price</h6>
                            <div class="value text-success">₹<fmt:formatNumber value="${offer.listing.price}" pattern="#,##0.00"/></div>
                        </div>
                        <div class="info-card">
                            <h6><i class="fas fa-hand-holding-usd me-2"></i>Offer Price</h6>
                            <div class="value text-primary">₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></div>
                        </div>
                        <c:if test="${not empty offer.counterPrice}">
                            <div class="info-card">
                                <h6><i class="fas fa-exchange-alt me-2"></i>Counter Price</h6>
                                <div class="value text-info">₹<fmt:formatNumber value="${offer.counterPrice}" pattern="#,##0.00"/></div>
                            </div>
                        </c:if>
                        <div class="info-card">
                            <h6><i class="far fa-clock me-2"></i>Expires On</h6>
                            ${offer.expiryDate}
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
                            <span class="detail-label">Product:</span>
                            <span class="detail-value">
                                <strong>${offer.listing.listingName}</strong> 
                                (ID: #${offer.listing.listingId})
                            </span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Category:</span>
                            <span class="detail-value">
                                ${offer.listing.category.categoryName} > ${offer.listing.subCategory.subCategoryName}
                            </span>
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
                                <span class="status-badge status-${offer.offerStatus.toString().toLowerCase()}">
                                    ${offer.offerStatus}
                                </span>
                            </span>
                        </div>
                        
                        <div class="detail-row">
                            <span class="detail-label">Created On:</span>
                            <span class="detail-value">
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
                    </div>

                    <!-- Message -->
                    <c:if test="${not empty offer.message}">
                        <div class="detail-table">
                            <h6 class="mb-3"><i class="fas fa-envelope me-2"></i>Message</h6>
                            <p class="mb-0">${offer.message}</p>
                        </div>
                    </c:if>

                    <!-- Action Buttons -->
                    <div class="text-center mt-4">
                        <form action="${pageContext.request.contextPath}/admin/offers/update-status/${offer.offerId}" method="post" class="d-inline">
                            <select name="status" class="form-select d-inline w-auto me-2">
                                <option value="PENDING" ${offer.offerStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="ACCEPTED" ${offer.offerStatus == 'ACCEPTED' ? 'selected' : ''}>Accepted</option>
                                <option value="REJECTED" ${offer.offerStatus == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                <option value="COUNTERED" ${offer.offerStatus == 'COUNTERED' ? 'selected' : ''}>Countered</option>
                                <option value="EXPIRED" ${offer.offerStatus == 'EXPIRED' ? 'selected' : ''}>Expired</option>
                                <option value="WITHDRAWN" ${offer.offerStatus == 'WITHDRAWN' ? 'selected' : ''}>Withdrawn</option>
                            </select>
                            <button type="submit" class="btn btn-warning me-2">
                                <i class="fas fa-sync-alt me-2"></i>Update Status
                            </button>
                        </form>
                        
                        <a href="${pageContext.request.contextPath}/admin/offers/delete/${offer.offerId}" 
                           class="btn btn-danger me-2"
                           onclick="return confirm('Are you sure you want to delete this offer?')">
                            <i class="fas fa-trash me-2"></i>Delete
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/admin/offers" class="btn-back">
                            <i class="fas fa-arrow-left me-2"></i>Back to List
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>