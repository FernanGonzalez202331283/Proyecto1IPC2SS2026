<%-- 
    Document   : cambiarEstadoBus
    Created on : 7 sept 2026, 0:22:29
    Author     : fernan
--%>
<%@page import="transporte.dao.BusDAO"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {

        response.sendRedirect("../login.jsp");

    } else if (!"ADMIN_SUCURSAL".equals(
            usuarioSesion.getRol())) {

        response.sendRedirect("../inicio.jsp");

    } else {

        String codigoSucursal =
                usuarioSesion.getCodigoSucursal();

        String placa =
                request.getParameter("placa");

        String accion =
                request.getParameter("accion");

        if (placa != null &&
            !placa.trim().isEmpty() &&
            accion != null &&
            !accion.trim().isEmpty()) {

            placa = placa.trim();
            accion = accion.trim();

            BusDAO busDAO = new BusDAO();

            Bus bus =
                    busDAO.obtenerPorSucursal(
                            placa,
                            codigoSucursal
                    );

            if (bus != null) {

                if ("desactivar".equals(accion)) {

    boolean resultado =
            busDAO.desactivarPorSucursal(
                    placa,
                    codigoSucursal
            );

    if (resultado) {

        session.setAttribute(
                "mensajeBus",
                "El bus fue desactivado correctamente."
        );

        session.setAttribute(
                "tipoMensajeBus",
                "exito"
        );

    } else {

        session.setAttribute(
                "mensajeBus",
                "No se puede desactivar el bus porque tiene un viaje programado o en curso."
        );

        session.setAttribute(
                "tipoMensajeBus",
                "error"
        );
    }

} else if ("activar".equals(accion)) {

    if ("INACTIVO".equals(
            bus.getEstadoOperativo())) {

        boolean resultado =
                busDAO.activarPorSucursal(
                        placa,
                        codigoSucursal
                );

        if (resultado) {

            session.setAttribute(
                    "mensajeBus",
                    "El bus fue activado correctamente."
            );

            session.setAttribute(
                    "tipoMensajeBus",
                    "exito"
            );

        } else {

            session.setAttribute(
                    "mensajeBus",
                    "No se pudo activar el bus."
            );

            session.setAttribute(
                    "tipoMensajeBus",
                    "error"
            );
        }
    }
}
            }
        }

        response.sendRedirect("buses.jsp");
    }
%>