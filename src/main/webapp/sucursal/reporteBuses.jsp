<%-- 
    Document   : reporteBuses
    Created on : 15 sept 2026, 0:37:16
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
    String mensaje = null;

    try {

        ReporteBusesDAO dao = new ReporteBusesDAO();

        resultado = dao.obtenerReporte(
                codigoSucursal,
                estadoOperativo
        );

    } catch (Exception e) {

        mensaje = "Error al obtener el reporte de buses: "
                + e.getMessage();

    }
%>
<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Reporte general de buses</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Listado general de buses
                </h1>

                <p>
                    Buses pertenecientes a la sucursal:
                    <strong><%= codigoSucursal%></strong>
                </p>

            </header>


            <!-- FILTRO -->

            <section class="formulario">

                <h2>
                    Filtrar buses
                </h2>

                <p>
                    Selecciona un estado operativo para consultar
                    los buses de la sucursal.
                </p>

                <form
                    method="GET"
                    action="reporteBuses.jsp"
                    id="formularioReporteBuses">

                    <div class="campo">

                        <label for="estadoOperativo">
                            Estado operativo
                        </label>

                        <select
                            id="estadoOperativo"
                            name="estadoOperativo">

                            <option
                                value=""
                                <%= "".equals(estadoOperativo)
                                        ? "selected"
                                        : ""%>>
                                Todos los estados
                            </option>

                            <option
                                value="DISPONIBLE"
                                <%= "DISPONIBLE".equals(estadoOperativo)
                                        ? "selected"
                                        : ""%>>
                                Disponible
                            </option>

                            <option
                                value="EN_VIAJE"
                                <%= "EN_VIAJE".equals(estadoOperativo)
                                        ? "selected"
                                        : ""%>>
                                En viaje
                            </option>

                            <option
                                value="INACTIVO"
                                <%= "INACTIVO".equals(estadoOperativo)
                                        ? "selected"
                                        : ""%>>
                                Inactivo
                            </option>

                        </select>

                        <p
                            id="mensajeEstado"
                            class="campo-error">
                        </p>

                    </div>

                    <div class="botones-formulario">

                        <button
                            type="submit"
                            class="boton">
                            Filtrar
                        </button>

                        <br>

                        <a
                            href="reporteBuses.jsp"
                            class="boton">
                            Limpiar
                        </a>

                    </div>

                </form>

            </section>


            <!-- MENSAJE DE ERROR -->

            <% if (mensaje != null) {%>

            <section class="formulario">

                <div class="mensaje mensaje-error">

                    <%= mensaje%>

                </div>

            </section>

            <% } %>


            <!-- TABLA -->

            <% if (resultado != null) { %>

            <section class="formulario">

                <h2>
                    Buses registrados
                </h2>

                <div class="tabla-contenedor">

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

                                    <% if ("DISPONIBLE".equals(estado)) { %>

                                    <span class="estado-activo">
                                        Disponible
                                    </span>

                                    <% } else if ("EN_VIAJE".equals(estado)) { %>

                                    <span class="estado-activo">
                                        En viaje
                                    </span>

                                    <% } else if ("MANTENIMIENTO".equals(estado)) { %>

                                    <span class="estado-inactivo">
                                        Mantenimiento
                                    </span>

                                    <% } else if ("INACTIVO".equals(estado)) { %>

                                    <span class="estado-inactivo">
                                        Inactivo
                                    </span>

                                    <% } else {%>

                                    <span>
                                        <%= estado%>
                                    </span>

                                    <% }%>

                                </td>

                                <td>
                                    <%= resultado.getString("chofer_asignado")%>
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

                                    <%= resultado.getInt("total_viajes")%>

                                </td>

                            </tr>

                            <% }%>

                        </tbody>

                    </table>

                </div>

                <div class="mensaje">

                    Total de buses encontrados:
                    <strong><%= cantidadBuses%></strong>

                </div>
                <!-- EXPORTAR REPORTE A HTML -->

                <form
                    method="GET"
                    action="exportarReporteBuses.jsp"
                    class="botones">

                    <input
                        type="hidden"
                        name="estadoOperativo"
                        value="<%= estadoOperativo%>">

                    <button
                        type="submit"
                        class="boton">

                        Exportar HTML

                    </button>

                </form>

            </section>

            <% }%>

            <!-- BOTÓN VOLVER -->
            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal

                </a>

            </div>
        </main>
        <script src="../resources/js/reporteBuses.js"></script>
    </body>
</html>
