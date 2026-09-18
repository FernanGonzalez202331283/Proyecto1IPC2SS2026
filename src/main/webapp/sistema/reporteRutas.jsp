<%--
Document   : reporteRutas
Created on : 14 sept 2026, 18:39:38
Author     : fernan
--%>

<%@page import="transporte.Reporte.ReporteRutasDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="transporte.modelo.Usuario"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

// Solo ADMIN_SISTEMA puede consultar este reporte
    if (!"ADMIN_SISTEMA".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");

    ResultSet resultado = null;
    String error = null;

    boolean consultar = fechaInicio != null
            && !fechaInicio.isEmpty()
            && fechaFin != null
            && !fechaFin.isEmpty();

    if (consultar) {

        // Validación del servidor
        if (fechaInicio.compareTo(fechaFin) > 0) {

            error = "La fecha inicial no puede ser mayor que la fecha final.";

        } else {

            try {

                ReporteRutasDAO dao = new ReporteRutasDAO();

                resultado = dao.obtenerReporte(
                        fechaInicio,
                        fechaFin
                );

            } catch (Exception e) {

                error = "Error al generar el reporte: "
                        + e.getMessage();

            }
        }
    }
%>

<!DOCTYPE html>

<html lang="es">
    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Rutas más demandadas</title>

        <link
            rel="stylesheet"
            href="../resources/css/styles.css">

    </head>

    <body>

        <div class="pagina">

            <!-- ENCABEZADO -->

            <div class="encabezado">

                <h1>
                    Rutas más demandadas
                </h1>

                <p>
                    Consulta las rutas con mayor cantidad de
                    boletos vendidos durante un intervalo.
                </p>

            </div>


            <!-- FORMULARIO -->

            <section class="formulario">

                <form
                    method="GET"
                    action="reporteRutas.jsp"
                    id="formularioReporteRutas">

                    <div class="form-group">

                        <label for="fechaInicio">
                            Fecha inicial
                        </label>

                        <input
                            type="date"
                            id="fechaInicio"
                            name="fechaInicio"
                            value="<%= fechaInicio != null ? fechaInicio : ""%>"
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
                            value="<%= fechaFin != null ? fechaFin : ""%>"
                            required>

                        <div
                            id="mensajeFechaFin"
                            class="campo-error">
                        </div>

                    </div>


                    <div
                        id="mensajeReporte"
                        class="campo-error">
                    </div>


                    <!-- BOTONES DEL FORMULARIO -->

                    <div class="botones-formulario">

                        <button
                            type="submit"
                            class="boton">

                            Generar reporte
                        </button>
                    </div>
                    
                    <br><!-- comment -->
                     <a
                            href="reporteRutas.jsp"
                            class="boton">

                            Limpiar

                        </a>

                </form>

            </section>


            <!-- ERROR DEL SERVIDOR -->

            <% if (error != null) {%>

            <div class="mensaje error">

                <%= error%>

            </div>

            <% } %>


            <!-- RESULTADOS -->

            <% if (consultar && resultado != null && error == null) { %>

            <section class="formulario">

                <h2>
                    Resultados del reporte
                </h2>

                <div class="tabla-contenedor">

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

                                <td>
                                    <%= String.format("%.2f", distancia)%>
                                </td>

                                <td>
                                    Q <%= String.format("%.2f", precio)%>
                                </td>

                                <td>
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
                        <% if (hayResultados) {%>
                        <tfoot>
                            <tr>
                                <th colspan="6">
                                    TOTAL DE BOLETOS VENDIDOS
                                </th>
                                <th>
                                    <%= totalBoletos%>
                                </th>
                            </tr>
                        </tfoot>
                        <% } %>
                    </table>
                </div>
            </section>
            <% }%>
             <!-- EXPORTAR REPORTE A HTML -->

                <form
                    method="GET"
                    action="exportarReporteRutas.jsp"
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
            src="../resources/js/reporteRutas.js">
        </script>

    </body>
</html>
