<%-- 
    Document   : modificarViaje
    Created on : 8 sept 2026, 23:48:37
    Author     : fernan
--%>
<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page import="transporte.modelo.Ruta"%>
<%@page import="transporte.dao.ViajeDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    String rolSesion =
            (String) session.getAttribute("rol");

    if (usuarioSesion == null
            || rolSesion == null
            || !"ADMIN_SUCURSAL".equals(rolSesion)) {

        response.sendRedirect("../login.jsp");
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

    ViajeDAO viajeDAO = new ViajeDAO();

    Viaje viaje =
            viajeDAO.obtenerPorSucursal(
                    codigoViaje.trim(),
                    codigoSucursal
            );

    if (viaje == null) {

        response.sendRedirect("viajes.jsp");
        return;
    }
    
    if (!"PROGRAMADO".equals(viaje.getEstado())) {

        response.sendRedirect("viajes.jsp");
        return;
    }

    String mensaje = "";
    String tipoMensaje = "";
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

    if ("POST".equalsIgnoreCase(request.getMethod())) {

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

        String fechaSalida =
                request.getParameter("fechaSalida");

        String horaSalida =
                request.getParameter("horaSalida");

        String fechaLlegada =
                request.getParameter("fechaLlegada");

        String horaLlegada =
                request.getParameter("horaLlegada");

        boolean datosValidos = true;
        if (placaBus == null
                || placaBus.trim().isEmpty()) {

            mensaje = "Debe seleccionar un bus.";
            tipoMensaje = "error";
            datosValidos = false;

        } else if (numeroLicencia == null
                || numeroLicencia.trim().isEmpty()) {

            mensaje = "Debe seleccionar un chofer.";
            tipoMensaje = "error";
            datosValidos = false;

        } else if (fechaSalida == null
                || fechaSalida.trim().isEmpty()
                || horaSalida == null
                || horaSalida.trim().isEmpty()) {

            mensaje = "Debe indicar la fecha y hora de salida.";
            tipoMensaje = "error";
            datosValidos = false;

        } else if (fechaLlegada == null
                || fechaLlegada.trim().isEmpty()
                || horaLlegada == null
                || horaLlegada.trim().isEmpty()) {

            mensaje = "Debe indicar la fecha y hora de llegada.";
            tipoMensaje = "error";
            datosValidos = false;
        }
        Bus busSeleccionado = null;

        if (datosValidos) {

            for (Bus bus : buses) {

                if (bus.getPlaca().equals(placaBus)) {

                    busSeleccionado = bus;
                    break;
                }
            }

            if (busSeleccionado == null) {

                mensaje =
                    "El bus seleccionado no pertenece "
                    + "a esta sucursal o no está disponible.";

                tipoMensaje = "error";
                datosValidos = false;
            }
        }

        Chofer choferSeleccionado = null;

        if (datosValidos) {

            for (Chofer chofer : choferes) {

                if (chofer.getNumeroLicencia()
                        .equals(numeroLicencia)) {

                    choferSeleccionado = chofer;
                    break;
                }
            }

            if (choferSeleccionado == null) {

                mensaje =
                    "El chofer seleccionado no pertenece "
                    + "a esta sucursal o no está activo.";

                tipoMensaje = "error";
                datosValidos = false;
            }
        }

        Ruta rutaSeleccionada = null;

        if (datosValidos
                && "REGULAR".equals(viaje.getTipoViaje())) {

            if (codigoRuta == null
                    || codigoRuta.trim().isEmpty()) {

                mensaje = "Debe seleccionar una ruta.";
                tipoMensaje = "error";
                datosValidos = false;

            } else {

                for (Ruta ruta : rutas) {

                    if (ruta.getCodigoRuta()
                            .equals(codigoRuta)) {

                        rutaSeleccionada = ruta;
                        break;
                    }
                }

                if (rutaSeleccionada == null) {

                    mensaje =
                        "La ruta seleccionada no pertenece "
                        + "a esta sucursal o no está activa.";

                    tipoMensaje = "error";
                    datosValidos = false;
                }
            }
        }
        if (datosValidos
                && "PRIVADO".equals(viaje.getTipoViaje())) {

            if (origen == null
                    || origen.trim().isEmpty()
                    || destino == null
                    || destino.trim().isEmpty()) {

                mensaje =
                    "Debe ingresar el origen y destino.";

                tipoMensaje = "error";
                datosValidos = false;
            }
        }
        java.sql.Date fechaSalidaSQL = null;
        java.sql.Time horaSalidaSQL = null;
        java.sql.Date fechaLlegadaSQL = null;
        java.sql.Time horaLlegadaSQL = null;

        if (datosValidos) {

            try {

                fechaSalidaSQL =
                        java.sql.Date.valueOf(
                                fechaSalida
                        );

                horaSalidaSQL =
                        java.sql.Time.valueOf(
                                horaSalida
                        );

                fechaLlegadaSQL =
                        java.sql.Date.valueOf(
                                fechaLlegada
                        );

                horaLlegadaSQL =
                        java.sql.Time.valueOf(
                                horaLlegada
                        );

            } catch (IllegalArgumentException e) {

                mensaje =
                    "La fecha u hora ingresada no es válida.";

                tipoMensaje = "error";
                datosValidos = false;
            }
        }
        if (datosValidos) {

            java.util.Date salida =
                    new java.util.Date(
                        fechaSalidaSQL.getTime()
                        + horaSalidaSQL.getTime()
                    );

            java.util.Date llegada =
                    new java.util.Date(
                        fechaLlegadaSQL.getTime()
                        + horaLlegadaSQL.getTime()
                    );

            if (!llegada.after(salida)) {

                mensaje =
                    "La fecha y hora de llegada debe ser "
                    + "posterior a la salida.";

                tipoMensaje = "error";
                datosValidos = false;
            }
        }
        double depreciacionPorKm = 0;
        double depreciacionTotal = 0;
        
        // Verificar que el bus no tenga otro viaje
if (datosValidos) {

    boolean busOcupado =
            viajeDAO.busTieneViajeActivo(
                    placaBus,
                    fechaSalidaSQL,
                    horaSalidaSQL,
                    fechaLlegadaSQL,
                    horaLlegadaSQL,
                    codigoViaje
            );

    if (busOcupado) {

        mensaje =
            "El bus seleccionado ya tiene otro viaje "
            + "programado o en curso dentro de ese horario.";

        tipoMensaje = "error";
        datosValidos = false;
    }
}

// Verificar que el chofer no tenga otro viaje
if (datosValidos) {

    boolean choferOcupado =
            viajeDAO.choferTieneViajeActivo(
                    numeroLicencia,
                    fechaSalidaSQL,
                    horaSalidaSQL,
                    fechaLlegadaSQL,
                    horaLlegadaSQL,
                    codigoViaje
            );

    if (choferOcupado) {

        mensaje =
            "El chofer seleccionado ya tiene otro viaje "
            + "programado o en curso dentro de ese horario.";

        tipoMensaje = "error";
        datosValidos = false;
    }
}

        if (datosValidos) {

            if ("REGULAR".equals(viaje.getTipoViaje())) {

                origen =
                    rutaSeleccionada
                        .getCodigoSucursalOrigen();

                destino =
                    rutaSeleccionada
                        .getCodigoSucursalDestino();

                depreciacionPorKm =
                        viaje.getDepreciacionPorKm();

                depreciacionTotal =
                        rutaSeleccionada.getDistanciaKm()
                        * depreciacionPorKm;

            } else {

                codigoRuta = null;

                depreciacionPorKm =
                        viaje.getDepreciacionPorKm();

                depreciacionTotal = 0;
            }

            Viaje viajeActualizado = new Viaje();

            viajeActualizado.setCodigoViaje(
                    viaje.getCodigoViaje()
            );

            viajeActualizado.setTipoViaje(
                    viaje.getTipoViaje()
            );

            viajeActualizado.setPlacaBus(
                    placaBus
            );

            viajeActualizado.setNumeroLicencia(
                    numeroLicencia
            );

            viajeActualizado.setCodigoRuta(
                    codigoRuta
            );

            viajeActualizado.setOrigen(
                    origen.trim()
            );

            viajeActualizado.setDestino(
                    destino.trim()
            );

            viajeActualizado.setFechaSalida(
                    fechaSalidaSQL
            );

            viajeActualizado.setHoraSalida(
                    horaSalidaSQL
            );

            viajeActualizado.setFechaLlegadaEstimada(
                    fechaLlegadaSQL
            );

            viajeActualizado.setHoraLlegadaEstimada(
                    horaLlegadaSQL
            );

            viajeActualizado.setEstado(
                    viaje.getEstado()
            );

            viajeActualizado.setDepreciacionPorKm(
                    depreciacionPorKm
            );

            viajeActualizado.setDepreciacionTotal(
                    depreciacionTotal
            );
           boolean actualizado =
            viajeDAO.actualizarPorSucursal(
                    viajeActualizado,
                    codigoSucursal
            );

            if (actualizado) {

                response.sendRedirect("viajes.jsp");

            } else {

                mensaje =
                    "No se pudo actualizar el viaje.";

                tipoMensaje = "error";
            }
        }
    }

    String valorOrigen = viaje.getOrigen();
    String valorDestino = viaje.getDestino();

    if ("REGULAR".equals(viaje.getTipoViaje())) {

        for (Ruta ruta : rutas) {

            if (ruta.getCodigoRuta()
                    .equals(viaje.getCodigoRuta())) {

                valorOrigen =
                        ruta.getCodigoSucursalOrigen();

                valorDestino =
                        ruta.getCodigoSucursalDestino();

                break;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Modificar viaje</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 30px;
        }

        .contenedor {
            max-width: 800px;
            margin: auto;
        }

        .campo {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        button {
            padding: 10px 20px;
            cursor: pointer;
        }

        .error {
            padding: 10px;
            margin-bottom: 15px;
            background-color: #f8d7da;
            color: #842029;
        }

        .info {
            padding: 10px;
            margin-bottom: 15px;
            background-color: #cff4fc;
            color: #055160;
        }

    </style>

</head>

<body>

<div class="contenedor">

    <h1>Modificar viaje</h1>

    <p>
        <strong>Código del viaje:</strong>
        <%= viaje.getCodigoViaje() %>
    </p>

    <p>
        <strong>Tipo de viaje:</strong>
        <%= viaje.getTipoViaje() %>
    </p>

    <p>
        <strong>Estado actual:</strong>
        <%= viaje.getEstado() %>
    </p>

    <% if (!mensaje.isEmpty()) { %>

        <div class="<%= tipoMensaje %>">
            <%= mensaje %>
        </div>

    <% } %>

    <form method="POST">

        <!-- BUS -->

        <div class="campo">

            <label for="placaBus">
                Bus
            </label>

            <select
                id="placaBus"
                name="placaBus"
                required>

                <option value="">
                    Seleccione un bus
                </option>

                <%
                    for (Bus bus : buses) {
                %>

                    <option
                        value="<%= bus.getPlaca() %>"
                        <%= bus.getPlaca()
                                .equals(viaje.getPlacaBus())
                                ? "selected"
                                : "" %>>

                        <%= bus.getPlaca() %>
                        -
                        <%= bus.getMarca() %>
                        <%= bus.getModelo() %>

                    </option>

                <%
                    }
                %>

            </select>

        </div>
        <!-- CHOFER -->

        <div class="campo">

            <label for="numeroLicencia">
                Chofer
            </label>

            <select
                id="numeroLicencia"
                name="numeroLicencia"
                required>

                <option value="">
                    Seleccione un chofer
                </option>

                <%
                    for (Chofer chofer : choferes) {
                %>

                    <option
                        value="<%= chofer.getNumeroLicencia() %>"
                        <%= chofer.getNumeroLicencia()
                                .equals(viaje.getNumeroLicencia())
                                ? "selected"
                                : "" %>>

                        <%= chofer.getNombreCompleto() %>
                        -
                        Licencia:
                        <%= chofer.getNumeroLicencia() %>

                    </option>

                <%
                    }
                %>

            </select>

        </div>


        <% if ("REGULAR".equals(viaje.getTipoViaje())) { %>

            <!-- RUTA -->

            <div class="campo">

                <label for="codigoRuta">
                    Ruta
                </label>

                <select
                    id="codigoRuta"
                    name="codigoRuta"
                    required>

                    <option value="">
                        Seleccione una ruta
                    </option>

                    <%
                        for (Ruta ruta : rutas) {
                    %>

                        <option
                            value="<%= ruta.getCodigoRuta() %>"
                            data-origen="<%= ruta.getCodigoSucursalOrigen() %>"
                            data-destino="<%= ruta.getCodigoSucursalDestino() %>"
                            <%= ruta.getCodigoRuta()
                                    .equals(viaje.getCodigoRuta())
                                    ? "selected"
                                    : "" %>>

                            <%= ruta.getCodigoRuta() %>
                            -
                            <%= ruta.getCodigoSucursalOrigen() %>
                            →
                            <%= ruta.getCodigoSucursalDestino() %>

                        </option>

                    <%
                        }
                    %>

                </select>

            </div>

        <% } %>


        <!-- ORIGEN -->

        <div class="campo">

            <label for="origen">
                Origen
            </label>

            <input
                type="text"
                id="origen"
                name="origen"
                value="<%= valorOrigen %>"
                <%= "REGULAR".equals(viaje.getTipoViaje())
                        ? "readonly"
                        : "" %>
                required>

        </div>


        <!-- DESTINO -->

        <div class="campo">

            <label for="destino">
                Destino
            </label>

            <input
                type="text"
                id="destino"
                name="destino"
                value="<%= valorDestino %>"
                <%= "REGULAR".equals(viaje.getTipoViaje())
                        ? "readonly"
                        : "" %>
                required>

        </div>


        <!-- FECHA SALIDA -->

        <div class="campo">

            <label for="fechaSalida">
                Fecha de salida
            </label>

            <input
                type="date"
                id="fechaSalida"
                name="fechaSalida"
                value="<%= viaje.getFechaSalida() %>"
                required>

        </div>


        <!-- HORA SALIDA -->

        <div class="campo">

            <label for="horaSalida">
                Hora de salida
            </label>

            <input
                type="time"
                id="horaSalida"
                name="horaSalida"
                value="<%= viaje.getHoraSalida() %>"
                required>

        </div>


        <!-- FECHA LLEGADA -->

        <div class="campo">

            <label for="fechaLlegada">
                Fecha de llegada estimada
            </label>

            <input
                type="date"
                id="fechaLlegada"
                name="fechaLlegada"
                value="<%= viaje.getFechaLlegadaEstimada() %>"
                required>

        </div>


        <!-- HORA LLEGADA -->

        <div class="campo">

            <label for="horaLlegada">
                Hora de llegada estimada
            </label>

            <input
                type="time"
                id="horaLlegada"
                name="horaLlegada"
                value="<%= viaje.getHoraLlegadaEstimada() %>"
                required>

        </div>


        <br>

        <button type="submit">
            Guardar cambios
        </button>

        <a href="viajes.jsp">
            Cancelar
        </a>

    </form>

</div>


<% if ("REGULAR".equals(viaje.getTipoViaje())) { %>

<script>

    const rutaSelect =
        document.getElementById("codigoRuta");

    const origenInput =
        document.getElementById("origen");

    const destinoInput =
        document.getElementById("destino");


    rutaSelect.addEventListener("change", function () {

        const opcion =
            this.options[this.selectedIndex];

        if (opcion) {

            origenInput.value =
                opcion.dataset.origen || "";

            destinoInput.value =
                opcion.dataset.destino || "";
        }

    });

</script>

<% } %>

</body>

</html>
