<%-- 
    Document   : exportarReporteChoferes
    Created on : 17 sept 2026, 13:32:02
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteChoferesDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="transporte.modelo.Usuario"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal = usuario.getCodigoSucursal();

    ResultSet resultado = null;

    try {

        ReporteChoferesDAO dao = new ReporteChoferesDAO();

        resultado = dao.obtenerReporte(codigoSucursal);
        response.reset();
        response.setContentType(
                "text/html; charset=UTF-8"
        );
        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteChoferes.html\""
        );

%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">

        <title>Reporte de Choferes</title>

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

            .estado-activo {
                font-weight: bold;
            }

            .estado-inactivo {
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
            Listado de Choferes
        </h1>

        <div class="informacion">

            <strong>Sucursal:</strong>
            <%= codigoSucursal%>

            <br><br>

            <strong>Reporte:</strong>
            Información general de los choferes
            pertenecientes a esta sucursal.

        </div>

        <table>

            <thead>

                <tr>

                    <th>
                        Número de licencia
                    </th>

                    <th>
                        Nombre completo
                    </th>

                    <th>
                        Tipo de licencia
                    </th>

                    <th>
                        Fecha de vencimiento
                    </th>

                    <th>
                        Estado
                    </th>

                    <th>
                        Total de viajes
                    </th>

                </tr>

            </thead>

            <tbody>

                <%
                    int cantidadChoferes = 0;
                    int totalViajes = 0;

                    while (resultado.next()) {

                        cantidadChoferes++;

                        int estado =
                                resultado.getInt("estado");

                        int viajes =
                                resultado.getInt("total_viajes");

                        totalViajes += viajes;
                %>

                <tr>

                    <td>

                        <strong>
                            <%= resultado.getString(
                                    "numero_licencia"
                            )%>
                        </strong>

                    </td>

                    <td>
                        <%= resultado.getString(
                                "nombre_completo"
                        )%>
                    </td>

                    <td>
                        <%= resultado.getString(
                                "tipo_licencia"
                        )%>
                    </td>

                    <td>
                        <%= resultado.getDate(
                                "fecha_vencimiento_licencia"
                        )%>
                    </td>

                    <td>

                        <% if (estado == 1) { %>

                            <span class="estado-activo">
                                Activo
                            </span>

                        <% } else { %>

                            <span class="estado-inactivo">
                                Inactivo
                            </span>

                        <% } %>

                    </td>

                    <td>
                        <%= viajes%>
                    </td>

                </tr>

                <%
                    }

                    if (cantidadChoferes == 0) {
                %>

                <tr>

                    <td colspan="6">

                        No hay choferes registrados
                        en esta sucursal.

                    </td>

                </tr>

                <%
                    }
                %>

            </tbody>

        </table>

        <div class="total">

            Total de choferes encontrados:

            <strong>
                <%= cantidadChoferes%>
            </strong>

            <br><br>

            Total de viajes realizados:

            <strong>
                <%= totalViajes%>
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

        <title>Error</title>

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
