<%-- 
    Document   : exportarReporteBuses
    Created on : 17 sept 2026, 13:24:33
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteBusesDAO"%>
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

    String estadoOperativo = request.getParameter("estadoOperativo");

    if (estadoOperativo == null) {
        estadoOperativo = "";
    }

    ResultSet resultado = null;

    try {

        ReporteBusesDAO dao = new ReporteBusesDAO();

        resultado = dao.obtenerReporte(
                codigoSucursal,
                estadoOperativo
        );
        response.reset();

        response.setContentType("text/html; charset=UTF-8");

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"reporteBuses.html\""
        );

%>
<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <title>Reporte general de buses</title>

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
            Listado general de buses
        </h1>

        <div class="informacion">

            <strong>Sucursal:</strong>
            <%= codigoSucursal%>

            <br><br>

            <strong>Estado operativo:</strong>

            <%
                if (estadoOperativo == null
                        || estadoOperativo.isEmpty()) {
            %>

                Todos los estados

            <%
                } else {
            %>

                <%= estadoOperativo%>

            <%
                }
            %>

        </div>

        <table>

            <thead>

                <tr>

                    <th>
                        Placa
                    </th>

                    <th>
                        Marca
                    </th>

                    <th>
                        Modelo
                    </th>

                    <th>
                        Capacidad
                    </th>

                    <th>
                        Estado operativo
                    </th>

                    <th>
                        Chofer asignado actualmente
                    </th>

                    <th>
                        Kilometraje actual
                    </th>

                    <th>
                        Total de viajes
                    </th>

                </tr>

            </thead>

            <tbody>

                <%
                    int cantidadBuses = 0;

                    while (resultado.next()) {

                        cantidadBuses++;

                        String estado
                                = resultado.getString(
                                        "estado_operativo"
                                );
                %>

                <tr>

                    <td>
                        <strong>
                            <%= resultado.getString("placa")%>
                        </strong>
                    </td>

                    <td>
                        <%= resultado.getString("marca")%>
                    </td>

                    <td>
                        <%= resultado.getString("modelo")%>
                    </td>

                    <td>
                        <%= resultado.getInt("capacidad")%>
                    </td>

                    <td>

                        <%
                            if ("DISPONIBLE".equals(estado)) {
                        %>

                            <span class="estado-activo">
                                Disponible
                            </span>

                        <%
                            } else if ("EN_VIAJE".equals(estado)) {
                        %>

                            <span class="estado-activo">
                                En viaje
                            </span>

                        <%
                            } else if ("MANTENIMIENTO".equals(estado)) {
                        %>

                            <span class="estado-inactivo">
                                Mantenimiento
                            </span>

                        <%
                            } else if ("INACTIVO".equals(estado)) {
                        %>

                            <span class="estado-inactivo">
                                Inactivo
                            </span>

                        <%
                            } else {
                        %>

                            <span>
                                <%= estado%>
                            </span>

                        <%
                            }
                        %>

                    </td>

                    <td>
                        <%= resultado.getString(
                                "chofer_asignado"
                        )%>
                    </td>

                    <td>

                        <%= String.format(
                                "%.2f",
                                resultado.getDouble(
                                        "kilometraje_actual"
                                )
                        )%>
                        km

                    </td>

                    <td>

                        <%= resultado.getInt(
                                "total_viajes"
                        )%>

                    </td>

                </tr>

                <%
                    }

                    if (cantidadBuses == 0) {
                %>

                <tr>

                    <td colspan="8">
                        No se encontraron buses para
                        el filtro seleccionado.
                    </td>

                </tr>

                <%
                    }
                %>

            </tbody>

        </table>

        <div class="total">

            Total de buses encontrados:

            <strong>
                <%= cantidadBuses%>
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

        <h1>Error al generar el reporte</h1>

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
