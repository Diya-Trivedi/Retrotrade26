<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reviews - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .rating-stars { color: #ffc107; font-size: 14px; }
        .rating-stars i { margin-right: 2px; }
        .review-card { background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .stats-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 15px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 10px; padding: 15px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .stat-value { font-size: 28px; font-weight: 700; color: #667eea; }
        .stat-label { color: #666; font-size: 13px; }
        .filter-section { background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .review-text { max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .dataTables_wrapper .paginate_button.current { background: #667eea !important; border-color: #667eea !important; color: white !important; }
        .dt-buttons .btn { background: #667eea; color: white; margin-right: 5px; }
        .chart-container { background: white; border-radius: 10px; padding: 20px; margin-bottom: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <c:set var="activePage" value="reviews" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-star me-2"></i>Manage Reviews</h2>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card"><div class="stat-value">${totalReviews}</div><div class="stat-label">Total Reviews</div></div>
                <div class="stat-card"><div class="stat-value"><fmt:formatNumber value="${averageRating}" pattern="#.0"/></div><div class="stat-label">Average Rating</div></div>
                <div class="stat-card"><div class="stat-value">${rating5Count}</div><div class="stat-label">5 Star</div></div>
                <div class="stat-card"><div class="stat-value">${rating4Count}</div><div class="stat-label">4 Star</div></div>
                <div class="stat-card"><div class="stat-value">${rating3Count}</div><div class="stat-label">3 Star</div></div>
                <div class="stat-card"><div class="stat-value">${rating2Count}</div><div class="stat-label">2 Star</div></div>
                <div class="stat-card"><div class="stat-value">${rating1Count}</div><div class="stat-label">1 Star</div></div>
            </div>

            <!-- Charts Row -->
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-pie me-2 text-primary"></i>Rating Distribution</h5>
                        <canvas id="ratingPieChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-bar me-2 text-primary"></i>Rating Bar Chart</h5>
                        <canvas id="ratingBarChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/reviews" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Filter by Rating</label>
                        <select name="rating" class="form-select">
                            <option value="">All Ratings</option>
                            <option value="5" ${selectedRating == 5 ? 'selected' : ''}>5 Star - Excellent</option>
                            <option value="4" ${selectedRating == 4 ? 'selected' : ''}>4 Star - Good</option>
                            <option value="3" ${selectedRating == 3 ? 'selected' : ''}>3 Star - Average</option>
                            <option value="2" ${selectedRating == 2 ? 'selected' : ''}>2 Star - Poor</option>
                            <option value="1" ${selectedRating == 1 ? 'selected' : ''}>1 Star - Terrible</option>
                        </select>
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
                    <div class="col-md-3 d-flex align-items-end">
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-secondary w-100">
                            <i class="fas fa-sync-alt me-2"></i>Reset
                        </a>
                    </div>
                </form>
            </div>

            <!-- Reviews Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="reviewsTable">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Product</th>
                            <th>Seller</th>
                            <th>Buyer</th>
                            <th>Rating</th>
                            <th>Review</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="review" items="${reviews}">
                            <tr>
                                <td>#${review.reviewId}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <c:choose>
                                            <c:when test="${not empty review.listing and not empty review.listing.images and not empty review.listing.images[0]}">
                                                <img src="${review.listing.images[0].imageUrl}" class="product-thumb me-2" style="width: 40px; height: 40px; object-fit: cover; border-radius: 5px;">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://via.placeholder.com/40" class="product-thumb me-2" style="width: 40px; height: 40px; object-fit: cover; border-radius: 5px;">
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <strong>${review.listing.listingName}</strong>
                                            <br><small class="text-muted">ID: #${review.listing.listingId}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    ${review.seller.firstName} ${review.seller.lastName}
                                    <br><small class="text-muted">ID: ${review.seller.userId}</small>
                                </td>
                                <td>
                                    ${review.buyer.firstName} ${review.buyer.lastName}
                                    <br><small class="text-muted">ID: ${review.buyer.userId}</small>
                                </td>
                                <td>
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="${review.rating}">
                                            <i class="fas fa-star"></i>
                                        </c:forEach>
                                        <c:forEach begin="${review.rating + 1}" end="5">
                                            <i class="far fa-star"></i>
                                        </c:forEach>
                                        <span class="ms-2">(${review.rating}/5)</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="review-text" title="${review.comment}">
                                        ${review.comment}
                                    </div>
                                </td>
                                <td>${review.createdAt}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/admin/reviews/view/${review.reviewId}" 
                                           class="btn btn-sm btn-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/reviews/delete/${review.reviewId}" 
                                           class="btn btn-sm btn-danger" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this review?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty reviews}">
                            <tr>
                                <td colspan="8" class="text-center py-5">
                                    <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                    <h5>No Reviews Found</h5>
                                    <p class="text-muted">No reviews match your filter criteria.</p>
                                </td>
                            </tr>
                        </c:if>
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
            if ($('#reviewsTable tbody tr').length > 0 && $('#reviewsTable tbody tr td').length > 1) {
                $('#reviewsTable').DataTable({
                    pageLength: 10,
                    lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    responsive: true,
                    order: [[0, 'asc']],
                    language: {
                        search: "Search:",
                        lengthMenu: "Show _MENU_ entries",
                        info: "Showing _START_ to _END_ of _TOTAL_ entries",
                        paginate: { previous: "Previous", next: "Next" }
                    },
                    dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>' +
                         '<"row"<"col-sm-12"B>>' +
                         '<"row"<"col-sm-12"tr>>' +
                         '<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                    columnDefs: [
                        { orderable: false, targets: [7] } // Actions column
                    ]
                });
            }
        });

        // Rating Distribution Pie Chart
        const ctxPie = document.getElementById('ratingPieChart').getContext('2d');
        new Chart(ctxPie, {
            type: 'pie',
            data: {
                labels: ['5 Star', '4 Star', '3 Star', '2 Star', '1 Star'],
                datasets: [{
                    data: [${rating5Count}, ${rating4Count}, ${rating3Count}, ${rating2Count}, ${rating1Count}],
                    backgroundColor: ['#28a745', '#17a2b8', '#ffc107', '#fd7e14', '#dc3545'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: { callbacks: { label: (ctx) => `${ctx.label}: ${ctx.raw} reviews` } }
                }
            }
        });

        // Rating Bar Chart
        const ctxBar = document.getElementById('ratingBarChart').getContext('2d');
        new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: ['5 Star', '4 Star', '3 Star', '2 Star', '1 Star'],
                datasets: [{
                    label: 'Number of Reviews',
                    data: [${rating5Count}, ${rating4Count}, ${rating3Count}, ${rating2Count}, ${rating1Count}],
                    backgroundColor: ['#28a745', '#17a2b8', '#ffc107', '#fd7e14', '#dc3545'],
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                },
                plugins: {
                    legend: { display: false },
                    tooltip: { callbacks: { label: (ctx) => `${ctx.raw} reviews` } }
                }
            }
        });
    </script>
    
    <style>
        .product-thumb { width: 40px; height: 40px; object-fit: cover; border-radius: 5px; }
        .rating-stars { color: #ffc107; font-size: 14px; }
        .review-text { max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .dataTables_wrapper .paginate_button.current { background: #667eea !important; border-color: #667eea !important; color: white !important; }
        .dt-buttons .btn { background: #667eea; color: white; margin-right: 5px; }
    </style>
</body>
</html>