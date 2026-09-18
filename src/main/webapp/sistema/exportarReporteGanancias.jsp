<%-- 
    Document   : exportarReporteGanancias
    Created on : 17 sept 2026, 12:26:22
    Author     : fernan
--%>

<%@page import="transporte.Reporte.ReporteGananciasDAO"%>
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
        fechaInicio = "";
    }

    if (fechaFin == null || fechaFin.isEmpty()) {
        fechaFin = "";
    }

    if (codigoSucursal == null) {
        codigoSucursal = "";
    }

    ResultSet resultado = null;

    try {

        ReporteGananciasDAO dao = new ReporteGananciasDAO();

        resultado = dao.obtenerReporte(
                fechaInicio,
                fechaFin,
                codigoSucursal
        );

        response.reset();

        response.setContentType("text/html; charset=UTF-8");

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteGanancias.html\""
        );
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <title>Reporte de ganancias</title>

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

        <h1>Reporte de ganancias</h1>

        <p>
            Ingresos, costos y resultado neto de las sucursales
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

                    <th>Sucursal</th>

                    <th>Ingresos boletos</th>

                    <th>Ingresos alquileres</th>

                    <th>Total ingresos</th>

                    <th>Combustible</th>

                    <th>Mano de obra</th>

                    <th>Repuestos</th>

                    <th>Depreciación</th>

                    <th>Total costos</th>

                    <th>Ganancia / Pérdida</th>

                </tr>

            </thead>

            <tbody>

                <%
                    double totalIngresosBoletos = 0;
                    double totalIngresosAlquileres = 0;
                    double totalIngresos = 0;

                    double totalCombustible = 0;
                    double totalManoObra = 0;
                    double totalRepuestos = 0;
                    double totalDepreciacion = 0;

                    double totalCostos = 0;
                    double totalGanancia = 0;

                    boolean hayResultados = false;

                    while (resultado.next()) {

                        hayResultados = true;

                        String sucursal
                                = resultado.getString("sucursal");

                        double ingresosBoletos
                                = resultado.getDouble("ingresos_boletos");

                        double ingresosAlquileres
                                = resultado.getDouble("ingresos_alquileres");

                        double ingresos
                                = resultado.getDouble("total_ingresos");

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

                        double ganancia
                                = resultado.getDouble("ganancia_neta");

                        totalIngresosBoletos += ingresosBoletos;
                        totalIngresosAlquileres += ingresosAlquileres;
                        totalIngresos += ingresos;

                        totalCombustible += combustible;
                        totalManoObra += manoObra;
                        totalRepuestos += repuestos;
                        totalDepreciacion += depreciacion;

                        totalCostos += costos;
                        totalGanancia += ganancia;
                %>

                <tr>

                    <td>
                        <strong>
                            <%= sucursal%>
                        </strong>
                    </td>

                    <td class="numero">
                        Q <%= String.format(
                                "%.2f",
                                ingresosBoletos)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format(
                                "%.2f",
                                ingresosAlquileres)%>
                    </td>

                    <td class="numero">
                        <strong>
                            Q <%= String.format(
                                    "%.2f",
                                    ingresos)%>
                        </strong>
                    </td>

                    <td class="numero">
                        Q <%= String.format(
                                "%.2f",
                                combustible)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format(
                                "%.2f",
                                manoObra)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format(
                                "%.2f",
                                repuestos)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format(
                                "%.2f",
                                depreciacion)%>
                    </td>

                    <td class="numero">
                        <strong>
                            Q <%= String.format(
                                    "%.2f",
                                    costos)%>
                        </strong>
                    </td>

                    <td class="numero">
                        <strong>
                            Q <%= String.format(
                                    "%.2f",
                                    ganancia)%>
                        </strong>
                    </td>

                </tr>

                <%
                    }

                    if (!hayResultados) {
                %>

                <tr>

                    <td colspan="10">
                        No se encontraron resultados
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

                    <th>
                        TOTALES
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalIngresosBoletos)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalIngresosAlquileres)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalIngresos)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalCombustible)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalManoObra)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalRepuestos)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalDepreciacion)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalCostos)%>
                    </th>

                    <th class="numero">
                        Q <%= String.format(
                                "%.2f",
                                totalGanancia)%>
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
