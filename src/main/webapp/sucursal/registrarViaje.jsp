<%-- 
    Document   : registrarViaje
    Created on : 7 sept 2026, 2:05:47
    Author     : fernan
--%>

<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
<%@page import="java.util.List"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page import="transporte.modelo.Ruta"%>
<%@page import="transporte.modelo.Usuario"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null) {

        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {

        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    ViajeDAO viajeDAO = new ViajeDAO();

    List<Bus> buses =
            viajeDAO.listarBusesDisponiblesPorSucursal(
                    codigoSucursal
            );

    List<Chofer> choferes =
            viajeDAO.listarChoferesActivosPorSucursal(
                    codigoSucursal
            );

    List<Ruta> rutas =
            viajeDAO.listarRutasActivasPorSucursal(
                    codigoSucursal
            );


    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String codigoViaje =
                request.getParameter("codigoViaje");

        String tipoViaje =
                request.getParameter("tipoViaje");

        String placaBus =
                request.getParameter("placaBus");

        String numeroLicencia =
                request.getParameter("numeroLicencia");

        String codigoRuta =
                request.getParameter("codigoRuta");

        String origen =
                request.getParameter("origen");

        String destino =
                request.getParameter("destino");

        String fechaSalidaTexto =
                request.getParameter("fechaSalida");

        String horaSalidaTexto =
                request.getParameter("horaSalida");

        String fechaLlegadaTexto =
                request.getParameter(
                        "fechaLlegadaEstimada"
                );

        String horaLlegadaTexto =
                request.getParameter(
                        "horaLlegadaEstimada"
                );
        if (codigoViaje == null ||
            codigoViaje.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar el código del viaje.";

            tipoMensaje = "error";

        } else if (tipoViaje == null ||
                   tipoViaje.trim().isEmpty()) {

            mensaje =
                    "Debe seleccionar el tipo de viaje.";

            tipoMensaje = "error";

        } else if (placaBus == null ||
                   placaBus.trim().isEmpty()) {

            mensaje =
                    "Debe seleccionar un bus.";

            tipoMensaje = "error";

        } else if (numeroLicencia == null ||
                   numeroLicencia.trim().isEmpty()) {

            mensaje =
                    "Debe seleccionar un chofer.";

            tipoMensaje = "error";

        } else if (fechaSalidaTexto == null ||
                   fechaSalidaTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar la fecha de salida.";

            tipoMensaje = "error";

        } else if (horaSalidaTexto == null ||
                   horaSalidaTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar la hora de salida.";

            tipoMensaje = "error";

        } else if (fechaLlegadaTexto == null ||
                   fechaLlegadaTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar la fecha de llegada estimada.";

            tipoMensaje = "error";

        } else if (horaLlegadaTexto == null ||
                   horaLlegadaTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar la hora de llegada estimada.";

            tipoMensaje = "error";

        } else {

            try {

                codigoViaje =
                        codigoViaje.trim();

                tipoViaje =
                        tipoViaje.trim();

                placaBus =
                        placaBus.trim();

                numeroLicencia =
                        numeroLicencia.trim();

                fechaSalidaTexto =
                        fechaSalidaTexto.trim();

                horaSalidaTexto =
                        horaSalidaTexto.trim();

                fechaLlegadaTexto =
                        fechaLlegadaTexto.trim();

                horaLlegadaTexto =
                        horaLlegadaTexto.trim();
                if (!"REGULAR".equals(tipoViaje) &&
                    !"PRIVADO".equals(tipoViaje)) {

                    mensaje =
                            "El tipo de viaje no es válido.";

                    tipoMensaje = "error";

                } else {
                    final String placaBusSeleccionada =
                            placaBus;

                    Bus busSeleccionado =
                            viajeDAO
                                .listarBusesDisponiblesPorSucursal(
                                    codigoSucursal
                                )
                                .stream()
                                .filter(b ->
                                    b.getPlaca()
                                     .equals(placaBusSeleccionada)
                                )
                                .findFirst()
                                .orElse(null);


                    if (busSeleccionado == null) {

                        mensaje =
                                "El bus seleccionado no está disponible "
                                + "o no pertenece a su sucursal.";

                        tipoMensaje = "error";

                    } else {

                        final String licenciaSeleccionada =
                                numeroLicencia;

                        Chofer choferSeleccionado =
                                viajeDAO
                                    .listarChoferesActivosPorSucursal(
                                        codigoSucursal
                                    )
                                    .stream()
                                    .filter(c ->
                                        c.getNumeroLicencia()
                                         .equals(
                                            licenciaSeleccionada
                                         )
                                    )
                                    .findFirst()
                                    .orElse(null);


                        if (choferSeleccionado == null) {

                            mensaje =
                                    "El chofer seleccionado no está activo "
                                    + "o no pertenece a su sucursal.";

                            tipoMensaje = "error";

                        } else {
                            Ruta rutaSeleccionada = null;

                            if ("REGULAR".equals(tipoViaje)) {

                                if (codigoRuta == null ||
                                    codigoRuta.trim().isEmpty()) {

                                    mensaje =
                                            "Debe seleccionar una ruta.";

                                    tipoMensaje = "error";

                                } else {

                                    String rutaTexto =
                                            codigoRuta.trim();

                                    rutaSeleccionada =
                                            viajeDAO
                                                .listarRutasActivasPorSucursal(
                                                    codigoSucursal
                                                )
                                                .stream()
                                                .filter(r ->
                                                    r.getCodigoRuta()
                                                     .equals(rutaTexto)
                                                )
                                                .findFirst()
                                                .orElse(null);


                                    if (rutaSeleccionada == null) {

                                        mensaje =
                                                "La ruta seleccionada "
                                                + "no es válida para su sucursal.";

                                        tipoMensaje = "error";
                                    }
                                }
                            }

                            if (tipoMensaje.isEmpty() &&
                                "PRIVADO".equals(tipoViaje)) {

                                if (origen == null ||
                                    origen.trim().isEmpty()) {

                                    mensaje =
                                            "Debe ingresar el origen.";

                                    tipoMensaje = "error";

                                } else if (destino == null ||
                                           destino.trim().isEmpty()) {

                                    mensaje =
                                            "Debe ingresar el destino.";

                                    tipoMensaje = "error";

                                } else {

                                    origen =
                                            origen.trim();

                                    destino =
                                            destino.trim();
                                }
                            }
                            if (tipoMensaje.isEmpty()) {
                                Date fechaSalida =
                                        Date.valueOf(
                                            fechaSalidaTexto
                                        );

                                Time horaSalida =
                                        Time.valueOf(
                                            horaSalidaTexto + ":00"
                                        );

                                Date fechaLlegada =
                                        Date.valueOf(
                                            fechaLlegadaTexto
                                        );

                                Time horaLlegada =
                                        Time.valueOf(
                                            horaLlegadaTexto + ":00"
                                        );


                                boolean llegadaValida =
                                        fechaLlegada.after(fechaSalida)
                                        ||
                                        (
                                            fechaLlegada.equals(fechaSalida)
                                            &&
                                            horaLlegada.after(horaSalida)
                                        );


                                if (!llegadaValida) {

                                    mensaje =
                                            "La fecha y hora de llegada "
                                            + "estimada debe ser posterior "
                                            + "a la fecha y hora de salida.";

                                    tipoMensaje = "error";

                                } else {

                                   boolean busOcupado =
                                            viajeDAO.busTieneViajeActivo(
                                                placaBus,
                                                fechaSalida,
                                                horaSalida,
                                                fechaLlegada,
                                                horaLlegada,
                                                null
                                            );


                                    if (busOcupado) {

                                        mensaje =
                                                "El bus seleccionado ya tiene "
                                                + "otro viaje programado o en "
                                                + "curso dentro de ese horario.";

                                        tipoMensaje = "error";

                                    } else {

                                        boolean choferOcupado =
                                                viajeDAO.choferTieneViajeActivo(
                                                    numeroLicencia,
                                                    fechaSalida,
                                                    horaSalida,
                                                    fechaLlegada,
                                                    horaLlegada,
                                                    null
                                                );


                                        if (choferOcupado) {

                                            mensaje =
                                                    "El chofer seleccionado ya "
                                                    + "tiene otro viaje programado "
                                                    + "o en curso dentro de ese horario.";

                                            tipoMensaje = "error";

                                        } else {

                                            if ("REGULAR".equals(tipoViaje)) {

                                                origen =
                                                    rutaSeleccionada
                                                        .getCodigoSucursalOrigen();

                                                destino =
                                                    rutaSeleccionada
                                                        .getCodigoSucursalDestino();
                                            }

                                            Viaje viaje =
                                                    new Viaje();


                                            viaje.setCodigoViaje(
                                                    codigoViaje
                                            );

                                            viaje.setTipoViaje(
                                                    tipoViaje
                                            );

                                            viaje.setPlacaBus(
                                                    placaBus
                                            );

                                            viaje.setNumeroLicencia(
                                                    numeroLicencia
                                            );


                                            if ("REGULAR".equals(tipoViaje)) {

                                                viaje.setCodigoRuta(
                                                    codigoRuta.trim()
                                                );

                                            } else {

                                                viaje.setCodigoRuta(null);
                                            }


                                            viaje.setOrigen(
                                                    origen
                                            );

                                            viaje.setDestino(
                                                    destino
                                            );

                                            viaje.setFechaSalida(
                                                    fechaSalida
                                            );

                                            viaje.setHoraSalida(
                                                    horaSalida
                                            );

                                            viaje.setFechaLlegadaEstimada(
                                                    fechaLlegada
                                            );

                                            viaje.setHoraLlegadaEstimada(
                                                    horaLlegada
                                            );

                                            viaje.setEstado(
                                                    "PROGRAMADO"
                                            );


                                            viaje.setDepreciacionPorKm(
                                                    0
                                            );

                                            viaje.setDepreciacionTotal(
                                                    0
                                            );
                                            boolean registrado =
                                                    viajeDAO.insertar(
                                                        viaje
                                                    );


                                            if (registrado) {

                                                response.sendRedirect(
                                                    "viajes.jsp"
                                                );

                                                return;

                                            } else {

                                                mensaje =
                                                        "No se pudo registrar "
                                                        + "el viaje.";

                                                tipoMensaje = "error";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

            } catch (IllegalArgumentException e) {

                mensaje =
                        "Uno de los valores ingresados "
                        + "no tiene un formato válido.";

                tipoMensaje = "error";

            } catch (Exception e) {

                mensaje =
                        "Ocurrió un error al registrar "
                        + "el viaje.";

                tipoMensaje = "error";

                System.out.println(
                    "Error en registrarViaje.jsp: "
                    + e.getMessage()
                );
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

        <title>Registrar Viaje</title>

        <link rel="stylesheet"
              href="<%= request.getContextPath() %>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Registrar Viaje</h1>

                <p>
                    Sucursal:
                    <strong><%= codigoSucursal %></strong>
                </p>

            </header>


            <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">

                <%= mensaje %>

            </div>

            <% } %>
            <div class="formulario">
                <h2>Datos del viaje</h2>
                    <form method="POST" id="formViaje">
                    <!-- Código -->
                    <div class="form-group">

                        <label for="codigoViaje">
                            Código del viaje
                        </label>

                        <input
                            type="text"
                            id="codigoViaje"
                            name="codigoViaje"
                            maxlength="20"
                            required>
                            <p id="mensajeCodigoViaje" class="campo-error"></p>
                    </div>
                    <!-- Tipo -->
                    <div class="form-group">
                        <label for="tipoViaje">
                            Tipo de viaje
                        </label>
                        <select
                            id="tipoViaje"
                            name="tipoViaje"
                            required>
                            <p id="mensajeTipoViaje" class="campo-error"></p>
                            <option value="">
                                Seleccione
                            </option>

                            <option value="REGULAR">
                                Regular
                            </option>

                            <option value="PRIVADO">
                                Privado
                            </option>

                        </select>

                    </div>


                    <!-- Bus -->

                    <div class="form-group">

                        <label for="placaBus">
                            Bus
                        </label>

                        <select
                            id="placaBus"
                            name="placaBus"
                            required>
                            <p id="mensajeBus" class="campo-error"></p>
                            <option value="">
                                Seleccione un bus
                            </option>

                            <% for (Bus bus : buses) { %>

                            <option
                                value="<%= bus.getPlaca() %>">

                                <%= bus.getPlaca() %>
                                -
                                <%= bus.getMarca() %>
                                <%= bus.getModelo() %>
                                -
                                <%= bus.getCapacidad() %>
                                pasajeros

                            </option>

                            <% } %>

                        </select>


                        <% if (buses.isEmpty()) { %>

                        <small>
                            No hay buses disponibles
                            en esta sucursal.
                        </small>

                        <% } %>

                    </div>


                    <!-- Chofer -->

                    <div class="form-group">

                        <label for="numeroLicencia">
                            Chofer
                        </label>

                        <select
                            id="numeroLicencia"
                            name="numeroLicencia"
                            required>
                            <p id="mensajeChofer" class="campo-error"></p>
                            <option value="">
                                Seleccione un chofer
                            </option>

                            <% for (Chofer chofer : choferes) { %>

                            <option
                                value="<%= chofer.getNumeroLicencia() %>">

                                <%= chofer.getNombreCompleto() %>
                                -
                                Licencia:
                                <%= chofer.getNumeroLicencia() %>

                            </option>

                            <% } %>

                        </select>


                        <% if (choferes.isEmpty()) { %>

                        <small>
                            No hay choferes activos
                            en esta sucursal.
                        </small>

                        <% } %>

                    </div>


                    <!-- Ruta -->

                    <div class="form-group"
                         id="grupoRuta">

                        <label for="codigoRuta">
                            Ruta
                        </label>

                        <select
                            id="codigoRuta"
                            name="codigoRuta">

                            <option value="">
                                Seleccione una ruta
                            </option>

                            <% for (Ruta ruta : rutas) { %>

                            <option
                                value="<%= ruta.getCodigoRuta() %>">

                                <%= ruta.getCodigoRuta() %>
                                -
                                <%= ruta.getCodigoSucursalOrigen() %>
                                ->
                                <%= ruta.getCodigoSucursalDestino() %>
                                -
                                <%= ruta.getDistanciaKm() %>
                                km

                            </option>

                            <% } %>

                        </select>


                        <% if (rutas.isEmpty()) { %>

                        <small>
                            No hay rutas activas
                            desde esta sucursal.
                        </small>

                        <% } %>
                        <p id="mensajeRuta" class="campo-error"></p>

                    </div>


                    <!-- Datos privados -->

                    <div id="grupoPrivado">

                        <div class="form-group">

                            <label for="origen">
                                Origen
                            </label>

                            <input
                                type="text"
                                id="origen"
                                name="origen"
                                maxlength="250">
                            <p id="mensajeOrigen" class="campo-error"></p>

                        </div>


                        <div class="form-group">

                            <label for="destino">
                                Destino
                            </label>

                            <input
                                type="text"
                                id="destino"
                                name="destino"
                                maxlength="250">
                            <p id="mensajeDestino" class="campo-error"></p>

                        </div>

                    </div>


                    <!-- Fecha salida -->

                    <div class="form-group">

                        <label for="fechaSalida">
                            Fecha de salida
                        </label>

                        <input
                            type="date"
                            id="fechaSalida"
                            name="fechaSalida"
                            required>
                        <p id="mensajeFechaSalida" class="campo-error"></p>

                    </div>


                    <!-- Hora salida -->

                    <div class="form-group">

                        <label for="horaSalida">
                            Hora de salida
                        </label>

                        <input
                            type="time"
                            id="horaSalida"
                            name="horaSalida"
                            required>
                            <p id="mensajeHoraSalida" class="campo-error"></p>
                    </div>


                    <!-- Fecha llegada estimada -->

                    <div class="form-group">

                        <label for="fechaLlegadaEstimada">
                            Fecha de llegada estimada
                        </label>

                        <input
                            type="date"
                            id="fechaLlegadaEstimada"
                            name="fechaLlegadaEstimada"
                            required>
                        <p id="mensajeFechaLlegada" class="campo-error"></p>

                    </div>


                    <!-- Hora llegada estimada -->

                    <div class="form-group">

                        <label for="horaLlegadaEstimada">
                            Hora de llegada estimada
                        </label>

                        <input
                            type="time"
                            id="horaLlegadaEstimada"
                            name="horaLlegadaEstimada"
                            required>
                            <p id="mensajeHoraLlegada" class="campo-error"></p>
                    </div>


                    <!-- Estado -->

                    <div class="form-group">

                        <label>
                            Estado inicial
                        </label>

                        <input
                            type="text"
                            value="Programado"
                            readonly>

                        <small>
                            Todo viaje nuevo se registra
                            como programado.
                        </small>

                    </div>


                    <button type="submit">
                        Registrar viaje
                    </button>

                </form>

            </div>             
            <div class="botones-inferiores">
                <a
                    href="../sucursal/viajes.jsp"
                    class="boton boton-volver">
                    Regresar
                </a>

            </div>
        </main>
       <script src="../resources/js/registrarViaje.js"></script>
    </body>

</html>
