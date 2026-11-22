<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System</title>

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

        .header h1 {
            margin: 0;
            font-size: 32px;
        }

        .header p {
            margin-top: 8px;
            color: #d1d5db;
        }

        .container {
            width: 85%;
            margin: 40px auto;
        }

        .welcome {
            text-align: center;
            margin-bottom: 35px;
        }

        .welcome h2 {
            color: #1f2937;
        }

        .cards {
            display: flex;
            justify-content: center;
            gap: 25px;
            flex-wrap: wrap;
        }

        .card {
            background: white;
            width: 230px;
            padding: 30px;
            text-align: center;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }

        .card h3 {
            color: #2563eb;
        }

        .card p {
            color: #666;
        }

        .button {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .button:hover {
            background: #1d4ed8;
        }

        .footer {
            margin-top: 60px;
            background: #1f2937;
            color: white;
            text-align: center;
            padding: 15px;
        }
    </style>
</head>

<body>

    <div class="header">
    <h1>Library Management System</h1>
    <p>Manage Students, Books and Book Issues</p>

    <a href="LogoutServlet"
       style="display:inline-block;
              margin-top:15px;
              padding:10px 22px;
              background:#dc2626;
              color:white;
              text-decoration:none;
              border-radius:6px;">
        Logout
    </a>
</div>

    <div class="container">

        <div class="welcome">
            <h2>Welcome to Library Management System</h2>
            <p>Select an option below to manage the library.</p>
        </div>

        <div class="cards">

            <div class="card">
                <h3>Students</h3>
                <p>Add, view, update and delete student records.</p>
               <a class="button" href="StudentServlet">Manage Students</a>
            </div>

            <div class="card">
                <h3>Books</h3>
                <p>Manage available books in the library.</p>
               <a href="BookServlet" class="button">Manage Books</a>
            </div>

            <div class="card">
                <h3>Issue Books</h3>
                <p>Issue books to students and view issued books.</p>
                <a href="IssueServlet" class="button">Manage Issues</a>
            </div>

        </div>

    </div>

    <div class="footer">
        <p>Library Management System | Advanced Java Technology</p>
    </div>

</body>
</html>
