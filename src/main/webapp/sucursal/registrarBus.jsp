<%-- 
    Document   : registrarBus
    Created on : 6 sept 2026, 23:59:08
    Author     : fernan
--%>

<%@page import="transporte.dao.BusDAO"%>
<%@page import="transporte.modelo.Bus"%>
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

    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String placa = request.getParameter("placa");
        String foto = request.getParameter("foto");
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String anioTexto = request.getParameter("anioFabricacion");
        String capacidadTexto = request.getParameter("capacidad");
        String kilometrajeTexto =
                request.getParameter("kilometrajeActual");

        if (placa == null || placa.trim().isEmpty()) {

            mensaje = "Debe ingresar la placa.";
            tipoMensaje = "error";

        } else if (marca == null || marca.trim().isEmpty()) {

            mensaje = "Debe ingresar la marca.";
            tipoMensaje = "error";

        } else if (modelo == null || modelo.trim().isEmpty()) {

            mensaje = "Debe ingresar el modelo.";
            tipoMensaje = "error";

        } else if (anioTexto == null || anioTexto.trim().isEmpty()) {

            mensaje = "Debe ingresar el año de fabricación.";
            tipoMensaje = "error";

        } else if (capacidadTexto == null || capacidadTexto.trim().isEmpty()) {

            mensaje = "Debe ingresar la capacidad.";
            tipoMensaje = "error";

        } else if (kilometrajeTexto == null ||
                   kilometrajeTexto.trim().isEmpty()) {

            mensaje = "Debe ingresar el kilometraje actual.";
            tipoMensaje = "error";

        } else {

            try {

                int anioFabricacion =
                        Integer.parseInt(anioTexto.trim());

                int capacidad =
                        Integer.parseInt(capacidadTexto.trim());

                double kilometrajeActual =
                        Double.parseDouble(kilometrajeTexto.trim());

                if (capacidad <= 0) {

                    mensaje =
                            "La capacidad debe ser mayor que cero.";
                    tipoMensaje = "error";

                } else if (kilometrajeActual < 0) {

                    mensaje =
                            "El kilometraje no puede ser negativo.";
                    tipoMensaje = "error";

                } else {

                    BusDAO busDAO = new BusDAO();

                    placa = placa.trim();

                    if (busDAO.existe(placa)) {

                        mensaje =
                                "Ya existe un bus registrado con esa placa.";
                        tipoMensaje = "error";

                    } else {

                        Bus bus = new Bus();

                        bus.setPlaca(placa);

                        /*
                         * La sucursal se obtiene directamente
                         * del usuario que inició sesión.
                         */
                        bus.setCodigoSucursal(codigoSucursal);

                        bus.setFoto(
                                foto != null && !foto.trim().isEmpty()
                                ? foto.trim()
                                : null
                        );

                        bus.setMarca(marca.trim());

                        bus.setModelo(modelo.trim());

                        bus.setAñoFabricacion(anioFabricacion);

                        bus.setCapacidad(capacidad);

                        /*
                         * Todo bus nuevo comienza disponible.
                         */
                        bus.setEstadoOperativo("DISPONIBLE");

                        bus.setKilometrajeActual(
                                kilometrajeActual
                        );

                        boolean registrado =
                                busDAO.insertar(bus);

                        if (registrado) {

                            response.sendRedirect("buses.jsp");
                            return;

                        } else {

                            mensaje =
                                    "No se pudo registrar el bus.";
                            tipoMensaje = "error";
                        }
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                        "Los valores numéricos ingresados no son válidos.";
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

    <title>Registrar Bus</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <header class="encabezado">

            <h1>Registrar Bus</h1>

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

            <h2>Datos del bus</h2>

            <form method="POST">

                <div class="form-group">

                    <label for="placa">
                        Placa
                    </label>

                    <input
                        type="text"
                        id="placa"
                        name="placa"
                        maxlength="20"
                        value="<%= request.getParameter("placa") != null
                                ? request.getParameter("placa")
                                : "" %>"
                        required>

                </div>

                <div class="form-group">

                    <label for="foto">
                        Foto
                    </label>

                    <input
                        type="text"
                        id="foto"
                        name="foto"
                        maxlength="500"
                        value="<%= request.getParameter("foto") != null
                                ? request.getParameter("foto")
                                : "" %>">

                    <small>
                        Por ahora puede ingresar la ruta o referencia
                        de la fotografía.
                    </small>

                </div>

                <div class="form-group">

                    <label for="marca">
                        Marca
                    </label>

                    <input
                        type="text"
                        id="marca"
                        name="marca"
                        maxlength="100"
                        value="<%= request.getParameter("marca") != null
                                ? request.getParameter("marca")
                                : "" %>"
                        required>

                </div>

                <div class="form-group">

                    <label for="modelo">
                        Modelo
                    </label>

                    <input
                        type="text"
                        id="modelo"
                        name="modelo"
                        maxlength="100"
                        value="<%= request.getParameter("modelo") != null
                                ? request.getParameter("modelo")
                                : "" %>"
                        required>

                </div>

                <div class="form-group">

                    <label for="anioFabricacion">
                        Año de fabricación
                    </label>

                    <input
                        type="number"
                        id="anioFabricacion"
                        name="anioFabricacion"
                        min="1900"
                        max="2100"
                        value="<%= request.getParameter("anioFabricacion") != null
                                ? request.getParameter("anioFabricacion")
                                : "" %>"
                        required>

                </div>

                <div class="form-group">

                    <label for="capacidad">
                        Capacidad de pasajeros
                    </label>

                    <input
                        type="number"
                        id="capacidad"
                        name="capacidad"
                        min="1"
                        value="<%= request.getParameter("capacidad") != null
                                ? request.getParameter("capacidad")
                                : "" %>"
                        required>

                </div>

                <div class="form-group">

                    <label>
                        Estado operativo
                    </label>

                    <input
                        type="text"
                        value="Disponible"
                        readonly>

                    <small>
                        Todo bus nuevo se registra como disponible.
                    </small>

                </div>

                <div class="form-group">

                    <label for="kilometrajeActual">
                        Kilometraje actual
                    </label>

                    <input
                        type="number"
                        id="kilometrajeActual"
                        name="kilometrajeActual"
                        min="0"
                        step="0.01"
                        value="<%= request.getParameter("kilometrajeActual") != null
                                ? request.getParameter("kilometrajeActual")
                                : "0" %>"
                        required>

                </div>

                <button type="submit">
                    Registrar bus
                </button>

            </form>

        </div>

        <br>

        <a href="buses.jsp">
            Regresar a buses
        </a>

    </main>

</body>

</html>