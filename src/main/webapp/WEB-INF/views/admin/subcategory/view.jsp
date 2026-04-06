<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Subcategory - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .view-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .view-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .view-body {
            padding: 30px;
        }
        .info-row {
            display: flex;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            width: 150px;
            color: #666;
            font-weight: 600;
        }
        .info-value {
            flex: 1;
            color: #333;
        }
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
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
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }
        .page-header {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="subcategories" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Breadcrumb -->
            <div class="page-header">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/subcategory/list">Subcategories</a></li>
                        <li class="breadcrumb-item active">${subcategory.subCategoryName}</li>
                    </ol>
                </nav>
            </div>

            <div class="view-card">
                <div class="view-header">
                    <h3><i class="fas fa-sitemap me-2"></i>${subcategory.subCategoryName}</h3>
                </div>
                
                <div class="view-body">
                    <div class="row">
                        <div class="col-md-8 mx-auto">
                            <div class="info-row">
                                <span class="info-label">Subcategory ID:</span>
                                <span class="info-value">#${subcategory.subCategoryId}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Subcategory Name:</span>
                                <span class="info-value">${subcategory.subCategoryName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Category:</span>
                                <span class="info-value">
                                    <span class="category-badge">
                                        <i class="fas fa-tag me-1"></i>${subcategory.category.categoryName}
                                    </span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Description:</span>
                                <span class="info-value">${subcategory.description != null ? subcategory.description : 'No description provided'}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Status:</span>
                                <span class="info-value">
                                    <span class="status-badge ${subcategory.active ? 'status-active' : 'status-inactive'}">
                                        <i class="fas ${subcategory.active ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                        ${subcategory.active ? 'Active' : 'Inactive'}
                                    </span>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Created:</span>
                                <span class="info-value">${subcategory.createdAt}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Total Products:</span>
                                <span class="info-value">
                                    <span class="badge bg-info">${subcategory.listings.size()}</span>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/admin/subcategory/edit/${subcategory.subCategoryId}" class="btn btn-warning">
                            <i class="fas fa-edit me-2"></i>Edit Subcategory
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/subcategory/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to List
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/subcategory/toggle-status/${subcategory.subCategoryId}" 
                           class="btn ${subcategory.active ? 'btn-secondary' : 'btn-success'}"
                           onclick="return confirm('Are you sure you want to ${subcategory.active ? 'deactivate' : 'activate'} this subcategory?')">
                            <i class="fas ${subcategory.active ? 'fa-times-circle' : 'fa-check-circle'} me-2"></i>
                            ${subcategory.active ? 'Deactivate' : 'Activate'}
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>