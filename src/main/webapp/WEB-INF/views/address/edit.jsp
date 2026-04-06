<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Address - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-header h2 {
            color: #333;
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25);
        }
        .btn-update {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            padding: 12px;
            width: 100%;
            cursor: pointer;
            transition: transform 0.3s;
        }
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }
        .btn-cancel {
            background: #6c757d;
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            padding: 12px;
            width: 100%;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            margin-top: 10px;
        }
        .btn-cancel:hover {
            background: #5a6268;
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="form-container">
        <div class="form-card">
            <div class="form-header">
                <h2><i class="fas fa-edit me-2"></i>Edit Address</h2>
                <p class="text-muted">Update your address details</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/address/update" method="post">
                <input type="hidden" name="addressId" value="${address.addressId}">
                
                <div class="form-group">
                    <label class="form-label">Full Name (Receiver's Name)</label>
                    <input type="text" class="form-control" name="fullName" value="${address.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Mobile Number</label>
                    <input type="text" class="form-control" name="mobileNo" value="${address.mobileNo}" 
                           pattern="[0-9]{10}" title="Please enter a valid 10-digit mobile number" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Address Line</label>
                    <input type="text" class="form-control" name="addressLine1" value="${address.addressLine1}" 
                           placeholder="House/Flat No., Building, Street" required>
                </div>
                
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">City</label>
                            <input type="text" class="form-control" name="city" value="${address.city}" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">State</label>
                            <input type="text" class="form-control" name="state" value="${address.state}" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">Pincode</label>
                            <input type="text" class="form-control" name="pincode" value="${address.pincode}" 
                                   pattern="[0-9]{6}" title="Please enter a valid 6-digit pincode" required>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Address Type</label>
                    <select class="form-select" name="addressType" required>
                        <option value="HOME" ${address.addressType == 'HOME' ? 'selected' : ''}>Home</option>
                        <option value="OFFICE" ${address.addressType == 'OFFICE' ? 'selected' : ''}>Office</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" name="setAsDefault" id="setAsDefault" 
                               ${address.isDefault ? 'checked' : ''}>
                        <label class="form-check-label" for="setAsDefault">
                            Set as default address
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn-update">
                    <i class="fas fa-save me-2"></i>Update Address
                </button>
                <a href="${pageContext.request.contextPath}/address/list" class="btn-cancel">
                    <i class="fas fa-times me-2"></i>Cancel
                </a>
            </form>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>