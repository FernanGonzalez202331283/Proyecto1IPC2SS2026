<%-- 
    Document   : procesarCompra
    Created on : 11 sept 2026, 11:15:34
    Author     : fernan
--%>
<%@page import="java.sql.Date"%>
<%@page import="transporte.dao.CompraBoletoDAO"%>
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

    String codigoViaje
            = request.getParameter("codigoViaje");

    String numeroAsientoParametro
            = request.getParameter("numeroAsiento");

    if (codigoViaje == null
            || codigoViaje.trim().isEmpty()
            || numeroAsientoParametro == null
            || numeroAsientoParametro.trim().isEmpty()) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    codigoViaje = codigoViaje.trim();

    int numeroAsiento;

    try {

        numeroAsiento
                = Integer.parseInt(
                        numeroAsientoParametro.trim()
                );

    } catch (NumberFormatException e) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    String codigoBoleto
            = "BOL-" + System.currentTimeMillis();

    String codigoMovimiento
            = "MOV-" + System.currentTimeMillis();

    Date fechaPago
            = new Date(System.currentTimeMillis());

    CompraBoletoDAO compraDAO
            = new CompraBoletoDAO();

    boolean compraRealizada
            = compraDAO.comprarBoleto(
                    codigoBoleto,
                    codigoViaje,
                    usuario.getUsuario(),
                    numeroAsiento,
                    codigoMovimiento,
                    fechaPago
            );
%>


<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Resultado de compra</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>


    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Resultado de la compra</h1>

            </header>


            <div class="card-menu">

                <% if (compraRealizada) {%>

                <h2>Compra realizada correctamente</h2>

                <p>
                    Tu boleto fue registrado
                    correctamente.
                </p>

                <p>
                    <strong>Código del boleto:</strong>
                    <%= codigoBoleto%>
                </p>

                <p>
                    <strong>Viaje:</strong>
                    <%= codigoViaje%>
                </p>

                <p>
                    <strong>Asiento:</strong>
                    <%= numeroAsiento%>
                </p>

                <div class="card-acciones">

                    <a href="boletos.jsp">
                        Ver mis boletos
                    </a>

                    <a href="../inicio.jsp">
                        Regresar al inicio
                    </a>

                </div>

                <% } else { %>

                <h2>No se pudo realizar la compra</h2>

                <p>
                    La compra no pudo completarse.
                </p>

                <p>
                    Esto puede ocurrir si el asiento
                    ya fue ocupado, el saldo es
                    insuficiente o el viaje ya no
                    está disponible.
                </p>

                <div class="card-acciones">

                    <a href="viajes.jsp">
                        Regresar a viajes
                    </a>

                </div>

                <% }%>

            </div>

        </main>

    </body>

</html>

