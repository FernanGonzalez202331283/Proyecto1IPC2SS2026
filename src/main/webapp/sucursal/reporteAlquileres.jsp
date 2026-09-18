<%-- 
    Document   : reporteAlquileres
    Created on : 15 sept 2026, 1:25:11
    Author     : fernan
--%>

<%@page import="transporte.Reporte.ReporteAlquileresDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="transporte.modelo.Usuario"%>

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

    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");

    if (fechaInicio == null || fechaInicio.trim().isEmpty()) {
        fechaInicio = null;
    }

    if (fechaFin == null || fechaFin.trim().isEmpty()) {
        fechaFin = null;
    }

    ReporteAlquileresDAO dao
            = new ReporteAlquileresDAO();

    ResultSet resultado = null;

    String mensajeError = null;

    try {

        resultado = dao.obtenerReporte(
                codigoSucursal,
                fechaInicio,
                fechaFin
        );
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Reporte de Alquileres</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Ingresos por alquiler de buses
                </h1>

                <p>
                    Consulta los alquileres realizados por
                    clientes de tu sucursal.
                </p>

                <p>
                    Sucursal:
                    <strong>
                        <%= codigoSucursal%>
                    </strong>
                </p>

            </header>


            <!-- FILTROS -->

            <section class="formulario">

                <h2>
                    Filtros de consulta
                </h2>

                <p>
                    Selecciona un rango de fechas para consultar
                    los alquileres registrados.
                </p>

                <form
                    method="get"
                    action="reporteAlquileres.jsp"
                    id="formularioReporteAlquileres">

                    <div class="form-group">

                        <label for="fechaInicio">
                            Fecha inicial
                        </label>

                        <input
                            type="date"
                            id="fechaInicio"
                            name="fechaInicio"
                            class="campo"
                            value="<%= fechaInicio != null ? fechaInicio : ""%>">

                        <p
                            id="mensajeFechaInicio"
                            class="campo-error">
                        </p>

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
                            value="<%= fechaFin != null ? fechaFin : ""%>">

                        <p
                            id="mensajeFechaFin"
                            class="campo-error">
                        </p>

                    </div>


                    <div class="form-group">

                        <p
                            id="mensajeReporte"
                            class="campo-error">
                        </p>

                    </div>


                    <div class="botones-formulario">

                        <button
                            type="submit"
                            class="boton">

                            Consultar

                        </button>

                        <a
                            href="reporteAlquileres.jsp"
                            class="boton">

                            Limpiar filtros

                        </a>

                    </div>

                </form>

            </section>


            <!-- RESULTADOS -->

            <section class="formulario">

                <h2>
                    Resultados
                </h2>

                <%
                    boolean hayResultados = false;
                %>

                <div class="tabla-contenedor">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Código de alquiler
                                </th>

                                <th>
                                    Cliente
                                </th>

                                <th>
                                    Origen
                                </th>

                                <th>
                                    Destino
                                </th>

                                <th>
                                    Fecha de salida
                                </th>

                                <th>
                                    Fecha de retorno
                                </th>

                                <th>
                                    Bus
                                </th>

                                <th>
                                    Precio total
                                </th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                while (resultado.next()) {

                                    hayResultados = true;
                            %>

                            <tr>

                                <td>
                                    <strong>
                                        <%= resultado.getString(
                                                "codigo_alquiler"
                                        )%>
                                    </strong>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "cliente"
                                    )%>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "origen"
                                    )%>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "destino"
                                    )%>
                                </td>

                                <td>
                                    <%= resultado.getDate(
                                            "fecha_salida"
                                    )%>
                                </td>

                                <td>
                                    <%= resultado.getDate(
                                            "fecha_retorno"
                                    )%>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "bus"
                                    )%>
                                </td>

                                <td>
                                    Q
                                    <%= String.format(
                                            "%.2f",
                                            resultado.getDouble(
                                                    "precio_total"
                                            )
                                    )%>
                                </td>

                            </tr>

                            <%
                                }

                                if (!hayResultados) {
                            %>

                            <tr>

                                <td colspan="8">

                                    <div class="mensaje">

                                        No se encontraron alquileres
                                        para los filtros seleccionados.

                                    </div>

                                </td>

                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                </div>

            </section>
            <!-- EXPORTAR REPORTE A HTML -->

            <form
                method="GET"
                action="exportarReporteAlquileres.jsp"
                class="botones">

                <input
                    type="hidden"
                    name="fechaInicio"
                    value="<%= fechaInicio != null ? fechaInicio : ""%>">

                <input
                    type="hidden"
                    name="fechaFin"
                    value="<%= fechaFin != null ? fechaFin : ""%>">

                <button
                    type="submit"
                    class="boton">

                    Exportar HTML

                </button>

            </form>


            <!-- BOTÓN VOLVER -->

            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal

                </a>

            </div>

        </main>


        <script
            src="../resources/js/reporteAlquileres.js">
        </script>

    </body>

</html>

<%
} catch (Exception e) {

    mensajeError = e.getMessage();
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Error - Reporte de Alquileres</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>
                    Reporte de alquileres
                </h1>

            </header>

            <section class="formulario">

                <div class="mensaje">

                    <strong>
                        Error al generar el reporte:
                    </strong>

                    <p>
                        <%= mensajeError%>
                    </p>

                </div>

            </section>

            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal

                </a>

            </div>

        </main>

    </body>

</html>

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
