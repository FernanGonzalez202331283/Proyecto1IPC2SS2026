<%-- 
    Document   : viajes
    Created on : 10 sept 2026, 1:17:51
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario =
            (Usuario) session.getAttribute("usuario");

    // Verificar sesión
    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Solo CLIENTE puede entrar
    if (!"CLIENTE".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    // Obtener viajes regulares disponibles
    ViajeDAO viajeDAO =
            new ViajeDAO();

    List<Viaje> viajes =
            viajeDAO.listarViajesRegularesDisponibles();
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Viajes disponibles</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

<main class="pagina">

    <header class="encabezado">

        <h1>Viajes regulares disponibles</h1>

        <p>
            Bienvenido,
            <strong>
                <%= usuario.getUsuario() %>
            </strong>
        </p>

        <p>
            Seleccione el viaje que desea realizar.
        </p>

    </header>


    <% if (viajes.isEmpty()) { %>

        <div class="mensaje">

            Actualmente no hay viajes regulares
            disponibles.

        </div>

    <% } else { %>


        <div class="cards-menu">

            <% for (Viaje viaje : viajes) { %>

                <div class="card-menu">

                    <h3>
                        <%= viaje.getOrigen() %>
                        →
                        <%= viaje.getDestino() %>
                    </h3>


                    <p>
                        <strong>Viaje:</strong>
                        <%= viaje.getCodigoViaje() %>
                    </p>


                    <p>
                        <strong>Ruta:</strong>
                        <%= viaje.getCodigoRuta() %>
                    </p>


                    <p>
                        <strong>Fecha de salida:</strong>
                        <%= viaje.getFechaSalida() %>
                    </p>


                    <p>
                        <strong>Hora de salida:</strong>
                        <%= viaje.getHoraSalida() %>
                    </p>


                    <p>
                        <strong>Llegada estimada:</strong>
                        <%= viaje.getFechaLlegadaEstimada() %>
                        -
                        <%= viaje.getHoraLlegadaEstimada() %>
                    </p>


                    <p>
                        <strong>Bus:</strong>
                        <%= viaje.getPlacaBus() %>
                    </p>


                    <p>
                        <strong>Precio del boleto:</strong>
                        Q<%= String.format(
                                "%.2f",
                                viaje.getPrecioBoletos()
                        ) %>
                    </p>


                    <p>
                        <strong>Asientos disponibles:</strong>
                        <%= viaje.getAsientosDisponibles() %>
                    </p>


                    <div class="card-acciones">

                        <% if (viaje.getAsientosDisponibles() > 0) { %>

                            <a href="comprarBoleto.jsp?codigoViaje=<%= viaje.getCodigoViaje() %>">
                                Comprar boleto
                            </a>

                        <% } else { %>

                            <span>
                                Sin asientos disponibles
                            </span>

                        <% } %>

                    </div>

                </div>

            <% } %>

        </div>


    <% } %>


    <br>

    <a href="../inicio.jsp">
        Regresar al inicio
    </a>

</main>

</body>

</html>