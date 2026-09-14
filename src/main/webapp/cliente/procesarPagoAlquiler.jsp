<%--
Document   : procesarPagoAlquiler
Created on : 14 sept 2026
Author     : fernan
--%>

<%@page import="transporte.dao.PagoAlquilerDAO"%>
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

String codigoAlquiler
        = request.getParameter("codigoAlquiler");

if (codigoAlquiler == null
        || codigoAlquiler.trim().isEmpty()) {

    response.sendRedirect("misAlquileres.jsp");
    return;
}

codigoAlquiler
        = codigoAlquiler.trim();

PagoAlquilerDAO pagoDAO
        = new PagoAlquilerDAO();

boolean pagoRealizado
        = pagoDAO.procesarPago(
                codigoAlquiler,
                usuario.getUsuario()
        );

%>

<!DOCTYPE html>

<html lang="es">

```
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Resultado del pago</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>


<body>

    <main class="pagina">

        <header class="encabezado">

            <h1>Resultado del pago</h1>

        </header>


        <div class="card-menu">

            <% if (pagoRealizado) { %>

                <h2>Pago realizado correctamente</h2>

                <p>
                    El alquiler fue pagado correctamente.
                </p>

                <p>
                    <strong>Código del alquiler:</strong>
                    <%= codigoAlquiler %>
                </p>

                <p>
                    El monto correspondiente fue descontado
                    de tu cartera.
                </p>

                <div class="card-acciones">

                    <a href="misAlquileres.jsp">
                        Ver mis alquileres
                    </a>

                    <a href="../inicio.jsp">
                        Regresar al inicio
                    </a>

                </div>

            <% } else { %>

                <h2>No se pudo realizar el pago</h2>

                <p>
                    El pago del alquiler no pudo completarse.
                </p>

                <p>
                    Esto puede ocurrir si el alquiler no está
                    confirmado, el saldo de la cartera es
                    insuficiente o el pago ya fue realizado.
                </p>

                <div class="card-acciones">

                    <a href="misAlquileres.jsp">
                        Regresar a mis alquileres
                    </a>

                </div>

            <% } %>

        </div>

    </main>

</body>
</html>
