<%-- 
    Document   : confirmarCompra
    Created on : 11 sept 2026, 10:21:37
    Author     : fernan
--%>

<%@page import="transporte.dao.CarteraDAO"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.modelo.Cartera"%>
<%@page import="transporte.modelo.Viaje"%>
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

    codigoViaje
            = codigoViaje.trim();

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

    ViajeDAO viajeDAO
            = new ViajeDAO();

    Viaje viaje
            = viajeDAO.obtener(codigoViaje);

    if (viaje == null
            || !"REGULAR".equals(viaje.getTipoViaje())
            || !"PROGRAMADO".equals(viaje.getEstado())) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    if (numeroAsiento < 1
            || numeroAsiento > viaje.getCapacidadBus()) {

        response.sendRedirect(
                "comprarBoleto.jsp?codigoViaje="
                + codigoViaje
        );

        return;
    }

    CarteraDAO carteraDAO
            = new CarteraDAO();

    Cartera cartera
            = carteraDAO.obtener(
                    usuario.getUsuario()
            );
    if (cartera == null) {
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Error de cartera</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <div class="mensaje">

                No se encontró una cartera asociada
                a este usuario.

            </div>

            <br>

            <a href="viajes.jsp">
                Regresar a viajes
            </a>

        </main>

    </body>

</html>

<%
        return;
    }

    double precio
            = viaje.getPrecioBoletos();

    double saldoActual
            = cartera.getSaldo();

    double saldoRestante
            = saldoActual - precio;

%>


<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Confirmar compra</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>


    <body>

        <main class="pagina">


            <header class="encabezado">

                <h1>Confirmar compra</h1>

                <p>
                    Revise los datos antes de confirmar
                    su boleto.
                </p>

            </header>


            <!-- INFORMACIÓN DEL VIAJE -->

            <div class="card-menu">

                <h2>
                    <%= viaje.getOrigen()%>
                    →
                    <%= viaje.getDestino()%>
                </h2>

                <p>
                    <strong>Código del viaje:</strong>
                    <%= viaje.getCodigoViaje()%>
                </p>

                <p>
                    <strong>Fecha:</strong>
                    <%= viaje.getFechaSalida()%>
                </p>

                <p>
                    <strong>Hora:</strong>
                    <%= viaje.getHoraSalida()%>
                </p>

                <p>
                    <strong>Asiento seleccionado:</strong>
                    <%= numeroAsiento%>
                </p>

                <p>
                    <strong>Precio del boleto:</strong>
                    Q<%= String.format("%.2f", precio)%>
                </p>

            </div>


            <br>


            <!-- INFORMACIÓN DE CARTERA -->

            <div class="card-menu">

                <h2>Información de pago</h2>

                <p>
                    <strong>Saldo actual:</strong>
                    Q<%= String.format(
                            "%.2f",
                            saldoActual
                    )%>
                </p>

                <p>
                    <strong>Precio del boleto:</strong>
                    Q<%= String.format(
                            "%.2f",
                            precio
                    )%>
                </p>

                <%
                    if (saldoActual >= precio) {
                %>

                <p>
                    <strong>Saldo después de la compra:</strong>
                    Q<%= String.format(
                            "%.2f",
                            saldoRestante
                    )%>
                </p>

                <%
                } else {
                %>

                <p>
                    <strong>Saldo insuficiente.</strong>
                </p>

                <%
                    }
                %>

            </div>


            <br>


            <!-- CONFIRMACIÓN -->

            <div class="card-menu">

                <%
                    if (saldoActual >= precio) {
                %>

                <h2>
                    ¿Desea confirmar la compra?
                </h2>

                <form method="post"
                      action="procesarCompra.jsp">

                    <input type="hidden"
                           name="codigoViaje"
                           value="<%= codigoViaje%>">

                    <input type="hidden"
                           name="numeroAsiento"
                           value="<%= numeroAsiento%>">

                    <div class="form-actions">

                        <button type="submit">
                            Confirmar compra
                        </button>

                        <a href="comprarBoleto.jsp?codigoViaje=<%= codigoViaje%>">
                            Cancelar
                        </a>

                    </div>

                </form>

                <%
                } else {
                %>

                <p>
                    No puede realizar la compra porque
                    su saldo es insuficiente.
                </p>

                <div class="form-actions">

                    <a href="comprarBoleto.jsp?codigoViaje=<%= codigoViaje%>">
                        Regresar
                    </a>

                </div>

                <%
                    }
                %>

            </div>


            <br>

            <a href="../inicio.jsp">
                Regresar al inicio
            </a>


        </main>

    </body>

</html>
