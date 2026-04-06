<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Subcategory - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .page-header {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .info-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
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
            <div class="page-header">
                <h4 class="mb-1"><i class="fas fa-edit me-2 text-primary"></i>Edit Subcategory</h4>
                <p class="text-muted mb-0">Update subcategory information</p>
            </div>

            <div class="form-container">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <!-- Subcategory Info -->
                <div class="info-section">
                    <small class="text-muted">Subcategory ID: #${subcategory.subCategoryId}</small>
                    <br>
                    <small class="text-muted">Created: ${subcategory.createdAt}</small>
                </div>
                
                <form action="${pageContext.request.contextPath}/admin/subcategory/update" method="post">
                    <input type="hidden" name="subCategoryId" value="${subcategory.subCategoryId}">
                    
                    <div class="mb-3">
                        <label class="form-label">Select Category <span class="text-danger">*</span></label>
                        <select class="form-select" name="categoryId" required>
                            <option value="">-- Select Category --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${cat.categoryId == subcategory.category.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Subcategory Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="subCategoryName" value="${subcategory.subCategoryName}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3">${subcategory.description}</textarea>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" name="active" id="active" ${subcategory.active ? 'checked' : ''}>
                            <label class="form-check-label" for="active">Active (Visible to users)</label>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Update Subcategory
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/subcategory/list" class="btn btn-secondary">
                            <i class="fas fa-times me-2"></i>Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />
</body>
</html>