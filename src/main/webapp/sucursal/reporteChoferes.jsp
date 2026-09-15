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

    try {
        resultado = dao.obtenerReporte(codigoSucursal);
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Reporte de Choferes</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">
</head>

<body class="bg-light">

    <div class="container py-5">

        <div class="d-flex justify-content-between
                    align-items-center mb-4">

            <div>
                <h1 class="fw-bold">
                    Listado de Choferes
                </h1>

                <p class="text-muted mb-0">
                    Choferes de la sucursal:
                    <strong><%= codigoSucursal %></strong>
                </p>
            </div>

            <a href="../inicio.jsp"
               class="btn btn-secondary">
                Regresar
            </a>

        </div>

        <div class="card shadow-sm">

            <div class="card-body">

                <div class="table-responsive">

                    <table class="table table-hover
                                  table-bordered align-middle">

                        <thead class="table-dark">

                            <tr>
                                <th>Número de licencia</th>
                                <th>Nombre completo</th>
                                <th>Tipo de licencia</th>
                                <th>Fecha de vencimiento</th>
                                <th>Estado</th>
                                <th>Total de viajes</th>
                            </tr>

                        </thead>

                        <tbody>

                            <%
                                boolean hayRegistros = false;

                                while (resultado.next()) {

                                    hayRegistros = true;

                                    int estado =
                                        resultado.getInt("estado");
                            %>

                            <tr>

                                <td>
                                    <%= resultado.getString(
                                            "numero_licencia") %>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "nombre_completo") %>
                                </td>

                                <td>
                                    <%= resultado.getString(
                                            "tipo_licencia") %>
                                </td>

                                <td>
                                    <%= resultado.getDate(
                                            "fecha_vencimiento_licencia") %>
                                </td>

                                <td>

                                    <% if (estado == 1) { %>

                                        <span class="badge bg-success">
                                            Activo
                                        </span>

                                    <% } else { %>

                                        <span class="badge bg-danger">
                                            Inactivo
                                        </span>

                                    <% } %>

                                </td>

                                <td>
                                    <%= resultado.getInt(
                                            "total_viajes") %>
                                </td>

                            </tr>

                            <%
                                }

                                if (!hayRegistros) {
                            %>

                            <tr>

                                <td colspan="6"
                                    class="text-center text-muted py-4">

                                    No hay choferes registrados
                                    en esta sucursal.

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

    </div>

</body>

</html>

<%
    } catch (Exception e) {
        out.println(
            "<div class='alert alert-danger m-4'>"
            + "Error al generar el reporte: "
            + e.getMessage()
            + "</div>"
        );
    }
%>

