<%-- 
    Document   : activarRuta
    Created on : 8 sept 2026, 23:14:14
    Author     : fernan
--%>

<%-- 
    Document   : activarRuta
    Created on : 8 sept 2026
--%>

<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.RutaDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    String rolSesion =
            (String) session.getAttribute("rol");

    if (usuarioSesion == null
            || rolSesion == null
            || !"ADMIN_SUCURSAL".equals(rolSesion)) {

        response.sendRedirect("../login.jsp");
        return;
    }

    String codigoRuta =
            request.getParameter("codigoRuta");

    if (codigoRuta == null
            || codigoRuta.trim().isEmpty()) {

        response.sendRedirect("ruta.jsp");
        return;
    }

    RutaDAO rutaDAO = new RutaDAO();

    rutaDAO.activar(codigoRuta.trim());

    response.sendRedirect("ruta.jsp");
%>