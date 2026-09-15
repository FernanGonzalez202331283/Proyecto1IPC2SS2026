<%-- 
    Document   : reporteDepreciacion
    Created on : 15 sept 2026, 1:39:43
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteDepreciacionDAO"%>
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

    ReporteDepreciacionDAO dao = new ReporteDepreciacionDAO();

    ResultSet resultado = null;

    String mensajeError = null;

    try {

        resultado = dao.obtenerReporte(codigoSucursal);

%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Reporte de depreciación por bus</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    </head>

    <body class="bg-light">

        <nav class="navbar navbar-dark bg-dark">

            <div class="container">

                <a class="navbar-brand" href="../inicio.jsp">
                    Transporte Extraurbano
                </a>

                <span class="navbar-text text-white">
                    Reporte de depreciación
                </span>

            </div>

        </nav>


        <main class="container py-5">

            <!-- ENCABEZADO -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="h3 mb-1">
                        Reporte de depreciación por bus
                    </h1>

                    <p class="text-muted mb-0">
                        Consulta la depreciación acumulada de los buses
                        de la sucursal.
                    </p>

                </div>

                <a href="../inicio.jsp"
                   class="btn btn-outline-secondary">

                    Volver

                </a>

            </div>


            <!-- INFORMACIÓN -->

            <div class="alert alert-info">

                <strong>Sucursal:</strong>
                <%= codigoSucursal%>

                <br>

                La depreciación se calcula utilizando el kilometraje
                actual del bus y la configuración de depreciación
                vigente más reciente.

            </div>


            <!-- RESULTADOS -->

            <div class="card shadow-sm">

                <div class="card-header bg-primary text-white">

                    <h2 class="h5 mb-0">
                        Depreciación de los buses
                    </h2>

                </div>

                <div class="card-body p-0">

                    <div class="table-responsive">

                        <table class="table table-striped table-hover mb-0">

                            <thead class="table-dark">

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
                                    boolean hayResultados = false;

                                    while (resultado.next()) {

                                        hayResultados = true;
                                %>

                                <tr>

                                    <td>
                                        <strong>
                                            <%= resultado.getString("placa")%>
                                        </strong>
                                    </td>

                                    <td>
                                        <%= String.format(
                                                "%.2f",
                                                resultado.getDouble("total_km_recorridos")
                                        )%>
                                        km
                                    </td>

                                    <td>

                                        Q
                                        <%= String.format(
                                                "%.2f",
                                                resultado.getDouble("depreciacion_por_km")
                                        )%>

                                    </td>

                                    <td>

                                        <strong>

                                            Q
                                            <%= String.format(
                                                    "%.2f",
                                                    resultado.getDouble("depreciacion_total")
                                            )%>

                                        </strong>

                                    </td>

                                </tr>

                                <%
                                    }

                                    if (!hayResultados) {
                                %>

                                <tr>

                                    <td colspan="4"
                                        class="text-center text-muted py-4">

                                        No se encontraron buses
                                        para esta sucursal.

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </main>


        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
        </script>

    </body>

</html>

<%
} catch (Exception e) {

    mensajeError = e.getMessage();

%>

<div class="container mt-5">

    <div class="alert alert-danger">

        <strong>
            Error al generar el reporte:
        </strong>

        <%= mensajeError%>

    </div>

    <a href="../inicio.jsp"
       class="btn btn-secondary">

        Volver al inicio

    </a>

</div>

<%

    } finally {

        try {

            if (resultado != null) {
                resultado.close();
            }

        } catch (Exception e) {
        }

    }

%>

