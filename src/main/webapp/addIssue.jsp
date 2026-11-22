
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Issue Book - Library Management</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .header {
            background: #1f2937;
            color: white;
            padding: 25px;
            text-align: center;
        }

        .container {
            width: 500px;
            max-width: calc(100% - 40px);
            margin: 50px auto;
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.12);
            box-sizing: border-box;
        }

        h2 {
            text-align: center;
            color: #1f2937;
        }

        label {
            display: block;
            margin-top: 18px;
            margin-bottom: 7px;
            font-weight: bold;
        }

        select, input {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        button {
            width: 100%;
            margin-top: 25px;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #1d4ed8;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #2563eb;
            text-decoration: none;
        }

        .error {
            color: #dc2626;
            text-align: center;
            margin: 15px;
        }

        .field-error {
            color: #dc2626;
            font-size: 13px;
            margin-top: 5px;
        }
    </style>
</head>

<body>

<div class="header">
    <h1>Library Management System</h1>
    <p>Issue Book</p>
</div>

<div class="container">

    <h2>Issue New Book</h2>

    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/IssueServlet"
          method="post"
          onsubmit="return validateForm()">

        <label>Select Student</label>

        <select name="student_id" id="studentId" required>
            <option value="">-- Select Student --</option>

            <c:forEach var="student" items="${students}">
                <option value="${student.studentId}">
                    <c:out value="${student.name}"/>
                </option>
            </c:forEach>
        </select>

        <label>Select Book</label>

        <select name="book_id" id="bookId" required>
            <option value="">-- Select Book --</option>

            <c:forEach var="book" items="${books}">
                <c:if test="${book.quantity > 0}">
                    <option value="${book.bookId}">
                        <c:out value="${book.title}"/> -
                        <c:out value="${book.author}"/>
                        (Available: ${book.quantity})
                    </option>
                </c:if>
            </c:forEach>
        </select>

        <label>Issue Date</label>

        <input type="date"
               name="issue_date"
               id="issueDate"
               required>

        <div id="dateError" class="field-error"></div>

        <button type="submit">Issue Book</button>

    </form>

    <a class="back"
       href="${pageContext.request.contextPath}/IssueServlet">
       &#8592; Back to Issued Books
    </a>

</div>

<script>
    const dateInput = document.getElementById("issueDate");

    const today = new Date();
    const localDate = new Date(
        today.getTime() - today.getTimezoneOffset() * 60000
    ).toISOString().split("T")[0];

    dateInput.value = localDate;
    dateInput.max = localDate;

    function validateForm() {
        const student = document.getElementById("studentId").value;
        const book = document.getElementById("bookId").value;
        const date = dateInput.value;

        document.getElementById("dateError").textContent = "";

        if (!student || !book) {
            alert("Please select a student and an available book.");
            return false;
        }

        if (!date || date > localDate) {
            document.getElementById("dateError").textContent =
                "Issue date cannot be empty or in the future.";
            return false;
        }

        return true;
    }
</script>

</body>
</html>
