<%-- 
    Document   : exportarReporteBoletos
    Created on : 17 sept 2026, 13:11:53
    Author     : fernan
--%>
<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.ReporteBoleto"%>
<%@page import="transporte.Reporte.ReporteBoletosDAO"%>
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

    String codigoRuta
            = request.getParameter("codigoRuta");

    String placaBus
            = request.getParameter("placaBus");

    if (fechaInicio == null) {
        fechaInicio = "";
    }

    if (fechaFin == null) {
        fechaFin = "";
    }

    if (codigoRuta == null) {
        codigoRuta = "";
    }

    if (placaBus == null) {
        placaBus = "";
    }

    try {

        ReporteBoletosDAO dao
                = new ReporteBoletosDAO();

        List<ReporteBoleto> reporte
                = dao.obtenerReporte(
                        codigoSucursal,
                        fechaInicio,
                        fechaFin,
                        codigoRuta,
                        placaBus
                );

        response.reset();

        response.setContentType(
                "text/html; charset=UTF-8"
        );

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteBoletos.html\""
        );
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <title>Reporte de boletos</title>

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
            Reporte de boletos
        </h1>

        <p>
            Boletos vendidos e ingresos generados
            por los viajes.
        </p>


        <!-- INFORMACIÓN DEL REPORTE -->

        <div class="informacion">

            <strong>Sucursal:</strong>

            <%= codigoSucursal%>

            <br><br>

            <strong>Fecha inicial:</strong>

            <%
                if (fechaInicio.isEmpty()) {
            %>

            Todas

            <%
            } else {
            %>

            <%= fechaInicio%>

            <%
                }
            %>

            <br><br>

            <strong>Fecha final:</strong>

            <%
                if (fechaFin.isEmpty()) {
            %>

            Todas

            <%
            } else {
            %>

            <%= fechaFin%>

            <%
                }
            %>

            <br><br>

            <strong>Ruta:</strong>

            <%
                if (codigoRuta.isEmpty()) {
            %>

            Todas las rutas

            <%
            } else {
            %>

            <%= codigoRuta%>

            <%
                }
            %>

            <br><br>

            <strong>Bus:</strong>

            <%
                if (placaBus.isEmpty()) {
            %>

            Todos los buses

            <%
            } else {
            %>

            <%= placaBus%>

            <%
                }
            %>

        </div>


        <!-- TABLA -->

        <table>

            <thead>

                <tr>

                    <th>
                        Código viaje
                    </th>

                    <th>
                        Ruta
                    </th>

                    <th>
                        Bus
                    </th>

                    <th>
                        Fecha de salida
                    </th>

                    <th>
                        Boletos vendidos
                    </th>

                    <th>
                        Ingreso total
                    </th>

                </tr>

            </thead>


            <tbody>

                <%
                    int totalBoletos = 0;

                    double totalIngresos = 0;

                    if (reporte.isEmpty()) {
                %>

                <tr>

                    <td colspan="6">

                        No se encontraron boletos vendidos
                        con los filtros seleccionados.

                    </td>

                </tr>

                <%
                    } else {

                        for (ReporteBoleto item : reporte) {

                            totalBoletos
                                    += item.getBoletosVendidos();

                            totalIngresos
                                    += item.getIngresoTotal();
                %>

                <tr>

                    <td>
                        <strong>
                            <%= item.getCodigoViaje()%>
                        </strong>
                    </td>

                    <td>
                        <%= item.getRuta()%>
                    </td>

                    <td>
                        <%= item.getBus()%>
                    </td>

                    <td>
                        <%= item.getFechaSalida()%>
                    </td>

                    <td class="numero">
                        <%= item.getBoletosVendidos()%>
                    </td>

                    <td class="numero">

                        Q <%= String.format(
                                "%.2f",
                                item.getIngresoTotal())%>

                    </td>

                </tr>

                <%
                        }
                    }
                %>

            </tbody>


            <!-- TOTALES -->

            <%
                if (!reporte.isEmpty()) {
            %>

            <tfoot>

                <tr>

                    <th colspan="4">
                        TOTALES
                    </th>

                    <th class="numero">
                        <%= totalBoletos%>
                    </th>

                    <th class="numero">

                        Q <%= String.format(
                                "%.2f",
                                totalIngresos)%>

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
    }
%>