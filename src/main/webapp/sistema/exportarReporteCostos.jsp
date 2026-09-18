<%-- 
    Document   : exportarReporteCostos
    Created on : 17 sept 2026, 11:56:17
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteCostosDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SISTEMA".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");
    String codigoSucursal = request.getParameter("codigoSucursal");

    if (fechaInicio == null || fechaInicio.isEmpty()) {
        fechaInicio = "2026-01-01";
    }

    if (fechaFin == null || fechaFin.isEmpty()) {
        fechaFin = "2026-12-31";
    }

    if (codigoSucursal == null) {
        codigoSucursal = "";
    }

    ResultSet resultado = null;

    try {

        ReporteCostosDAO dao = new ReporteCostosDAO();

        resultado = dao.obtenerReporte(
                fechaInicio,
                fechaFin,
                codigoSucursal
        );
        response.reset();

        response.setContentType("text/html; charset=UTF-8");

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteCostos.html\""
        );

%>

<!DOCTYPE html>

<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Reporte de costos operativos</title>

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

        <h1>Reporte de costos operativos</h1>

        <p>
            Costos generados por las operaciones del sistema
        </p>

        <div class="informacion">

            <strong>Período:</strong>
            <%= fechaInicio%>
            al
            <%= fechaFin%>

            <br><br>

            <strong>Sucursal:</strong>

            <%
                if (codigoSucursal.isEmpty()) {
            %>

            Todas las sucursales

            <%
            } else {
            %>

            <%= codigoSucursal%>

            <%
                }
            %>

        </div>

        <table>

            <thead>

                <tr>

                    <th>Código</th>

                    <th>Sucursal</th>

                    <th>Combustible</th>

                    <th>Mano de obra</th>

                    <th>Repuestos</th>

                    <th>Depreciación</th>

                    <th>Total costos</th>

                </tr>

            </thead>

            <tbody>

                <%
                    double totalCombustible = 0;
                    double totalManoObra = 0;
                    double totalRepuestos = 0;
                    double totalDepreciacion = 0;
                    double totalCostos = 0;

                    boolean hayResultados = false;

                    while (resultado.next()) {

                        hayResultados = true;

                        String codigo = resultado.getString("codigo_sucursal");
                        String sucursal = resultado.getString("sucursal");

                        double combustible
                                = resultado.getDouble("combustible");

                        double manoObra
                                = resultado.getDouble("mano_obra");

                        double repuestos
                                = resultado.getDouble("repuestos");

                        double depreciacion
                                = resultado.getDouble("depreciacion");

                        double costos
                                = resultado.getDouble("total_costos");

                        totalCombustible += combustible;
                        totalManoObra += manoObra;
                        totalRepuestos += repuestos;
                        totalDepreciacion += depreciacion;
                        totalCostos += costos;
                %>

                <tr>

                    <td>
                        <%= codigo%>
                    </td>

                    <td>
                        <%= sucursal%>
                    </td>

                    <td class="numero">
                        Q <%= String.format("%.2f", combustible)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format("%.2f", manoObra)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format("%.2f", repuestos)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format("%.2f", depreciacion)%>
                    </td>

                    <td class="numero">
                        <strong>
                            Q <%= String.format("%.2f", costos)%>
                        </strong>
                    </td>

                </tr>

                <%
                    }

                    if (!hayResultados) {
                %>

                <tr>

                    <td colspan="7">
                        No se encontraron costos
                        para el intervalo seleccionado.
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

                    <th colspan="2">
                        TOTAL GENERAL
                    </th>

                    <th class="numero">
                        Q <%= String.format("%.2f", totalCombustible)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format("%.2f", totalManoObra)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format("%.2f", totalRepuestos)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format("%.2f", totalDepreciacion)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format("%.2f", totalCostos)%>
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

        response.setContentType("text/html; charset=UTF-8");

        out.println("<h2>Error al exportar el reporte</h2>");
        out.println("<p>" + e.getMessage() + "</p>");

    } finally {
        //cerramos el resultset
        if (resultado != null) {

            try {
                resultado.getStatement().getConnection().close();
            } catch (Exception e) {
            }

            try {
                resultado.close();
            } catch (Exception e) {
            }
        }
    }
%>
