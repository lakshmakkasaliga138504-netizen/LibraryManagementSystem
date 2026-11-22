<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Books - Library Management</title>

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

        tr:hover {
            background: #f5f5f5;
        }

        a.button, a.back {
            display: inline-block;
            padding: 10px 16px;
            background: #2878d0;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        a.back {
            background: #555;
            margin-top: 20px;
        }
    </style>
</head>

<body>

<div class="header">
    <h1>Library Management System</h1>
    <p>Book Management</p>
</div>

<div class="container">

    <div class="top">
        <h2>Book Records</h2>
        <a class="button" href="addBook.jsp">Add Book</a>
    </div>

    <c:if test="${not empty error}">
        <p style="color:red;"><c:out value="${error}"/></p>
    </c:if>

    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Author</th>
            <th>Category</th>
            <th>Quantity</th>
            <th>Actions</th>
        </tr>

        <c:forEach var="book" items="${books}">
            <tr>
                <td>${book.bookId}</td>
                <td><c:out value="${book.title}"/></td>
                <td><c:out value="${book.author}"/></td>
                <td><c:out value="${book.category}"/></td>
                <td>${book.quantity}</td>
                <td>
                    <a href="editBook.jsp?id=${book.bookId}">Edit</a>
                    |
                    <a href="deleteBook.jsp?id=${book.bookId}"
                       onclick="return confirm('Delete this book?');">
                        Delete
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty books}">
            <tr>
                <td colspan="6">No book records found.</td>
            </tr>
        </c:if>
    </table>

    <a class="back" href="index.jsp">Back to Dashboard</a>

</div>

</body>
</html>
