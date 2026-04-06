<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6f9;
            overflow-x: hidden;
        }
        
        .wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
        }
        
        /* Sidebar Styles */
        #sidebar {
            min-width: 280px;
            max-width: 280px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            transition: all 0.3s;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }
        
        #sidebar.active {
            margin-left: -280px;
        }
        
        #sidebar .sidebar-header {
            padding: 25px 20px;
            background: rgba(0, 0, 0, 0.1);
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        #sidebar .sidebar-header h3 {
            margin: 0;
            font-weight: 600;
            font-size: 1.5rem;
        }
        
        #sidebar .sidebar-header p {
            margin: 5px 0 0;
            opacity: 0.8;
            font-size: 0.9rem;
        }
        
        #sidebar ul.components {
            padding: 20px 0;
        }
        
        #sidebar ul li {
            list-style: none;
        }
        
        #sidebar ul li a {
            padding: 12px 25px;
            display: block;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }
        
        #sidebar ul li a:hover {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: #fff;
        }
        
        #sidebar ul li.active a {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: #fff;
        }
        
        #sidebar ul li a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        #sidebar ul ul a {
            padding-left: 50px;
            background: rgba(0, 0, 0, 0.1);
            font-size: 0.9rem;
        }
        
        #sidebar .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        #sidebar .user-info {
            display: flex;
            align-items: center;
            color: #fff;
        }
        
        #sidebar .user-info img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid #fff;
        }
        
        #sidebar .user-info .user-details {
            flex: 1;
        }
        
        #sidebar .user-info .user-details .name {
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        #sidebar .user-info .user-details .role {
            font-size: 0.8rem;
            opacity: 0.8;
        }
        
        /* Content Styles */
        #content {
            width: 100%;
            margin-left: 280px;
            transition: all 0.3s;
        }
        
        #content.active {
            margin-left: 0;
        }
        
        /* Navbar Styles */
        .navbar-custom {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 30px;
            position: fixed;
            width: calc(100% - 280px);
            z-index: 100;
            transition: all 0.3s;
        }
        
        .navbar-custom.active {
            width: 100%;
        }
        
        .navbar-custom .sidebar-toggle {
            background: transparent;
            border: none;
            font-size: 1.5rem;
            color: #667eea;
            cursor: pointer;
            margin-right: 20px;
        }
        
        .navbar-custom .navbar-nav {
            margin-left: auto;
        }
        
        .navbar-custom .nav-item {
            margin-left: 20px;
        }
        
        .navbar-custom .nav-link {
            color: #555;
        }
        
        .navbar-custom .nav-link:hover {
            color: #667eea;
        }
        
        /* Main Content Area */
        .main-content {
            padding: 100px 30px 30px;
            min-height: 100vh;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            #sidebar {
                margin-left: -280px;
            }
            #sidebar.active {
                margin-left: 0;
            }
            #content {
                margin-left: 0;
            }
            #content.active {
                margin-left: 280px;
            }
            .navbar-custom {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <!-- Sidebar -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3><i class="fas fa-store me-2"></i>Retrotrade</h3>
                <p>Administration Panel</p>
            </div>

            <ul class="components">
                <!-- Dashboard -->
                <li class="${param.activePage == 'dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                
                <!-- Products Dropdown -->
                <li class="${param.activePage == 'products' ? 'active' : ''}">
                    <a href="#productPages" data-bs-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                        <i class="fas fa-box"></i> Products
                    </a>
                    <ul class="collapse list-unstyled ${param.activePage == 'products' ? 'show' : ''}" id="productPages">
                        <li class="${param.subPage == 'all-listings' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/admin/listings">
                                <i class="fas fa-list me-2"></i>All Listings
                            </a>
                        </li>
                        <li class="${param.subPage == 'active-listings' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/admin/listings?status=ACTIVE">
                                <i class="fas fa-check-circle me-2"></i>Active
                            </a>
                        </li>
                        <li class="${param.subPage == 'pending-listings' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/admin/listings?status=PENDING">
                                <i class="fas fa-clock me-2"></i>Pending Approval
                            </a>
                        </li>
                        <li class="${param.subPage == 'sold-listings' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/admin/listings?status=SOLD">
                                <i class="fas fa-dollar-sign me-2"></i>Sold
                            </a>
                        </li>
                        <li class="${param.subPage == 'rejected-listings' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/admin/listings?status=REJECTED">
                                <i class="fas fa-times-circle me-2"></i>Rejected
                            </a>
                        </li>
                    </ul>
                </li>
                
                <!-- Categories -->
                <li class="${param.activePage == 'categories' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/category/list">
                        <i class="fas fa-tags"></i> Categories
                    </a>
                </li>
                
                <!-- Subcategories -->
                <li class="${param.activePage == 'subcategories' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/subcategory/list">
                        <i class="fas fa-sitemap"></i> Subcategories
                    </a>
                </li>
                
                <!-- Users -->
                <li class="${param.activePage == 'users' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/listUser">
                        <i class="fas fa-users"></i> Users
                    </a>
                </li>
                
                <!-- Transactions -->
				<li class="${param.activePage == 'transactions' ? 'active' : ''}">
    				<a href="${pageContext.request.contextPath}/admin/transactions">
        				<i class="fas fa-credit-card"></i> Transactions
    				</a>
				</li>
				<li class="${param.activePage == 'reports' ? 'active' : ''}">
                			<a href="${pageContext.request.contextPath}/admin/reports">
                    			<i class="fas fa-flag me-2"></i> Reports
                			</a>
            			</li>
                
                <!-- Reports -->
                <li class="${param.activePage == 'reports' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/#">
                        <i class="fas fa-chart-bar"></i> Reports
                    </a>
                </li>
                
                <!-- Settings -->
                <li class="${param.activePage == 'settings' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/#">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                </li>
             <!-- existing items ... -->
    
    		</ul>
            <div class="sidebar-footer">
                <div class="user-info">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.profilePicURL}">
                            <img src="${sessionScope.user.profilePicURL}" alt="Profile">
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/40" alt="Profile">
                        </c:otherwise>
                    </c:choose>
                    <div class="user-details">
                        <div class="name">${sessionScope.user.firstName} ${sessionScope.user.lastName}</div>
                        <div class="role"><i class="fas fa-crown me-1"></i>Administrator</div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Page Content -->
        <div id="content">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-custom">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="sidebar-toggle">
                        <i class="fas fa-bars"></i>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ms-auto">
                        	${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" 
                               data-bs-toggle="dropdown">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.profilePicURL}">
                                        <img src="${sessionScope.user.profilePicURL}" alt="Profile" 
                                             style="width: 30px; height: 30px; border-radius: 50%; margin-right: 5px;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-circle me-1"></i>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user me-2"></i>My Profile
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/address/list">
                                    <i class="fas fa-map-marker-alt me-2"></i>My Addresses
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                                </a></li>
                            </ul>
                        </li>

                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <div class="main-content">