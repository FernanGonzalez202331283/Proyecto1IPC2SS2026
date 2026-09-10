<%-- 
    Document   : desactivarRuta
    Created on : 8 sept 2026, 23:13:38
    Author     : fernan
--%>
<%@page import="transporte.dao.RutaDAO"%>
<%@page import="transporte.modelo.Usuario"%>
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

    rutaDAO.desactivar(codigoRuta.trim());

    response.sendRedirect("ruta.jsp");
%>