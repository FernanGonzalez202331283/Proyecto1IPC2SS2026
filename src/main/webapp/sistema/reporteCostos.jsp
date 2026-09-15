<%-- 
    Document   : reporteCostos
    Created on : 14 sept 2026, 19:01:10
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteCostosDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="transporte.modelo.Usuario"%>

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
    String mensaje = null;

    try {

        ReporteCostosDAO dao = new ReporteCostosDAO();

        resultado = dao.obtenerReporte(
                fechaInicio,
                fechaFin,
                codigoSucursal
        );

    } catch (Exception e) {

        mensaje = "Error al obtener el reporte: " + e.getMessage();

    }
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Reporte de costos operativos</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    </head>

    <body class="bg-light">

        <div class="container py-5">

            <!-- ENCABEZADO -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="fw-bold">
                        Reporte de costos operativos
                    </h1>

                    <p class="text-muted mb-0">
                        Costos generados por las operaciones del sistema
                    </p>

                </div>

                <a href="../inicio.jsp"
                   class="btn btn-secondary">

                    Volver al inicio

                </a>

            </div>


            <!-- FILTROS -->

            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <h5 class="card-title mb-3">
                        Filtros del reporte
                    </h5>

                    <form method="GET"
                          action="reporteCostos.jsp">

                        <div class="row g-3">

                            <!-- FECHA INICIO -->

                            <div class="col-md-4">

                                <label for="fechaInicio"
                                       class="form-label">

                                    Fecha inicial

                                </label>

                                <input
                                    type="date"
                                    class="form-control"
                                    id="fechaInicio"
                                    name="fechaInicio"
                                    value="<%= fechaInicio %>"
                                    required>

                            </div>


                            <!-- FECHA FIN -->

                            <div class="col-md-4">

                                <label for="fechaFin"
                                       class="form-label">

                                    Fecha final

                                </label>

                                <input
                                    type="date"
                                    class="form-control"
                                    id="fechaFin"
                                    name="fechaFin"
                                    value="<%= fechaFin %>"
                                    required>

                            </div>


                            <!-- SUCURSAL -->

                            <div class="col-md-4">

                                <label for="codigoSucursal"
                                       class="form-label">

                                    Sucursal

                                </label>

                                <select
                                    class="form-select"
                                    id="codigoSucursal"
                                    name="codigoSucursal">

                                    <option value="">
                                        Todas las sucursales
                                    </option>

                                    <option value="S002"
                                            <%= "S002".equals(codigoSucursal) ? "selected" : "" %>>
                                        Sucursal Central
                                    </option>

                                    <option value="SUC001"
                                            <%= "SUC001".equals(codigoSucursal) ? "selected" : "" %>>
                                        Sucursal Central Guatemala
                                    </option>

                                    <option value="S001"
                                            <%= "S001".equals(codigoSucursal) ? "selected" : "" %>>
                                        Sucursal Guatemala
                                    </option>

                                    <option value="01"
                                            <%= "01".equals(codigoSucursal) ? "selected" : "" %>>
                                        SUCURSAL SAN LORENZO
                                    </option>

                                </select>

                            </div>


                            <!-- BOTÓN -->

                            <div class="col-12">

                                <button
                                    type="submit"
                                    class="btn btn-primary">

                                    Generar reporte

                                </button>

                            </div>

                        </div>

                    </form>

                </div>

            </div>


            <!-- MENSAJE DE ERROR -->

            <% if (mensaje != null) { %>

            <div class="alert alert-danger">

                <%= mensaje %>

            </div>

            <% } %>


            <!-- TABLA -->

            <% if (resultado != null) { %>

            <div class="card shadow-sm">

                <div class="card-body">

                    <div class="d-flex justify-content-between align-items-center mb-3">

                        <div>

                            <h5 class="card-title mb-1">
                                Resultados
                            </h5>

                            <p class="text-muted mb-0">

                                Desde
                                <strong><%= fechaInicio %></strong>

                                hasta

                                <strong><%= fechaFin %></strong>

                            </p>

                        </div>

                    </div>


                    <div class="table-responsive">

                        <table class="table table-bordered table-hover align-middle">

                            <thead class="table-dark">

                                <tr>

                                    <th>
                                        Código
                                    </th>

                                    <th>
                                        Sucursal
                                    </th>

                                    <th class="text-end">
                                        Combustible
                                    </th>

                                    <th class="text-end">
                                        Mano de obra
                                    </th>

                                    <th class="text-end">
                                        Repuestos
                                    </th>

                                    <th class="text-end">
                                        Depreciación
                                    </th>

                                    <th class="text-end">
                                        Total costos
                                    </th>

                                </tr>

                            </thead>

                            <tbody>

                                <%
                                    double totalCombustible = 0;
                                    double totalManoObra = 0;
                                    double totalRepuestos = 0;
                                    double totalDepreciacion = 0;
                                    double totalCostos = 0;

                                    while (resultado.next()) {

                                        double combustible =
                                                resultado.getDouble("combustible");

                                        double manoObra =
                                                resultado.getDouble("mano_obra");

                                        double repuestos =
                                                resultado.getDouble("repuestos");

                                        double depreciacion =
                                                resultado.getDouble("depreciacion");

                                        double costos =
                                                resultado.getDouble("total_costos");

                                        totalCombustible += combustible;
                                        totalManoObra += manoObra;
                                        totalRepuestos += repuestos;
                                        totalDepreciacion += depreciacion;
                                        totalCostos += costos;
                                %>

                                <tr>

                                    <td>
                                        <%= resultado.getString("codigo_sucursal") %>
                                    </td>

                                    <td>
                                        <%= resultado.getString("sucursal") %>
                                    </td>

                                    <td class="text-end">
                                        Q <%= String.format("%.2f", combustible) %>
                                    </td>

                                    <td class="text-end">
                                        Q <%= String.format("%.2f", manoObra) %>
                                    </td>

                                    <td class="text-end">
                                        Q <%= String.format("%.2f", repuestos) %>
                                    </td>

                                    <td class="text-end">
                                        Q <%= String.format("%.2f", depreciacion) %>
                                    </td>

                                    <td class="text-end fw-bold">
                                        Q <%= String.format("%.2f", costos) %>
                                    </td>

                                </tr>

                                <% } %>

                            </tbody>

                            <tfoot class="table-light">

                                <tr>

                                    <th colspan="2">
                                        TOTAL GENERAL
                                    </th>

                                    <th class="text-end">
                                        Q <%= String.format("%.2f", totalCombustible) %>
                                    </th>

                                    <th class="text-end">
                                        Q <%= String.format("%.2f", totalManoObra) %>
                                    </th>

                                    <th class="text-end">
                                        Q <%= String.format("%.2f", totalRepuestos) %>
                                    </th>

                                    <th class="text-end">
                                        Q <%= String.format("%.2f", totalDepreciacion) %>
                                    </th>

                                    <th class="text-end fw-bold">
                                        Q <%= String.format("%.2f", totalCostos) %>
                                    </th>

                                </tr>

                            </tfoot>

                        </table>

                    </div>

                </div>

            </div>

            <% } %>

        </div>


        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
        </script>

    </body>

</html>


