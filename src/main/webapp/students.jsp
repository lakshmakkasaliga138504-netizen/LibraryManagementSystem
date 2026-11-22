<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Students - Library Management</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .header {
            background: #1f2937;
            color: white;
            padding: 20px;
            text-align: center;
        }

        .container {
            width: 90%;
            margin: 30px auto;
        }

        .top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        h2 {
            color: #1f2937;
        }

        .button {
            background: #2563eb;
            color: white;
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 6px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        th {
            background: #2563eb;
            color: white;
            padding: 14px;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        tr:hover {
            background: #f1f5f9;
        }

        .edit {
            background: #16a34a;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }

        .delete {
            background: #dc2626;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 5px;
        }

        .back {
            display: inline-block;
            margin-top: 25px;
            color: #2563eb;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="header">
    <h1>Library Management System</h1>
    <p>Student Management</p>
</div>

<div class="container">

    <div class="top">
        <h2>Student Records</h2>

        <a class="button" href="addStudent.jsp">
            Add Student
        </a>
    </div>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Actions</th>
        </tr>

        <c:forEach var="student" items="${students}">
            <tr>
                <td>${student.studentId}</td>
                <td><c:out value="${student.name}"/></td>
                <td><c:out value="${student.email}"/></td>
                <td><c:out value="${student.phone}"/></td>

                <td>
                    <a class="edit"
                       href="editStudent.jsp?id=${student.studentId}">
                        Edit
                    </a>

                    <a class="delete"
                       href="deleteStudent.jsp?id=${student.studentId}"
                       onclick="return confirm('Are you sure you want to delete this student?');">
                        Delete
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty students}">
            <tr>
                <td colspan="5">No student records found.</td>
            </tr>
        </c:if>
    </table>

    <a class="back" href="index.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
