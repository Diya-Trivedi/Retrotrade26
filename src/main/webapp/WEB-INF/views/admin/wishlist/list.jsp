<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist Management - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #667eea;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        .product-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
        }
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .dataTables_wrapper .paginate_button.current {
            background: #667eea !important;
            border-color: #667eea !important;
            color: white !important;
        }
        .dt-buttons .btn {
            background: #667eea;
            color: white;
            margin-right: 5px;
        }
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .top-list {
            max-height: 300px;
            overflow-y: auto;
        }
        .top-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .top-item:hover {
            background: #f8f9fa;
        }
        .rank-badge {
            width: 30px;
            height: 30px;
            background: #667eea;
            color: white;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }
        .rank-1 { background: #ffd700; color: #333; }
        .rank-2 { background: #c0c0c0; color: #333; }
        .rank-3 { background: #cd7f32; color: white; }
    </style>
</head>
<body>
    <c:set var="activePage" value="wishlist" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-heart me-2 text-danger"></i>Wishlist Management</h2>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">${totalWishlistItems}</div>
                    <div class="stat-label">Total Wishlist Items</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${totalUsersWithWishlist}</div>
                    <div class="stat-label">Users with Wishlist</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <fmt:formatNumber value="${totalWishlistItems / (totalUsersWithWishlist > 0 ? totalUsersWithWishlist : 1)}" pattern="#.0"/>
                    </div>
                    <div class="stat-label">Avg Items/User</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">#${mostSavedListingId}</div>
                    <div class="stat-label">Most Saved Listing ID</div>
                </div>
            </div>

            
            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/wishlist" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label"><i class="fas fa-user me-1"></i>Filter by User ID</label>
                        <input type="number" class="form-control" name="userId" value="${selectedUserId}" placeholder="Enter User ID">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><i class="fas fa-search me-1"></i>Search by Product</label>
                        <input type="text" class="form-control" name="search" value="${searchKeyword}" placeholder="Product name...">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Apply Filters
                        </button>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <a href="${pageContext.request.contextPath}/admin/wishlist" class="btn btn-secondary w-100">
                            <i class="fas fa-sync-alt me-2"></i>Reset
                        </a>
                    </div>
                </form>
            </div>

            <!-- Wishlist Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="wishlistTable">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Product</th>
                            <th>User</th>
                            <th>User Email</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Added On</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${wishlistItems}">
                            <tr>
                                <td>#${item.wishlistId}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <c:choose>
                                            <c:when test="${not empty item.listing.images and not empty item.listing.images[0]}">
                                                <img src="${item.listing.images[0].imageUrl}" class="product-thumb me-2" alt="${item.listing.listingName}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://via.placeholder.com/50" class="product-thumb me-2" alt="No image">
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <strong>${item.listing.listingName}</strong>
                                            <br><small class="text-muted">ID: ${item.listing.listingId}</small>
                                        </div>
                                    </div>
                                 </td>
                                 <td>
                                    <strong>${item.user.firstName} ${item.user.lastName}</strong>
                                    <br><small class="text-muted">ID: ${item.user.userId}</small>
                                 </td>
                                 <td>${item.user.email}</td>
                                 <td><strong>₹<fmt:formatNumber value="${item.listing.price}" pattern="#,##0"/></strong></td>
                                 <td>
                                    <span class="badge ${item.listing.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                        ${item.listing.status}
                                    </span>
                                 </td>
                                 <td>${item.addedAt}</td>
                                 <td>
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/listings/${item.listing.listingId}" 
                                           class="btn btn-sm btn-info" title="View Product" target="_blank">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/wishlist/user/${item.user.userId}" 
                                           class="btn btn-sm btn-primary" title="View User's Wishlist">
                                            <i class="fas fa-user"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/wishlist/remove/${item.wishlistId}" 
                                           class="btn btn-sm btn-danger" title="Remove from Wishlist"
                                           onclick="return confirm('Remove this item from user\'s wishlist?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                 </td>
                             </tr>
                        </c:forEach>
                        
                        <c:if test="${empty wishlistItems}">
                             <tr>
                                <td colspan="8" class="text-center py-5">
                                    <i class="fas fa-heart-broken fa-4x text-muted mb-3"></i>
                                    <h5>No Wishlist Items Found</h5>
                                    <p class="text-muted">No items match your filter criteria.</p>
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
            if ($('#wishlistTable tbody tr').length > 0 && $('#wishlistTable tbody tr td').length > 1) {
                $('#wishlistTable').DataTable({
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

        // Wishlist Distribution Chart
        const ctx = document.getElementById('wishlistChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['0-5', '6-10', '11-15', '16-20', '20+'],
                datasets: [{
                    label: 'Number of Users',
                    data: [
                        <c:set var="range1" value="0"/><c:set var="range2" value="0"/><c:set var="range3" value="0"/><c:set var="range4" value="0"/><c:set var="range5" value="0"/>
                        <c:forEach var="user" items="${topUsers}">
                            <c:set var="count" value="${user[1]}"/>
                            <c:choose>
                                <c:when test="${count <= 5}"><c:set var="range1" value="${range1 + 1}"/></c:when>
                                <c:when test="${count <= 10}"><c:set var="range2" value="${range2 + 1}"/></c:when>
                                <c:when test="${count <= 15}"><c:set var="range3" value="${range3 + 1}"/></c:when>
                                <c:when test="${count <= 20}"><c:set var="range4" value="${range4 + 1}"/></c:when>
                                <c:otherwise><c:set var="range5" value="${range5 + 1}"/></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        ${range1}, ${range2}, ${range3}, ${range4}, ${range5}
                    ],
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
                    tooltip: { callbacks: { label: (ctx) => `${ctx.raw} users` } }
                }
            }
        });
    </script>
</body>
</html>