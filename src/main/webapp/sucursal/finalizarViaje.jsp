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

        response.sendRedirect("../index.jsp");
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


    /*
     * Obtener el viaje y verificar que pertenezca
     * a la sucursal del administrador.
     */
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


    /*
     * Procesar formulario.
     */
    if ("POST".equalsIgnoreCase(
            request.getMethod())) {

        String horaRealLlegada =
                request.getParameter(
                        "horaRealLlegada"
                );

        String kilometrajeFinalTexto =
                request.getParameter(
                        "kilometrajeFinal"
                );

        String gastoCombustibleTexto =
                request.getParameter(
                        "gastoCombustible"
                );


        if (horaRealLlegada == null
                || horaRealLlegada.trim().isEmpty()
                || kilometrajeFinalTexto == null
                || kilometrajeFinalTexto.trim().isEmpty()
                || gastoCombustibleTexto == null
                || gastoCombustibleTexto.trim().isEmpty()) {

            mensaje =
                    "Debe completar todos los campos.";

            tipoMensaje = "error";

        } else {

            try {

                double kilometrajeFinal =
                        Double.parseDouble(
                                kilometrajeFinalTexto.trim()
                        );

                double gastoCombustible =
                        Double.parseDouble(
                                gastoCombustibleTexto.trim()
                        );


                if (kilometrajeFinal < 0) {

                    mensaje =
                            "El kilometraje final no puede ser negativo.";

                    tipoMensaje = "error";

                } else if (gastoCombustible < 0) {

                    mensaje =
                            "El gasto de combustible no puede ser negativo.";

                    tipoMensaje = "error";

                } else {

                    /*
                     * Convertir HH:mm a HH:mm:ss
                     * para utilizar Time.valueOf().
                     */
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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Finalizar viaje</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">


        <!-- ENCABEZADO -->

        <header class="encabezado">

            <h1>Finalizar viaje</h1>

            <p>
                Registre los datos reales de llegada
                del viaje.
            </p>

        </header>


        <!-- INFORMACIÓN DEL VIAJE -->

        <section class="card-menu">

            <h2>Información del viaje</h2>

            <p>
                <strong>Código:</strong>
                <%= viaje.getCodigoViaje() %>
            </p>

            <p>
                <strong>Bus:</strong>
                <%= viaje.getPlacaBus() %>
            </p>

            <p>
                <strong>Chofer:</strong>
                <%= viaje.getNumeroLicencia() %>
            </p>

            <p>
                <strong>Origen:</strong>
                <%= viaje.getOrigen() %>
            </p>

            <p>
                <strong>Destino:</strong>
                <%= viaje.getDestino() %>
            </p>

        </section>


        <!-- FORMULARIO -->

        <section class="card-menu">

            <h2>Datos reales de llegada</h2>

            <p>
                Ingrese cuidadosamente la información
                registrada al momento de finalizar el viaje.
            </p>


            <% if (!mensaje.isEmpty()) { %>

                <div class="<%= tipoMensaje %>">

                    <%= mensaje %>

                </div>

            <% } %>


            <form
                method="post"
                action="finalizarViaje.jsp?codigoViaje=<%= codigoViaje %>"
                id="formFinalizarViaje">


                <!-- HORA REAL -->

                <div class="formulario-grupo">

                    <label for="horaRealLlegada">

                        Hora real de llegada

                    </label>

                    <input
                        type="time"
                        id="horaRealLlegada"
                        name="horaRealLlegada"
                        required>

                </div>


                <!-- KILOMETRAJE FINAL -->

                <div class="formulario-grupo">

                    <label for="kilometrajeFinal">

                        Kilometraje final del bus

                    </label>

                    <input
                        type="number"
                        id="kilometrajeFinal"
                        name="kilometrajeFinal"
                        min="0"
                        step="0.01"
                        placeholder="Ejemplo: 125430.50"
                        required>

                </div>


                <!-- COMBUSTIBLE -->

                <div class="formulario-grupo">

                    <label for="gastoCombustible">

                        Gasto total de combustible

                    </label>

                    <input
                        type="number"
                        id="gastoCombustible"
                        name="gastoCombustible"
                        min="0"
                        step="0.01"
                        placeholder="Ejemplo: 350.00"
                        required>

                </div>


                <!-- ADVERTENCIA -->

                <div class="mensaje-advertencia">

                    <strong>Importante:</strong>

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

                <div class="card-acciones">

                    <button type="submit">

                        Finalizar viaje

                    </button>

                    <a href="viajes.jsp">

                        Cancelar

                    </a>

                </div>


            </form>

        </section>


        <!-- CERRAR SESIÓN -->

        <div class="cerrar-sesion">

            <form
                action="../logout.jsp"
                method="post">

                <button type="submit">

                    Cerrar sesión

                </button>

            </form>

        </div>


    </main>


    <script
        src="../resources/js/finalizarViaje.js">
    </script>

</body>

</html>
