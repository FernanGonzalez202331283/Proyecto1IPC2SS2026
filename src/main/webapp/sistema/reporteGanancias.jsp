<%--
Document   : reporteGanancias
Created on : 14 sept 2026, 18:21:35
Author     : fernan
--%>

<%@page import="transporte.Reporte.ReporteGananciasDAO"%>
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

    if (codigoSucursal == null) {
        codigoSucursal = "";
    }

// Obtener sucursales desde la base de datos
    SucursalDAO sucursalDAO = new SucursalDAO();
    List<Sucursal> sucursales = sucursalDAO.listar();

    ResultSet resultado = null;
    String mensaje = null;

    boolean consultar = fechaInicio != null
            && !fechaInicio.isEmpty()
            && fechaFin != null
            && !fechaFin.isEmpty();

    if (consultar) {

        try {

            ReporteGananciasDAO dao = new ReporteGananciasDAO();

            resultado = dao.obtenerReporte(
                    fechaInicio,
                    fechaFin,
                    codigoSucursal
            );

        } catch (Exception e) {

            mensaje = "Error al generar el reporte: " + e.getMessage();

        }
    }
%>

<!DOCTYPE html>

<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">
        <title>Reporte de ganancias</title>
        <link
            rel="stylesheet"
            href="../resources/css/styles.css">
    </head>
    <body>

        <div class="pagina">

            <!-- ENCABEZADO -->

            <h1>
                Reporte de ganancias
            </h1>

            <p>
                Consulta los ingresos, costos y resultado neto
                de las sucursales en un intervalo de fechas.
            </p>


            <!-- FORMULARIO DE CONSULTA -->

            <section class="formulario">

                <h2>
                    Filtros del reporte
                </h2>


                <form
                    method="GET"
                    action="reporteGanancias.jsp"
                    id="formularioReporteGanancias">


                    <!-- FECHA INICIAL -->

                    <div class="form-group">

                        <label for="fechaInicio">
                            Fecha inicial:
                        </label>

                        <input
                            type="date"
                            id="fechaInicio"
                            name="fechaInicio"
                            value="<%= fechaInicio != null ? fechaInicio : ""%>"
                            required>

                        <p
                            id="mensajeFechaInicio"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- FECHA FINAL -->

                    <div class="form-group">

                        <label for="fechaFin">
                            Fecha final:
                        </label>

                        <input
                            type="date"
                            id="fechaFin"
                            name="fechaFin"
                            value="<%= fechaFin != null ? fechaFin : ""%>"
                            required>

                        <p
                            id="mensajeFechaFin"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- SUCURSAL -->

                    <div class="form-group">

                        <label for="codigoSucursal">
                            Sucursal:
                        </label>

                        <select
                            id="codigoSucursal"
                            name="codigoSucursal">

                            <option
                                value=""
                                <%= "".equals(codigoSucursal)
                                        ? "selected"
                                        : ""%>>

                                Todas las sucursales

                            </option>

                            <%
                                if (sucursales != null) {

                                    for (Sucursal sucursal : sucursales) {

                                        if (sucursal == null
                                                || !sucursal.isEstado()) {
                                            continue;
                                        }
                            %>

                            <option
                                value="<%= sucursal.getCodigoSucursal()%>"
                                <%= sucursal.getCodigoSucursal()
                                        .equals(codigoSucursal)
                                        ? "selected"
                                        : ""%>>

                                <%= sucursal.getNombre()%>

                            </option>

                            <%
                                    }
                                }
                            %>

                        </select>
                    </div>
                    <!-- MENSAJE JAVASCRIPT -->
                    <div
                        id="mensajeReporte"
                        class="campo-error">
                    </div>
                    <!-- BOTÓN -->
                    <button type="submit">
                        Generar reporte
                    </button>
                </form>
            </section>
            <!-- EXPORTAR REPORTE A HTML -->
            <form
                method="GET"
                action="exportarReporteGanancias.jsp"
                class="botones">

                <input
                    type="hidden"
                    name="fechaInicio"
                    value="<%= fechaInicio != null ? fechaInicio : ""%>">

                <input
                    type="hidden"
                    name="fechaFin"
                    value="<%= fechaFin != null ? fechaFin : ""%>">

                <input
                    type="hidden"
                    name="codigoSucursal"
                    value="<%= codigoSucursal != null ? codigoSucursal : ""%>">

                <button
                    type="submit"
                    class="boton">

                    Exportar HTML

                </button>

            </form>
            <!-- MENSAJE DE ERROR DEL SERVIDOR -->
            <% if (mensaje != null) {%>
            <div class="mensaje error">
                <%= mensaje%>
            </div>
            <% } %>
            <!-- RESULTADOS -->
            <% if (consultar && resultado != null) { %>

            <section class="formulario">

                <h2>
                    Resultados del reporte
                </h2>


                <div class="tabla-contenedor">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Sucursal
                                </th>

                                <th>
                                    Ingresos boletos
                                </th>

                                <th>
                                    Ingresos alquileres
                                </th>

                                <th>
                                    Total ingresos
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

                                <th>
                                    Ganancia / Pérdida
                                </th>

                            </tr>

                        </thead>


                        <tbody>

                            <%
                                double totalIngresosGeneral = 0;
                                double totalCostosGeneral = 0;
                                double gananciaGeneral = 0;

                                boolean hayResultados = false;

                                while (resultado.next()) {

                                    hayResultados = true;

                                    String sucursal
                                            = resultado.getString("sucursal");

                                    double ingresosBoletos
                                            = resultado.getDouble("ingresos_boletos");

                                    double ingresosAlquileres
                                            = resultado.getDouble("ingresos_alquileres");

                                    double totalIngresos
                                            = resultado.getDouble("total_ingresos");

                                    double combustible
                                            = resultado.getDouble("combustible");

                                    double manoObra
                                            = resultado.getDouble("mano_obra");

                                    double repuestos
                                            = resultado.getDouble("repuestos");

                                    double depreciacion
                                            = resultado.getDouble("depreciacion");

                                    double totalCostos
                                            = resultado.getDouble("total_costos");

                                    double gananciaNeta
                                            = resultado.getDouble("ganancia_neta");

                                    totalIngresosGeneral += totalIngresos;
                                    totalCostosGeneral += totalCostos;
                                    gananciaGeneral += gananciaNeta;
                            %>

                            <tr>

                                <td>
                                    <strong>
                                        <%= sucursal%>
                                    </strong>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            ingresosBoletos)%>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            ingresosAlquileres)%>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            totalIngresos)%>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            combustible)%>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            manoObra)%>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            repuestos)%>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            depreciacion)%>
                                </td>

                                <td>
                                    Q <%= String.format(
                                            "%.2f",
                                            totalCostos)%>
                                </td>

                                <td>
                                    <strong>
                                        Q <%= String.format(
                                                "%.2f",
                                                gananciaNeta)%>
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


                        <% if (hayResultados) {%>

                        <tfoot>

                            <tr>

                                <th colspan="3">
                                    TOTALES
                                </th>

                                <th>
                                    Q <%= String.format(
                                            "%.2f",
                                            totalIngresosGeneral)%>
                                </th>

                                <th colspan="4">
                                </th>

                                <th>
                                    Q <%= String.format(
                                            "%.2f",
                                            totalCostosGeneral)%>
                                </th>

                                <th>
                                    Q <%= String.format(
                                            "%.2f",
                                            gananciaGeneral)%>
                                </th>

                            </tr>

                        </tfoot>

                        <% } %>

                    </table>

                </div>

            </section>

            <% }%>
            <!-- BOTONES INFERIORES -->
            <div class="botones-inferiores">

                <a
                    href="reporteGanancias.jsp"
                    class="boton">

                    Limpiar
                </a>
                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">
                    Volver al menú principal
                </a>
            </div>
        </div>

        <!-- JAVASCRIPT -->
        <script
            src="../resources/js/reporteGanancias.js">
        </script>

    </body>
</html>
