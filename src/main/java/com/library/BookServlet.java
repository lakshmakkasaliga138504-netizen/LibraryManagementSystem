
package com.library;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BookServlet")
public class BookServlet extends HttpServlet {

    
private BookDAO bookDAO;

@Override
public void init() throws ServletException {
    org.springframework.context.ApplicationContext context =
        (org.springframework.context.ApplicationContext)
        getServletContext().getAttribute("springContext");

    bookDAO = context.getBean(BookDAO.class);
}


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        loadBooks(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String quantityValue = request.getParameter("quantity");

        title = title == null ? "" : title.trim();
        author = author == null ? "" : author.trim();
        category = category == null ? "" : category.trim();

        if (title.isEmpty() || title.length() > 150) {
            request.setAttribute("error", "Enter a valid book title.");
        } else if (author.isEmpty() || author.length() > 100) {
            request.setAttribute("error", "Enter a valid author name.");
        } else if (category.length() > 50) {
            request.setAttribute("error",
                    "Category cannot exceed 50 characters.");
        } else if (quantityValue == null ||
                   !quantityValue.matches("[1-9][0-9]*")) {
            request.setAttribute("error",
                    "Quantity must be a positive whole number.");
        } else {
            try {
                int quantity = Integer.parseInt(quantityValue);

                boolean added = bookDAO.addBook(
                        title, author, category, quantity);

                if (added) {
                    response.sendRedirect(
                        request.getContextPath() + "/BookServlet?success=1");
                    return;
                }

                request.setAttribute("error",
                        "Unable to add book. Please try again.");

            } catch (NumberFormatException e) {
                request.setAttribute("error",
                        "Quantity is too large.");
            }
        }

        request.getRequestDispatcher("/addBook.jsp")
               .forward(request, response);
    }

    private void loadBooks(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        try {
            request.setAttribute("books", bookDAO.getAllBooks());

            request.getRequestDispatcher("/books.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load book records.", e);
        }
    }
}
