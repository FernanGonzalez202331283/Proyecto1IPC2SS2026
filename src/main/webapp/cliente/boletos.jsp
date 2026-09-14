<%-- 
    Document   : boletos
    Created on : 11 sept 2026, 11:51:57
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.dao.BoletoDAO"%>
<%@page import="transporte.modelo.Boleto"%>
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

    BoletoDAO boletoDAO
            = new BoletoDAO();

    List<Boleto> boletos
            = boletoDAO.listarPorUsuario(
                    usuario.getUsuario()
            );
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Mis boletos</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Mis boletos</h1>

                <p>
                    Usuario:
                    <strong>
                        <%= usuario.getUsuario()%>
                    </strong>
                </p>

                <p>
                    Aquí puedes consultar los boletos que has comprado.
                </p>

            </header>


            <% if (boletos.isEmpty()) { %>

            <div class="mensaje">

                No tienes boletos registrados.

            </div>

            <% } else { %>


            <div class="cards-menu">

                <% for (Boleto boleto : boletos) {%>

                <div class="card-menu">

                    <h2>
                        Boleto
                        <%= boleto.getCodigoBoleto()%>
                    </h2>

                    <p>
                        <strong>Viaje:</strong>
                        <%= boleto.getCodigoViaje()%>
                    </p>

                    <p>
                        <strong>Asiento:</strong>
                        <%= boleto.getNumeroAsiento()%>
                    </p>

                    <p>
                        <strong>Precio:</strong>
                        Q<%= String.format(
                                "%.2f",
                                boleto.getPrecio()
                        )%>
                    </p>

                    <p>
                        <strong>Fecha de pago:</strong>
                        <%= boleto.getFechaPago()%>
                    </p>

                    <p>
                        <strong>Estado:</strong>
                        <%= boleto.getEstado()%>
                    </p>

                    <p>
                        <strong>Movimiento:</strong>
                        <%= boleto.getCodigoMovimiento()%>
                    </p>

                </div>

                <% } %>

            </div>


            <% }%>


            <br>

            <div class="form-actions">

                <a href="viajes.jsp">
                    Ver viajes
                </a>

                <a href="../inicio.jsp">
                    Regresar al inicio
                </a>

            </div>

        </main>

    </body>

</html>