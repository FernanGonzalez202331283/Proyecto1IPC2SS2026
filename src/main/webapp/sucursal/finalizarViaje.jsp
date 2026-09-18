<%-- 
    Document   : finalizarViaje
    Created on : 9 sept 2026
    Author     : fernan
--%>

<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.dao.ViajeDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {

        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(
            usuarioSesion.getRol())) {

        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    String codigoViaje =
            request.getParameter("codigoViaje");

    if (codigoViaje == null
            || codigoViaje.trim().isEmpty()) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    codigoViaje =
            codigoViaje.trim();

    ViajeDAO viajeDAO =
            new ViajeDAO();

    Viaje viaje =
            viajeDAO.obtenerPorSucursal(
                    codigoViaje,
                    codigoSucursal
            );

    if (viaje == null
            || !"EN_CURSO".equals(
                    viaje.getEstado())) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    String mensaje = "";
    String tipoMensaje = "";

    String horaRealLlegada = "";
    String kilometrajeFinalTexto = "";
    String gastoCombustibleTexto = "";

    if ("POST".equalsIgnoreCase(
            request.getMethod())) {

        horaRealLlegada =
                request.getParameter(
                        "horaRealLlegada"
                );

        kilometrajeFinalTexto =
                request.getParameter(
                        "kilometrajeFinal"
                );

        gastoCombustibleTexto =
                request.getParameter(
                        "gastoCombustible"
                );

        if (horaRealLlegada != null) {

            horaRealLlegada =
                    horaRealLlegada.trim();
        }

        if (kilometrajeFinalTexto != null) {

            kilometrajeFinalTexto =
                    kilometrajeFinalTexto.trim();
        }

        if (gastoCombustibleTexto != null) {

            gastoCombustibleTexto =
                    gastoCombustibleTexto.trim();
        }

        if (horaRealLlegada == null
                || horaRealLlegada.isEmpty()
                || kilometrajeFinalTexto == null
                || kilometrajeFinalTexto.isEmpty()
                || gastoCombustibleTexto == null
                || gastoCombustibleTexto.isEmpty()) {

            mensaje =
                    "Debe completar todos los campos.";

            tipoMensaje = "error";

        } else {

            try {

                double kilometrajeFinal =
                        Double.parseDouble(
                                kilometrajeFinalTexto
                        );

                double gastoCombustible =
                        Double.parseDouble(
                                gastoCombustibleTexto
                        );

                if (kilometrajeFinal < 0) {

                    mensaje =
                            "El kilometraje final no puede ser negativo.";

                    tipoMensaje = "error";

                } else if (gastoCombustible < 0) {

                    mensaje =
                            "El gasto de combustible "
                            + "no puede ser negativo.";

                    tipoMensaje = "error";

                } else {

                    if (horaRealLlegada.length() == 5) {

                        horaRealLlegada =
                                horaRealLlegada + ":00";
                    }

                    boolean finalizado =
                            viajeDAO.finalizarViaje(
                                    codigoViaje,
                                    codigoSucursal,
                                    horaRealLlegada,
                                    kilometrajeFinal,
                                    gastoCombustible,
                                    usuarioSesion.getUsuario()
                            );


                    if (finalizado) {

                        response.sendRedirect(
                                "viajes.jsp"
                        );

                        return;

                    } else {

                        mensaje =
                                "No se pudo finalizar el viaje. "
                                + "Verifique los datos ingresados.";

                        tipoMensaje = "error";
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                        "El kilometraje y el gasto de combustible "
                        + "deben ser números válidos.";

                tipoMensaje = "error";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Finalizar viaje</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">


            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Finalizar viaje
                </h1>

                <p>
                    Registra los datos reales de llegada
                    del viaje.
                </p>

                <p>
                    Sucursal:
                    <strong>
                        <%= codigoSucursal%>
                    </strong>
                </p>

            </header>


            <!-- INFORMACIÓN DEL VIAJE -->

            <section class="formulario">

                <h2>
                    Información del viaje
                </h2>

                <p>
                    <strong>Código:</strong>
                    <%= viaje.getCodigoViaje()%>
                </p>

                <p>
                    <strong>Bus:</strong>
                    <%= viaje.getPlacaBus()%>
                </p>

                <p>
                    <strong>Chofer:</strong>
                    <%= viaje.getNumeroLicencia()%>
                </p>

                <p>
                    <strong>Origen:</strong>
                    <%= viaje.getOrigen()%>
                </p>

                <p>
                    <strong>Destino:</strong>
                    <%= viaje.getDestino()%>
                </p>

            </section>


            <!-- FORMULARIO DE LLEGADA -->

            <section class="formulario">

                <h2>
                    Datos reales de llegada
                </h2>

                <p>
                    Ingrese cuidadosamente la información
                    registrada al momento de finalizar
                    el viaje.
                </p>


                <!-- MENSAJE -->

                <% if (!mensaje.isEmpty()) { %>

                <div class="mensaje <%= tipoMensaje%>">

                    <%= mensaje%>

                </div>

                <% } %>


                <form
                    method="POST"
                    action="finalizarViaje.jsp?codigoViaje=<%= codigoViaje%>"
                    id="formFinalizarViaje">


                    <!-- HORA REAL -->

                    <div class="campo">

                        <label for="horaRealLlegada">

                            Hora real de llegada

                            <span class="obligatorio">
                                *
                            </span>

                        </label>

                        <input
                            type="time"
                            id="horaRealLlegada"
                            name="horaRealLlegada"
                            value="<%= horaRealLlegada%>"
                            required>

                        <p
                            id="mensajeHora"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- KILOMETRAJE FINAL -->

                    <div class="campo">

                        <label for="kilometrajeFinal">

                            Kilometraje final del bus

                            <span class="obligatorio">
                                *
                            </span>

                        </label>

                        <input
                            type="number"
                            id="kilometrajeFinal"
                            name="kilometrajeFinal"
                            min="0"
                            step="0.01"
                            value="<%= kilometrajeFinalTexto%>"
                            placeholder="Ejemplo: 125430.50"
                            required>

                        <p
                            id="mensajeKilometraje"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- COMBUSTIBLE -->

                    <div class="campo">

                        <label for="gastoCombustible">

                            Gasto total de combustible

                            <span class="obligatorio">
                                *
                            </span>

                        </label>

                        <input
                            type="number"
                            id="gastoCombustible"
                            name="gastoCombustible"
                            min="0"
                            step="0.01"
                            value="<%= gastoCombustibleTexto%>"
                            placeholder="Ejemplo: 350.00"
                            required>

                        <p
                            id="mensajeCombustible"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- ADVERTENCIA -->
                    <div class="mensaje">

                        <strong>
                            Importante
                        </strong>
                        <p>
                            Una vez registrada la llegada,
                            los datos no podrán modificarse
                            ni eliminarse.
                        </p>
                        <p>
                            Verifique que la hora,
                            el kilometraje y el gasto
                            de combustible sean correctos.
                        </p>
                    </div>


                    <!-- BOTONES -->
                    <div class="botones-formulario">
                        <button
                            type="submit"
                            class="boton">
                            Finalizar viaje

                        </button>
                        <a
                            href="viajes.jsp"
                            class="boton">

                            Cancelar
                        </a>
                    </div>
                </form>
            </section>

            <!-- VOLVER -->
            <div class="botones-inferiores">
                <a
                    href="viajes.jsp"
                    class="boton boton-volver">
                    Volver a viajes
                </a>
            </div>
        </main>
        <script
            src="../resources/js/finalizarViaje.js">
        </script>
    </body>
</html>
