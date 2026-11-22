<%@ page import="java.sql.*" %>
<%@ page import="com.library.DBConnection" %>

<%
    String message = "";

    String idParam = request.getParameter("id");

    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("students.jsp");
        return;
    }

    int id = Integer.parseInt(idParam);

    String name = "";
    String email = "";
    String phone = "";

    // UPDATE student
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        name = request.getParameter("name");
        email = request.getParameter("email");
        phone = request.getParameter("phone");

        String updateSql =
                "UPDATE students SET name=?, email=?, phone=? WHERE student_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(updateSql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, id);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("students.jsp");
                return;
            } else {
                message = "Student not found!";
            }

        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        }

    } else {

        // GET student details
        String selectSql =
                "SELECT * FROM students WHERE student_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(selectSql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    name = rs.getString("name");
                    email = rs.getString("email");
                    phone = rs.getString("phone");
                } else {
                    response.sendRedirect("students.jsp");
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
    <title>Edit Student - Library Management</title>

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
    <p>Edit Student</p>
</div>

<div class="container">

    <h2>Edit Student</h2>

    <% if (!message.isEmpty()) { %>
        <div class="error">
            <%= message %>
        </div>
    <% } %>

    <form method="post">

        <label>Student Name</label>
        <input type="text"
               name="name"
               value="<%= name %>"
               required>

        <label>Email</label>
        <input type="email"
               name="email"
               value="<%= email %>"
               required>

        <label>Phone</label>
        <input type="text"
               name="phone"
               value="<%= phone %>"
               required>

        <button type="submit">
            Update Student
        </button>

    </form>

    <a class="back" href="students.jsp">
        ? Back to Students
    </a>

</div>

</body>
</html>