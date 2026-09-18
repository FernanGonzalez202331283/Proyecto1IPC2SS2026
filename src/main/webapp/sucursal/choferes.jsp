<%-- 
    Document   : choferes
    Created on : 8 sept 2026, 22:27:58
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page import="transporte.dao.ChoferDAO"%>

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

    ChoferDAO choferDAO = new ChoferDAO();

    List<Chofer> choferes
            = choferDAO.listarPorSucursal(codigoSucursal);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Gestión de Choferes</title>
        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">
    </head>
    <body>
        <main class="pagina">
            <!-- ENCABEZADO -->
            <header class="encabezado">
                <h1>
                    Gestión de Choferes
                </h1>
                <p>
                    Administra los choferes pertenecientes
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
                    Choferes de la sucursal
                </h2>
                <p>
                    Desde aquí puedes registrar nuevos choferes,
                    modificar su información y cambiar su estado.
                </p>
                <div class="botones-formulario">

                    <a
                        href="registrarChofer.jsp"
                        class="boton">

                        Registrar nuevo chofer

                    </a>

                </div>

            </section>

            <!-- LISTADO DE CHOFERES -->
            <section class="formulario">

                <h2>
                    Choferes registrados
                </h2>

                <% if (choferes.isEmpty()) { %>

                <div class="mensaje">

                    No hay choferes registrados
                    para esta sucursal.

                </div>

                <% } else { %>

                <div class="tabla-contenedor">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Licencia
                                </th>

                                <th>
                                    Nombre
                                </th>

                                <th>
                                    Tipo de licencia
                                </th>

                                <th>
                                    Vencimiento
                                </th>

                                <th>
                                    Teléfono
                                </th>

                                <th>
                                    Salario por viaje
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

                            <% for (Chofer chofer : choferes) {%>

                            <tr>

                                <td>
                                    <strong>
                                        <%= chofer.getNumeroLicencia()%>
                                    </strong>
                                </td>

                                <td>
                                    <%= chofer.getNombreCompleto()%>
                                </td>

                                <td>
                                    <%= chofer.getTipoLicencia()%>
                                </td>

                                <td>
                                    <%= chofer.getFechaVencimientoLicencia()%>
                                </td>

                                <td>
                                    <%= chofer.getTelefono()%>
                                </td>

                                <td>
                                    Q
                                    <%= String.format(
                                            "%.2f",
                                            chofer.getSalarioBaseViaje()
                                    )%>
                                </td>

                                <td>

                                    <% if (chofer.isEstado()) { %>

                                    <span class="estado-activo">
                                        Activo
                                    </span>

                                    <% } else { %>

                                    <span class="estado-inactivo">
                                        Inactivo
                                    </span>

                                    <% }%>

                                </td>

                                <td>

                                    <div class="acciones-tabla">

                                        <!-- MODIFICAR -->

                                        <a
                                            href="modificarChofer.jsp?numeroLicencia=<%= chofer.getNumeroLicencia()%>"
                                            class="boton">

                                            Modificar

                                        </a>


                                        <!-- CAMBIAR ESTADO -->

                                        <% if (chofer.isEstado()) {%>

                                        <a
                                            href="desactivarChofer.jsp?numeroLicencia=<%= chofer.getNumeroLicencia()%>"
                                            class="boton">

                                            Desactivar

                                        </a>

                                        <% } else {%>

                                        <a
                                            href="activarChofer.jsp?numeroLicencia=<%= chofer.getNumeroLicencia()%>"
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

                <% }%>

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
