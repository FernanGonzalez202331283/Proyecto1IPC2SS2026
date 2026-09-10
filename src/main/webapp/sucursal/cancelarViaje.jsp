<%-- 
    Document   : cancelarViaje
    Created on : 9 sept 2026, 0:19:48
    Author     : fernan
--%>

<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.ViajeDAO"%>

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

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    String codigoViaje =
            request.getParameter("codigoViaje");

    if (codigoViaje == null
            || codigoViaje.trim().isEmpty()) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    ViajeDAO viajeDAO =
            new ViajeDAO();

    boolean cancelado =
            viajeDAO.cancelarViaje(
                    codigoViaje.trim(),
                    codigoSucursal
            );

    response.sendRedirect("viajes.jsp");
%>
