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
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <style>
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending { background: #ffc107; color: #333; }
        .status-accepted { background: #28a745; color: white; }
        .status-rejected { background: #dc3545; color: white; }
        .status-countered { background: #17a2b8; color: white; }
        .status-expired, .status-withdrawn { background: #6c757d; color: white; }
        .product-thumb { width: 40px; height: 40px; object-fit: cover; border-radius: 5px; }
        .btn-action { padding: 5px 10px; margin: 0 2px; }
        .stats-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 15px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 10px; padding: 15px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .stat-count { font-size: 28px; font-weight: 700; color: #667eea; }
        .stat-label { color: #666; font-size: 13px; }
        .filter-section { background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .dataTables_wrapper .paginate_button.current { background: #667eea !important; border-color: #667eea !important; color: white !important; }
        .dt-buttons .btn { background: #667eea; color: white; margin-right: 5px; }
    </style>
</head>
<body>
    <c:set var="activePage" value="offers" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-hand-holding-usd me-2"></i>Manage Offers</h2>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card"><div class="stat-count">${pendingCount}</div><div class="stat-label">Pending</div></div>
                <div class="stat-card"><div class="stat-count">${acceptedCount}</div><div class="stat-label">Accepted</div></div>
                <div class="stat-card"><div class="stat-count">${rejectedCount}</div><div class="stat-label">Rejected</div></div>
                <div class="stat-card"><div class="stat-count">${counteredCount}</div><div class="stat-label">Countered</div></div>
                <div class="stat-card"><div class="stat-count">${expiredCount}</div><div class="stat-label">Expired</div></div>
                <div class="stat-card"><div class="stat-count">${withdrawnCount}</div><div class="stat-label">Withdrawn</div></div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/offers" method="get" class="row g-3">
                    <div class="col-md-3"><label>Status</label><select name="status" class="form-select"><option value="">All</option><option value="PENDING">Pending</option><option value="ACCEPTED">Accepted</option><option value="REJECTED">Rejected</option><option value="COUNTERED">Countered</option></select></div>
                    <div class="col-md-3"><label>Listing ID</label><input type="number" class="form-control" name="listingId" value="${selectedListingId}"></div>
                    <div class="col-md-3"><label>Buyer ID</label><input type="number" class="form-control" name="buyerId" value="${selectedBuyerId}"></div>
                    <div class="col-md-3 d-flex align-items-end"><button type="submit" class="btn btn-primary w-100"><i class="fas fa-filter me-2"></i>Apply Filters</button></div>
                </form>
            </div>

            <!-- Offers Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="offersTable">
                    <thead class="table-dark">
                        <tr><th>ID</th><th>Product</th><th>Buyer</th><th>Seller</th><th>Offer Price</th><th>Asking Price</th><th>Status</th><th>Created</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="offer" items="${offers}">
                            <tr>
                                <td>#${offer.offerId}</td>
                                <td><div class="d-flex align-items-center"><img src="${not empty offer.listing.images ? offer.listing.images[0].imageUrl : 'https://via.placeholder.com/40'}" class="product-thumb me-2"><strong>${offer.listing.listingName}</strong></div></td>
                                <td>${offer.buyer.firstName} ${offer.buyer.lastName}</td>
                                <td>${offer.listing.seller.firstName} ${offer.listing.seller.lastName}</td>
                                <td><strong class="text-primary">₹<fmt:formatNumber value="${offer.offeredPrice}" pattern="#,##0.00"/></strong></td>
                                <td>₹<fmt:formatNumber value="${offer.listing.price}" pattern="#,##0.00"/></td>
                                <td><span class="status-badge status-${offer.offerStatus.toString().toLowerCase()}">${offer.offerStatus}</span></td>
                                <td>${offer.createdAt}</td>
                                <td><a href="${pageContext.request.contextPath}/admin/offers/view/${offer.offerId}" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/offers/delete/${offer.offerId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')"><i class="fas fa-trash"></i></a></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty offers}"><tr><td colspan="9" class="text-center py-4"><h5>No Offers Found</h5></td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
    
    <script>
        $(document).ready(function() {
            if ($('#offersTable tbody tr').length > 0) {
                $('#offersTable').DataTable({
                    pageLength: 10, lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    responsive: true, order: [[0, 'asc']],
                    language: { search: "Search:", lengthMenu: "Show _MENU_ entries", info: "Showing _START_ to _END_ of _TOTAL_ entries" },
                    dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>><"row"<"col-sm-12"B>><"row"<"col-sm-12"tr>><"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                    columnDefs: [{ orderable: false, targets: [8] }]
                });
            }
        });
    </script>
</body>
</html>