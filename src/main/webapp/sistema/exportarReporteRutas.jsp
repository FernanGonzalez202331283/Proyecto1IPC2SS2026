<%-- 
    Document   : exportarReporteRutas
    Created on : 17 sept 2026, 12:49:22
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteRutasDAO"%>
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

    if (fechaInicio == null || fechaInicio.isEmpty()) {
        fechaInicio = "";
    }

    if (fechaFin == null || fechaFin.isEmpty()) {
        fechaFin = "";
    }

    ResultSet resultado = null;

    try {

        if (fechaInicio.isEmpty() || fechaFin.isEmpty()) {

            response.reset();

            response.setContentType("text/html; charset=UTF-8");

            out.println("<h2>Error al exportar el reporte</h2>");
            out.println("<p>Debe seleccionar un intervalo de fechas.</p>");

            return;
        }

        if (fechaInicio.compareTo(fechaFin) > 0) {

            response.reset();

            response.setContentType("text/html; charset=UTF-8");

            out.println("<h2>Error al exportar el reporte</h2>");
            out.println("<p>La fecha inicial no puede ser mayor que la fecha final.</p>");

            return;
        }

        ReporteRutasDAO dao = new ReporteRutasDAO();

        resultado = dao.obtenerReporte(
                fechaInicio,
                fechaFin
        );

        response.reset();

        response.setContentType("text/html; charset=UTF-8");

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteRutas.html\""
        );
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <title>Reporte de rutas más demandadas</title>

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
            Reporte de rutas más demandadas
        </h1>

        <p>
            Rutas con mayor cantidad de boletos vendidos
            durante un intervalo de fechas.
        </p>

        <div class="informacion">

            <strong>Período:</strong>

            <%= fechaInicio%>

            al

            <%= fechaFin%>

        </div>

        <table>

            <thead>

                <tr>

                    <th>
                        Posición
                    </th>

                    <th>
                        Código de ruta
                    </th>

                    <th>
                        Origen
                    </th>

                    <th>
                        Destino
                    </th>

                    <th>
                        Distancia (km)
                    </th>

                    <th>
                        Precio boleto
                    </th>

                    <th>
                        Boletos vendidos
                    </th>

                </tr>

            </thead>

            <tbody>

                <%
                    int posicion = 1;

                    boolean hayResultados = false;

                    int totalBoletos = 0;

                    while (resultado.next()) {

                        hayResultados = true;

                        String codigoRuta
                                = resultado.getString("codigo_ruta");

                        String origen
                                = resultado.getString("sucursal_origen");

                        String destino
                                = resultado.getString("sucursal_destino");

                        double distancia
                                = resultado.getDouble("distancia_km");

                        double precio
                                = resultado.getDouble("precio_boleto");

                        int boletosVendidos
                                = resultado.getInt("boletos_vendidos");

                        totalBoletos += boletosVendidos;
                %>

                <tr>

                    <td>
                        <strong>
                            <%= posicion%>
                        </strong>
                    </td>

                    <td>
                        <%= codigoRuta%>
                    </td>

                    <td>
                        <%= origen%>
                    </td>

                    <td>
                        <%= destino%>
                    </td>

                    <td class="numero">
                        <%= String.format(
                                "%.2f",
                                distancia)%>
                    </td>

                    <td class="numero">
                        Q <%= String.format(
                                "%.2f",
                                precio)%>
                    </td>

                    <td class="numero">
                        <strong>
                            <%= boletosVendidos%>
                        </strong>
                    </td>

                </tr>

                <%
                        posicion++;
                    }

                    if (!hayResultados) {
                %>

                <tr>

                    <td colspan="7">

                        No se encontraron rutas con
                        boletos vendidos en el
                        intervalo seleccionado.

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

                    <th colspan="6">
                        TOTAL DE BOLETOS VENDIDOS
                    </th>

                    <th class="numero">
                        <%= totalBoletos%>
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
