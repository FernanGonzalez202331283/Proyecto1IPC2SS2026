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

    // Verificar sesión
    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Verificar rol
    if (!"ADMIN_SUCURSAL".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    // Obtener la sucursal del administrador
    String codigoSucursal = usuario.getCodigoSucursal();

    // Obtener filtro de estado
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
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body class="bg-light">

    <div class="container-fluid py-4">

        <!-- ENCABEZADO -->

        <div class="d-flex justify-content-between align-items-center mb-4">

            <div>

                <h1 class="fw-bold">
                    Listado general de buses
                </h1>

                <p class="text-muted mb-0">
                    Buses pertenecientes a la sucursal:
                    <strong><%= codigoSucursal %></strong>
                </p>

            </div>

            <a href="../inicio.jsp"
               class="btn btn-secondary">

                Volver al inicio

            </a>

        </div>


        <!-- FILTRO -->

        <div class="card shadow-sm mb-4">

            <div class="card-body">

                <h5 class="card-title">
                    Filtrar buses
                </h5>

                <form method="GET"
                      action="reporteBuses.jsp">

                    <div class="row g-3 align-items-end">

                        <div class="col-md-4">

                            <label
                                for="estadoOperativo"
                                class="form-label">

                                Estado operativo

                            </label>

                            <select
                                class="form-select"
                                id="estadoOperativo"
                                name="estadoOperativo">

                                <option value=""
                                    <%= "".equals(estadoOperativo)
                                            ? "selected"
                                            : "" %>>

                                    Todos los estados

                                </option>

                                <option value="DISPONIBLE"
                                    <%= "DISPONIBLE".equals(estadoOperativo)
                                            ? "selected"
                                            : "" %>>

                                    Disponible

                                </option>

                                <option value="EN_VIAJE"
                                    <%= "EN_VIAJE".equals(estadoOperativo)
                                            ? "selected"
                                            : "" %>>

                                    En viaje

                                </option>

                                <option value="MANTENIMIENTO"
                                    <%= "MANTENIMIENTO".equals(estadoOperativo)
                                            ? "selected"
                                            : "" %>>

                                    Mantenimiento

                                </option>

                                <option value="INACTIVO"
                                    <%= "INACTIVO".equals(estadoOperativo)
                                            ? "selected"
                                            : "" %>>

                                    Inactivo

                                </option>

                            </select>

                        </div>

                        <div class="col-md-3">

                            <button
                                type="submit"
                                class="btn btn-primary">

                                Filtrar

                            </button>

                            <a
                                href="reporteBuses.jsp"
                                class="btn btn-outline-secondary">

                                Limpiar

                            </a>

                        </div>

                    </div>

                </form>

            </div>

        </div>


        <!-- MENSAJE DE ERROR -->

        <% if (mensaje != null) { %>

            <div class="alert alert-danger">

                <%= mensaje %>

            </div>

        <% } %>


        <!-- TABLA -->

        <% if (resultado != null) { %>

            <div class="card shadow-sm">

                <div class="card-body">

                    <h5 class="card-title mb-3">
                        Buses registrados
                    </h5>

                    <div class="table-responsive">

                        <table class="table table-bordered table-hover align-middle">

                            <thead class="table-dark">

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
                                %>

                                <tr>

                                    <td>
                                        <%= resultado.getString("placa") %>
                                    </td>

                                    <td>
                                        <%= resultado.getString("marca") %>
                                    </td>

                                    <td>
                                        <%= resultado.getString("modelo") %>
                                    </td>

                                    <td>
                                        <%= resultado.getInt("capacidad") %>
                                    </td>

                                    <td>

                                        <%
                                            String estado =
                                                    resultado.getString("estado_operativo");

                                            String claseEstado = "bg-secondary";

                                            if ("DISPONIBLE".equals(estado)) {
                                                claseEstado = "bg-success";
                                            } else if ("EN_VIAJE".equals(estado)) {
                                                claseEstado = "bg-primary";
                                            } else if ("MANTENIMIENTO".equals(estado)) {
                                                claseEstado = "bg-warning text-dark";
                                            } else if ("INACTIVO".equals(estado)) {
                                                claseEstado = "bg-danger";
                                            }
                                        %>

                                        <span class="badge <%= claseEstado %>">

                                            <%= estado %>

                                        </span>

                                    </td>

                                    <td>
                                        <%= resultado.getString("chofer_asignado") %>
                                    </td>

                                    <td>
                                        <%= String.format(
                                                "%.2f",
                                                resultado.getDouble("kilometraje_actual")
                                            ) %>
                                        km
                                    </td>

                                    <td class="text-center">

                                        <span class="badge bg-dark">

                                            <%= resultado.getInt("total_viajes") %>

                                        </span>

                                    </td>

                                </tr>

                                <% } %>

                            </tbody>

                        </table>

                    </div>

                    <div class="mt-3 text-muted">

                        Total de buses encontrados:
                        <strong><%= cantidadBuses %></strong>

                    </div>

                </div>

            </div>

        <% } %>

    </div>


    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>

</body>

</html>

