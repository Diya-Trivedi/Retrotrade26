<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report Details - Admin</title>
</head>
<body>
    <c:set var="activePage" value="reports" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />
    <div class="main-content">
        <div class="container-fluid">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h4>Report #${report.reportId}</h4>
                </div>
                <div class="card-body">
                    <table class="table">
                        <tr><th>Listing</th><td>${report.listing.listingName} (#${report.listing.listingId})</td></tr>
                        <tr><th>Reported Seller</th><td>${report.seller.firstName} ${report.seller.lastName}</td></tr>
                        <tr><th>Reporter</th><td>${report.reportedBy.firstName} ${report.reportedBy.lastName}</td></tr>
                        <tr><th>Reason</th><td>${report.reason}</td></tr>
                        <tr><th>Status</th><td>${report.status}</td></tr>
                        <tr><th>Created</th><td>${report.createdAt}</td></tr>
                    </table>
                    <form action="${pageContext.request.contextPath}/admin/reports/update-status/${report.reportId}" method="post">
                        <div class="mb-3">
                            <label>Update Status</label>
                            <select name="status" class="form-select">
                                <option value="OPEN" ${report.status == 'OPEN' ? 'selected' : ''}>Open</option>
                                <option value="RESOLVED" ${report.status == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                                <option value="REJECTED" ${report.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Update Status</button>
                        <a href="${pageContext.request.contextPath}/admin/reports/delete/${report.reportId}" class="btn btn-danger" onclick="return confirm('Delete this report?')">Delete</a>
                        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-secondary">Back</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>