<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Category - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <c:set var="activePage" value="categories" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4><i class="fas fa-tag me-2"></i>Category Details</h4>
                </div>
                <div class="card-body">
                    <table class="table">
                        <tr>
                            <th style="width: 200px;">Category ID:</th>
                            <td>${category.categoryId}</td>
                        </tr>
                        <tr>
                            <th>Category Name:</th>
                            <td>${category.categoryName}</td>
                        </tr>
                        <tr>
                            <th>Description:</th>
                            <td>${category.description != null ? category.description : 'No description'}</td>
                        </tr>
                        <tr>
                            <th>Status:</th>
                            <td>
                                <span class="badge ${category.active ? 'bg-success' : 'bg-danger'}">
                                    ${category.active ? 'Active' : 'Inactive'}
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>Created:</th>
                            <td>${category.createdAt}</td>
                        </tr>
                        <tr>
                            <th>Subcategories:</th>
                            <td>${category.subCategories.size()}</td>
                        </tr>
                    </table>
                    
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/admin/category/edit/${category.categoryId}" class="btn btn-warning">
                            <i class="fas fa-edit me-2"></i>Edit
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>