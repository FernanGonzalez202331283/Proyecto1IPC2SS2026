<%-- 
    Document   : repuestos
    Created on : 13 sept 2026, 19:27:09
    Author     : fernan
--%>
<%--
Document   : repuestos
Created on : 14 sept 2026
Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.dao.RepuestoDAO"%>
<%@page import="transporte.modelo.Repuesto"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
Usuario usuario
= (Usuario) session.getAttribute("usuario");

if (usuario == null) {
    response.sendRedirect("../login.jsp");
    return;
}

if (!"ADMIN_SUCURSAL".equals(usuario.getRol())) {
    response.sendRedirect("../inicio.jsp");
    return;
}

RepuestoDAO repuestoDAO
        = new RepuestoDAO();

List<Repuesto> repuestos
        = repuestoDAO.listarActivos();

%>

<!DOCTYPE html>

<html lang="es">

```
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Repuestos</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>


<body>

    <main class="pagina">

        <header class="encabezado">

            <h1>Gestión de repuestos</h1>

            <p>
                Administra los repuestos disponibles
                para los mantenimientos de los buses.
            </p>

        </header>


        <!-- FORMULARIO -->

        <div class="card-menu">

            <h2>Registrar repuesto</h2>

            <form action="procesarRepuesto.jsp"
                  method="post">

                <div class="form-group">

                    <label for="codigoRepuesto">
                        Código del repuesto
                    </label>

                    <input type="text"
                           id="codigoRepuesto"
                           name="codigoRepuesto"
                           maxlength="20"
                           required>

                </div>


                <div class="form-group">

                    <label for="nombre">
                        Nombre
                    </label>

                    <input type="text"
                           id="nombre"
                           name="nombre"
                           maxlength="150"
                           required>

                </div>


                <div class="form-group">

                    <label for="descripcion">
                        Descripción
                    </label>

                    <textarea id="descripcion"
                              name="descripcion"
                              maxlength="250"
                              rows="3"></textarea>

                </div>


                <div class="form-group">

                    <label for="precio">
                        Precio
                    </label>

                    <input type="number"
                           id="precio"
                           name="precio"
                           min="0"
                           step="0.01"
                           required>

                </div>


                <div class="form-actions">

                    <button type="submit">
                        Registrar repuesto
                    </button>

                </div>

            </form>

        </div>


        <br>


        <!-- LISTADO -->

        <div class="card-menu">

            <h2>Repuestos disponibles</h2>


            <% if (repuestos.isEmpty()) { %>

                <p>
                    No hay repuestos registrados.
                </p>

            <% } else { %>

                <div class="tabla-container">

                    <table>

                        <thead>

                            <tr>

                                <th>Código</th>

                                <th>Nombre</th>

                                <th>Descripción</th>

                                <th>Precio</th>

                                <th>Estado</th>

                            </tr>

                        </thead>


                        <tbody>

                            <% for (Repuesto repuesto : repuestos) { %>

                                <tr>

                                    <td>
                                        <%= repuesto.getCodigoRepuesto() %>
                                    </td>

                                    <td>
                                        <%= repuesto.getNombre() %>
                                    </td>

                                    <td>
                                        <%= repuesto.getDescripcion() != null
                                                ? repuesto.getDescripcion()
                                                : "" %>
                                    </td>

                                    <td>
                                        Q<%= String.format(
                                                "%.2f",
                                                repuesto.getPrecio()
                                        ) %>
                                    </td>

                                    <td>
                                        Activo
                                    </td>

                                </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

            <% } %>

        </div>


        <br>


        <div class="card-acciones">

            <a href="../inicio.jsp">
                Regresar al inicio
            </a>

        </div>

    </main>

</body>
</html>

