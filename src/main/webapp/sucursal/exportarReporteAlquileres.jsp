<%-- 
    Document   : exportarReporteAlquileres
    Created on : 17 sept 2026, 13:03:52
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteAlquileresDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion
            = (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal
            = usuarioSesion.getCodigoSucursal();

    String fechaInicio
            = request.getParameter("fechaInicio");

    String fechaFin
            = request.getParameter("fechaFin");

    if (fechaInicio == null || fechaInicio.trim().isEmpty()) {
        fechaInicio = null;
    }

    if (fechaFin == null || fechaFin.trim().isEmpty()) {
        fechaFin = null;
    }

    ResultSet resultado = null;

    try {

        ReporteAlquileresDAO dao
                = new ReporteAlquileresDAO();

        resultado = dao.obtenerReporte(
                codigoSucursal,
                fechaInicio,
                fechaFin
        );

        response.reset();

        response.setContentType(
                "text/html; charset=UTF-8"
        );

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteAlquileres.html\""
        );
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <title>Reporte de alquileres</title>

        <style>

            body {
                font-family: Arial, Helvetica, sans-serif;
                margin: 30px;
                color: #222;
                background-color: #ffffff;
            }

            h1 {
                margin-bottom: 5px;
            }

            .informacion {
                margin-bottom: 25px;
                padding: 15px;
                background-color: #f1f3f5;
                border-radius: 6px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            th,
            td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
            }

            th {
                background-color: #f1f3f5;
                font-weight: bold;
            }

            .numero {
                text-align: right;
            }

            tfoot th {
                background-color: #e9ecef;
            }

        </style>

    </head>

    <body>

        <h1>
            Reporte de alquileres
        </h1>

        <p>
            Ingresos por alquiler de buses
        </p>

        <div class="informacion">

            <strong>Sucursal:</strong>

            <%= codigoSucursal%>

            <br><br>

            <strong>Período:</strong>

            <%
                if (fechaInicio == null && fechaFin == null) {
            %>

            Todos los registros

            <%
            } else {
            %>

            <%= fechaInicio != null ? fechaInicio : "Sin fecha inicial"%>

            al

            <%= fechaFin != null ? fechaFin : "Sin fecha final"%>

            <%
                }
            %>

        </div>

        <table>

            <thead>

                <tr>

                    <th>
                        Código de alquiler
                    </th>

                    <th>
                        Cliente
                    </th>

                    <th>
                        Origen
                    </th>

                    <th>
                        Destino
                    </th>

                    <th>
                        Fecha de salida
                    </th>

                    <th>
                        Fecha de retorno
                    </th>

                    <th>
                        Bus
                    </th>

                    <th>
                        Precio total
                    </th>

                </tr>

            </thead>

            <tbody>

                <%
                    boolean hayResultados = false;

                    double totalAlquileres = 0;

                    while (resultado.next()) {

                        hayResultados = true;

                        String codigoAlquiler
                                = resultado.getString(
                                        "codigo_alquiler"
                                );

                        String cliente
                                = resultado.getString(
                                        "cliente"
                                );

                        String origen
                                = resultado.getString(
                                        "origen"
                                );

                        String destino
                                = resultado.getString(
                                        "destino"
                                );

                        java.sql.Date fechaSalida
                                = resultado.getDate(
                                        "fecha_salida"
                                );

                        java.sql.Date fechaRetorno
                                = resultado.getDate(
                                        "fecha_retorno"
                                );

                        String bus
                                = resultado.getString(
                                        "bus"
                                );

                        double precioTotal
                                = resultado.getDouble(
                                        "precio_total"
                                );

                        totalAlquileres += precioTotal;
                %>

                <tr>

                    <td>
                        <strong>
                            <%= codigoAlquiler%>
                        </strong>
                    </td>

                    <td>
                        <%= cliente%>
                    </td>

                    <td>
                        <%= origen%>
                    </td>

                    <td>
                        <%= destino%>
                    </td>

                    <td>
                        <%= fechaSalida%>
                    </td>

                    <td>
                        <%= fechaRetorno%>
                    </td>

                    <td>
                        <%= bus%>
                    </td>

                    <td class="numero">

                        Q <%= String.format(
                                "%.2f",
                                precioTotal)%>

                    </td>

                </tr>

                <%
                    }

                    if (!hayResultados) {
                %>

                <tr>

                    <td colspan="8">

                        No se encontraron alquileres
                        para los filtros seleccionados.

                    </td>

                </tr>

                <%
                    }
                %>

            </tbody>

            <%
                if (hayResultados) {
            %>

            <tfoot>

                <tr>

                    <th colspan="7">
                        TOTAL INGRESOS POR ALQUILERES
                    </th>

                    <th class="numero">

                        Q <%= String.format(
                                "%.2f",
                                totalAlquileres)%>

                    </th>

                </tr>

            </tfoot>

            <%
                }
            %>

        </table>

    </body>

</html>

<%
    } catch (Exception e) {

        response.reset();

        response.setContentType(
                "text/html; charset=UTF-8"
        );

        out.println(
                "<h2>Error al exportar el reporte</h2>"
        );

        out.println(
                "<p>" + e.getMessage() + "</p>"
        );

    } finally {

        if (resultado != null) {

            try {

                resultado.getStatement()
                        .getConnection()
                        .close();

            } catch (Exception e) {
            }

            try {

                resultado.close();

            } catch (Exception e) {
            }
        }
    }
%>
