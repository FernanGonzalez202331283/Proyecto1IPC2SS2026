<%--
    Document   : misAlquileres
    Created on : 14 sept 2026
    Author     : fernan
--%>
<%@page import="java.util.List"%>
<%@page import="transporte.dao.AlquilerDAO"%>
<%@page import="transporte.modelo.Alquiler"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario
            = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"CLIENTE".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    AlquilerDAO alquilerDAO = new AlquilerDAO();

    List<Alquiler> alquileres = alquilerDAO.listarPorCliente(usuario.getUsuario());
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Mis alquileres</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Mis alquileres</h1>

                <p>
                    Consulta el estado de tus solicitudes
                    de alquiler privado.
                </p>

            </header>

            <div class="card-menu">

                <% if (alquileres.isEmpty()) { %>

                <h2>No tienes alquileres registrados</h2>

                <p>
                    Todavía no has realizado ninguna
                    solicitud de alquiler privado.
                </p>

                <% } else { %>

                <div class="tabla-contenedor">

                    <table>
                        <thead>

                            <tr>

                                <th>Código</th>

                                <th>Viaje</th>

                                <th>Pasajeros</th>

                                <th>Fecha retorno</th>

                                <th>Precio estimado</th>

                                <th>Precio confirmado</th>

                                <th>Estado</th>

                                <th>Acción</th>

                            </tr>

                        </thead>

                        <tbody>

                            <% for (Alquiler alquiler : alquileres) {%>

                            <tr>

                                <td>
                                    <%= alquiler.getCodigoAlquiler()%>
                                </td>

                                <td>
                                    <%= alquiler.getCodigoViaje()%>
                                </td>

                                <td>
                                    <%= alquiler.getNumeroPasajeros()%>
                                </td>

                                <td>

                                    <% if (alquiler.getFechaRetorno() != null) {%>

                                    <%= alquiler.getFechaRetorno()%>

                                    <% } else { %>

                                    No aplica

                                    <% }%>

                                </td>

                                <td>
                                    Q
                                    <%= String.format(
                                            "%.2f",
                                            alquiler.getPrecioEstimado()
                                    )%>
                                </td>

                                <td>

                                    <% if (alquiler.getPrecioConfirmado() > 0) {%>

                                    Q
                                    <%= String.format(
                                            "%.2f",
                                            alquiler.getPrecioConfirmado()
                                         )%>

                                    <% } else { %>

                                    Pendiente

                                    <% }%>

                                </td>

                                <td>

                                    <strong>
                                        <%= alquiler.getEstado()%>
                                    </strong>

                                </td>

                                <td>

                                    <% if ("CONFIRMADO".equals(alquiler.getEstado())) {%>

                                    <form action="procesarPagoAlquiler.jsp"
                                          method="post">

                                        <input
                                            type="hidden"
                                            name="codigoAlquiler"
                                            value="<%= alquiler.getCodigoAlquiler()%>"
                                            >

                                        <button type="submit">
                                            Pagar
                                        </button>

                                    </form>

                                    <% } else if ("PAGADO".equals(alquiler.getEstado())) { %>

                                    <strong>
                                        Pagado
                                    </strong>

                                    <% } else { %>

                                    <span>
                                        No disponible
                                    </span>

                                    <% } %>

                                </td>

                            </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

                <% }%>

                <div class="card-acciones">

                    <a href="alquiler.jsp">
                        Solicitar alquiler
                    </a>

                    <a href="../inicio.jsp">
                        Regresar al inicio
                    </a>

                </div>

            </div>

        </main>

    </body>

</html>
