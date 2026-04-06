<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .edit-container {
            max-width: 700px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .edit-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .edit-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .edit-header h2 {
            color: #333;
            font-weight: 600;
        }
        .edit-header p {
            color: #666;
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
        .profile-pic-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 3px solid #667eea;
            object-fit: cover;
            margin: 0 auto 15px;
            display: block;
        }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .form-row {
            display: flex;
            gap: 15px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .section-title {
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
            margin: 30px 0 20px;
            color: #333;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    
    <div class="edit-container">
        <div class="edit-card">
            <div class="edit-header">
                <h2><i class="fas fa-edit me-2"></i>Edit Profile</h2>
                <p class="text-muted">Update your personal information</p>
            </div>
            
            <!-- Display error message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/updateUser" method="post" enctype="multipart/form-data">
                <input type="hidden" name="userId" value="${userEntity.userId}">
                
                <!-- Profile Picture -->
                <div class="text-center mb-4">
                    <c:choose>
                        <c:when test="${not empty userEntity.profilePicURL}">
                            <img id="profilePreview" src="${userEntity.profilePicURL}" alt="Profile" class="profile-pic-preview">
                        </c:when>
                        <c:otherwise>
                            <img id="profilePreview" src="https://via.placeholder.com/120" alt="Profile" class="profile-pic-preview">
                        </c:otherwise>
                    </c:choose>
                    <div class="mt-2">
                        <label for="profilePic" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-camera me-1"></i>Change Photo
                        </label>
                        <input type="file" class="d-none" id="profilePic" name="profilePic" accept="image/*" onchange="previewImage(this)">
                        <small class="d-block text-muted mt-1">Leave empty to keep current photo</small>
                    </div>
                </div>
                
                <!-- Personal Information -->
                <h5 class="section-title"><i class="fas fa-user me-2"></i>Personal Information</h5>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">First Name</label>
                        <input type="text" class="form-control" name="firstName" value="${userEntity.firstName}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Last Name</label>
                        <input type="text" class="form-control" name="lastName" value="${userEntity.lastName}" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" class="form-control" value="${userEntity.email}" readonly disabled>
                    <small class="text-muted">Email cannot be changed</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Contact Number</label>
                        <input type="text" class="form-control" name="contactNum" value="${userEntity.contactNum}" 
                               pattern="[0-9]{10}" title="Please enter a valid 10-digit mobile number" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Gender</label>
                        <select class="form-select" name="gender" required>
                            <option value="MALE" ${userEntity.gender == 'MALE' ? 'selected' : ''}>Male</option>
                            <option value="FEMALE" ${userEntity.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                            <option value="OTHER" ${userEntity.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                </div>
                
                <!-- Address Information -->
                <h5 class="section-title"><i class="fas fa-map-marker-alt me-2"></i>Address Information</h5>
                
                <input type="hidden" name="addressId" value="${address.addressId}">
                
                <div class="form-group">
                    <label class="form-label">Full Name (Receiver's Name)</label>
                    <input type="text" class="form-control" name="fullName" value="${address.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Mobile Number (for delivery)</label>
                    <input type="text" class="form-control" name="mobileNo" value="${address.mobileNo}" 
                           pattern="[0-9]{10}" title="Please enter a valid 10-digit mobile number" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Address Line</label>
                    <input type="text" class="form-control" name="addressLine1" value="${address.addressLine1}" 
                           placeholder="House/Flat No., Building, Street" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">City</label>
                        <input type="text" class="form-control" name="city" value="${address.city}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">State</label>
                        <input type="text" class="form-control" name="state" value="${address.state}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Pincode</label>
                        <input type="text" class="form-control" name="pincode" value="${address.pincode}" 
                               pattern="[0-9]{6}" title="Please enter a valid 6-digit pincode" required>
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
                        <input type="checkbox" class="form-check-input" name="isDefault" id="isDefault" ${address.isDefault ? 'checked' : ''}>
                        <label class="form-check-label" for="isDefault">
                            Set as default address
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn-update">
                    <i class="fas fa-save me-2"></i>Update Profile
                </button>
                <a href="${pageContext.request.contextPath}/viewUser?userId=${userEntity.userId}" class="btn-cancel">
                    <i class="fas fa-times me-2"></i>Cancel
                </a>
            </form>
        </div>
    </div>
    
    <jsp:include page="common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profilePreview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>