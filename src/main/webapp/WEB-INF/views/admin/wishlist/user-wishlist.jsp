<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Wishlist - ${user.firstName} ${user.lastName} - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <style>
        .user-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
        }
        .product-thumb {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
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
    </style>
</head>
<body>
    <c:set var="activePage" value="wishlist" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Back Button -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/admin/wishlist" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to All Wishlists
                </a>
            </div>

            <!-- User Info Card -->
            <div class="user-card">
                <div class="row align-items-center">
                    <div class="col-auto">
                        <c:choose>
                            <c:when test="${not empty user.profilePicURL}">
                                <img src="${user.profilePicURL}" class="user-avatar" alt="Profile">
                            </c:when>
                            <c:otherwise>
                                <img src="https://via.placeholder.com/80" class="user-avatar" alt="Profile">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col">
                        <h3 class="mb-1">${user.firstName} ${user.lastName}</h3>
                        <p class="mb-1"><i class="fas fa-envelope me-2"></i>${user.email}</p>
                        <p class="mb-0"><i class="fas fa-phone me-2"></i>${user.contactNum}</p>
                    </div>
                    <div class="col-auto">
                        <div class="text-center bg-white rounded p-3">
                            <h2 class="text-primary mb-0">${totalItems}</h2>
                            <small class="text-muted">Wishlist Items</small>
                        </div>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/admin/wishlist/clear-user/${user.userId}" 
                           class="btn btn-danger"
                           onclick="return confirm('Remove ALL items from ${user.firstName} ${user.lastName}\'s wishlist?')">
                            <i class="fas fa-trash-alt me-2"></i>Clear All Items
                        </a>
                    </div>
                </div>
            </div>

            <!-- Wishlist Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="wishlistTable">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Product</th>
                            <th>Category</th>
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
                                                <img src="${item.listing.images[0].imageUrl}" class="product-thumb me-3" alt="${item.listing.listingName}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://via.placeholder.com/60" class="product-thumb me-3" alt="No image">
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <strong>${item.listing.listingName}</strong>
                                            <br><small class="text-muted">Brand: ${item.listing.brand}</small>
                                        </div>
                                    </div>
                                 </td>
                                 <td>
                                    <span class="badge bg-info">${item.listing.category.categoryName}</span>
                                    <br><small>${item.listing.subCategory.subCategoryName}</small>
                                 </td>
                                 <td><strong class="text-primary">₹<fmt:formatNumber value="${item.listing.price}" pattern="#,##0"/></strong></td>
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
                                <td colspan="7" class="text-center py-5">
                                    <i class="fas fa-heart-broken fa-4x text-muted mb-3"></i>
                                    <h5>No Wishlist Items</h5>
                                    <p class="text-muted">This user has no items in their wishlist.</p>
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
            if ($('#wishlistTable tbody tr').length > 0) {
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
                        { orderable: false, targets: [6] } // Actions column
                    ]
                });
            }
        });
    </script>
</body>
</html>