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

    String[] asientos
            = request.getParameterValues("numeroAsiento");

    if (codigoViaje == null
            || codigoViaje.trim().isEmpty()
            || asientos == null
            || asientos.length == 0) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    codigoViaje = codigoViaje.trim();

    int[] numerosAsientos
            = new int[asientos.length];

    try {

        for (int i = 0; i < asientos.length; i++) {

            numerosAsientos[i]
                    = Integer.parseInt(
                            asientos[i].trim()
                    );
        }

    } catch (NumberFormatException e) {

        response.sendRedirect(
                "comprarBoleto.jsp?codigoViaje="
                + codigoViaje
        );

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

    for (int numeroAsiento : numerosAsientos) {

        if (numeroAsiento < 1
                || numeroAsiento > viaje.getCapacidadBus()) {

            response.sendRedirect(
                    "comprarBoleto.jsp?codigoViaje="
                    + codigoViaje
            );

            return;
        }
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

    double precioBoleto
            = viaje.getPrecioBoletos();

    int cantidadBoletos
            = numerosAsientos.length;

    double precioTotal
            = precioBoleto * cantidadBoletos;

    double saldoActual
            = cartera.getSaldo();

    double saldoRestante
            = saldoActual - precioTotal;
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
                    su compra.
                </p>

            </header>


            <!-- INFORMACIÓN DEL VIAJE -->

            <div class="card-menu">

                <h2>

                    <%= viaje.getOrigen()%>
                    ->
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

                    <strong>Cantidad de boletos:</strong>

                    <%= cantidadBoletos%>

                </p>


                <p>

                    <strong>Precio por boleto:</strong>

                    Q<%= String.format(
                            "%.2f",
                            precioBoleto
                    )%>

                </p>


                <p>

                    <strong>Precio total:</strong>

                    Q<%= String.format(
                            "%.2f",
                            precioTotal
                    )%>

                </p>


                <p>

                    <strong>Asientos seleccionados:</strong>

                </p>


                <ul>

                    <%
                        for (int numeroAsiento : numerosAsientos) {
                    %>

                    <li>
                        Asiento <%= numeroAsiento%>
                    </li>

                    <%
                        }
                    %>

                </ul>

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

                    <strong>Total de la compra:</strong>

                    Q<%= String.format(
                            "%.2f",
                            precioTotal
                    )%>

                </p>


                <%
                    if (saldoActual >= precioTotal) {
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
                    if (saldoActual >= precioTotal) {
                %>

                <h2>
                    ¿Desea confirmar la compra?
                </h2>


                <form method="post"
                      action="procesarCompra.jsp">


                    <input type="hidden"
                           name="codigoViaje"
                           value="<%= codigoViaje%>">


                    <%
                        for (int numeroAsiento : numerosAsientos) {
                    %>

                    <input type="hidden"
                           name="numeroAsiento"
                           value="<%= numeroAsiento%>">

                    <%
                        }
                    %>


                    <div class="form-actions">

                        <button type="submit">
                            Confirmar compra
                        </button>


                        <a href="comprarBoleto.jsp?codigoViaje=<%= codigoViaje%>" class="boton botones-inferiores">

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
