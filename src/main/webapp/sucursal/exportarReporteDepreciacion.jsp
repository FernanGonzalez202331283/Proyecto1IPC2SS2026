<%-- 
    Document   : exportarReporteDepreciacion
    Created on : 17 sept 2026, 13:36:22
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteDepreciacionDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="transporte.modelo.Usuario"%>

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

    ResultSet resultado = null;

    try {

        ReporteDepreciacionDAO dao
                = new ReporteDepreciacionDAO();

        resultado = dao.obtenerReporte(codigoSucursal);
        response.reset();

        response.setContentType(
                "text/html; charset=UTF-8"
        );

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteDepreciacion.html\""
        );

%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <title>
            Reporte de depreciación por bus
        </title>

        <style>

            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                color: #333;
            }

            h1 {
                text-align: center;
                margin-bottom: 10px;
            }

            .informacion {
                margin-bottom: 20px;
                padding: 15px;
                border: 1px solid #ccc;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            th,
            td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: center;
            }

            th {
                background-color: #eeeeee;
                font-weight: bold;
            }

            .total {
                margin-top: 20px;
                padding: 12px;
                border: 1px solid #ccc;
                font-size: 16px;
            }

        </style>

    </head>

    <body>

        <h1>
            Reporte de depreciación por bus
        </h1>

        <div class="informacion">

            <strong>Sucursal:</strong>
            <%= codigoSucursal%>

            <br><br>

            <strong>Información:</strong>

            Depreciación calculada utilizando el
            kilometraje actual de cada bus y la
            configuración de depreciación vigente.

        </div>

        <table>

            <thead>

                <tr>

                    <th>
                        Placa
                    </th>

                    <th>
                        Total km recorridos
                    </th>

                    <th>
                        Depreciación por km
                    </th>

                    <th>
                        Depreciación acumulada total
                    </th>

                </tr>

            </thead>

            <tbody>

                <%
                    int cantidadBuses = 0;

                    double totalDepreciacion = 0;

                    while (resultado.next()) {

                        cantidadBuses++;

                        double kilometraje =
                                resultado.getDouble(
                                        "total_km_recorridos"
                                );

                        double depreciacionPorKm =
                                resultado.getDouble(
                                        "depreciacion_por_km"
                                );

                        double depreciacionTotal =
                                resultado.getDouble(
                                        "depreciacion_total"
                                );

                        totalDepreciacion +=
                                depreciacionTotal;
                %>

                <tr>

                    <td>

                        <strong>
                            <%= resultado.getString(
                                    "placa"
                            )%>
                        </strong>

                    </td>

                    <td>

                        <%= String.format(
                                "%.2f",
                                kilometraje
                        )%>

                        km

                    </td>

                    <td>

                        Q
                        <%= String.format(
                                "%.2f",
                                depreciacionPorKm
                        )%>

                    </td>

                    <td>

                        <strong>

                            Q
                            <%= String.format(
                                    "%.2f",
                                    depreciacionTotal
                            )%>

                        </strong>

                    </td>

                </tr>

                <%
                    }

                    if (cantidadBuses == 0) {
                %>

                <tr>

                    <td colspan="4">

                        No se encontraron buses
                        para esta sucursal.

                    </td>

                </tr>

                <%
                    }
                %>

            </tbody>

        </table>

        <div class="total">

            Total de buses:

            <strong>
                <%= cantidadBuses%>
            </strong>

            <br><br>

            Depreciación acumulada total:

            <strong>
                Q
                <%= String.format(
                        "%.2f",
                        totalDepreciacion
                )%>
            </strong>

        </div>

    </body>

</html>

<%

    } catch (Exception e) {

        response.reset();

        response.setContentType(
                "text/html; charset=UTF-8"
        );

%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <title>
            Error
        </title>

    </head>

    <body>

        <h1>
            Error al generar el reporte
        </h1>

        <p>
            <%= e.getMessage()%>
        </p>

    </body>

</html>

<%

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