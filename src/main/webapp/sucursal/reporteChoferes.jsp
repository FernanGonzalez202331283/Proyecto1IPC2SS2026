<%-- 
    Document   : reporteChoferes
    Created on : 15 sept 2026, 0:49:49
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

    ReporteChoferesDAO dao = new ReporteChoferesDAO();
    ResultSet resultado = null;

    String mensaje = null;

    try {

        resultado = dao.obtenerReporte(codigoSucursal);

%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Reporte de Choferes</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Listado de Choferes
                </h1>

                <p>
                    Choferes de la sucursal:
                    <strong><%= codigoSucursal%></strong>
                </p>

            </header>


            <!-- REPORTE -->

            <section class="formulario">

                <h2>
                    Choferes registrados
                </h2>

                <p>
                    Información general de los choferes
                    pertenecientes a esta sucursal.
                </p>

                <div class="tabla-contenedor">

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
                                boolean hayRegistros = false;

                                while (resultado.next()) {

                                    hayRegistros = true;

                                    int estado
                                            = resultado.getInt("estado");
                            %>

                            <tr>

                                <td>
                                    <strong>
                                        <%= resultado.getString(
                                                "numero_licencia")%>
                                    </strong>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "nombre_completo")%>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "tipo_licencia")%>
                                </td>

                                <td>
                                    <%= resultado.getDate(
                                            "fecha_vencimiento_licencia")%>
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

                                    <% }%>

                                </td>

                                <td>
                                    <%= resultado.getInt(
                                            "total_viajes")%>
                                </td>

                            </tr>

                            <%
                                }

                                if (!hayRegistros) {
                            %>

                            <tr>

                                <td colspan="6">

                                    <div class="mensaje">

                                        No hay choferes registrados
                                        en esta sucursal.

                                    </div>

                                </td>

                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                </div>
                </div>

                <!-- EXPORTAR REPORTE A HTML -->

                <form
                    method="GET"
                    action="exportarReporteChoferes.jsp"
                    class="botones">

                    <button
                        type="submit"
                        class="boton">

                        Exportar HTML

                    </button>

                </form>
            </section>


            <!-- BOTÓN VOLVER -->

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
} catch (Exception e) {

    mensaje = "Error al generar el reporte: "
            + e.getMessage();

%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Error - Reporte de Choferes</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>
                    Reporte de Choferes
                </h1>

            </header>

            <section class="formulario">

                <div class="mensaje mensaje-error">

                    <%= mensaje%>

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
    }
%>
