<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="viewerRole" value="${sessionScope.user.role}" />

<%-- ==================== ADMIN LAYOUT ==================== --%>
<c:if test="${viewerRole == 'ADMIN'}">
    <jsp:include page="adminHeader.jsp">
        <jsp:param name="activePage" value="users"/>
    </jsp:include>
    <%-- Admin header already provides <html>, <head>, and opening body --%>
    <style>
        /* Profile-specific styles (copied to ensure they apply in admin layout) */
        .profile-container { max-width: 1000px; margin: 40px auto; padding: 0 20px; }
        .profile-card { background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); overflow: hidden; margin-bottom: 30px; }
        .profile-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 25px; display: flex; align-items: center; gap: 20px; flex-wrap: wrap; }
        .profile-pic { width: 100px; height: 100px; border-radius: 50%; border: 3px solid white; object-fit: cover; }
        .role-badge { padding: 5px 15px; border-radius: 20px; font-weight: 600; background: rgba(255,255,255,0.2); }
        .role-admin { background: #dc3545 !important; color: white; }
        .info-table { width: 100%; border-collapse: collapse; margin: 0; padding: 0; }
        .info-table tr { border-bottom: 1px solid #f0f0f0; }
        .info-table tr:last-child { border-bottom: none; }
        .info-table td { padding: 10px 15px; vertical-align: top; }
        .info-table .label { font-weight: 600; color: #555; width: 150px; background-color: #fafafa; }
        .info-table .value { color: #333; background-color: white; }
        .address-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .address-table th { background: #667eea; color: white; font-weight: 500; padding: 12px 8px; text-align: left; font-size: 14px; }
        .address-table td { padding: 10px 8px; border-bottom: 1px solid #dee2e6; vertical-align: top; font-size: 14px; }
        .address-table tr:last-child td { border-bottom: none; }
        .default-badge { background: #28a745; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; display: inline-block; }
        .btn-edit { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 8px 20px; border-radius: 8px; text-decoration: none; display: inline-block; transition: transform 0.3s; }
        .btn-edit:hover { transform: translateY(-2px); color: white; box-shadow: 0 5px 15px rgba(102,126,234,0.4); }
        .btn-back { background: #6c757d; color: white; padding: 8px 20px; border-radius: 8px; text-decoration: none; display: inline-block; margin-left: 10px; transition: transform 0.3s; }
        .btn-back:hover { transform: translateY(-2px); color: white; background: #5a6268; }
        .alert { border-radius: 8px; margin-bottom: 20px; }
        .section-title { font-size: 22px; font-weight: 600; margin: 30px 0 15px; }
    </style>
    <div class="main-content">
</c:if>

<%-- ==================== PUBLIC LAYOUT ==================== --%>
<c:if test="${viewerRole != 'ADMIN'}">
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Details - Entitykart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* All profile-specific styles (same as above) */
            .profile-container { max-width: 1000px; margin: 40px auto; padding: 0 20px; }
            .profile-card { background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); overflow: hidden; margin-bottom: 30px; }
            .profile-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 25px; display: flex; align-items: center; gap: 20px; flex-wrap: wrap; }
            .profile-pic { width: 100px; height: 100px; border-radius: 50%; border: 3px solid white; object-fit: cover; }
            .role-badge { padding: 5px 15px; border-radius: 20px; font-weight: 600; background: rgba(255,255,255,0.2); }
            .role-admin { background: #dc3545 !important; color: white; }
            .info-table { width: 100%; border-collapse: collapse; margin: 0; padding: 0; }
            .info-table tr { border-bottom: 1px solid #f0f0f0; }
            .info-table tr:last-child { border-bottom: none; }
            .info-table td { padding: 10px 15px; vertical-align: top; }
            .info-table .label { font-weight: 600; color: #555; width: 150px; background-color: #fafafa; }
            .info-table .value { color: #333; background-color: white; }
            .address-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            .address-table th { background: #667eea; color: white; font-weight: 500; padding: 12px 8px; text-align: left; font-size: 14px; }
            .address-table td { padding: 10px 8px; border-bottom: 1px solid #dee2e6; vertical-align: top; font-size: 14px; }
            .address-table tr:last-child td { border-bottom: none; }
            .default-badge { background: #28a745; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; display: inline-block; }
            .btn-edit { background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 8px 20px; border-radius: 8px; text-decoration: none; display: inline-block; transition: transform 0.3s; }
            .btn-edit:hover { transform: translateY(-2px); color: white; box-shadow: 0 5px 15px rgba(102,126,234,0.4); }
            .btn-back { background: #6c757d; color: white; padding: 8px 20px; border-radius: 8px; text-decoration: none; display: inline-block; margin-left: 10px; transition: transform 0.3s; }
            .btn-back:hover { transform: translateY(-2px); color: white; background: #5a6268; }
            .alert { border-radius: 8px; margin-bottom: 20px; }
            .section-title { font-size: 22px; font-weight: 600; margin: 30px 0 15px; }
        </style>
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />
</c:if>

<!-- ==================== MAIN PROFILE CONTENT (same for both) ==================== -->
<div class="profile-container">
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="profile-card">
        <!-- Header with profile picture and basic info -->
        <div class="profile-header">
            <c:choose>
                <c:when test="${not empty userEntity.profilePicURL}">
                    <img src="${userEntity.profilePicURL}" class="profile-pic" alt="Profile">
                </c:when>
                <c:otherwise>
                    <img src="https://via.placeholder.com/100" class="profile-pic" alt="Profile">
                </c:otherwise>
            </c:choose>
            <div>
                <h3 class="mb-1">${userEntity.firstName} ${userEntity.lastName}</h3>
                <p class="mb-1"><i class="fas fa-envelope me-2"></i>${userEntity.email}</p>
                <span class="role-badge ${userEntity.role == 'ADMIN' ? 'role-admin' : ''}">
                    <i class="fas ${userEntity.role == 'ADMIN' ? 'fa-crown' : 'fa-user'} me-1"></i>${userEntity.role}
                </span>
                <span class="ms-2">User ID: #${userEntity.userId}</span>
            </div>
        </div>

        <!-- Personal Information Table -->
        <table class="info-table">
            <tr>
                <td class="label"><i class="fas fa-user me-2"></i>Full Name</td>
                <td class="value">${userEntity.firstName} ${userEntity.lastName}</td>
            </tr>
            <tr>
                <td class="label"><i class="fas fa-venus-mars me-2"></i>Gender</td>
                <td class="value">${userEntity.gender}</td>
            </tr>
            <tr>
                <td class="label"><i class="fas fa-tag me-2"></i>Role</td>
                <td class="value">${userEntity.role}</td>
            </tr>
            <tr>
                <td class="label"><i class="fas fa-phone me-2"></i>Contact Number</td>
                <td class="value">${userEntity.contactNum}</td>
            </tr>
            <tr>
                <td class="label"><i class="fas fa-envelope me-2"></i>Email Address</td>
                <td class="value">${userEntity.email}</td>
            </tr>
            <tr>
                <td class="label"><i class="fas fa-calendar me-2"></i>Member Since</td>
                <td class="value">${userEntity.createdAt}</td>
            </tr>
        </table>
    </div>

    <!-- Address Details Section -->
    <h4 class="section-title"><i class="fas fa-map-marker-alt me-2"></i>Address Details</h4>
    <c:choose>
        <c:when test="${not empty addressList}">
            <table class="address-table">
                <thead>
                    <tr>
                        <th>Address ID</th>
                        <th>Full Name</th>
                        <th>Mobile Number</th>
                        <th>Address Line 1</th>
                        <th>City</th>
                        <th>State</th>
                        <th>Pincode</th>
                        <th>Address Type</th>
                        <th>Default Address</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="addr" items="${addressList}">
                        <tr>
                            <td>${addr.addressId}</td>
                            <td>${addr.fullName}</td>
                            <td>${addr.mobileNo}</td>
                            <td>${addr.addressLine1}</td>
                            <td>${addr.city}</td>
                            <td>${addr.state}</td>
                            <td>${addr.pincode}</td>
                            <td>${addr.addressType}</td>
                            <td>
                                <c:if test="${addr.isDefault}">
                                    <span class="default-badge">Yes</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">No addresses found.</div>
        </c:otherwise>
    </c:choose>

    <!-- Action Buttons -->
    <div class="mt-4 text-center">
        <a href="${pageContext.request.contextPath}/editUser?userId=${userEntity.userId}" class="btn-edit">
            <i class="fas fa-edit me-2"></i>Edit Profile
        </a>
        <a href="javascript:history.back()" class="btn-back">
            <i class="fas fa-arrow-left me-2"></i>Back
        </a>
    </div>
</div>

<%-- ==================== CLOSE LAYOUTS ==================== --%>
<c:if test="${viewerRole == 'ADMIN'}">
    </div> <!-- end main-content -->
    <jsp:include page="adminFooter.jsp" />
</c:if>

<c:if test="${viewerRole != 'ADMIN'}">
    <jsp:include page="../common/footer.jsp" />
    </body>
    </html>
</c:if>