<%-- 
    Document   : reporteBoletos
    Created on : 2026
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Ruta"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.Reporte.ReporteBoletosDAO"%>
<%@page import="transporte.modelo.ReporteBoleto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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

    String fechaInicio
            = request.getParameter("fechaInicio");

    String fechaFin
            = request.getParameter("fechaFin");

    String codigoRuta
            = request.getParameter("codigoRuta");

    String placaBus
            = request.getParameter("placaBus");

    if (fechaInicio == null) {
        fechaInicio = "";
    }

    if (fechaFin == null) {
        fechaFin = "";
    }

    if (codigoRuta == null) {
        codigoRuta = "";
    }

    if (placaBus == null) {
        placaBus = "";
    }

    ReporteBoletosDAO dao
            = new ReporteBoletosDAO();

    List<ReporteBoleto> reporte
            = dao.obtenerReporte(
                    codigoSucursal,
                    fechaInicio,
                    fechaFin,
                    codigoRuta,
                    placaBus
            );

    List<Ruta> rutas = dao.listarRutasPorSucursal(codigoSucursal);

    List<Bus> buses = dao.listarBusesPorSucursal(codigoSucursal);
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Reporte de Boletos</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Reporte de Boletos</h1>

                <p>
                    Consulta los boletos vendidos
                    y los ingresos generados por los viajes.
                </p>

                <p>
                    Sucursal:
                    <strong><%= codigoSucursal%></strong>
                </p>

            </header>


            <!-- FILTROS -->

            <section class="formulario">

                <h2>Filtros de búsqueda</h2>

                <form method="GET">

                    <div class="form-group">

                        <label for="fechaInicio">
                            Fecha inicial
                        </label>

                        <input
                            type="date"
                            id="fechaInicio"
                            name="fechaInicio"
                            class="campo"
                            value="<%= fechaInicio%>">

                    </div>


                    <div class="form-group">

                        <label for="fechaFin">
                            Fecha final
                        </label>

                        <input
                            type="date"
                            id="fechaFin"
                            name="fechaFin"
                            class="campo"
                            value="<%= fechaFin%>">

                    </div>


                    <div class="form-group">

                        <label for="codigoRuta">
                            Ruta
                        </label>

                        <select
                            id="codigoRuta"
                            name="codigoRuta"
                            class="campo">

                            <option value="">
                                Todas las rutas
                            </option>

                            <% for (Ruta ruta : rutas) {%>

                            <option
                                value="<%= ruta.getCodigoRuta()%>"
                                <%= ruta.getCodigoRuta().equals(codigoRuta)
                                        ? "selected"
                                        : ""%>>

                                <%= ruta.getCodigoRuta()%>

                            </option>

                            <% } %>

                        </select>

                    </div>


                    <div class="form-group">

                        <label for="placaBus">
                            Bus
                        </label>

                        <select
                            id="placaBus"
                            name="placaBus"
                            class="campo">

                            <option value="">
                                Todos los buses
                            </option>

                            <% for (Bus bus : buses) {%>

                            <option
                                value="<%= bus.getPlaca()%>"
                                <%= bus.getPlaca().equals(placaBus)
                                        ? "selected"
                                        : ""%>>

                                <%= bus.getPlaca()%>
                                -
                                <%= bus.getMarca()%>
                                <%= bus.getModelo()%>

                            </option>

                            <% } %>

                        </select>

                    </div>


                    <div class="botones-formulario">

                        <button
                            type="submit"
                            class="boton">

                            Generar reporte

                        </button>

                        <a
                            href="reporteBoletos.jsp"
                            class="boton">

                            Limpiar filtros

                        </a>

                    </div>

                </form>

            </section>


            <!-- RESULTADOS -->

            <section class="formulario">

                <h2>Resultados</h2>

                <% if (reporte.isEmpty()) { %>

                <div class="mensaje">

                    No se encontraron boletos vendidos
                    con los filtros seleccionados.

                </div>

                <% } else { %>

                <div class="tabla-contenedor">

                    <table>

                        <thead>

                            <tr>

                                <th>Código viaje</th>

                                <th>Ruta</th>

                                <th>Bus</th>

                                <th>Fecha de salida</th>

                                <th>Boletos vendidos</th>

                                <th>Ingreso total</th>

                            </tr>

                        </thead>

                        <tbody>

                            <% for (ReporteBoleto item : reporte) {%>

                            <tr>

                                <td>
                                    <strong>
                                        <%= item.getCodigoViaje()%>
                                    </strong>
                                </td>

                                <td>
                                    <%= item.getRuta()%>
                                </td>

                                <td>
                                    <%= item.getBus()%>
                                </td>

                                <td>
                                    <%= item.getFechaSalida()%>
                                </td>

                                <td>
                                    <%= item.getBoletosVendidos()%>
                                </td>

                                <td>
                                    Q
                                    <%= String.format(
                                            "%.2f",
                                            item.getIngresoTotal()
                                    )%>
                                </td>

                            </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

                <% }%>

            </section>


            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal

                </a>

            </div>
            <!-- EXPORTAR REPORTE A HTML -->
            <form
                method="GET"
                action="exportarReporteBoletos.jsp"
                class="botones">

                <input
                    type="hidden"
                    name="fechaInicio"
                    value="<%= fechaInicio%>">

                <input
                    type="hidden"
                    name="fechaFin"
                    value="<%= fechaFin%>">

                <input
                    type="hidden"
                    name="codigoRuta"
                    value="<%= codigoRuta%>">

                <input
                    type="hidden"
                    name="placaBus"
                    value="<%= placaBus%>">

                <button
                    type="submit"
                    class="boton">

                    Exportar HTML

                </button>

            </form>

        </main>

        <script
            src="../resources/js/reporteBoletos.js">
        </script>

    </body>
</html>
