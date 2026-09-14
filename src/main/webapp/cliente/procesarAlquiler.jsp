<%-- 
    Document   : procesarAlquiler
    Created on : 13 sept 2026, 0:43:32
    Author     : fernan
--%>

<%@page import="transporte.dao.ConfiguracionDAO"%>
<%@page import="transporte.dao.RutaPrivadaDAO"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.dao.AlquilerDAO"%>
<%@page import="transporte.modelo.Configuracion"%>
<%@page import="transporte.modelo.RutaPrivada"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.modelo.Alquiler"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
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

    String origen = request.getParameter("origen");
    String destino = request.getParameter("destino");

    String numeroPasajerosParametro =
            request.getParameter("numeroPasajeros");

    String fechaSalidaParametro =
            request.getParameter("fechaSalida");

    String horaSalidaParametro =
            request.getParameter("horaSalida");

    String fechaLlegadaParametro =
            request.getParameter("fechaLlegada");

    String horaLlegadaParametro =
            request.getParameter("horaLlegada");

    String fechaRetornoParametro =
            request.getParameter("fechaRetorno");

    boolean correcto = false;
    String mensaje = "";

    String codigoViajeGenerado = null;
    String codigoAlquilerGenerado = null;

    RutaPrivada rutaPrivada = null;

    if (origen == null
            || origen.trim().isEmpty()
            || destino == null
            || destino.trim().isEmpty()
            || numeroPasajerosParametro == null
            || numeroPasajerosParametro.trim().isEmpty()
            || fechaSalidaParametro == null
            || fechaSalidaParametro.trim().isEmpty()
            || horaSalidaParametro == null
            || horaSalidaParametro.trim().isEmpty()
            || fechaLlegadaParametro == null
            || fechaLlegadaParametro.trim().isEmpty()
            || horaLlegadaParametro == null
            || horaLlegadaParametro.trim().isEmpty()) {

        mensaje = "Todos los campos obligatorios deben ser completados.";

    } else {

        origen = origen.trim();
        destino = destino.trim();

        try {

            int numeroPasajeros =
                    Integer.parseInt(numeroPasajerosParametro.trim());

            if (numeroPasajeros <= 0) {

                mensaje =
                        "El número de pasajeros debe ser mayor que cero.";

            } else if (origen.equalsIgnoreCase(destino)) {

                mensaje =
                        "El origen y destino no pueden ser iguales.";

            } else {

                Date fechaSalida =
                        Date.valueOf(fechaSalidaParametro);

                Time horaSalida =
                        Time.valueOf(horaSalidaParametro + ":00");

                Date fechaLlegada =
                        Date.valueOf(fechaLlegadaParametro);

                Time horaLlegada =
                        Time.valueOf(horaLlegadaParametro + ":00");

                Date fechaRetorno = null;

                if (fechaRetornoParametro != null
                        && !fechaRetornoParametro.trim().isEmpty()) {

                    fechaRetorno =
                            Date.valueOf(fechaRetornoParametro);
                }

                if (fechaLlegada.before(fechaSalida)
                        || (fechaLlegada.equals(fechaSalida)
                        && horaLlegada.before(horaSalida))) {

                    mensaje =
                            "La fecha y hora de llegada estimada "
                            + "no pueden ser anteriores a la salida.";

                } else if (fechaRetorno != null
                        && fechaRetorno.before(fechaSalida)) {

                    mensaje =
                            "La fecha de retorno no puede ser "
                            + "anterior a la fecha de salida.";

                } else {

                    RutaPrivadaDAO rutaDAO =
                            new RutaPrivadaDAO();

                    rutaPrivada =
                            rutaDAO.buscarPorOrigenDestino(
                                    origen,
                                    destino
                            );

                    if (rutaPrivada == null) {

                        mensaje =
                                "No existe una ruta privada registrada "
                                + "para el origen y destino seleccionados.";

                    } else if (!rutaPrivada.isEstado()) {

                        mensaje =
                                "La ruta privada seleccionada "
                                + "se encuentra inactiva.";

                    } else {

                        /*
                         * Obtener la configuración vigente.
                         */
                        ConfiguracionDAO configuracionDAO =
                                new ConfiguracionDAO();

                        Configuracion configuracion =
                                configuracionDAO.obtenerConfiguracionVigente();

                        if (configuracion == null) {

                            mensaje =
                                    "No existe una configuración vigente "
                                    + "para calcular el precio del alquiler.";

                        } else if (configuracion.getPrecioKmAlquilerPrivado() <= 0) {

                            mensaje =
                                    "El precio por kilómetro para alquiler privado "
                                    + "no está configurado correctamente.";

                        } else {

                            /*
                             * Calcular el precio estimado.
                             *
                             * Precio = distancia de la ruta
                             *          × precio configurado por kilómetro
                             */
                            double distanciaKm =
                                    rutaPrivada.getDistanciaKm();

                            double precioKm =
                                    configuracion.getPrecioKmAlquilerPrivado();

                            double precioEstimado =
                                    distanciaKm * precioKm;

                            /*
                             * Crear viaje privado.
                             */
                            codigoViajeGenerado =
                                    "VPR-" + System.currentTimeMillis();

                            Viaje viaje = new Viaje();

                            viaje.setCodigoViaje(
                                    codigoViajeGenerado
                            );

                            viaje.setTipoViaje("PRIVADO");

                            /*
                             * El bus y chofer se asignarán
                             * posteriormente por ADMIN_SUCURSAL.
                             */
                            viaje.setPlacaBus(null);
                            viaje.setNumeroLicencia(null);
                            viaje.setCodigoRuta(null);

                            viaje.setOrigen(origen);
                            viaje.setDestino(destino);

                            viaje.setFechaSalida(fechaSalida);
                            viaje.setHoraSalida(horaSalida);

                            viaje.setFechaLlegadaEstimada(
                                    fechaLlegada
                            );

                            viaje.setHoraLlegadaEstimada(
                                    horaLlegada
                            );

                            viaje.setEstado("PROGRAMADO");

                            /*
                             * La depreciación es un costo interno
                             * y se calculará al finalizar el viaje.
                             */
                            viaje.setDepreciacionPorKm(0);
                            viaje.setDepreciacionTotal(0);

                            ViajeDAO viajeDAO =
                                    new ViajeDAO();

                            boolean viajeInsertado =
                                    viajeDAO.insertar(viaje);

                            if (!viajeInsertado) {

                                mensaje =
                                        "No se pudo registrar el viaje "
                                        + "privado.";

                            } else {

                                /*
                                 * Crear solicitud de alquiler.
                                 */
                                codigoAlquilerGenerado =
                                        "ALQ-" + System.currentTimeMillis();

                                Alquiler alquiler =
                                        new Alquiler();

                                alquiler.setCodigoAlquiler(
                                        codigoAlquilerGenerado
                                );

                                alquiler.setCodigoViaje(
                                        codigoViajeGenerado
                                );

                                alquiler.setUsuarioCliente(
                                        usuario.getUsuario()
                                );

                                alquiler.setNumeroPasajeros(
                                        numeroPasajeros
                                );

                                alquiler.setFechaRetorno(
                                        fechaRetorno
                                );

                                /*
                                 * Precio calculado:
                                 * distancia × precio por km.
                                 */
                                alquiler.setPrecioEstimado(
                                        precioEstimado
                                );

                                /*
                                 * Todavía no se ha confirmado
                                 * ni pagado el alquiler.
                                 */
                                alquiler.setPrecioConfirmado(0);

                                alquiler.setEstado(
                                        "SOLICITADO"
                                );

                                AlquilerDAO alquilerDAO =
                                        new AlquilerDAO();

                                boolean alquilerInsertado =
                                        alquilerDAO.insertar(alquiler);

                                if (alquilerInsertado) {

                                    correcto = true;

                                    mensaje =
                                            "La solicitud de alquiler "
                                            + "fue registrada correctamente.";

                                } else {

                                    /*
                                     * Si no se pudo crear el alquiler,
                                     * eliminamos el viaje creado.
                                     */
                                    viajeDAO.eliminar(
                                            codigoViajeGenerado
                                    );

                                    mensaje =
                                            "No se pudo registrar la solicitud "
                                            + "de alquiler.";
                                }
                            }
                        }
                    }
                }
            }

        } catch (NumberFormatException e) {

            mensaje =
                    "El número de pasajeros no es válido.";

        } catch (IllegalArgumentException e) {

            mensaje =
                    "Una de las fechas u horas ingresadas "
                    + "no tiene un formato válido.";
        }
    }
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Resultado de solicitud</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Solicitud de alquiler</h1>

            </header>

            <div class="card-menu">

                <% if (correcto) { %>

                <h2>Solicitud registrada correctamente</h2>

                <p>
                    <%= mensaje %>
                </p>

                <p>
                    <strong>Código de solicitud:</strong>
                    <%= codigoAlquilerGenerado %>
                </p>

                <p>
                    <strong>Código de viaje:</strong>
                    <%= codigoViajeGenerado %>
                </p>

                <p>
                    <strong>Origen:</strong>
                    <%= origen %>
                </p>

                <p>
                    <strong>Destino:</strong>
                    <%= destino %>
                </p>

                <% if (rutaPrivada != null) { %>

                <p>
                    <strong>Distancia:</strong>
                    <%= rutaPrivada.getDistanciaKm() %> km
                </p>

                <% } %>

                <p>
                    <strong>Estado:</strong>
                    SOLICITADO
                </p>

                <p>
                    La sucursal deberá revisar la solicitud
                    y posteriormente asignar el bus y el chofer.
                </p>

                <div class="card-acciones">

                    <a href="alquiler.jsp">
                        Solicitar otro alquiler
                    </a>

                    <a href="../inicio.jsp">
                        Regresar al inicio
                    </a>

                </div>

                <% } else { %>

                <h2>No se pudo registrar la solicitud</h2>

                <p>
                    <%= mensaje %>
                </p>

                <div class="card-acciones">

                    <a href="alquiler.jsp">
                        Regresar al formulario
                    </a>

                    <a href="../inicio.jsp">
                        Regresar al inicio
                    </a>

                </div>

                <% } %>

            </div>

        </main>

    </body>

</html>