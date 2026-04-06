<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User List - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .list-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .list-header h2 {
            color: #333;
            font-weight: 600;
        }
        .table-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 20px;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            font-weight: 600;
        }
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .profile-thumb {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        .role-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .role-admin {
            background: #dc3545;
            color: white;
        }
        .role-user {
            background: #28a745;
            color: white;
        }
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
        .btn-action {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            margin: 0 2px;
            text-decoration: none;
        }
        .btn-view {
            background: #17a2b8;
            color: white;
        }
        .btn-edit {
            background: #007bff;
            color: white;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .btn-view:hover, .btn-edit:hover, .btn-delete:hover {
            color: white;
            opacity: 0.9;
        }
        .alert {
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .search-box {
            max-width: 300px;
        }
    </style>
</head>
<body>
    <jsp:include page="adminHeader.jsp" />
    
    <div class="list-container">
        <!-- Display success message -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        
        <!-- Display error message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <div class="list-header">
            <h2><i class="fas fa-users me-2"></i>User Management</h2>
            <div class="search-box">
                <input type="text" class="form-control" id="searchInput" placeholder="Search users..." onkeyup="searchTable()">
            </div>
        </div>
        
        <div class="table-card">
            <table id="userTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Profile</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Contact</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Joined</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${userList}">
                        <tr>
                            <td>${user.userId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty user.profilePicURL}">
                                        <img src="${user.profilePicURL}" alt="Profile" class="profile-thumb">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/40" alt="Profile" class="profile-thumb">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${user.firstName} ${user.lastName}</td>
                            <td>${user.email}</td>
                            <td>${user.contactNum}</td>
                            <td>
                                <span class="role-badge ${user.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                    ${user.role}
                                </span>
                            </td>
                            <td>
                                <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                    ${user.active ? 'Active' : 'Inactive'}
                                </span>
                            </td>
                            <td>${user.createdAt}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/viewUser?userId=${user.userId}" class="btn-action btn-view" title="View">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <c:if test="${sessionScope.user.userId != user.userId}">
                                    <a href="${pageContext.request.contextPath}/deleteUser?userId=${user.userId}" 
                                       class="btn-action btn-delete" 
                                       title="Delete"
                                       onclick="return confirm('Are you sure you want to delete this user?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    
    <jsp:include page="adminFooter.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function searchTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("userTable");
            tr = table.getElementsByTagName("tr");
            
            for (i = 1; i < tr.length; i++) {
                tr[i].style.display = "none";
                td = tr[i].getElementsByTagName("td");
                for (var j = 0; j < td.length; j++) {
                    if (td[j]) {
                        txtValue = td[j].textContent || td[j].innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        }
                    }
                }
            }
        }
    </script>
</body>
</html>