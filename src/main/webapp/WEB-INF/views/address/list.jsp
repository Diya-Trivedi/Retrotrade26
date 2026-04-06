<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Addresses - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .address-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .address-header h2 {
            color: #333;
            font-weight: 600;
        }
        .btn-add {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.3s;
        }
        .btn-add:hover {
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .address-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 20px;
            height: 100%;
            transition: transform 0.3s;
            position: relative;
        }
        .address-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .default-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .address-type {
            display: inline-block;
            background: #e9ecef;
            color: #495057;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .address-details {
            margin-top: 15px;
        }
        .address-details p {
            margin-bottom: 5px;
            color: #666;
        }
        .address-details .name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .address-actions {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .btn-action {
            padding: 5px 15px;
            border-radius: 5px;
            font-size: 14px;
            text-decoration: none;
            margin-right: 10px;
            transition: all 0.3s;
        }
        .btn-edit {
            background: #007bff;
            color: white;
        }
        .btn-edit:hover {
            background: #0056b3;
            color: white;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .btn-delete:hover {
            background: #c82333;
            color: white;
        }
        .btn-default {
            background: #28a745;
            color: white;
        }
        .btn-default:hover {
            background: #218838;
            color: white;
        }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .empty-state {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .empty-state i {
            font-size: 60px;
            color: #667eea;
            margin-bottom: 20px;
        }
        .empty-state h3 {
            color: #333;
            margin-bottom: 10px;
        }
        .empty-state p {
            color: #666;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="address-container">
        <!-- Display success message -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        
        <!-- Display error message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <div class="address-header">
            <h2><i class="fas fa-map-marker-alt me-2"></i>My Addresses</h2>
            <a href="${pageContext.request.contextPath}/address/add" class="btn-add">
                <i class="fas fa-plus me-2"></i>Add New Address
            </a>
        </div>
        
        <c:choose>
            <c:when test="${empty addressList}">
                <div class="empty-state">
                    <i class="fas fa-map-marker-alt"></i>
                    <h3>No Addresses Found</h3>
                    <p>You haven't added any addresses yet. Add your first address to get started!</p>
                    <a href="${pageContext.request.contextPath}/address/add" class="btn-add">
                        <i class="fas fa-plus me-2"></i>Add Address
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="address" items="${addressList}">
                        <div class="col-md-6 col-lg-4 mb-4">
                            <div class="address-card">
                                <c:if test="${address.isDefault}">
                                    <span class="default-badge">
                                        <i class="fas fa-check-circle me-1"></i>Default
                                    </span>
                                </c:if>
                                
                                <span class="address-type">
                                    <i class="fas fa-${address.addressType == 'HOME' ? 'home' : 'building'} me-1"></i>
                                    ${address.addressType}
                                </span>
                                
                                <div class="address-details">
                                    <div class="name">${address.fullName}</div>
                                    <p><i class="fas fa-phone me-2"></i>${address.mobileNo}</p>
                                    <p><i class="fas fa-map-pin me-2"></i>${address.addressLine1}</p>
                                    <p><i class="fas fa-city me-2"></i>${address.city}, ${address.state}</p>
                                    <p><i class="fas fa-mail-bulk me-2"></i>${address.pincode}</p>
                                </div>
                                
                                <div class="address-actions">
                                    <a href="${pageContext.request.contextPath}/address/edit/${address.addressId}" 
                                       class="btn-action btn-edit">
                                        <i class="fas fa-edit me-1"></i>Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/address/delete/${address.addressId}" 
                                       class="btn-action btn-delete"
                                       onclick="return confirm('Are you sure you want to delete this address?')">
                                        <i class="fas fa-trash me-1"></i>Delete
                                    </a>
                                    <c:if test="${!address.isDefault}">
                                        <a href="${pageContext.request.contextPath}/address/set-default/${address.addressId}" 
                                           class="btn-action btn-default">
                                            <i class="fas fa-star me-1"></i>Set Default
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>