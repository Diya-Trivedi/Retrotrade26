<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Cart - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .cart-container { max-width: 1200px; margin: 50px auto; padding: 0 20px; }
        .cart-header { margin-bottom: 30px; }
        .cart-table th { background: #f8f9fa; }
        .cart-item-img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; }
        .quantity-input { width: 70px; text-align: center; }
        .cart-summary { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .btn-checkout { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; }
        .empty-cart { text-align: center; padding: 50px; background: white; border-radius: 10px; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    <div class="cart-container">
        <div class="cart-header">
            <h2><i class="fas fa-shopping-cart me-2"></i>My Cart</h2>
        </div>
        <c:choose>
            <c:when test="${empty cart.items}">
                <div class="empty-cart">
                    <i class="fas fa-cart-shopping fa-4x text-muted mb-3"></i>
                    <h4>Your cart is empty</h4>
                    <a href="${pageContext.request.contextPath}/listings" class="btn btn-primary mt-3">Start Shopping</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-body">
                                <table class="table cart-table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Subtotal</th>
                                            <th></th>
                                        </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cart.items}">
                                            <c:set var="subtotal" value="${item.listing.price * item.quantity}" />
                                             <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <img src="${not empty item.listing.images ? item.listing.images[0].imageUrl : 'https://via.placeholder.com/80'}" 
                                                             class="cart-item-img me-3">
                                                        <div>
                                                            <h6>${item.listing.listingName}</h6>
                                                            <small class="text-muted">${item.listing.condition}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>₹<fmt:formatNumber value="${item.listing.price}" pattern="#,##0.00"/></td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/cart/update" method="post" style="display: inline;">
                                                        <input type="hidden" name="listingId" value="${item.listing.listingId}">
                                                        <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control quantity-input d-inline w-auto" onchange="this.form.submit()">
                                                    </form>
                                                </td>
                                                <td>₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/cart/remove/${item.listing.listingId}" 
                                                       class="btn btn-sm btn-danger" onclick="return confirm('Remove this item?')">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="cart-summary">
                            <h5>Order Summary</h5>
                            <hr>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal (${cart.totalItems} items)</span>
                                <span>₹<fmt:formatNumber value="${total}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-3">
                                <span>Delivery Charges</span>
                                <span class="text-success">Free</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-4">
                                <strong>Total</strong>
                                <strong>₹<fmt:formatNumber value="${total}" pattern="#,##0.00"/></strong>
                            </div>
                            <a href="${pageContext.request.contextPath}/cart/checkout" class="btn btn-checkout w-100">Proceed to Checkout</a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <jsp:include page="../common/footer.jsp" />
</body>
</html>