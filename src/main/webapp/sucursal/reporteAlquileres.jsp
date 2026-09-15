<%-- 
    Document   : reporteAlquileres
    Created on : 15 sept 2026, 1:25:11
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteAlquileresDAO"%>
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

    String fechaInicio = request.getParameter("fechaInicio");
    String fechaFin = request.getParameter("fechaFin");

    if (fechaInicio == null || fechaInicio.trim().isEmpty()) {
        fechaInicio = null;
    }

    if (fechaFin == null || fechaFin.trim().isEmpty()) {
        fechaFin = null;
    }

    ReporteAlquileresDAO dao = new ReporteAlquileresDAO();

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

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Ingresos por alquiler de buses</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    </head>

    <body class="bg-light">

        <nav class="navbar navbar-dark bg-dark">

            <div class="container">

                <a class="navbar-brand" href="../inicio.jsp">
                    Transporte Extraurbano
                </a>

                <span class="navbar-text text-white">
                    Reporte de alquileres
                </span>

            </div>

        </nav>


        <main class="container py-5">

            <!-- ENCABEZADO -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h1 class="h3 mb-1">
                        Ingresos por alquiler de buses
                    </h1>

                    <p class="text-muted mb-0">
                        Consulta los alquileres realizados por clientes
                        de la sucursal.
                    </p>

                </div>

                <a href="../inicio.jsp"
                   class="btn btn-outline-secondary">

                    Volver

                </a>

            </div>


            <!-- FILTROS -->

            <div class="card shadow-sm mb-4">

                <div class="card-header bg-primary text-white">

                    <h2 class="h5 mb-0">
                        Filtros de consulta
                    </h2>

                </div>

                <div class="card-body">

                    <form method="get"
                          action="reporteAlquileres.jsp">

                        <div class="row g-3">

                            <!-- FECHA INICIAL -->

                            <div class="col-md-6">

                                <label for="fechaInicio"
                                       class="form-label">

                                    Fecha inicial

                                </label>

                                <input
                                    type="date"
                                    class="form-control"
                                    id="fechaInicio"
                                    name="fechaInicio"
                                    value="<%= fechaInicio != null ? fechaInicio : ""%>">

                            </div>


                            <!-- FECHA FINAL -->

                            <div class="col-md-6">

                                <label for="fechaFin"
                                       class="form-label">

                                    Fecha final

                                </label>

                                <input
                                    type="date"
                                    class="form-control"
                                    id="fechaFin"
                                    name="fechaFin"
                                    value="<%= fechaFin != null ? fechaFin : ""%>">

                            </div>


                            <!-- BOTONES -->

                            <div class="col-12">

                                <div class="d-flex gap-2">

                                    <button
                                        type="submit"
                                        class="btn btn-primary">

                                        Consultar

                                    </button>

                                    <a
                                        href="reporteAlquileres.jsp"
                                        class="btn btn-outline-secondary">

                                        Limpiar filtros

                                    </a>

                                </div>

                            </div>

                        </div>

                    </form>

                </div>

            </div>


            <!-- RESULTADOS -->

            <div class="card shadow-sm">

                <div class="card-header">

                    <h2 class="h5 mb-0">
                        Resultados
                    </h2>

                </div>

                <div class="card-body p-0">

                    <div class="table-responsive">

                        <table class="table table-striped table-hover mb-0">

                            <thead class="table-dark">

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
                                    boolean hayResultados = false;

                                    while (resultado.next()) {

                                        hayResultados = true;
                                %>

                                <tr>

                                    <td>
                                        <%= resultado.getString("codigo_alquiler")%>
                                    </td>

                                    <td>
                                        <%= resultado.getString("cliente")%>
                                    </td>

                                    <td>
                                        <%= resultado.getString("origen")%>
                                    </td>

                                    <td>
                                        <%= resultado.getString("destino")%>
                                    </td>

                                    <td>
                                        <%= resultado.getDate("fecha_salida")%>
                                    </td>

                                    <td>
                                        <%= resultado.getDate("fecha_retorno")%>
                                    </td>

                                    <td>
                                        <%= resultado.getString("bus")%>
                                    </td>

                                    <td>

                                        Q
                                        <%= String.format(
                                                "%.2f",
                                                resultado.getDouble("precio_total")
                                        )%>

                                    </td>

                                </tr>

                                <%
                                    }

                                    if (!hayResultados) {
                                %>

                                <tr>

                                    <td colspan="8"
                                        class="text-center text-muted py-4">

                                        No se encontraron alquileres
                                        para los filtros seleccionados.

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </main>


        <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
        </script>

    </body>

</html>

<%
} catch (Exception e) {

    mensajeError = e.getMessage();

%>

<div class="container mt-5">

    <div class="alert alert-danger">

        <strong>
            Error al generar el reporte:
        </strong>

        <%= mensajeError%>

    </div>

    <a href="../inicio.jsp"
       class="btn btn-secondary">

        Volver al inicio

    </a>

</div>

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

