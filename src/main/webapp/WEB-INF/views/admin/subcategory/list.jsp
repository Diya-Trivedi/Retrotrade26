<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Subcategories - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    <style>
        .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-active { background: #28a745; color: white; }
        .status-inactive { background: #dc3545; color: white; }
        .category-badge { background: #667eea; color: white; padding: 5px 10px; border-radius: 20px; font-size: 11px; }
        .action-btn { padding: 5px 10px; margin: 0 2px; }
        .filter-section { background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .dataTables_wrapper .paginate_button.current { background: #667eea !important; border-color: #667eea !important; color: white !important; }
        .dt-buttons .btn { background: #667eea; color: white; margin-right: 5px; }
    </style>
</head>
<body>
    <c:set var="activePage" value="subcategories" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-sitemap me-2"></i>Manage Subcategories</h2>
                <a href="${pageContext.request.contextPath}/admin/subcategory/add" class="btn btn-primary"><i class="fas fa-plus me-2"></i>Add New Subcategory</a>
            </div>

            <!-- Subcategories Table -->
            <div class="table-responsive">
                <table class="table table-hover table-striped" id="subcategoriesTable">
                    <thead class="table-dark">
                        <tr><th>ID</th><th>Subcategory Name</th><th>Category</th><th>Products</th><th>Status</th><th>Created</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sub" items="${subcategories}">
                            <tr>
                                <td>${sub.subCategoryId}</td>
                                <td><strong>${sub.subCategoryName}</strong></td>
                                <td><span class="category-badge"><i class="fas fa-tag me-1"></i>${sub.category.categoryName}</span></td>
                                <td><span class="badge bg-info">${sub.listings.size()} Products</span></td>
                                <td><span class="status-badge ${sub.active ? 'status-active' : 'status-inactive'}">${sub.active ? 'Active' : 'Inactive'}</span></td>
                                <td>${sub.createdAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/subcategory/view/${sub.subCategoryId}" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/subcategory/edit/${sub.subCategoryId}" class="btn btn-sm btn-warning"><i class="fas fa-edit"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/subcategory/toggle-status/${sub.subCategoryId}" class="btn btn-sm ${sub.active ? 'btn-secondary' : 'btn-success'}" onclick="return confirm('${sub.active ? 'Deactivate' : 'Activate'}?')"><i class="fas ${sub.active ? 'fa-times-circle' : 'fa-check-circle'}"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/subcategory/delete/${sub.subCategoryId}" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')"><i class="fas fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty subcategories}"><tr><td colspan="7" class="text-center py-4"><h5>No Subcategories Found</h5><a href="${pageContext.request.contextPath}/admin/subcategory/add" class="btn btn-primary mt-2">Add Subcategory</a></td></tr></c:if>
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
            if ($('#subcategoriesTable tbody tr').length > 0) {
                $('#subcategoriesTable').DataTable({
                    pageLength: 10, lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    responsive: true, order: [[0, 'asc']],
                    language: { search: "Search:", lengthMenu: "Show _MENU_ entries", info: "Showing _START_ to _END_ of _TOTAL_ entries" },
                    dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>><"row"<"col-sm-12"B>><"row"<"col-sm-12"tr>><"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                    columnDefs: [{ orderable: false, targets: [6] }]
                });
            }
        });
    </script>
</body>
</html>