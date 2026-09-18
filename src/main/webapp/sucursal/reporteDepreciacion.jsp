<%-- 
    Document   : reporteDepreciacion
    Created on : 15 sept 2026, 1:39:43
    Author     : fernan
--%>

<%@page import="transporte.Reporte.ReporteDepreciacionDAO"%>
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

    ReporteDepreciacionDAO dao
            = new ReporteDepreciacionDAO();

    ResultSet resultado = null;

    String mensajeError = null;

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

        <title>Reporte de depreciación por bus</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Reporte de depreciación por bus
                </h1>

                <p>
                    Consulta la depreciación acumulada de los buses
                    de tu sucursal.
                </p>

                <p>
                    Sucursal:
                    <strong>
                        <%= codigoSucursal%>
                    </strong>
                </p>

            </header>


            <!-- INFORMACIÓN -->

            <section class="formulario">

                <h2>
                    Información del reporte
                </h2>

                <p>
                    La depreciación se calcula utilizando el
                    kilometraje actual del bus y la configuración
                    de depreciación vigente más reciente.
                </p>

            </section>


            <!-- RESULTADOS -->

            <section class="formulario">

                <h2>
                    Depreciación de los buses
                </h2>

                <%
                    boolean hayResultados = false;
                %>

                <div class="tabla-contenedor">

                    <table>

                        <thead>

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
                                while (resultado.next()) {

                                    hayResultados = true;
                            %>

                            <tr>

                                <td>
                                    <strong>
                                        <%= resultado.getString(
                                                "placa"
                                        )%>
                                    </strong>
                                </td>

                                <td>

                                    <%= String.format(
                                            "%.2f",
                                            resultado.getDouble(
                                                    "total_km_recorridos"
                                            )
                                    )%>

                                    km

                                </td>

                                <td>

                                    Q
                                    <%= String.format(
                                            "%.2f",
                                            resultado.getDouble(
                                                    "depreciacion_por_km"
                                            )
                                    )%>

                                </td>

                                <td>

                                    <strong>

                                        Q
                                        <%= String.format(
                                                "%.2f",
                                                resultado.getDouble(
                                                        "depreciacion_total"
                                                )
                                        )%>

                                    </strong>

                                </td>

                            </tr>

                            <%
                                }

                                if (!hayResultados) {
                            %>

                            <tr>

                                <td colspan="4">

                                    <div class="mensaje">

                                        No se encontraron buses
                                        para esta sucursal.

                                    </div>

                                </td>

                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                </div>
                <!-- EXPORTAR REPORTE A HTML -->

                <form
                    method="GET"
                    action="exportarReporteDepreciacion.jsp"
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

    mensajeError = e.getMessage();
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Error - Reporte de depreciación</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>
                    Reporte de depreciación
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
