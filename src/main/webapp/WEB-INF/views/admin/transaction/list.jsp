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
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <style>
        .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .status-initiated, .status-pending { background: #ffc107; color: #333; }
        .status-completed, .status-delivered { background: #28a745; color: white; }
        .status-cancelled, .status-refunded { background: #6c757d; color: white; }
        .status-disputed { background: #dc3545; color: white; }
        .product-thumb { width: 40px; height: 40px; object-fit: cover; border-radius: 5px; }
        .stats-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 15px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 10px; padding: 15px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .stat-value { font-size: 28px; font-weight: 700; color: #667eea; }
        .filter-section { background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .dataTables_wrapper .paginate_button.current { background: #667eea !important; border-color: #667eea !important; color: white !important; }
        .dt-buttons .btn { background: #667eea; color: white; margin-right: 5px; }
    </style>
</head>
<body>
    <c:set var="activePage" value="transactions" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-credit-card me-2"></i>Manage Transactions</h2>
                <a href="${pageContext.request.contextPath}/admin/transactions/revenue" class="btn btn-success"><i class="fas fa-chart-line me-2"></i>Revenue Report</a>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card"><div class="stat-value">${totalTransactions}</div><div class="text-muted">Total</div></div>
                <div class="stat-card"><div class="stat-value">${completedCount}</div><div class="text-muted">Completed</div></div>
                <div class="stat-card"><div class="stat-value">${pendingCount}</div><div class="text-muted">Pending</div></div>
                <div class="stat-card"><div class="stat-value">${deliveredCount}</div><div class="text-muted">Delivered</div></div>
                <div class="stat-card"><div class="stat-value">${cancelledCount}</div><div class="text-muted">Cancelled</div></div>
                <div class="stat-card"><div class="stat-value">${disputedCount}</div><div class="text-muted">Disputed</div></div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/transactions" method="get" class="row g-3">
                    <div class="col-md-3"><label>Status</label><select name="status" class="form-select"><option value="">All</option><option value="COMPLETED">Completed</option><option value="PENDING">Pending</option><option value="DELIVERED">Delivered</option><option value="CANCELLED">Cancelled</option></select></div>
                    <div class="col-md-3"><label>Buyer ID</label><input type="number" class="form-control" name="buyerId" value="${selectedBuyerId}"></div>
                    <div class="col-md-3"><label>Seller ID</label><input type="number" class="form-control" name="sellerId" value="${selectedSellerId}"></div>
                    <div class="col-md-3 d-flex align-items-end"><button type="submit" class="btn btn-primary w-100"><i class="fas fa-filter me-2"></i>Apply Filters</button></div>
                </form>
            </div>

            <!-- Transactions Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="transactionsTable">
                    <thead class="table-dark">
                        <tr><th>ID</th><th>Product</th><th>Buyer</th><th>Seller</th><th>Amount</th><th>Payment</th><th>Status</th><th>Date</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="txn" items="${transactions}">
                            <tr>
                                <td>#${txn.transactionId}</td>
                                <td><div class="d-flex align-items-center"><img src="${not empty txn.listing.images ? txn.listing.images[0].imageUrl : 'https://via.placeholder.com/40'}" class="product-thumb me-2"><strong>${txn.listing.listingName}</strong></div></td>
                                <td>${txn.buyer.firstName} ${txn.buyer.lastName}<br><small class="text-muted">ID: ${txn.buyer.userId}</small></td>
                                <td>${txn.seller.firstName} ${txn.seller.lastName}<br><small class="text-muted">ID: ${txn.seller.userId}</small></td>
                                <td><strong>₹<fmt:formatNumber value="${txn.finalPrice}" pattern="#,##0.00"/></strong><br><small>Fee: ₹<fmt:formatNumber value="${txn.transactionFee}" pattern="#,##0.00"/></small></td>
                                <td><span class="badge bg-info">${txn.paymentMode}</span></td>
                                <td><span class="status-badge status-${fn:toLowerCase(txn.transactionStatus)}">${txn.transactionStatus}</span></td>
                                <td>${txn.createdAt}</td>
                                <td><a href="${pageContext.request.contextPath}/admin/transactions/view/${txn.transactionId}" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/transactions/delete/${txn.transactionId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')"><i class="fas fa-trash"></i></a></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty transactions}"><tr><td colspan="9" class="text-center py-4"><h5>No Transactions Found</h5></td></tr></c:if>
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
            if ($('#transactionsTable tbody tr').length > 0) {
                $('#transactionsTable').DataTable({
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