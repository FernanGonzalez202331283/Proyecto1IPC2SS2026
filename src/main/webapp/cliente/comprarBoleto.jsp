<%-- 
    Document   : comprarBoleto
    Created on : 11 sept 2026, 9:53:37
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.dao.BoletoDAO"%>
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

    if (codigoViaje == null
            || codigoViaje.trim().isEmpty()) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    codigoViaje = codigoViaje.trim();

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

    BoletoDAO boletoDAO
            = new BoletoDAO();

    List<Integer> asientosOcupados
            = boletoDAO.listarAsientosOcupados(codigoViaje);
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Comprar boletos</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Comprar boletos</h1>

                <p>
                    Seleccione uno o varios asientos para realizar su compra.
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
                    <strong>Ruta:</strong>
                    <%= viaje.getCodigoRuta()%>
                </p>

                <p>
                    <strong>Fecha de salida:</strong>
                    <%= viaje.getFechaSalida()%>
                </p>

                <p>
                    <strong>Hora de salida:</strong>
                    <%= viaje.getHoraSalida()%>
                </p>

                <p>
                    <strong>Llegada estimada:</strong>
                    <%= viaje.getFechaLlegadaEstimada()%>
                    -
                    <%= viaje.getHoraLlegadaEstimada()%>
                </p>

                <p>
                    <strong>Bus:</strong>
                    <%= viaje.getPlacaBus()%>
                </p>

                <p>
                    <strong>Precio por boleto:</strong>
                    Q<%= String.format(
                            "%.2f",
                            viaje.getPrecioBoletos()
                    )%>
                </p>

                <p>
                    <strong>Asientos disponibles:</strong>
                    <%= viaje.getAsientosDisponibles()%>
                </p>

            </div>


            <br>


            <!-- SELECCIÓN DE ASIENTOS -->

            <div class="card-menu">

                <h2>Seleccione sus asientos</h2>

                <p>
                    Los asientos ocupados no pueden seleccionarse.
                </p>

                <p>
                    Puede seleccionar uno o varios asientos.
                </p>
                <p id="mensajeAsientos"></p>

                <p>
                    Asientos seleccionados:
                    <strong id="cantidadSeleccionada">0</strong>
                </p>

                <p>
                    Total estimado:
                    <strong>
                        Q<span id="totalCompra">0.00</span>
                    </strong>
                </p>


                <form 
                    method="post"
                    action="confirmarCompra.jsp"
                    id="formComprarBoleto"
                    data-precio="<%= viaje.getPrecioBoletos()%>"
                    data-disponibles="<%= viaje.getAsientosDisponibles()%>">



                    <!-- VIAJE -->

                    <input type="hidden"
                           name="codigoViaje"
                           value="<%= viaje.getCodigoViaje()%>">


                    <!-- ASIENTOS -->

                    <div class="asientos">

                        <%
                            for (int asiento = 1;
                                    asiento <= viaje.getCapacidadBus();
                                    asiento++) {

                                boolean ocupado
                                        = asientosOcupados.contains(asiento);
                        %>

                        <label class="asiento
                               <%= ocupado
                                ? "asiento-ocupado"
                                : "asiento-disponible"%>">

                            <input
                                type="checkbox"
                                name="numeroAsiento"
                                value="<%= asiento%>"
                                <%= ocupado
                                    ? "disabled"
                                    : ""%>
                                >

                            <span>
                                <%= asiento%>
                            </span>

                        </label>

                        <%
                            }
                        %>

                    </div>


                    <br>


                    <!-- BOTONES -->

                    <div class="form-actions">

                        <button type="submit">
                            Continuar con la compra
                        </button>

                    </div>
            <div class="botones-inferiores">

                <a
                    href="../cliente/viajes.jsp"
                    class="boton boton-volver">

                    cancelar
                </a>

            </div>
                </form>

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
        <script src="../resources/js/comprarBoleto.js"></script>

    </body>

</html>
