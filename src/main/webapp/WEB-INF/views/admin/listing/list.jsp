<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Listings - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <style>
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
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
        .status-pending {
            background: #ffc107;
            color: #333;
        }
        .thumbnail {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        /* DataTables custom styling */
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter {
            margin-bottom: 20px;
        }
        .dataTables_wrapper .dataTables_paginate {
            margin-top: 20px;
        }
        .dataTables_wrapper .dataTables_info {
            margin-top: 15px;
            color: #6c757d;
        }
        .dataTables_wrapper .paginate_button.current {
            background: #667eea !important;
            border-color: #667eea !important;
            color: white !important;
        }
        .dataTables_wrapper .paginate_button:hover {
            background: #764ba2 !important;
            border-color: #764ba2 !important;
            color: white !important;
        }
        .dt-buttons {
            margin-bottom: 20px;
        }
        .dt-buttons .btn {
            background: #667eea;
            color: white;
            border: none;
            margin-right: 5px;
        }
        .dt-buttons .btn:hover {
            background: #764ba2;
        }
        /* Sorting icons styling */
        .dataTables_wrapper .sorting:before,
        .dataTables_wrapper .sorting:after,
        .dataTables_wrapper .sorting_asc:after,
        .dataTables_wrapper .sorting_desc:after {
            color: #667eea;
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="products" scope="request"/>
    <c:set var="subPage" value="${param.status == 'ACTIVE' ? 'active-listings' : 
                                    (param.status == 'SOLD' ? 'sold-listings' : 
                                    (param.status == 'REJECTED' ? 'rejected-listings' : 'all-listings'))}" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-box me-2"></i>Manage Listings</h2>
            </div>

            <!-- Statistics Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-primary">${activeCount}</h3>
                        <p class="text-muted mb-0">Active Listings</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-secondary">${soldCount}</h3>
                        <p class="text-muted mb-0">Sold</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-danger">${rejectedCount}</h3>
                        <p class="text-muted mb-0">Rejected</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card">
                        <h3 class="text-success">${listings.size()}</h3>
                        <p class="text-muted mb-0">Total Displayed</p>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <form action="${pageContext.request.contextPath}/admin/listings" method="get" class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Filter by Status</label>
                        <select name="status" class="form-select">
                            <option value="">All Status</option>
                            <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="SOLD" ${param.status == 'SOLD' ? 'selected' : ''}>Sold</option>
                            <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Filter by Category</label>
                        <select name="categoryId" class="form-select">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Apply Filters
                        </button>
                    </div>
                </form>
            </div>

            <!-- Listings Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="listingsTable">
                    <thead class="table-dark">
                        <tr>
                            <th>Image</th>
                            <th>ID</th>
                            <th>Product Name</th>
                            <th>Seller</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Views</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="listing" items="${listings}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty listing.images and not empty listing.images[0]}">
                                            <img src="${listing.images[0].imageUrl}" class="thumbnail" alt="Product">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/50" class="thumbnail" alt="No image">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="sorting_1">${listing.listingId}</td>
                                <td>
                                    <strong>${listing.listingName}</strong><br>
                                    <small class="text-muted">${listing.brand}</small>
                                </td>
                                <td>
                                    ${listing.seller.firstName} ${listing.seller.lastName}<br>
                                    <small class="text-muted">${listing.seller.email}</small>
                                </td>
                                <td>
                                    <span class="badge bg-info">${listing.category.categoryName}</span><br>
                                    <small>${listing.subCategory.subCategoryName}</small>
                                </td>
                                <td><strong>₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/></strong></td>
                                <td>
                                    <span class="status-badge status-${listing.status.toLowerCase()}">
                                        ${listing.status}
                                    </span>
                                </td>
                                <td>${listing.viewCount}</td>
                                <td>${listing.createdAt}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/admin/listings/view/${listing.listingId}" 
                                           class="btn btn-sm btn-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <c:if test="${listing.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/admin/listings/mark-sold/${listing.listingId}" 
                                               class="btn btn-sm btn-success" title="Mark as Sold"
                                               onclick="return confirm('Mark this listing as sold?')">
                                                <i class="fas fa-check-circle"></i>
                                            </a>
                                        </c:if>
                                        <c:if test="${listing.status == 'PENDING'}">
                                            <a href="${pageContext.request.contextPath}/admin/listings/approve/${listing.listingId}" 
                                               class="btn btn-sm btn-success" title="Approve">
                                                <i class="fas fa-check"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/listings/reject/${listing.listingId}" 
                                               class="btn btn-sm btn-danger" title="Reject"
                                               onclick="return confirm('Reject this listing?')">
                                                <i class="fas fa-times"></i>
                                            </a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/admin/listings/delete/${listing.listingId}" 
                                           class="btn btn-sm btn-danger" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this listing?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                 </td>
                             </tr>
                        </c:forEach>
                        
                        <c:if test="${empty listings}">
                             <tr>
                                <td colspan="10" class="text-center py-5">
                                    <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                                    <h5>No Listings Found</h5>
                                    <p class="text-muted">No listings match your filter criteria.</p>
                                </td>
                             </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
    
    <!-- jQuery first, then DataTables -->
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
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.colVis.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            if ($('#listingsTable tbody tr').length > 0) {
                $('#listingsTable').DataTable({
                    pageLength: 10,
                    lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    responsive: true,
                    language: {
                        search: "Search:",
                        lengthMenu: "Show _MENU_ entries",
                        info: "Showing _START_ to _END_ of _TOTAL_ entries",
                        infoEmpty: "Showing 0 to 0 of 0 entries",
                        infoFiltered: "(filtered from _MAX_ total entries)",
                        paginate: {
                            first: "First",
                            last: "Last",
                            next: "Next",
                            previous: "Previous"
                        },
                        zeroRecords: "No matching records found"
                    },
                    dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>' +
                         '<"row"<"col-sm-12"B>>' +
                         '<"row"<"col-sm-12"tr>>' +
                         '<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                    buttons: [
                        {
                            extend: 'copy',
                            text: '<i class="fas fa-copy"></i> Copy',
                            className: 'btn btn-sm btn-outline-primary'
                        },
                        {
                            extend: 'csv',
                            text: '<i class="fas fa-file-csv"></i> CSV',
                            className: 'btn btn-sm btn-outline-primary'
                        },
                        {
                            extend: 'excel',
                            text: '<i class="fas fa-file-excel"></i> Excel',
                            className: 'btn btn-sm btn-outline-primary'
                        },
                        {
                            extend: 'pdf',
                            text: '<i class="fas fa-file-pdf"></i> PDF',
                            className: 'btn btn-sm btn-outline-primary'
                        },
                        {
                            extend: 'print',
                            text: '<i class="fas fa-print"></i> Print',
                            className: 'btn btn-sm btn-outline-primary'
                        }
                    ],
                    columnDefs: [
                        { 
                            orderable: false, 
                            targets: [0, 9] // Disable sorting on image (col 0) and actions (col 9)
                        },
                        {
                            orderable: true,
                            targets: [1, 2, 3, 4, 5, 6, 7, 8] // Enable sorting on other columns
                        }
                    ],
                    order: [[1, 'asc']], // Sort by ID column (index 1) in ASCENDING order (1 to 10)
                    // Custom sorting for numeric columns
                    columns: [
                        null, // Image - no sorting
                        { type: 'num' }, // ID - numeric sorting (ascending by default)
                        { type: 'html' }, // Product Name - HTML content
                        { type: 'html' }, // Seller - HTML content
                        { type: 'html' }, // Category - HTML content
                        { type: 'num' }, // Price - numeric sorting
                        { type: 'html' }, // Status - HTML content
                        { type: 'num' }, // Views - numeric sorting
                        { type: 'date' }, // Created - date sorting
                        null // Actions - no sorting
                    ]
                });
                
                // Apply custom styling for sorted column
                $('#listingsTable').on('draw.dt', function() {
                    $('.dataTables_wrapper .sorting_asc, .dataTables_wrapper .sorting_desc').css('color', '#667eea');
                });
            } else {
                console.log("No data to initialize DataTable");
            }
        });
    </script>
    
    <!-- Your existing JS files -->
    <script src="assets/vendors/js/vendor.bundle.base.js"></script>
    <script src="assets/vendors/chart.js/chart.umd.js"></script>
    <script src="assets/js/dataTables.select.min.js"></script>
    <script src="assets/js/off-canvas.js"></script>
    <script src="assets/js/template.js"></script>
    <script src="assets/js/settings.js"></script>
    <script src="assets/js/todolist.js"></script>
    <script src="assets/js/jquery.cookie.js" type="text/javascript"></script>
    <script src="assets/js/dashboard.js"></script>
</body>
</html>