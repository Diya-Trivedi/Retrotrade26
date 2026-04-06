<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - Retrotrade Admin</title>
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
        .action-btn {
            padding: 5px 10px;
            border-radius: 5px;
            margin: 0 2px;
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
                <table class="table table-hover table-striped">
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
                                <td>
                                    <span class="badge bg-info">${category.subCategories.size()}</span>
                                </td>
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
                                       onclick="return confirm('Are you sure you want to delete this category? This will also delete all associated subcategories.')">
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
</body>
</html>