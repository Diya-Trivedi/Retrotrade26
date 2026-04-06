<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="bg-dark text-white mt-5 py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5><i class="fas fa-store me-2"></i>Retrotrade</h5>
                <p class="text-muted">Your trusted second-hand marketplace for quality pre-owned items.</p>
                <div class="d-flex gap-3 mt-3">
                    <a href="#" class="text-white"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-twitter fa-lg"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-instagram fa-lg"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-linkedin fa-lg"></i></a>
                </div>
            </div>
            <div class="col-md-2">
                <h5>Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/listings" class="text-muted text-decoration-none">Browse</a></li>
                    <li><a href="${pageContext.request.contextPath}/listings/add" class="text-muted text-decoration-none">Sell</a></li>
                    <li><a href="${pageContext.request.contextPath}/profile" class="text-muted text-decoration-none">My Account</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Categories</h5>
                <ul class="list-unstyled">
                    <c:forEach var="cat" items="${categoryList}" varStatus="status">
                        <c:if test="${status.index < 5}">
                            <li><a href="${pageContext.request.contextPath}/listings?categoryId=${cat.categoryId}" class="text-muted text-decoration-none">${cat.categoryName}</a></li>
                        </c:if>
                    </c:forEach>
                    <li><a href="${pageContext.request.contextPath}/listings" class="text-muted text-decoration-none">View All</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Help & Support</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-muted text-decoration-none">About Us</a></li>
                    <li><a href="#" class="text-muted text-decoration-none">Contact</a></li>
                    <li><a href="#" class="text-muted text-decoration-none">FAQs</a></li>
                    <li><a href="#" class="text-muted text-decoration-none">Terms & Conditions</a></li>
                    <li><a href="#" class="text-muted text-decoration-none">Privacy Policy</a></li>
                </ul>
            </div>
        </div>
        <hr class="bg-secondary">
        <div class="text-center text-muted">
            <p class="mb-0">&copy; 2024 Retrotrade. All rights reserved. | Version 1.0</p>
        </div>
    </div>
</footer>