<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reviews - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .reviews-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .review-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .review-card:hover {
            transform: translateY(-5px);
        }
        .rating {
            color: #ffc107;
            margin-bottom: 10px;
        }
        .seller-name {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .comment {
            color: #555;
            margin-bottom: 10px;
        }
        .date {
            font-size: 0.85rem;
            color: #999;
        }
        .empty-state {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .empty-state i {
            font-size: 60px;
            color: #ddd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="reviews-container">
        <h2 class="mb-4"><i class="fas fa-star me-2 text-primary"></i>My Reviews</h2>
        
        <c:choose>
            <c:when test="${empty reviews}">
                <div class="empty-state">
                    <i class="fas fa-star"></i>
                    <h4>No Reviews Yet</h4>
                    <p class="text-muted">You haven't written any reviews yet.</p>
                    <a href="${pageContext.request.contextPath}/transactions/my-purchases" class="btn btn-primary">
                        <i class="fas fa-shopping-bag me-2"></i>View Your Purchases
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${reviews}">
                    <div class="review-card">
                        <div class="rating">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                            </c:forEach>
                        </div>
                        <div class="seller-name">
                            <i class="fas fa-user-circle me-2 text-primary"></i>
                            ${review.seller.firstName} ${review.seller.lastName}
                        </div>
                        <div class="comment">
                            <i class="fas fa-quote-left me-2 text-muted"></i>${review.comment}
                        </div>
                        <div class="date">
                            <i class="far fa-calendar-alt me-2"></i>${review.createdAt}
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
</body>
</html>