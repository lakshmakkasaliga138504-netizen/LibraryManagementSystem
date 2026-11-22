
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Student - Library Management</title>

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
            margin-bottom: 30px;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus {
            border-color: #2563eb;
            outline: none;
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
            margin-top: 20px;
            text-align: center;
            color: #2563eb;
            text-decoration: none;
        }

        .error {
            color: #dc2626;
            text-align: center;
            margin-bottom: 15px;
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
    <p>Add New Student</p>
</div>

<div class="container">

    <h2>Add Student</h2>

    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/StudentServlet"
          method="post"
          onsubmit="return validateForm()">

        <label>Student Name</label>
        <input type="text"
               id="name"
               name="name"
               placeholder="Enter student name"
               maxlength="100"
               required>

        <div id="nameError" class="field-error"></div>

        <label>Email</label>
        <input type="email"
               id="email"
               name="email"
               placeholder="Enter email address"
               maxlength="150"
               required>

        <div id="emailError" class="field-error"></div>

        <label>Phone</label>
        <input type="tel"
               id="phone"
               name="phone"
               placeholder="Enter 10-digit phone number"
               maxlength="10"
               pattern="[0-9]{10}"
               required>

        <div id="phoneError" class="field-error"></div>

        <button type="submit">Add Student</button>

    </form>

    <a class="back"
       href="${pageContext.request.contextPath}/StudentServlet">
       &#8592; Back to Students
    </a>

</div>

<script>
function validateForm() {

    let valid = true;

    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const phone = document.getElementById("phone").value.trim();

    document.getElementById("nameError").textContent = "";
    document.getElementById("emailError").textContent = "";
    document.getElementById("phoneError").textContent = "";

    if (!/^[A-Za-z][A-Za-z .'-]{1,99}$/.test(name)) {
        document.getElementById("nameError").textContent =
            "Enter a valid student name.";
        valid = false;
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        document.getElementById("emailError").textContent =
            "Enter a valid email address.";
        valid = false;
    }

    if (!/^[0-9]{10}$/.test(phone)) {
        document.getElementById("phoneError").textContent =
            "Phone number must contain exactly 10 digits.";
        valid = false;
    }

    return valid;
}
</script>

</body>
</html>
