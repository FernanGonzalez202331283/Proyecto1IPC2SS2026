<%-- 
    Document   : desactivarChofer
    Created on : 16 sept 2026, 1:45:03
    Author     : fernan
--%>

<%@page import="transporte.dao.ChoferDAO"%>
<%@page import="transporte.modelo.Usuario"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String numeroLicencia =
            request.getParameter("numeroLicencia");

    if (numeroLicencia == null
            || numeroLicencia.trim().isEmpty()) {

        response.sendRedirect("choferes.jsp");
        return;
    }

    numeroLicencia = numeroLicencia.trim();

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    ChoferDAO choferDAO =
            new ChoferDAO();
    transporte.modelo.Chofer chofer =
            choferDAO.obtener(numeroLicencia);

    if (chofer == null
            || !codigoSucursal.equals(
                    chofer.getCodigoSucursal())) {

        response.sendRedirect("choferes.jsp");
        return;
    }

    boolean resultado =
            choferDAO.desactivar(numeroLicencia);

    response.sendRedirect("choferes.jsp");
%>

