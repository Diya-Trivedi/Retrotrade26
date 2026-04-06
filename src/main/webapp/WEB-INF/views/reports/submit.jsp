<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Listing - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 40px 0;
        }
        .report-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 20px;
        }
        .report-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .report-header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 25px 30px;
            text-align: center;
        }
        .report-header h2 {
            margin: 0;
            font-weight: 600;
        }
        .report-header p {
            margin: 10px 0 0;
            opacity: 0.9;
        }
        .report-body {
            padding: 30px;
        }
        .listing-summary {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            border-left: 5px solid #dc3545;
        }
        .listing-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .listing-info {
            flex: 1;
        }
        .listing-info h4 {
            margin: 0 0 5px;
            color: #333;
        }
        .listing-info .price {
            font-size: 20px;
            font-weight: 700;
            color: #28a745;
        }
        .listing-info .seller {
            color: #666;
            font-size: 14px;
        }
        .reason-option {
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
        }
        .reason-option:hover {
            border-color: #dc3545;
            background: #fff5f5;
        }
        .reason-option.selected {
            border-color: #dc3545;
            background: #fff0f0;
            box-shadow: 0 2px 8px rgba(220,53,69,0.2);
        }
        .reason-option input[type="radio"] {
            margin-right: 12px;
            transform: scale(1.2);
            accent-color: #dc3545;
        }
        .reason-option label {
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            margin: 0;
        }
        .reason-desc {
            margin-left: 28px;
            font-size: 13px;
            color: #666;
            margin-top: 5px;
        }
        .comment-box {
            margin: 25px 0;
        }
        .comment-box textarea {
            border-radius: 12px;
            border: 2px solid #e0e0e0;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .comment-box textarea:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220,53,69,0.1);
        }
        .btn-submit {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
            border-radius: 40px;
            padding: 12px 30px;
            font-weight: 600;
            font-size: 16px;
            width: 100%;
            transition: transform 0.3s;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220,53,69,0.4);
        }
        .btn-cancel {
            background: #6c757d;
            border: none;
            border-radius: 40px;
            padding: 12px 30px;
            font-weight: 600;
            width: 100%;
            margin-top: 10px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            color: white;
        }
        .btn-cancel:hover {
            background: #5a6268;
            color: white;
        }
        .alert {
            border-radius: 12px;
            margin-bottom: 20px;
        }
        .warning-note {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 12px 15px;
            border-radius: 10px;
            font-size: 13px;
            margin-top: 20px;
        }
        @media (max-width: 768px) {
            .listing-summary {
                flex-direction: column;
                text-align: center;
            }
            .listing-image {
                margin: 0 auto;
            }
        }
    </style>
</head>
<body>
    <div class="report-container">
        <div class="report-card">
            <div class="report-header">
                <h2><i class="fas fa-flag me-2"></i>Report a Listing</h2>
                <p>Help us keep the marketplace safe and trustworthy</p>
            </div>
            <div class="report-body">
                <!-- Display error or success messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle me-2"></i> ${error}
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle me-2"></i> ${success}
                    </div>
                </c:if>

                <!-- Listing Details -->
                <div class="listing-summary">
                    <c:choose>
                        <c:when test="${not empty listing.images && not empty listing.images[0]}">
                            <img src="${listing.images[0].imageUrl}" class="listing-image" alt="${listing.listingName}">
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/100" class="listing-image" alt="No image">
                        </c:otherwise>
                    </c:choose>
                    <div class="listing-info">
                        <h4>${listing.listingName}</h4>
                        <div class="price">₹<fmt:formatNumber value="${listing.price}" pattern="#,##0.00"/></div>
                        <div class="seller">
                            <i class="fas fa-store me-1"></i> Seller: ${listing.seller.firstName} ${listing.seller.lastName}
                        </div>
                        <div class="mt-2">
                            <span class="badge bg-secondary">${listing.condition}</span>
                            <span class="badge bg-info ms-2">ID: #${listing.listingId}</span>
                        </div>
                    </div>
                </div>

                <!-- Report Form -->
                <form action="${pageContext.request.contextPath}/reports/save" method="post" id="reportForm">
                    <input type="hidden" name="listingId" value="${listing.listingId}">

                    <h5 class="mb-3"><i class="fas fa-exclamation-triangle me-2 text-danger"></i>Reason for reporting</h5>

                    <c:forEach var="reason" items="${reasons}">
                        <div class="reason-option" onclick="selectReason('${reason}')">
                            <input type="radio" name="reason" value="${reason}" id="reason_${reason}" required>
                            <label for="reason_${reason}">
                                <i class="fas ${reason == 'SCAM' ? 'fa-hand-holding-usd' : 
                                            (reason == 'FAKE_ITEM' ? 'fa-clone' : 
                                            (reason == 'ABUSE' ? 'fa-comment-dots' : 'fa-ellipsis-h'))} me-2"></i>
                                ${reason}
                            </label>
                            <div class="reason-desc">
                                <c:choose>
                                    <c:when test="${reason == 'SCAM'}">Suspected fraudulent activity, fake payment requests, or misleading information</c:when>
                                    <c:when test="${reason == 'FAKE_ITEM'}">Product is counterfeit, replica, or not as described</c:when>
                                    <c:when test="${reason == 'ABUSE'}">Harassment, offensive language, or inappropriate behavior</c:when>
                                    <c:otherwise>Other violation of marketplace policies</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Additional Comments -->
                    <div class="comment-box">
                        <label class="form-label fw-semibold"><i class="fas fa-comment me-2"></i>Additional Comments (Optional)</label>
                        <textarea class="form-control" name="comment" rows="4" placeholder="Please provide any extra details that might help us investigate..."></textarea>
                        <div class="form-text text-muted">Your identity will be kept confidential.</div>
                    </div>

                    <div class="warning-note">
                        <i class="fas fa-gavel me-2"></i>
                        <strong>Note:</strong> False reporting may lead to account restrictions. Please only report genuine violations.
                    </div>

                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-danger btn-submit">
                            <i class="fas fa-paper-plane me-2"></i> Submit Report
                        </button>
                        <a href="${pageContext.request.contextPath}/listings/${listing.listingId}" class="btn-cancel">
                            <i class="fas fa-times me-2"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectReason(reasonValue) {
            // Unselect all
            document.querySelectorAll('.reason-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            // Select clicked
            event.currentTarget.classList.add('selected');
            // Check radio button
            const radio = document.getElementById('reason_' + reasonValue);
            if (radio) radio.checked = true;
        }

        // Form validation (ensure a reason is selected)
        document.getElementById('reportForm').addEventListener('submit', function(e) {
            const selected = document.querySelector('input[name="reason"]:checked');
            if (!selected) {
                e.preventDefault();
                alert('Please select a reason for reporting this listing.');
            }
        });
    </script>
</body>
</html>