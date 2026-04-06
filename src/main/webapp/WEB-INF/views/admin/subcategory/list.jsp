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
        .category-badge {
            background: #667eea;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .action-btn {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            margin: 0 2px;
            text-decoration: none;
        }
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .table-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .page-header {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .empty-state {
            text-align: center;
            padding: 50px;
        }
        .empty-state i {
            font-size: 60px;
            color: #ddd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="subcategories" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="mb-1"><i class="fas fa-sitemap me-2 text-primary"></i>Manage Subcategories</h4>
                    <p class="text-muted mb-0">View and manage all product subcategories</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/subcategory/add" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add New Subcategory
                    </a>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Filter by Category</label>
                        <select class="form-select" id="categoryFilter" onchange="filterByCategory()">
                            <option value="all">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}">${cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Filter by Status</label>
                        <select class="form-select" id="statusFilter" onchange="filterByStatus()">
                            <option value="all">All Subcategories</option>
                            <option value="active">Active Only</option>
                            <option value="inactive">Inactive Only</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Search</label>
                        <input type="text" class="form-control" id="searchInput" placeholder="Search subcategories..." onkeyup="searchTable()">
                    </div>
                </div>
            </div>

            <!-- Subcategories Table -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover table-striped" id="subcategoryTable">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Subcategory Name</th>
                                <th>Category</th>
                                <th>Products</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sub" items="${subcategories}">
                                <tr data-category="${sub.category.categoryId}" data-status="${sub.active ? 'active' : 'inactive'}">
                                    <td>${sub.subCategoryId}</td>
                                    <td>
                                        <strong>${sub.subCategoryName}</strong>
                                    </td>
                                    <td>
                                        <span class="category-badge">
                                            <i class="fas fa-tag me-1"></i>${sub.category.categoryName}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">${sub.listings.size()} Products</span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${sub.active ? 'status-active' : 'status-inactive'}">
                                            ${sub.active ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>${sub.createdAt}</td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="${pageContext.request.contextPath}/admin/subcategory/view/${sub.subCategoryId}" 
                                               class="btn btn-sm btn-info action-btn" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/subcategory/edit/${sub.subCategoryId}" 
                                               class="btn btn-sm btn-warning action-btn" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/subcategory/toggle-status/${sub.subCategoryId}" 
                                               class="btn btn-sm ${sub.active ? 'btn-secondary' : 'btn-success'} action-btn" 
                                               title="${sub.active ? 'Deactivate' : 'Activate'}"
                                               onclick="return confirm('Are you sure you want to ${sub.active ? 'deactivate' : 'activate'} this subcategory?')">
                                                <i class="fas ${sub.active ? 'fa-times-circle' : 'fa-check-circle'}"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/subcategory/delete/${sub.subCategoryId}" 
                                               class="btn btn-sm btn-danger action-btn" 
                                               title="Delete"
                                               onclick="return confirm('Are you sure you want to delete this subcategory? This action cannot be undone.')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty subcategories}">
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="fas fa-folder-open"></i>
                                            <h5>No Subcategories Found</h5>
                                            <p class="text-muted">Get started by creating your first subcategory.</p>
                                            <a href="${pageContext.request.contextPath}/admin/subcategory/add" class="btn btn-primary">
                                                <i class="fas fa-plus me-2"></i>Add Subcategory
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        function searchTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("subcategoryTable");
            tr = table.getElementsByTagName("tr");
            
            for (i = 1; i < tr.length; i++) {
                tr[i].style.display = "";
                td = tr[i].getElementsByTagName("td")[1]; // Subcategory name column
                if (td) {
                    txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) == -1) {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
        
        function filterByCategory() {
            var categoryFilter = document.getElementById("categoryFilter").value;
            var statusFilter = document.getElementById("statusFilter").value;
            var table = document.getElementById("subcategoryTable");
            var tr = table.getElementsByTagName("tr");
            
            for (var i = 1; i < tr.length; i++) {
                var category = tr[i].getAttribute("data-category");
                var status = tr[i].getAttribute("data-status");
                
                var categoryMatch = (categoryFilter == "all" || category == categoryFilter);
                var statusMatch = (statusFilter == "all" || status == statusFilter);
                
                if (categoryMatch && statusMatch) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
        
        function filterByStatus() {
            filterByCategory(); // Reuse the same function
        }
    </script>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>