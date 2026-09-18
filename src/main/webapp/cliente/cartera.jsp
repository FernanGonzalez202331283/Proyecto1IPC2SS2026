<%-- 
    Document   : cartera
    Created on : 11 sept 2026, 11:09:30
    Author     : fernan
--%>

<%@page import="transporte.dao.CarteraDAO"%>
<%@page import="transporte.modelo.Cartera"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"CLIENTE".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    CarteraDAO carteraDAO = new CarteraDAO();
    Cartera cartera = carteraDAO.obtener(usuario.getUsuario());
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Mi cartera</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Mi cartera</h1>

                <p>
                    Bienvenido,
                    <strong><%= usuario.getUsuario()%></strong>
                </p>

                <p>
                    Consulta el saldo disponible
                    de tu cartera.
                </p>

            </header>


            <% if (cartera == null) { %>

            <div class="mensaje Error">

                No se encontró una cartera asociada
                a tu usuario.

            </div>

            <% } else {%>

            <div class="card-menu">

                <h2>Saldo disponible</h2>

                <p>
                    <strong>
                        Q<%= String.format(
                                "%.2f",
                                cartera.getSaldo()
                        )%>
                    </strong>
                </p>

                <div class="card-acciones">

                    <a href="recargarCartera.jsp">
                        Recargar saldo
                    </a>

                </div>

            </div>

            <% }%>

              <div class="botones-inferiores">
                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">
                    Regresar al inicio
                </a>

            </div>

        </main>

    </body>

</html>

