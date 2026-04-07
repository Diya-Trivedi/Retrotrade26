<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - Retrotrade Admin</title>
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
        .status-active {
            background: #28a745;
            color: white;
        }
        .status-inactive {
            background: #dc3545;
            color: white;
        }
        .action-btn {
            padding: 5px 10px;
            border-radius: 5px;
            margin: 0 2px;
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
    <c:set var="activePage" value="categories" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-tags me-2"></i>Manage Categories</h2>
                <a href="${pageContext.request.contextPath}/admin/category/add" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Add New Category
                </a>
            </div>

            <!-- Categories Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="categoriesTable">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Category Name</th>
                            <th>Subcategories</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="category" items="${categories}">
                            <tr>
                                <td>${category.categoryId}</td>
                                <td><strong>${category.categoryName}</strong></td>
                                <td><span class="badge bg-info">${category.subCategories.size()}</span></td>
                                <td>
                                    <span class="status-badge ${category.active ? 'status-active' : 'status-inactive'}">
                                        ${category.active ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>${category.createdAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/category/view/${category.categoryId}" 
                                       class="btn btn-sm btn-info action-btn" title="View">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/category/edit/${category.categoryId}" 
                                       class="btn btn-sm btn-warning action-btn" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/category/toggle-status/${category.categoryId}" 
                                       class="btn btn-sm ${category.active ? 'btn-secondary' : 'btn-success'} action-btn" 
                                       title="${category.active ? 'Deactivate' : 'Activate'}"
                                       onclick="return confirm('Are you sure you want to ${category.active ? 'deactivate' : 'activate'} this category?')">
                                        <i class="fas ${category.active ? 'fa-times-circle' : 'fa-check-circle'}"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/category/delete/${category.categoryId}" 
                                       class="btn btn-sm btn-danger action-btn" 
                                       title="Delete"
                                       onclick="return confirm('Are you sure you want to delete this category?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty categories}">
                            <tr>
                                <td colspan="6" class="text-center py-4">
                                    <i class="fas fa-folder-open fa-3x text-muted mb-3"></i>
                                    <h5>No Categories Found</h5>
                                    <a href="${pageContext.request.contextPath}/admin/category/add" class="btn btn-primary">
                                        <i class="fas fa-plus me-2"></i>Add Category
                                    </a>
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
            if ($('#categoriesTable tbody tr').length > 0) {
                $('#categoriesTable').DataTable({
                    pageLength: 10,
                    lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    responsive: true,
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
                    order: [[0, 'asc']], // Sort by ID ascending
                    columnDefs: [
                        { orderable: false, targets: [5] } // Disable sorting on Actions column
                    ]
                });
            }
        });
    </script>
</body>
</html>