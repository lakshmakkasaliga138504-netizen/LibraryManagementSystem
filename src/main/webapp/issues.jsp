
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Issue Books - Library Management</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .header {
            background: #26364a;
            color: white;
            padding: 22px 40px;
        }

        .container {
            max-width: 1100px;
            margin: 35px auto;
            padding: 25px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px #ddd;
        }

        .top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 13px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #26364a;
            color: white;
        }

        .button, .back, .return-button {
            display: inline-block;
            padding: 9px 14px;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .button {
            background: #2878d0;
        }

        .back {
            background: #555;
            margin-top: 20px;
        }

        .return-button {
            background: #16a34a;
        }

        .status {
            color: green;
            font-weight: bold;
        }

        .pending {
            color: #d97706;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="header">
    <h1>Library Management System</h1>
    <p>Issue Book Management</p>
</div>

<div class="container">

    <div class="top">
        <h2>Issued Book Records</h2>
        <a class="button"
   href="${pageContext.request.contextPath}/IssueServlet?action=new">
   Issue New Book
</a>
    </div>

    <c:if test="${param.success == '1'}">
        <p class="status">Operation completed successfully!</p>
    </c:if>

    <c:if test="${not empty error}">
        <p style="color:red;"><c:out value="${error}"/></p>
    </c:if>

    <table>
        <tr>
            <th>Issue ID</th>
            <th>Student ID</th>
            <th>Book ID</th>
            <th>Issue Date</th>
            <th>Return Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <c:forEach var="issue" items="${issues}">
            <tr>
                <td>${issue.issueId}</td>
                <td>${issue.studentId}</td>
                <td>${issue.bookId}</td>
                <td>${issue.issueDate}</td>

                <td>
                    <c:choose>
                        <c:when test="${not empty issue.returnDate}">
                            ${issue.returnDate}
                        </c:when>
                        <c:otherwise>Not returned</c:otherwise>
                    </c:choose>
                </td>

                <td>
                    <c:choose>
                        <c:when test="${not empty issue.returnDate}">
                            <span class="status">Returned</span>
                        </c:when>
                        <c:otherwise>
                            <span class="pending">Pending</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td>
                    <c:if test="${empty issue.returnDate}">
                        <form action="${pageContext.request.contextPath}/IssueServlet"
                              method="post"
                              onsubmit="return confirm('Confirm book return?');">

                            <input type="hidden" name="action" value="return">
                            <input type="hidden" name="issue_id"
                                   value="${issue.issueId}">

                            <button class="return-button" type="submit">
                                Return Book
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${not empty issue.returnDate}">
                        Completed
                    </c:if>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty issues}">
            <tr>
                <td colspan="7">No issue records found.</td>
            </tr>
        </c:if>
    </table>

    <a class="back" href="index.jsp">Back to Dashboard</a>

</div>

</body>
</html>
