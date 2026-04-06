<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        .signup-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            padding: 40px;
            width: 100%;
            max-width: 600px;
        }
        .signup-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .signup-header h2 {
            color: #333;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .signup-header p {
            color: #666;
            font-size: 14px;
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
        .btn-signup {
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
        .btn-signup:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .alert {
            border-radius: 8px;
            padding: 12px 15px;
            margin-bottom: 20px;
        }
        .form-row {
            display: flex;
            gap: 15px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .profile-pic-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 3px solid #667eea;
            object-fit: cover;
            margin: 10px auto;
            display: block;
        }
    </style>
</head>
<body>
    <div class="signup-card">
        <div class="signup-header">
            <h2><i class="fas fa-user-plus me-2"></i>Create Account</h2>
            <p>Join Retrotrade marketplace</p>
        </div>
        
        <!-- Display error message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data">
            <!-- Profile Picture -->
            <div class="text-center mb-3">
                <img id="profilePreview" src="https://via.placeholder.com/100" alt="Profile Preview" class="profile-pic-preview">
                <div class="mt-2">
                    <label for="profilePic" class="btn btn-outline-primary btn-sm">
                        <i class="fas fa-camera me-1"></i>Choose Photo
                    </label>
                    <input type="file" class="d-none" id="profilePic" name="profilePic" accept="image/*" onchange="previewImage(this)">
                </div>
            </div>
            
            <!-- Personal Information -->
            <h5 class="mb-3"><i class="fas fa-user me-2"></i>Personal Information</h5>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">First Name</label>
                    <input type="text" class="form-control" name="firstName" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="lastName" required>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <input type="email" class="form-control" name="email" required>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" class="form-control" name="password" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" name="confirmPassword" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Contact Number</label>
                    <input type="text" class="form-control" name="contactNum" pattern="[0-9]{10}" 
                           title="Please enter a valid 10-digit mobile number" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Gender</label>
                    <select class="form-select" name="gender" required>
                        <option value="" disabled selected>Select Gender</option>
                        <option value="MALE">Male</option>
                        <option value="FEMALE">Female</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
            </div>
            
            <!-- Address Information -->
            <h5 class="mb-3 mt-4"><i class="fas fa-map-marker-alt me-2"></i>Address Information</h5>
            
            <div class="form-group">
                <label class="form-label">Full Name (Receiver's Name)</label>
                <input type="text" class="form-control" name="fullName" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">Mobile Number (for delivery)</label>
                <input type="text" class="form-control" name="mobileNo" pattern="[0-9]{10}" 
                       title="Please enter a valid 10-digit mobile number" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">Address Line</label>
                <input type="text" class="form-control" name="addressLine1" 
                       placeholder="House/Flat No., Building, Street" required>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">City</label>
                    <input type="text" class="form-control" name="city" required>
                </div>
                <div class="form-group">
                    <label class="form-label">State</label>
                    <input type="text" class="form-control" name="state" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Pincode</label>
                    <input type="text" class="form-control" name="pincode" pattern="[0-9]{6}" 
                           title="Please enter a valid 6-digit pincode" required>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">Address Type</label>
                <select class="form-select" name="addressType" required>
                    <option value="" disabled selected>Select address type</option>
                    <option value="HOME">Home</option>
                    <option value="OFFICE">Office</option>
                </select>
            </div>
            
            <input type="hidden" name="isDefault" value="true">
            
            <button type="submit" class="btn-signup">
                <i class="fas fa-user-plus me-2"></i>Register
            </button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
    
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