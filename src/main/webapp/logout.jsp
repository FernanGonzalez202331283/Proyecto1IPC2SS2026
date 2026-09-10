<%-- 
    Document   : logout
    Created on : 4 sept 2026, 1:36:36
    Author     : fernan
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>
