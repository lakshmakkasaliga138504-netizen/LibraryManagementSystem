<%@ page import="java.sql.*" %>
<%@ page import="com.library.DBConnection" %>

<%
    String message = "";

    String idParam = request.getParameter("id");

    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("books.jsp");
        return;
    }

    int id = Integer.parseInt(idParam);

    String title = "";
    String author = "";
    String category = "";
    int quantity = 0;

    // UPDATE BOOK
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        title = request.getParameter("title");
        author = request.getParameter("author");
        category = request.getParameter("category");

        try {
            quantity = Integer.parseInt(request.getParameter("quantity"));

            String updateSql =
                    "UPDATE books SET title=?, author=?, category=?, quantity=? WHERE book_id=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(updateSql)) {

                ps.setString(1, title);
                ps.setString(2, author);
                ps.setString(3, category);
                ps.setInt(4, quantity);
                ps.setInt(5, id);

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("books.jsp");
                    return;
                } else {
                    message = "Book not found!";
                }
            }

        } catch (NumberFormatException e) {
            message = "Quantity must be a valid number!";
        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        }

    } else {

        // GET BOOK DETAILS
        String selectSql =
                "SELECT * FROM books WHERE book_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(selectSql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    title = rs.getString("title");
                    author = rs.getString("author");
                    category = rs.getString("category");
                    quantity = rs.getInt("quantity");
                } else {
                    response.sendRedirect("books.jsp");
                    return;
                }
            }

        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Book - Library Management</title>

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
            margin: 50px auto;
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.12);
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
            background: #16a34a;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #15803d;
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
    </style>
</head>

<body>

<div class="header">
    <h1>Library Management System</h1>
    <p>Edit Book</p>
</div>

<div class="container">

    <h2>Edit Book</h2>

    <% if (!message.isEmpty()) { %>
        <div class="error">
            <%= message %>
        </div>
    <% } %>

    <form method="post">

        <label>Book Title</label>
        <input type="text"
               name="title"
               value="<%= title %>"
               required>

        <label>Author</label>
        <input type="text"
               name="author"
               value="<%= author %>"
               required>

        <label>Category</label>
        <input type="text"
               name="category"
               value="<%= category %>"
               required>

        <label>Quantity</label>
        <input type="number"
               name="quantity"
               value="<%= quantity %>"
               min="1"
               required>

        <button type="submit">
            Update Book
        </button>

    </form>

    <a class="back" href="books.jsp">
        ? Back to Books
    </a>

</div>

</body>
</html>