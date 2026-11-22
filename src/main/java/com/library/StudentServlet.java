
package com.library;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {

   
private StudentDAO studentDAO;

@Override
public void init() throws ServletException {
    org.springframework.context.ApplicationContext context =
        (org.springframework.context.ApplicationContext)
        getServletContext().getAttribute("springContext");

    studentDAO = context.getBean(StudentDAO.class);
}

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        loadStudents(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (name == null || email == null || phone == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/addStudent.jsp")
                   .forward(request, response);
            return;
        }

        name = name.trim();
        email = email.trim();
        phone = phone.trim();

        if (!name.matches("[A-Za-z][A-Za-z .'-]{1,99}")) {
            request.setAttribute("error", "Enter a valid student name.");
        } else if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "Enter a valid email address.");
        } else if (!phone.matches("[0-9]{10}")) {
            request.setAttribute("error", "Phone must contain exactly 10 digits.");
        } else {
            boolean added = studentDAO.addStudent(name, email, phone);

            if (added) {
                response.sendRedirect(
                    request.getContextPath() + "/StudentServlet?success=1"
                );
                return;
            }

            request.setAttribute("error",
                "Unable to add student. Check the details and try again.");
        }

        request.getRequestDispatcher("/addStudent.jsp")
               .forward(request, response);
    }

    private void loadStudents(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("students", studentDAO.getAllStudents());
            request.getRequestDispatcher("/students.jsp")
                   .forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load student records.", e);
        }
    }
}
