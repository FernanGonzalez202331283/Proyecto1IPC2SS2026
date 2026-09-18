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
    Usuario usuarioSesion
            = (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(
            usuarioSesion.getRol())) {

        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal
            = usuarioSesion.getCodigoSucursal();

    ViajeDAO viajeDAO
            = new ViajeDAO();

    List<Viaje> viajes
            = viajeDAO.listarPorSucursal(
                    codigoSucursal
            );
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Gestión de Viajes</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Gestión de Viajes
                </h1>

                <p>
                    Administra los viajes programados
                    y realizados desde tu sucursal.
                </p>

                <p>
                    Sucursal:
                    <strong>
                        <%= codigoSucursal%>
                    </strong>
                </p>

            </header>


            <!-- OPCIONES -->

            <section class="formulario">

                <h2>
                    Viajes de la sucursal
                </h2>

                <p>
                    Desde aquí puedes registrar nuevos viajes,
                    modificarlos, iniciarlos, finalizarlos
                    o cancelarlos según su estado.
                </p>

                <div class="botones-formulario">

                    <a
                        href="registrarViaje.jsp"
                        class="boton">

                        Registrar nuevo viaje

                    </a>

                </div>

            </section>


            <!-- LISTADO DE VIAJES -->

            <section class="formulario">

                <h2>
                    Viajes registrados
                </h2>

                <% if (viajes.isEmpty()) { %>

                <div class="mensaje">

                    No hay viajes registrados
                    para esta sucursal.

                </div>

                <% } else { %>


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
                                double kilometrajeInicial
                                        = viajeDAO.obtenerKilometrajeInicial(
                                                viaje.getCodigoViaje()
                                        );
                            %>

                            <tr>

                                <!-- CÓDIGO -->

                                <td>

                                    <strong>
                                        <%= viaje.getCodigoViaje()%>
                                    </strong>

                                </td>


                                <!-- TIPO -->

                                <td>

                                    <%= viaje.getTipoViaje()%>

                                </td>


                                <!-- BUS -->

                                <td>

                                    <%= viaje.getPlacaBus()%>

                                </td>


                                <!-- CHOFER -->

                                <td>

                                    <%= viaje.getNumeroLicencia() != null
                                                ? viaje.getNumeroLicencia()
                                                : "No asignado"%>

                                </td>


                                <!-- RUTA -->

                                <td>

                                    <%= viaje.getCodigoRuta() != null
                                                ? viaje.getCodigoRuta()
                                                : "Privado"%>

                                </td>


                                <!-- ORIGEN -->

                                <td>

                                    <%= viaje.getOrigen() != null
                                                ? viaje.getOrigen()
                                                : "-"%>

                                </td>


                                <!-- DESTINO -->

                                <td>

                                    <%= viaje.getDestino() != null
                                                ? viaje.getDestino()
                                                : "-"%>

                                </td>


                                <!-- SALIDA -->

                                <td>

                                    <%= viaje.getFechaSalida()%>

                                    <br>

                                    <%= viaje.getHoraSalida()%>

                                </td>


                                <!-- LLEGADA ESTIMADA -->

                                <td>

                                    <%= viaje.getFechaLlegadaEstimada()%>

                                    <br>

                                    <%= viaje.getHoraLlegadaEstimada()%>

                                </td>


                                <!-- KILOMETRAJE INICIAL -->

                                <td>

                                    <% if (kilometrajeInicial >= 0) { %>

                                    <%= String.format(
                                            "%.2f km",
                                            kilometrajeInicial
                                    )%>

                                    <% } else { %>

                                    -

                                    <% } %>

                                </td>


                                <!-- ESTADO -->

                                <td>

                                    <%= viaje.getEstado()%>

                                </td>


                                <!-- ACCIONES -->

                                <td>

                                    <div class="acciones-tabla">

                                        <% if ("PROGRAMADO".equals(
                                                viaje.getEstado())) { %>

                                        <!-- MODIFICAR -->

                                        <a
                                            href="modificarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje()%>"
                                            class="boton">

                                            Modificar

                                        </a>


                                        <!-- INICIAR -->

                                        <a
                                            href="iniciarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje()%>"
                                            class="boton"
                                            onclick="return confirm('¿Desea iniciar este viaje?');">

                                            Iniciar viaje

                                        </a>


                                        <!-- CANCELAR -->

                                        <a
                                            href="cancelarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje()%>"
                                            class="boton"
                                            onclick="return confirm('¿Está seguro de cancelar este viaje?');">

                                            Cancelar viaje

                                        </a>

                                        <% } %>


                                        <% if ("EN_CURSO".equals(
                                                viaje.getEstado())) { %>

                                        <!-- FINALIZAR -->

                                        <a
                                            href="finalizarViaje.jsp?codigoViaje=<%= viaje.getCodigoViaje()%>"
                                            class="boton"
                                            onclick="return confirm('¿Desea finalizar este viaje?');">

                                            Finalizar viaje

                                        </a>

                                        <% } %>

                                    </div>

                                </td>

                            </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

                <% } %>

            </section>


            <!-- VOLVER -->

            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    regresar
                </a>

            </div>

        </main>

    </body>

</html>
