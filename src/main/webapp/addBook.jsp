
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Book - Library Management</title>

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
    <p>Add New Book</p>
</div>

<div class="container">

    <h2>Add Book</h2>

    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/BookServlet"
          method="post"
          onsubmit="return validateForm()">

        <label>Book Title</label>
        <input type="text"
               id="title"
               name="title"
               placeholder="Enter book title"
               maxlength="150"
               required>

        <div id="titleError" class="field-error"></div>

        <label>Author</label>
        <input type="text"
               id="author"
               name="author"
               placeholder="Enter author name"
               maxlength="100"
               required>

        <div id="authorError" class="field-error"></div>

        <label>Category</label>
        <input type="text"
               id="category"
               name="category"
               placeholder="Enter book category"
               maxlength="50">

        <div id="categoryError" class="field-error"></div>

        <label>Quantity</label>
        <input type="number"
               id="quantity"
               name="quantity"
               placeholder="Enter number of copies"
               min="1"
               max="2147483647"
               required>

        <div id="quantityError" class="field-error"></div>

        <button type="submit">Add Book</button>

    </form>

    <a class="back"
       href="${pageContext.request.contextPath}/BookServlet">
       &#8592; Back to Books
    </a>

</div>

<script>
function validateForm() {

    let valid = true;

    const title = document.getElementById("title").value.trim();
    const author = document.getElementById("author").value.trim();
    const category = document.getElementById("category").value.trim();
    const quantity = document.getElementById("quantity").value;

    document.querySelectorAll(".field-error").forEach(function(error) {
        error.textContent = "";
    });

    if (title.length < 1 || title.length > 150) {
        document.getElementById("titleError").textContent =
            "Enter a valid book title.";
        valid = false;
    }

    if (author.length < 1 || author.length > 100) {
        document.getElementById("authorError").textContent =
            "Enter a valid author name.";
        valid = false;
    }

    if (category.length > 50) {
        document.getElementById("categoryError").textContent =
            "Category cannot exceed 50 characters.";
        valid = false;
    }

    if (!/^[1-9][0-9]*$/.test(quantity) ||
        Number(quantity) > 2147483647) {
        document.getElementById("quantityError").textContent =
            "Quantity must be a positive whole number.";
        valid = false;
    }

    return valid;
}
</script>

</body>
</html>
