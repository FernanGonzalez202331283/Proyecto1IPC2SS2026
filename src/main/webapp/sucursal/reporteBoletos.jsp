<%-- 
    Document   : reporteBoletos
    Created on : 15 sept 2026, 1:06:50
    Author     : fernan
--%>
<%@page import="transporte.Reporte.ReporteBoletosDAO"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="transporte.conexion.Conexion"%>
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
    String codigoRuta = request.getParameter("codigoRuta");
    String placaBus = request.getParameter("placaBus");

    if (fechaInicio == null || fechaInicio.trim().isEmpty()) {
        fechaInicio = null;
    }

    if (fechaFin == null || fechaFin.trim().isEmpty()) {
        fechaFin = null;
    }

    if (codigoRuta == null) {
        codigoRuta = "";
    }

    if (placaBus == null) {
        placaBus = "";
    }

    ReporteBoletosDAO dao = new ReporteBoletosDAO();

    ResultSet resultado = null;

    Connection conexionCatalogos = null;
    PreparedStatement psRutas = null;
    PreparedStatement psBuses = null;

    ResultSet rutas = null;
    ResultSet buses = null;

    String mensajeError = null;

    try {

        resultado = dao.obtenerReporte(
            codigoSucursal,
            fechaInicio,
            fechaFin,
            codigoRuta,
            placaBus
        );

        conexionCatalogos = Conexion.getConnection();

        String sqlRutas = """
            SELECT
                r.codigo_ruta,
                CONCAT(
                    s_origen.nombre,
                    ' ? ',
                    s_destino.nombre
                ) AS ruta
            FROM ruta r
            INNER JOIN sucursal s_origen
                ON s_origen.codigo_sucursal =
                   r.codigo_sucursal_origen
            INNER JOIN sucursal s_destino
                ON s_destino.codigo_sucursal =
                   r.codigo_sucursal_destino
            WHERE r.codigo_sucursal_origen = ?
               OR r.codigo_sucursal_destino = ?
            ORDER BY r.codigo_ruta ASC
            """;

        psRutas = conexionCatalogos.prepareStatement(sqlRutas);

        psRutas.setString(1, codigoSucursal);
        psRutas.setString(2, codigoSucursal);

        rutas = psRutas.executeQuery();
        String sqlBuses = """
            SELECT
                placa,
                marca,
                modelo
            FROM bus
            WHERE codigo_sucursal = ?
            ORDER BY placa ASC
            """;

        psBuses = conexionCatalogos.prepareStatement(sqlBuses);

        psBuses.setString(1, codigoSucursal);

        buses = psBuses.executeQuery();

%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Ingresos por venta de boletos</title>

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
            Reporte de boletos
        </span>

    </div>

</nav>


<main class="container py-5">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>
            <h1 class="h3 mb-1">
                Ingresos por venta de boletos
            </h1>

            <p class="text-muted mb-0">
                Consulta los ingresos generados por los viajes de la sucursal.
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
                  action="reporteBoletos.jsp">

                <div class="row g-3">

                    <!-- FECHA INICIO -->

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
                            value="<%= fechaInicio != null ? fechaInicio : "" %>">

                    </div>


                    <!-- FECHA FIN -->

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
                            value="<%= fechaFin != null ? fechaFin : "" %>">

                    </div>


                    <!-- RUTA -->

                    <div class="col-md-6">

                        <label for="codigoRuta"
                               class="form-label">

                            Ruta

                        </label>

                        <select
                            class="form-select"
                            id="codigoRuta"
                            name="codigoRuta">

                            <option value="">
                                Todas las rutas
                            </option>

                            <%
                                while (rutas.next()) {

                                    String codigoRutaActual =
                                        rutas.getString("codigo_ruta");

                                    String nombreRuta =
                                        rutas.getString("ruta");

                                    boolean seleccionada =
                                        codigoRutaActual.equals(codigoRuta);
                            %>

                            <option
                                value="<%= codigoRutaActual %>"
                                <%= seleccionada ? "selected" : "" %>>

                                <%= codigoRutaActual %>
                                -
                                <%= nombreRuta %>

                            </option>

                            <%
                                }
                            %>

                        </select>

                    </div>


                    <!-- BUS -->

                    <div class="col-md-6">

                        <label for="placaBus"
                               class="form-label">

                            Bus

                        </label>

                        <select
                            class="form-select"
                            id="placaBus"
                            name="placaBus">

                            <option value="">
                                Todos los buses
                            </option>

                            <%
                                while (buses.next()) {

                                    String placaActual =
                                        buses.getString("placa");

                                    String marca =
                                        buses.getString("marca");

                                    String modelo =
                                        buses.getString("modelo");

                                    boolean seleccionado =
                                        placaActual.equals(placaBus);
                            %>

                            <option
                                value="<%= placaActual %>"
                                <%= seleccionado ? "selected" : "" %>>

                                <%= placaActual %>
                                -
                                <%= marca %>
                                <%= modelo %>

                            </option>

                            <%
                                }
                            %>

                        </select>

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
                                href="reporteBoletos.jsp"
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
                                Código de viaje
                            </th>

                            <th>
                                Ruta
                            </th>

                            <th>
                                Bus
                            </th>

                            <th>
                                Fecha
                            </th>

                            <th>
                                Boletos vendidos
                            </th>

                            <th>
                                Ingreso total
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
                                <%= resultado.getString("codigo_viaje") %>
                            </td>

                            <td>
                                <%= resultado.getString("ruta") %>
                            </td>

                            <td>
                                <%= resultado.getString("bus") %>
                            </td>

                            <td>
                                <%= resultado.getDate("fecha_salida") %>
                            </td>

                            <td>
                                <%= resultado.getInt("boletos_vendidos") %>
                            </td>

                            <td>

                                Q
                                <%= String.format(
                                    "%.2f",
                                    resultado.getDouble("ingreso_total")
                                ) %>

                            </td>

                        </tr>

                        <%
                            }

                            if (!hayResultados) {
                        %>

                        <tr>

                            <td colspan="6"
                                class="text-center text-muted py-4">

                                No se encontraron registros
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

        <strong>Error al generar el reporte:</strong>

        <%= mensajeError %>

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

        try {
            if (rutas != null) {
                rutas.close();
            }
        } catch (Exception e) {
        }

        try {
            if (buses != null) {
                buses.close();
            }
        } catch (Exception e) {
        }

        try {
            if (psRutas != null) {
                psRutas.close();
            }
        } catch (Exception e) {
        }

        try {
            if (psBuses != null) {
                psBuses.close();
            }
        } catch (Exception e) {
        }

        try {
            if (conexionCatalogos != null) {
                conexionCatalogos.close();
            }
        } catch (Exception e) {
        }
    }

%>