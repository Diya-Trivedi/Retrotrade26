<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Revenue Report - Retrotrade Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
            margin-bottom: 20px;
        }
        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            height: 100%;
        }
        .table-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .btn-export {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 600;
            transition: transform 0.3s;
        }
        .btn-export:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
            color: white;
        }
        /* FIX: Ensure chart containers have proper sizing */
        .chart-wrapper {
            position: relative;
            height: 250px;
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .chart-wrapper canvas {
            max-height: 220px;
            max-width: 220px;
            width: 100%;
            height: auto;
        }
    </style>
</head>
<body>
    <c:set var="activePage" value="transactions" scope="request"/>
    <jsp:include page="../adminHeader.jsp" />

    <div class="main-content">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-chart-line me-2 text-primary"></i>Revenue Report</h2>
                <button class="btn-export" onclick="exportCSV()">
                    <i class="fas fa-download me-2"></i>Export CSV
                </button>
            </div>

            <!-- Statistics Row -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value">₹<fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" pattern="#,##0"/></div>
                        <div class="stat-label">Total Platform Revenue</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value">${stats != null }</div>
                        <div class="stat-label">Completed Transactions</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value">₹<fmt:formatNumber value="${stats != null && stats[1] != null ? stats[1] : 0}" pattern="#,##0"/></div>
                        <div class="stat-label">Total Transaction Value</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value">₹<fmt:formatNumber value="${stats != null && stats[2] != null ? stats[2] : 0}" pattern="#,##0"/></div>
                        <div class="stat-label">Average Transaction Value</div>
                    </div>
                </div>
            </div>

            <!-- Charts Row - FIXED PIE CHART POSITIONING -->
            <div class="row g-4 mb-4">
                <div class="col-md-8">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-calendar-alt me-2 text-primary"></i>Monthly Revenue</h5>
                        <div style="position: relative; height: 300px; width: 100%;">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-pie me-2 text-primary"></i>Payment Distribution</h5>
                        <!-- FIXED: Centered container for pie chart -->
                        <div class="chart-wrapper">
                            <canvas id="paymentChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Monthly Revenue Table -->
            <div class="table-card">
                <h5 class="mb-3"><i class="fas fa-table me-2 text-primary"></i>Monthly Revenue Details</h5>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Month</th>
                                <th>Year</th>
                                <th>Revenue</th>
                                <th>Growth</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="month" items="${monthlyRevenue}" varStatus="loop">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${month[0] == 1}">January</c:when>
                                            <c:when test="${month[0] == 2}">February</c:when>
                                            <c:when test="${month[0] == 3}">March</c:when>
                                            <c:when test="${month[0] == 4}">April</c:when>
                                            <c:when test="${month[0] == 5}">May</c:when>
                                            <c:when test="${month[0] == 6}">June</c:when>
                                            <c:when test="${month[0] == 7}">July</c:when>
                                            <c:when test="${month[0] == 8}">August</c:when>
                                            <c:when test="${month[0] == 9}">September</c:when>
                                            <c:when test="${month[0] == 10}">October</c:when>
                                            <c:when test="${month[0] == 11}">November</c:when>
                                            <c:when test="${month[0] == 12}">December</c:when>
                                        </c:choose>
                                    </td>
                                    <td>${month[1]}</td>
                                    <td class="text-success fw-bold">₹<fmt:formatNumber value="${month[2]}" pattern="#,##0.00"/></td>
                                    <td>
                                        <c:if test="${loop.index > 0}">
                                            <c:set var="prev" value="${monthlyRevenue[loop.index - 1][2]}"/>
                                            <c:set var="growth" value="${(month[2] - prev) / prev * 100}"/>
                                            <span class="badge ${growth >= 0 ? 'bg-success' : 'bg-danger'}">
                                                <fmt:formatNumber value="${growth}" pattern="0.0"/>%
                                            </span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pending Payouts -->
            <div class="table-card">
                <h5 class="mb-3"><i class="fas fa-clock me-2 text-warning"></i>Pending Seller Payouts</h5>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Seller ID</th>
                                <th>Pending Amount</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="payout" items="${pendingPayouts}">
                                <tr>
                                    <td>Seller #${payout[0]}</td>
                                    <td class="text-danger fw-bold">₹<fmt:formatNumber value="${payout[1]}" pattern="#,##0.00"/></td>
                                    <td>
                                        <button class="btn btn-sm btn-success" onclick="processPayout(${payout[0]})">
                                            <i class="fas fa-check me-1"></i>Process
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty pendingPayouts}">
                                <tr><td colspan="3" class="text-center py-3">No pending payouts</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../adminFooter.jsp" />

    <script>
        // Monthly Revenue Chart
        const ctx1 = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx1, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach var="month" items="${monthlyRevenue}" varStatus="s">
                        <c:choose>
                            <c:when test="${month[0] == 1}">'Jan ${month[1]}'</c:when>
                            <c:when test="${month[0] == 2}">'Feb ${month[1]}'</c:when>
                            <c:when test="${month[0] == 3}">'Mar ${month[1]}'</c:when>
                            <c:when test="${month[0] == 4}">'Apr ${month[1]}'</c:when>
                            <c:when test="${month[0] == 5}">'May ${month[1]}'</c:when>
                            <c:when test="${month[0] == 6}">'Jun ${month[1]}'</c:when>
                            <c:when test="${month[0] == 7}">'Jul ${month[1]}'</c:when>
                            <c:when test="${month[0] == 8}">'Aug ${month[1]}'</c:when>
                            <c:when test="${month[0] == 9}">'Sep ${month[1]}'</c:when>
                            <c:when test="${month[0] == 10}">'Oct ${month[1]}'</c:when>
                            <c:when test="${month[0] == 11}">'Nov ${month[1]}'</c:when>
                            <c:when test="${month[0] == 12}">'Dec ${month[1]}'</c:when>
                        </c:choose>${!s.last ? ',' : ''}
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Revenue (₹)',
                    data: [
                        <c:forEach var="month" items="${monthlyRevenue}" varStatus="s">
                            ${month[2]}${!s.last ? ',' : ''}
                        </c:forEach>
                    ],
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102,126,234,0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { mode: 'index', intersect: false }
                }
            }
        });

        // Payment Distribution Chart - FIXED POSITIONING
        const ctx2 = document.getElementById('paymentChart').getContext('2d');
        new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: ['Card (45%)', 'UPI (30%)', 'Net Banking (15%)', 'Wallet (7%)', 'Cash (3%)'],
                datasets: [{
                    data: [45, 30, 15, 7, 3],
                    backgroundColor: ['#4a7c59', '#b8860b', '#2980b9', '#e67e22', '#8c8277'],
                    borderColor: '#ffffff',
                    borderWidth: 2,
                    hoverOffset: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                cutout: '65%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            padding: 15,
                            font: {
                                size: 11,
                                family: "'DM Sans', sans-serif"
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return ' ' + context.label + ': ' + context.raw + '%';
                            }
                        }
                    }
                },
                layout: {
                    padding: {
                        top: 10,
                        bottom: 10
                    }
                }
            }
        });

        function exportCSV() {
            let csv = "Month,Year,Revenue\n";
            <c:forEach var="month" items="${monthlyRevenue}">
                <c:choose>
                    <c:when test="${month[0] == 1}">csv += "January,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 2}">csv += "February,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 3}">csv += "March,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 4}">csv += "April,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 5}">csv += "May,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 6}">csv += "June,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 7}">csv += "July,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 8}">csv += "August,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 9}">csv += "September,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 10}">csv += "October,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 11}">csv += "November,${month[1]},${month[2]}\n";</c:when>
                    <c:when test="${month[0] == 12}">csv += "December,${month[1]},${month[2]}\n";</c:when>
                </c:choose>
            </c:forEach>
            const blob = new Blob([csv], {type: 'text/csv'});
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'revenue-report.csv';
            a.click();
            URL.revokeObjectURL(url);
        }

        function processPayout(sellerId) {
            if(confirm('Process payout for seller #' + sellerId + '?')) {
                alert('Payout processing initiated for seller #' + sellerId + ' (demo).');
                // In a real app, you would make an AJAX call here
            }
        }
    </script>
</body>
</html>