<%--
Document   : reporteCostos
Created on : 14 sept 2026, 19:01:10
Author     : fernan
--%>

<%@page import="transporte.Reporte.ReporteCostosDAO"%>
<%@page import="transporte.dao.SucursalDAO"%>
<%@page import="transporte.modelo.Sucursal"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
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

// Obtener las sucursales desde la base de datos
    SucursalDAO sucursalDAO = new SucursalDAO();
    List<Sucursal> sucursales = sucursalDAO.listar();

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

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Reporte de costos operativos</title>

        <link
            rel="stylesheet"
            href="../resources/css/styles.css">

    </head>

    <body>

        <div class="pagina">

            <!-- ENCABEZADO -->

            <div class="encabezado">

                <h1>
                    Reporte de costos operativos
                </h1>

                <p>
                    Costos generados por las operaciones del sistema
                </p>

            </div>


            <!-- FILTROS -->

            <section class="formulario">

                <h2>
                    Filtros del reporte
                </h2>

                <form
                    method="GET"
                    action="reporteCostos.jsp"
                    id="formularioReporte">

                    <div class="form-group">

                        <label for="fechaInicio">
                            Fecha inicial
                        </label>

                        <input
                            type="date"
                            id="fechaInicio"
                            name="fechaInicio"
                            value="<%= fechaInicio%>"
                            required>

                        <div
                            id="mensajeFechaInicio"
                            class="campo-error">
                        </div>

                    </div>


                    <div class="form-group">

                        <label for="fechaFin">
                            Fecha final
                        </label>

                        <input
                            type="date"
                            id="fechaFin"
                            name="fechaFin"
                            value="<%= fechaFin%>"
                            required>

                        <div
                            id="mensajeFechaFin"
                            class="campo-error">
                        </div>

                    </div>


                    <div class="form-group">

                        <label for="codigoSucursal">
                            Sucursal
                        </label>

                        <select
                            id="codigoSucursal"
                            name="codigoSucursal">

                            <option value="">
                                Todas las sucursales
                            </option>

                            <%
                                for (Sucursal sucursal : sucursales) {

                                    // Solo mostrar sucursales activas
                                    if (!sucursal.isEstado()) {
                                        continue;
                                    }
                            %>

                            <option
                                value="<%= sucursal.getCodigoSucursal()%>"
                                <%= sucursal.getCodigoSucursal().equals(codigoSucursal)
                                        ? "selected"
                                        : ""%>>

                                <%= sucursal.getNombre()%>

                            </option>

                            <%
                                }
                            %>

                        </select>

                    </div>


                    <div
                        id="mensajeReporte"
                        class="campo-error">
                    </div>

                <div class="botones">

                    <button
                        type="submit"
                        class="boton">
                        Generar reporte
                    </button>

                    <a
                        href="reporteCostos.jsp"
                        class="boton">
                        Limpiar
                    </a>

                </div>

                </form>

                <!-- Exportar el reporte actual a HTML -->
                <form
                    method="GET"
                    action="exportarReporteCostos.jsp"
                    class="botones">

                    <input
                        type="hidden"
                        name="fechaInicio"
                        value="<%= fechaInicio %>">

                    <input
                        type="hidden"
                        name="fechaFin"
                        value="<%= fechaFin %>">

                    <input
                        type="hidden"
                        name="codigoSucursal"
                        value="<%= codigoSucursal %>">

                    <button
                        type="submit"
                        class="boton">
                        Exportar HTML
                    </button>

                </form>

            </section>


            <!-- MENSAJE DE ERROR DEL SERVIDOR -->

            <% if (mensaje != null) {%>

            <div class="mensaje error">

                <%= mensaje%>

            </div>

            <% } %>


            <!-- RESULTADOS -->

            <% if (resultado != null) {%>

            <section class="formulario">

                <div class="encabezado">

                    <h2>
                        Resultados
                    </h2>

                    <p>
                        Desde
                        <strong><%= fechaInicio%></strong>
                        hasta
                        <strong><%= fechaFin%></strong>
                    </p>

                </div>


                <div class="tabla-contenedor">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Código
                                </th>

                                <th>
                                    Sucursal
                                </th>

                                <th>
                                    Combustible
                                </th>

                                <th>
                                    Mano de obra
                                </th>

                                <th>
                                    Repuestos
                                </th>

                                <th>
                                    Depreciación
                                </th>

                                <th>
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

                                boolean hayResultados = false;

                                while (resultado.next()) {

                                    hayResultados = true;

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
                                    <%= resultado.getString("codigo_sucursal")%>
                                </td>

                                <td>
                                    <%= resultado.getString("sucursal")%>
                                </td>

                                <td>
                                    Q <%= String.format("%.2f", combustible)%>
                                </td>

                                <td>
                                    Q <%= String.format("%.2f", manoObra)%>
                                </td>

                                <td>
                                    Q <%= String.format("%.2f", repuestos)%>
                                </td>

                                <td>
                                    Q <%= String.format("%.2f", depreciacion)%>
                                </td>

                                <td>
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


                        <% if (hayResultados) {%>

                        <tfoot>

                            <tr>

                                <th colspan="2">
                                    TOTAL GENERAL
                                </th>

                                <th>
                                    Q <%= String.format("%.2f", totalCombustible)%>
                                </th>

                                <th>
                                    Q <%= String.format("%.2f", totalManoObra)%>
                                </th>

                                <th>
                                    Q <%= String.format("%.2f", totalRepuestos)%>
                                </th>

                                <th>
                                    Q <%= String.format("%.2f", totalDepreciacion)%>
                                </th>

                                <th>
                                    Q <%= String.format("%.2f", totalCostos)%>
                                </th>

                            </tr>

                        </tfoot>

                        <% }%>

                    </table>

                </div>
            </section>
            <% }%>
            <!-- VOLVER -->
            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">
                    Volver al menú principal
                </a>

            </div>

        </div>
        <script
            src="../resources/js/reporteCostos.js">
        </script>

    </body>
</html>
