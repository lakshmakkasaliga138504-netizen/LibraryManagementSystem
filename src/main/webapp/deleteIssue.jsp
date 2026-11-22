<%@ page import="java.sql.*" %>
<%@ page import="com.library.DBConnection" %>

<%
    String idParam = request.getParameter("id");

    if (idParam != null && !idParam.isEmpty()) {

        try {
            int id = Integer.parseInt(idParam);

            String sql = "DELETE FROM issues WHERE issue_id=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            out.println("Return operation failed: " + e.getMessage());
            return;
        }
    }

    response.sendRedirect("issues.jsp");
%>