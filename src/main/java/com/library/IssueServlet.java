
package com.library;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/IssueServlet")
public class IssueServlet extends HttpServlet {

    
private IssueDAO issueDAO;
private StudentDAO studentDAO;
private BookDAO bookDAO;

@Override
public void init() throws ServletException {

    org.springframework.context.ApplicationContext context =
        (org.springframework.context.ApplicationContext)
        getServletContext().getAttribute("springContext");

    issueDAO = context.getBean(IssueDAO.class);
    studentDAO = context.getBean(StudentDAO.class);
    bookDAO = context.getBean(BookDAO.class);
}


    @Override
protected void doGet(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if ("new".equals(action)) {
        loadPage(request, response, "/addIssue.jsp");
    } else {
        loadPage(request, response, "/issues.jsp");
    }
}

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // Return an issued book
        if ("return".equals(action)) {
            try {
                int issueId = Integer.parseInt(
                    request.getParameter("issue_id"));

                if (issueId <= 0 || !issueDAO.returnBook(issueId)) {
                    request.setAttribute("error",
                            "Unable to return this book.");
                    loadPage(request, response, "/issues.jsp");
                    return;
                }

                response.sendRedirect(
                    request.getContextPath() + "/IssueServlet?success=1");
                return;

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid issue ID.");
                loadPage(request, response, "/issues.jsp");
                return;
            }
        }

        // Issue a new book
        String studentValue = request.getParameter("student_id");
        String bookValue = request.getParameter("book_id");
        String dateValue = request.getParameter("issue_date");

        int studentId;
        int bookId;
        LocalDate issueDate;

        try {
            studentId = Integer.parseInt(studentValue);
            bookId = Integer.parseInt(bookValue);
            issueDate = LocalDate.parse(dateValue);

            if (studentId <= 0 || bookId <= 0
                    || issueDate.isAfter(LocalDate.now())) {
                throw new IllegalArgumentException();
            }

        } catch (Exception e) {
            request.setAttribute("error",
                    "Select a valid student, book and issue date.");
            loadPage(request, response, "/addIssue.jsp");
            return;
        }

        String insertSql =
            "INSERT INTO issues (student_id, book_id, issue_date) "
            + "VALUES (?, ?, ?)";

        String updateSql =
            "UPDATE books SET quantity = quantity - 1 "
            + "WHERE book_id = ? AND quantity > 0";

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                // Check student exists
                try (PreparedStatement ps = con.prepareStatement(
                    "SELECT student_id FROM students WHERE student_id=?")) {

                    ps.setInt(1, studentId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Student not found.");
                        }
                    }
                }

                // Reduce available book quantity
                try (PreparedStatement ps =
                         con.prepareStatement(updateSql)) {

                    ps.setInt(1, bookId);

                    if (ps.executeUpdate() == 0) {
                        throw new SQLException(
                            "Book not found or no copies available.");
                    }
                }

                // Insert issue record
                try (PreparedStatement ps =
                         con.prepareStatement(insertSql)) {

                    ps.setInt(1, studentId);
                    ps.setInt(2, bookId);
                    ps.setDate(3, Date.valueOf(issueDate));
                    ps.executeUpdate();
                }

                con.commit();

                response.sendRedirect(
                    request.getContextPath() + "/IssueServlet?success=1");
                return;

            } catch (SQLException e) {
                con.rollback();
                throw e;

            } finally {
                con.setAutoCommit(true);
            }

        } catch (SQLException e) {
            getServletContext().log("Issue operation failed.", e);

            request.setAttribute("error",
                    "Unable to issue book: " + e.getMessage());

            loadPage(request, response, "/addIssue.jsp");
        }
    }

    private void loadPage(HttpServletRequest request,
                          HttpServletResponse response,
                          String page)
            throws ServletException, IOException {

        try {
            request.setAttribute("issues", issueDAO.getAllIssues());
            request.setAttribute("students", studentDAO.getAllStudents());
            request.setAttribute("books", bookDAO.getAllBooks());

            request.getRequestDispatcher(page).forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load issue management data.", e);
        }
    }
}
