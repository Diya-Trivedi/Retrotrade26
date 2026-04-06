<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>   <!-- Add this line -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reports - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .reports-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .page-header h2 {
            color: #333;
            font-weight: 600;
        }
        .table-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 20px;
            overflow-x: auto;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-OPEN {
            background: #ffc107;
            color: #333;
        }
        .status-RESOLVED {
            background: #28a745;
            color: white;
        }
        .status-REJECTED {
            background: #dc3545;
            color: white;
        }
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        .empty-state {
            text-align: center;
            padding: 60px;
        }
        .empty-state i {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .pagination .page-link {
            color: #667eea;
        }
        .pagination .active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="reports-container">
        <div class="page-header">
            <h2><i class="fas fa-flag me-2 text-danger"></i>My Reports</h2>
            <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary">
                <i class="fas fa-search me-2"></i>Browse Listings
            </a>
        </div>

        <div class="table-card">
            <c:choose>
                <c:when test="${empty reports}">
                    <div class="empty-state">
                        <i class="fas fa-flag"></i>
                        <h4>No Reports Submitted</h4>
                        <p class="text-muted">You haven't reported any listing yet.</p>
                        <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Browse & Report
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Listing</th>
                                    <th>Reported Seller</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Reported On</th>
                                    <th>Comment</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="report" items="${reports}">
                                    <tr>
                                        <td>#${report.reportId}</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <c:choose>
                                                    <c:when test="${not empty report.listing.images and not empty report.listing.images[0]}">
                                                        <img src="${report.listing.images[0].imageUrl}" class="product-thumb" alt="Product">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/50" class="product-thumb" alt="No image">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <strong>${report.listing.listingName}</strong>
                                                    <br><small class="text-muted">ID: #${report.listing.listingId}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            ${report.seller.firstName} ${report.seller.lastName}
                                            <br><small class="text-muted">${report.seller.email}</small>
                                        </td>
                                        <td>
                                            <span class="badge bg-danger">${report.reason}</span>
                                        </td>
                                        <td>
                                            <span class="status-badge status-${report.status}">
                                                ${report.status}
                                            </span>
                                        </td>
                                        <td>
                                            ${report.createdAt}
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty report.comment}">
                                                    <span class="text-muted" title="${report.comment}">
                                                        ${fn:substring(report.comment, 0, 30)}${fn:length(report.comment) > 30 ? '...' : ''}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/listings/${report.listing.listingId}" 
                                               class="btn btn-sm btn-outline-primary" title="View Listing">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage-1}&size=10">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <c:forEach begin="0" end="${totalPages-1}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&size=10">${i+1}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages-1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage+1}&size=10">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>