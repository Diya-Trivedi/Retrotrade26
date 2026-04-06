<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Write a Review - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f8f9fa; }
        .review-container { max-width: 600px; margin: 50px auto; }
        .rating i { cursor: pointer; font-size: 30px; color: #ddd; transition: color 0.2s; }
        .rating i.selected, .rating i.hover { color: #ffc107; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    <div class="review-container">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4>Review Seller: ${seller.firstName} ${seller.lastName}</h4>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/reviews/save" method="post">
                    <input type="hidden" name="sellerId" value="${seller.userId}">
                    <div class="mb-3">
                        <label>Rating</label>
                        <div class="rating">
                            <i class="fas fa-star" data-value="1"></i>
                            <i class="fas fa-star" data-value="2"></i>
                            <i class="fas fa-star" data-value="3"></i>
                            <i class="fas fa-star" data-value="4"></i>
                            <i class="fas fa-star" data-value="5"></i>
                        </div>
                        <input type="hidden" name="rating" id="ratingInput" required>
                    </div>
                    <div class="mb-3">
                        <label>Your Review</label>
                        <textarea name="comment" class="form-control" rows="5" placeholder="Share your experience..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Submit Review</button>
                </form>
            </div>
        </div>
    </div>
    <script>
        document.querySelectorAll('.rating i').forEach(star => {
            star.addEventListener('click', function() {
                let value = this.getAttribute('data-value');
                document.getElementById('ratingInput').value = value;
                document.querySelectorAll('.rating i').forEach(s => s.classList.remove('selected'));
                for(let i=0; i<value; i++) {
                    document.querySelectorAll('.rating i')[i].classList.add('selected');
                }
            });
            star.addEventListener('mouseover', function() {
                let value = this.getAttribute('data-value');
                document.querySelectorAll('.rating i').forEach(s => s.classList.remove('hover'));
                for(let i=0; i<value; i++) {
                    document.querySelectorAll('.rating i')[i].classList.add('hover');
                }
            });
            star.addEventListener('mouseout', function() {
                document.querySelectorAll('.rating i').forEach(s => s.classList.remove('hover'));
            });
        });
    </script>
</body>
</html>