<%-- 
    Document   : reporteGanancias
    Created on : 14 sept 2026, 18:21:35
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteGananciasDAO"%>
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

    ResultSet resultado = null;

    boolean consultar = fechaInicio != null
            && !fechaInicio.isEmpty()
            && fechaFin != null
            && !fechaFin.isEmpty();

    if (consultar) {
        try {
            ReporteGananciasDAO dao = new ReporteGananciasDAO();

            if (codigoSucursal == null) {
                codigoSucursal = "";
            }

            resultado = dao.obtenerReporte(
                    fechaInicio,
                    fechaFin,
                    codigoSucursal
            );

        } catch (Exception e) {
            out.println("<p>Error al generar el reporte: "
                    + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>

<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Reporte de ganancias</title>

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
                    Reporte de ganancias
                </h1>

                <p class="text-muted">
                    Consulta los ingresos, costos y resultado neto
                    de las sucursales en un intervalo de fechas.
                </p>

            </div>


            <!-- FORMULARIO -->
            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <form method="GET" action="reporteGanancias.jsp">

                        <div class="row g-3">

                            <!-- FECHA INICIAL -->
                            <div class="col-md-4">

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
                            <div class="col-md-4">

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


                            <!-- SUCURSAL -->
                            <div class="col-md-4">

                                <label
                                    for="codigoSucursal"
                                    class="form-label"
                                    >
                                    Sucursal
                                </label>

                                <select
                                    class="form-select"
                                    id="codigoSucursal"
                                    name="codigoSucursal"
                                    >

                                    <option
                                        value=""
                                        <%= "".equals(codigoSucursal) ? "selected" : ""%>
                                        >
                                        Todas las sucursales
                                    </option>

                                    <option
                                        value="S002"
                                        <%= "S002".equals(codigoSucursal) ? "selected" : ""%>
                                        >
                                        Sucursal Central
                                    </option>

                                    <option
                                        value="SUC001"
                                        <%= "SUC001".equals(codigoSucursal) ? "selected" : ""%>
                                        >
                                        Sucursal Central Guatemala
                                    </option>

                                    <option
                                        value="S001"
                                        <%= "S001".equals(codigoSucursal) ? "selected" : ""%>
                                        >
                                        Sucursal Guatemala
                                    </option>

                                    <option
                                        value="01"
                                        <%= "01".equals(codigoSucursal) ? "selected" : ""%>
                                        >
                                        SUCURSAL SAN LORENZO
                                    </option>

                                </select>

                            </div>


                            <!-- BOTONES -->
                            <div class="col-12">

                                <button
                                    type="submit"
                                    class="btn btn-primary"
                                    >
                                    Generar reporte
                                </button>

                                <a
                                    href="reporteGanancias.jsp"
                                    class="btn btn-secondary"
                                    >
                                    Limpiar
                                </a>

                            </div>

                        </div>

                    </form>

                </div>

            </div>


            <!-- RESULTADOS -->
            <% if (consultar && resultado != null) { %>

            <div class="card shadow-sm">

                <div class="card-body">

                    <h2 class="h4 mb-4">
                        Resultados del reporte
                    </h2>

                    <div class="table-responsive">

                        <table class="table table-bordered table-hover align-middle">

                            <thead class="table-dark">

                                <tr>

                                    <th>Sucursal</th>

                                    <th>Ingresos boletos</th>

                                    <th>Ingresos alquileres</th>

                                    <th>Total ingresos</th>

                                    <th>Combustible</th>

                                    <th>Mano de obra</th>

                                    <th>Repuestos</th>

                                    <th>Depreciación</th>

                                    <th>Total costos</th>

                                    <th>Ganancia / Pérdida</th>

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
                                        Q <%= String.format("%.2f", ingresosBoletos)%>
                                    </td>

                                    <td>
                                        Q <%= String.format("%.2f", ingresosAlquileres)%>
                                    </td>

                                    <td>
                                        Q <%= String.format("%.2f", totalIngresos)%>
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
                                        Q <%= String.format("%.2f", totalCostos)%>
                                    </td>

                                    <td>

                                        <strong>
                                            Q <%= String.format("%.2f", gananciaNeta)%>
                                        </strong>

                                    </td>

                                </tr>

                                <%
                                    }

                                    if (!hayResultados) {
                                %>

                                <tr>

                                    <td
                                        colspan="10"
                                        class="text-center"
                                        >
                                        No se encontraron resultados
                                        para el intervalo seleccionado.
                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                            </tbody>

                            <% if (hayResultados) {%>

                            <tfoot class="table-secondary">

                                <tr>

                                    <th colspan="3">
                                        TOTALES
                                    </th>

                                    <th>
                                        Q <%= String.format("%.2f", totalIngresosGeneral)%>
                                    </th>

                                    <th colspan="4">
                                    </th>

                                    <th>
                                        Q <%= String.format("%.2f", totalCostosGeneral)%>
                                    </th>

                                    <th>
                                        Q <%= String.format("%.2f", gananciaGeneral)%>
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
