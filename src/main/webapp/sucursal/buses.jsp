<%-- 
    Document   : buses
    Created on : 6 sept 2026, 23:06:01
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.dao.BusDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    BusDAO busDAO = new BusDAO();

    List<Bus> buses =
            busDAO.listarPorSucursal(codigoSucursal);
    String mensajeBus =
        (String) session.getAttribute("mensajeBus");

String tipoMensajeBus =
        (String) session.getAttribute("tipoMensajeBus");

session.removeAttribute("mensajeBus");
session.removeAttribute("tipoMensajeBus");
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestión de Buses</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <header class="encabezado">

            <h1>Gestión de Buses</h1>

            <p>
                Sucursal:
                <strong><%= codigoSucursal %></strong>
            </p>

        </header>
            
            <% if (mensajeBus != null && !mensajeBus.isEmpty()) { %>

                <div class="mensaje <%= tipoMensajeBus %>">
                    <%= mensajeBus %>
                </div>

                <br>

            <% } %>

        <div class="card-menu">

            <h2>Buses de la sucursal</h2>

            <p>
                Administra los buses pertenecientes
                a esta sucursal.
            </p>

            <div class="card-acciones">

                <a href="registrarBus.jsp">
                    Registrar bus
                </a>

            </div>

        </div>

        <br>

        <% if (buses.isEmpty()) { %>

            <div class="mensaje">

                No hay buses registrados
                en esta sucursal.

            </div>

        <% } else { %>

            <div class="tabla-contenedor">

                <table>

                    <thead>

                        <tr>
                            <th>Placa</th>
                            <th>Marca</th>
                            <th>Modelo</th>
                            <th>Año</th>
                            <th>Capacidad</th>
                            <th>Estado</th>
                            <th>Kilometraje</th>
                            <th>Acciones</th>
                        </tr>

                    </thead>

                    <tbody>

                        <% for (Bus bus : buses) { %>

                            <tr>

                                <td>
                                    <%= bus.getPlaca() %>
                                </td>

                                <td>
                                    <%= bus.getMarca() %>
                                </td>

                                <td>
                                    <%= bus.getModelo() %>
                                </td>

                                <td>
                                    <%= bus.getAñoFabricacion() %>
                                </td>

                                <td>
                                    <%= bus.getCapacidad() %>
                                </td>

                                <td>
                                    <%= bus.getEstadoOperativo() %>
                                </td>

                                <td>
                                    <%= bus.getKilometrajeActual() %>
                                </td>

                                <td>

                                    <a href="modificarBus.jsp?placa=<%= bus.getPlaca() %>">
                                        Modificar
                                    </a>

                                    <% if ("INACTIVO".equals(bus.getEstadoOperativo())) { %>

                                        <form method="POST"
                                              action="cambiarEstadoBus.jsp"
                                              style="display:inline;">

                                            <input type="hidden"
                                                   name="placa"
                                                   value="<%= bus.getPlaca() %>">

                                            <input type="hidden"
                                                   name="accion"
                                                   value="activar">

                                            <button type="submit">
                                                Activar
                                            </button>

                                        </form>

                                    <% } else { %>

                                        <form method="POST"
                                              action="cambiarEstadoBus.jsp"
                                              style="display:inline;">

                                            <input type="hidden"
                                                   name="placa"
                                                   value="<%= bus.getPlaca() %>">

                                            <input type="hidden"
                                                   name="accion"
                                                   value="desactivar">

                                            <button type="submit">
                                                Desactivar
                                            </button>

                                        </form>

                                    <% } %>

                                </td>

                            </tr>

                        <% } %>

                    </tbody>

                </table>

            </div>

        <% } %>

        <br>

        <a href="../inicio.jsp">
            Regresar al inicio
        </a>

    </main>

</body>

</html>