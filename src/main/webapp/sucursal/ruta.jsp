<%-- 
    Document   : ruta
    Created on : 8 sept 2026, 22:42:23
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Ruta"%>
<%@page import="transporte.dao.RutaDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion
            = (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal
            = usuarioSesion.getCodigoSucursal();

    RutaDAO rutaDAO
            = new RutaDAO();

    List<Ruta> rutas
            = rutaDAO.listarPorSucursal(codigoSucursal);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Gestión de Rutas</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Gestión de Rutas
                </h1>

                <p>
                    Administra las rutas pertenecientes
                    a tu sucursal.
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
                    Rutas de la sucursal
                </h2>

                <p>
                    Desde aquí puedes registrar nuevas rutas,
                    modificar su información y cambiar su estado.
                </p>

                <div class="botones-formulario">

                    <a
                        href="registrarRuta.jsp"
                        class="boton">

                        Registrar nueva ruta

                    </a>

                </div>

            </section>


            <!-- LISTADO DE RUTAS -->

            <section class="formulario">

                <h2>
                    Rutas registradas
                </h2>

                <% if (rutas.isEmpty()) { %>

                <div class="mensaje">

                    No hay rutas registradas
                    para esta sucursal.

                </div>

                <% } else { %>

                <div class="tabla-contenedor">

                    <table>

                        <thead>

                            <tr>

                                <th>Código</th>
                                <th>Origen</th>
                                <th>Destino</th>
                                <th>Distancia</th>
                                <th>Precio boleto</th>
                                <th>Estado</th>
                                <th>Acciones</th>

                            </tr>

                        </thead>

                        <tbody>

                            <% for (Ruta ruta : rutas) {%>

                            <tr>

                                <td>

                                    <strong>
                                        <%= ruta.getCodigoRuta()%>
                                    </strong>

                                </td>

                                <td>
                                    <%= ruta.getCodigoSucursalOrigen()%>
                                </td>

                                <td>
                                    <%= ruta.getCodigoSucursalDestino()%>
                                </td>

                                <td>

                                    <%= String.format(
                                            "%.2f",
                                            ruta.getDistanciaKm()
                                    )%>
                                    km

                                </td>

                                <td>

                                    Q
                                    <%= String.format(
                                            "%.2f",
                                            ruta.getPrecioBoleto()
                                    )%>

                                </td>

                                <td>

                                    <% if (ruta.isEstado()) { %>

                                    <span class="estado-activo">
                                        Activa
                                    </span>

                                    <% } else { %>

                                    <span class="estado-inactivo">
                                        Inactiva
                                    </span>

                                    <% } %>

                                </td>

                                <td>

                                    <div class="acciones-tabla">

                                        <!-- MODIFICAR -->

                                        <a
                                            href="modificarRuta.jsp?codigoRuta=<%= ruta.getCodigoRuta()%>"
                                            class="boton">

                                            Modificar

                                        </a>


                                        <!-- CAMBIAR ESTADO -->

                                        <% if (ruta.isEstado()) { %>

                                        <a
                                            href="desactivarRuta.jsp?codigoRuta=<%= ruta.getCodigoRuta()%>"
                                            class="boton">

                                            Desactivar

                                        </a>

                                        <% } else { %>

                                        <a
                                            href="activarRuta.jsp?codigoRuta=<%= ruta.getCodigoRuta()%>"
                                            class="boton">

                                            Activar

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

                    Volver al menú principal

                </a>

            </div>

        </main>

    </body>

</html>
