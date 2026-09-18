<%-- 
    Document   : mantenimientos
    Created on : 13 sept 2026, 19:52:00
    Author     : fernan
--%>


<%@page import="java.util.List"%>
<%@page import="transporte.dao.BusDAO"%>
<%@page import="transporte.dao.RepuestoDAO"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.modelo.Repuesto"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario
            = (Usuario) session.getAttribute("usuario");

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


    BusDAO busDAO = new BusDAO();

    List<Bus> buses
            = busDAO.listarPorSucursal(
                    usuario.getCodigoSucursal()
            );

    RepuestoDAO repuestoDAO
            = new RepuestoDAO();

    List<Repuesto> repuestos
            = repuestoDAO.listarActivos();
%>


<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Mantenimientos</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>


    <body>

        <main class="pagina">


            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>Gestión de mantenimientos</h1>

                <p>
                    Registra los mantenimientos realizados
                    a los buses de la sucursal.
                </p>

            </header>


            <!-- FORMULARIO -->

            <div class="card-menu">

                <h2>Registrar mantenimiento</h2>


                <form action="procesarMantenimiento.jsp"
                      method="post">


                    <!-- BUS -->

                    <div class="form-group">

                        <label for="placaBus">
                            Bus
                        </label>

                        <select id="placaBus"
                                name="placaBus"
                                required>

                            <option value="">
                                Seleccione un bus
                            </option>


                            <% for (Bus bus : buses) { %>

                                <option value="<%= bus.getPlaca() %>">

                                    <%= bus.getPlaca() %>
                                    -
                                    <%= bus.getMarca() %>
                                    <%= bus.getModelo() %>

                                </option>

                            <% } %>

                        </select>

                    </div>


                    <!-- FECHA -->

                    <div class="form-group">

                        <label for="fecha">
                            Fecha del mantenimiento
                        </label>

                        <input type="date"
                               id="fecha"
                               name="fecha"
                               required>

                    </div>


                    <!-- MANO DE OBRA -->

                    <div class="form-group">

                        <label for="montoManoObra">
                            Monto de mano de obra
                        </label>

                        <input type="number"
                               id="montoManoObra"
                               name="montoManoObra"
                               min="0"
                               step="0.01"
                               value="0"
                               required>

                    </div>


                    <!-- DESCRIPCIÓN -->

                    <div class="form-group">

                        <label for="descripcion">
                            Descripción
                        </label>

                        <textarea id="descripcion"
                                  name="descripcion"
                                  maxlength="500"
                                  rows="4"></textarea>

                    </div>


                    <!-- REPUESTOS -->

                    <h3>Repuestos utilizados</h3>

                    <% if (repuestos.isEmpty()) { %>

                        <p>
                            No hay repuestos activos registrados.
                        </p>

                    <% } else { %>


                        <div class="tabla-container">

                            <table>

                                <thead>

                                    <tr>

                                        <th>
                                            Repuesto
                                        </th>

                                        <th>
                                            Precio
                                        </th>

                                        <th>
                                            Cantidad
                                        </th>

                                        <th>
                                            Subtotal
                                        </th>

                                    </tr>

                                </thead>


                                <tbody>


                                    <% for (Repuesto repuesto : repuestos) { %>

                                        <tr>

                                            <td>

                                                <%= repuesto.getNombre() %>

                                                <input type="hidden"
                                                       name="codigoRepuesto"
                                                       value="<%= repuesto.getCodigoRepuesto() %>">

                                            </td>


                                            <td>

                                                Q<%= String.format(
                                                        "%.2f",
                                                        repuesto.getPrecio()
                                                ) %>

                                                <input type="hidden"
                                                       name="precioRepuesto"
                                                       value="<%= repuesto.getPrecio() %>">

                                            </td>


                                            <td>

                                                <input type="number"
                                                       name="cantidad"
                                                       class="cantidad-repuesto"
                                                       data-precio="<%= repuesto.getPrecio() %>"
                                                       min="0"
                                                       step="1"
                                                       value="0">

                                            </td>


                                            <td>

                                                Q<span class="subtotal-repuesto">
                                                    0.00
                                                </span>

                                            </td>

                                        </tr>

                                    <% } %>


                                </tbody>

                            </table>

                        </div>


                    <% } %>


                    <!-- TOTALES -->

                    <div class="card-menu">

                        <h3>Resumen del mantenimiento</h3>


                        <p>

                            Repuestos:

                            Q<span id="totalRepuestos">
                                0.00
                            </span>

                        </p>


                        <p>

                            Mano de obra:

                            Q<span id="totalManoObra">
                                0.00
                            </span>

                        </p>


                        <p>

                            <strong>
                                Costo total:
                            </strong>

                            Q<span id="totalMantenimiento">
                                0.00
                            </span>

                        </p>

                    </div>


                    <!-- CAMPOS OCULTOS -->

                    <input type="hidden"
                           id="montoRepuestos"
                           name="montoRepuestos"
                           value="0">


                    <!-- BOTÓN -->

                    <div class="form-actions">

                        <button type="submit">
                            Registrar mantenimiento
                        </button>

                    </div>


                </form>

            </div>


            <br>


            <!-- REGRESAR -->

            <div class="botones-inferiores">

                <a href="../inicio.jsp"
                   class="boton boton-volver">
                    Regresar al inicio
                </a>

            </div>
        </main>
        
        <script src="../resources/js/mantenimientos.js"></script>
      
    </body>
</html>

