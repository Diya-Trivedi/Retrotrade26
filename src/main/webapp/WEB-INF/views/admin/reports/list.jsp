<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Reports - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <c:set var="activePage" value="reports" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />
    <div class="main-content">
        <div class="container-fluid">
            <h2>Reports</h2>
            <div class="card">
                <div class="card-body">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Listing</th>
                                <th>Reported Seller</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </thead>
                        <tbody>
                            <c:forEach var="report" items="${reports.content}">
                                 <tr>
                                    <td>${report.reportId}</td>
                                    <td>${report.listing.listingName}</td>
                                    <td>${report.seller.firstName} ${report.seller.lastName}</td>
                                    <td>${report.reason}</td>
                                    <td><span class="badge bg-${report.status == 'OPEN' ? 'warning' : (report.status == 'RESOLVED' ? 'success' : 'secondary')}">${report.status}</span></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/reports/view/${report.reportId}" class="btn btn-sm btn-info">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${reports.totalPages > 1}">
                        <nav><ul class="pagination">...</ul></nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>
</html>