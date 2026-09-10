<%-- 
    Document   : viajes
    Created on : 8 sept 2026
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.modelo.Usuario"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {

        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(
            usuarioSesion.getRol())) {

        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    ViajeDAO viajeDAO =
            new ViajeDAO();

    List<Viaje> viajes =
            viajeDAO.listarPorSucursal(
                    codigoSucursal
            );
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestionar Viajes</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <!-- ENCABEZADO -->

        <header class="encabezado">

            <h1>Gestionar Viajes</h1>

            <p>

                Sucursal:

                <strong>
                    <%= codigoSucursal %>
                </strong>

            </p>

        </header>


        <!-- ACCIONES -->

        <div>

            <a href="registrarViaje.jsp">

                Registrar nuevo viaje

            </a>

        </div>


        <br>


        <!-- MENSAJE CUANDO NO EXISTEN VIAJES -->

        <% if (viajes.isEmpty()) { %>

            <div class="mensaje">

                No hay viajes registrados
                para esta sucursal.

            </div>

        <% } else { %>


            <!-- TABLA DE VIAJES -->

            <div class="tabla-contenedor">

                <table>

                    <thead>

                        <tr>

                            <th>
                                Código
                            </th>

                            <th>
                                Tipo
                            </th>

                            <th>
                                Bus
                            </th>

                            <th>
                                Chofer
                            </th>

                            <th>
                                Ruta
                            </th>

                            <th>
                                Origen
                            </th>

                            <th>
                                Destino
                            </th>

                            <th>
                                Salida
                            </th>

                            <th>
                                Llegada estimada
                            </th>

                            <th>
                                Kilometraje inicial
                            </th>

                            <th>
                                Estado
                            </th>

                            <th>
                                Acciones
                            </th>

                        </tr>

                    </thead>


                    <tbody>

                        <% for (Viaje viaje : viajes) { %>

                            <%
                                double kilometrajeInicial =
                                        viajeDAO.obtenerKilometrajeInicial(
                                                viaje.getCodigoViaje()
                                        );
                            %>

                            <tr>

                                <!-- CÓDIGO -->

                                <td>

                                    <%= viaje.getCodigoViaje() %>

                                </td>


                                <!-- TIPO -->

                                <td>

                                    <%= viaje.getTipoViaje() %>

                                </td>


                                <!-- BUS -->

                                <td>

                                    <%= viaje.getPlacaBus() %>

                                </td>


                                <!-- CHOFER -->

                                <td>

                                    <%= viaje.getNumeroLicencia() != null
                                        ? viaje.getNumeroLicencia()
                                        : "No asignado" %>

                                </td>


                                <!-- RUTA -->

                                <td>

                                    <%= viaje.getCodigoRuta() != null
                                        ? viaje.getCodigoRuta()
                                        : "Privado" %>

                                </td>


                                <!-- ORIGEN -->

                                <td>

                                    <%= viaje.getOrigen() != null
                                        ? viaje.getOrigen()
                                        : "-" %>

                                </td>


                                <!-- DESTINO -->

                                <td>

                                    <%= viaje.getDestino() != null
                                        ? viaje.getDestino()
                                        : "-" %>

                                </td>


                                <!-- SALIDA -->

                                <td>

                                    <%= viaje.getFechaSalida() %>

                                    <br>

                                    <%= viaje.getHoraSalida() %>

                                </td>


                                <!-- LLEGADA ESTIMADA -->

                                <td>

                                    <%= viaje.getFechaLlegadaEstimada() %>

                                    <br>

                                    <%= viaje.getHoraLlegadaEstimada() %>

                                </td>


                                <!-- KILOMETRAJE INICIAL -->

                                <td>

                                    <% if (kilometrajeInicial >= 0) { %>

                                        <%= String.format(
                                                "%.2f km",
                                                kilometrajeInicial
                                            ) %>

                                    <% } else { %>

                                        -

                                    <% } %>

                                </td>


                                <!-- ESTADO -->

                                <td>

                                    <%= viaje.getEstado() %>

                                </td>


                                <!-- ACCIONES -->

                                <td>

                                    <% if ("PROGRAMADO".equals(
                                            viaje.getEstado())) { %>

                                        <a href="modificarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje() %>">

                                            Modificar

                                        </a>

                                        <br><br>

                                        <a href="iniciarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje() %>"
                                           onclick="return confirm('¿Desea iniciar este viaje?');">

                                            Iniciar viaje

                                        </a>

                                        <br><br>

                                        <a href="cancelarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje() %>"
                                           onclick="return confirm('¿Está seguro de cancelar este viaje?');">

                                            Cancelar viaje

                                        </a>

                                    <% } %>


                                    <% if ("EN_CURSO".equals(
                                            viaje.getEstado())) { %>

                                        <br><br>

                                        <a href="finalizarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje() %>"
                                           onclick="return confirm('¿Desea finalizar este viaje?');">

                                            Finalizar viaje

                                        </a>

                                    <% } %>

                                </td>

                            </tr>

                        <% } %>

                    </tbody>

                </table>

            </div>

        <% } %>


        <br>


        <!-- REGRESAR -->

        <a href="../inicio.jsp">

            Regresar al inicio

        </a>

    </main>

</body>

</html>