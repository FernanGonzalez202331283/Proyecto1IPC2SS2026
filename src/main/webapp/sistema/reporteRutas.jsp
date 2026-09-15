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

    boolean consultar = fechaInicio != null
            && !fechaInicio.isEmpty()
            && fechaFin != null
            && !fechaFin.isEmpty();

    String error = null;

    if (consultar) {

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
            content="width=device-width, initial-scale=1.0"
            >

        <title>Rutas más demandadas</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
            rel="stylesheet"
            >

        <link
            rel="stylesheet"
            href="../resources/css/styles.css"
            >

    </head>

    <body>

        <div class="container py-5">

            <!-- ENCABEZADO -->

            <div class="mb-4">

                <h1 class="fw-bold">
                    Rutas más demandadas
                </h1>

                <p class="text-muted">
                    Consulta las rutas con mayor cantidad de
                    boletos vendidos durante un intervalo.
                </p>

            </div>


            <!-- FORMULARIO -->

            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <form
                        method="GET"
                        action="reporteRutas.jsp"
                        >

                        <div class="row g-3">

                            <!-- FECHA INICIAL -->

                            <div class="col-md-5">

                                <label
                                    for="fechaInicio"
                                    class="form-label"
                                    >
                                    Fecha inicial
                                </label>

                                <input
                                    type="date"
                                    class="form-control"
                                    id="fechaInicio"
                                    name="fechaInicio"
                                    value="<%= fechaInicio != null ? fechaInicio : ""%>"
                                    required
                                    >

                            </div>


                            <!-- FECHA FINAL -->

                            <div class="col-md-5">

                                <label
                                    for="fechaFin"
                                    class="form-label"
                                    >
                                    Fecha final
                                </label>

                                <input
                                    type="date"
                                    class="form-control"
                                    id="fechaFin"
                                    name="fechaFin"
                                    value="<%= fechaFin != null ? fechaFin : ""%>"
                                    required
                                    >

                            </div>


                            <!-- BOTÓN -->

                            <div class="col-md-2 d-flex align-items-end">

                                <button
                                    type="submit"
                                    class="btn btn-primary w-100"
                                    >
                                    Generar
                                </button>

                            </div>

                        </div>

                    </form>

                </div>

            </div>


            <!-- ERROR -->

            <% if (error != null) {%>

            <div
                class="alert alert-danger"
                role="alert"
                >
                <%= error%>
            </div>

            <% } %>


            <!-- RESULTADOS -->

            <% if (consultar && resultado != null && error == null) { %>

            <div class="card shadow-sm">

                <div class="card-body">

                    <h2 class="h4 mb-4">
                        Resultados del reporte
                    </h2>

                    <div class="table-responsive">

                        <table
                            class="table table-bordered table-hover align-middle"
                            >

                            <thead class="table-dark">

                                <tr>

                                    <th>Posición</th>

                                    <th>Código de ruta</th>

                                    <th>Origen</th>

                                    <th>Destino</th>

                                    <th>Distancia (km)</th>

                                    <th>Precio boleto</th>

                                    <th>Boletos vendidos</th>

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

                                    <td
                                        colspan="7"
                                        class="text-center"
                                        >
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

                            <tfoot class="table-secondary">

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

                </div>

            </div>

            <% }%>


            <!-- VOLVER -->

            <div class="mt-4">

                <a
                    href="../inicio.jsp"
                    class="btn btn-outline-secondary"
                    >
                    Volver al inicio
                </a>

            </div>

        </div>


        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js">
        </script>
    </body>

</html>

