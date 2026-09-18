<%-- 
    Document   : registrarRuta
    Created on : 8 sept 2026, 22:46:10
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Ruta"%>
<%@page import="transporte.modelo.Sucursal"%>
<%@page import="transporte.dao.RutaDAO"%>
<%@page import="transporte.dao.SucursalDAO"%>

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
    String codigoSucursal
            = usuarioSesion.getCodigoSucursal();

    String mensaje = "";
    String tipoMensaje = "";

    String codigoRuta = "";
    String codigoSucursalDestino = "";
    String distanciaTexto = "";
    String precioTexto = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        codigoRuta = request.getParameter("codigoRuta");
        codigoSucursalDestino
                = request.getParameter("codigoSucursalDestino");

        distanciaTexto
                = request.getParameter("distanciaKm");

        precioTexto
                = request.getParameter("precioBoleto");

        // Limpiar espacios
        if (codigoRuta != null) {
            codigoRuta = codigoRuta.trim();
        }

        if (codigoSucursalDestino != null) {
            codigoSucursalDestino
                    = codigoSucursalDestino.trim();
        }

        if (distanciaTexto != null) {
            distanciaTexto = distanciaTexto.trim();
        }

        if (precioTexto != null) {
            precioTexto = precioTexto.trim();
        }

        if (codigoRuta == null || codigoRuta.isEmpty()
                || codigoSucursalDestino == null
                || codigoSucursalDestino.isEmpty()
                || distanciaTexto == null
                || distanciaTexto.isEmpty()
                || precioTexto == null
                || precioTexto.isEmpty()) {

            mensaje
                    = "Todos los campos obligatorios deben ser completados.";

            tipoMensaje = "error";

        } else if (codigoSucursal.equals(codigoSucursalDestino)) {

            mensaje
                    = "La sucursal de destino debe ser diferente a la sucursal de origen.";

            tipoMensaje = "error";

        } else {

            try {

                double distanciaKm
                        = Double.parseDouble(distanciaTexto);

                double precioBoleto
                        = Double.parseDouble(precioTexto);

                if (distanciaKm <= 0) {

                    mensaje
                            = "La distancia debe ser mayor que cero.";

                    tipoMensaje = "error";

                } else if (precioBoleto < 0) {

                    mensaje
                            = "El precio del boleto no puede ser negativo.";

                    tipoMensaje = "error";

                } else {

                    RutaDAO rutaDAO = new RutaDAO();

                    Ruta rutaExistente
                            = rutaDAO.obtener(codigoRuta);

                    if (rutaExistente != null) {

                        mensaje
                                = "Ya existe una ruta con ese código.";

                        tipoMensaje = "error";

                    } else {

                        SucursalDAO sucursalDAO
                                = new SucursalDAO();

                        Sucursal sucursalDestino
                                = sucursalDAO.buscar(codigoSucursalDestino);

                        if (sucursalDestino == null) {

                            mensaje
                                    = "La sucursal de destino no existe.";

                            tipoMensaje = "error";

                        } else if (!sucursalDestino.isEstado()) {

                            mensaje
                                    = "La sucursal de destino está inactiva.";

                            tipoMensaje = "error";

                        } else {

                            Ruta ruta = new Ruta(
                                    codigoRuta,
                                    codigoSucursal,
                                    codigoSucursalDestino,
                                    distanciaKm,
                                    precioBoleto,
                                    true
                            );

                            boolean registrado
                                    = rutaDAO.insertar(ruta);

                            if (registrado) {

                                response.sendRedirect("ruta.jsp");
                                return;

                            } else {

                                mensaje
                                        = "No se pudo registrar la ruta.";

                                tipoMensaje = "error";
                            }
                        }
                    }
                }

            } catch (NumberFormatException e) {

                mensaje
                        = "La distancia y el precio deben ser números válidos.";

                tipoMensaje = "error";
            }
        }
    }

    SucursalDAO sucursalDAO = new SucursalDAO();

    List<Sucursal> sucursales
            = sucursalDAO.listar();
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Registrar Ruta</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">
    </head>

    <body>

        <div class="contenedor">

            <h1>Registrar Ruta</h1>

            <p class="subtitulo">
                Crear una nueva ruta de transporte
            </p>


            <div class="info">

                <strong>Origen:</strong>
                <%= codigoSucursal%>

                <br>

                La sucursal de origen se establece automáticamente
                según tu cuenta.

            </div>


            <% if (!mensaje.isEmpty()) {%>

            <div class="mensaje <%= tipoMensaje%>">

                <%= mensaje%>

            </div>

            <% }%>


            <form id="formularioRegistrarRuta"
                  method="POST"
                  action="registrarRuta.jsp">

                <div class="campo">

                    <label for="codigoRuta">
                        Código de ruta
                        <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="text"
                        id="codigoRuta"
                        name="codigoRuta"
                        maxlength="20"
                        value="<%= codigoRuta%>"
                        required>

                    <p id="mensajeCodigoRuta" class="campo-error"></p>

                </div>


                <div class="campo">

                    <label for="origen">
                        Sucursal de origen
                    </label>

                    <input
                        type="text"
                        id="origen"
                        value="<%= codigoSucursal%>"
                        readonly>

                </div>


                <div class="campo">

                    <label for="codigoSucursalDestino">
                        Sucursal de destino
                        <span class="obligatorio">*</span>
                    </label>

                    <select
                        id="codigoSucursalDestino"
                        name="codigoSucursalDestino"
                        required>

                        <option value="">
                            -- Seleccione la sucursal destino --
                        </option>

                        <%
                            boolean hayDestinos = false;

                            for (Sucursal sucursal : sucursales) {

                                if (sucursal.isEstado()
                                        && !codigoSucursal.equals(
                                                sucursal.getCodigoSucursal())) {

                                    hayDestinos = true;
                        %>

                        <option
                            value="<%= sucursal.getCodigoSucursal()%>"
                            <%= sucursal.getCodigoSucursal()
                                    .equals(codigoSucursalDestino)
                                    ? "selected"
                                    : ""%>>

                            <%= sucursal.getNombre()%>
                            -
                            <%= sucursal.getCodigoSucursal()%>

                        </option>

                        <%
                                }
                            }
                        %>

                    </select>

                    <p id="mensajeDestino" class="campo-error"></p>

                    <% if (!hayDestinos) { %>

                    <div class="sin-destinos">
                        No existen otras sucursales activas
                        disponibles como destino.
                    </div>

                    <% }%>

                </div>


                <div class="campo">

                    <label for="distanciaKm">
                        Distancia en kilómetros
                        <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="number"
                        id="distanciaKm"
                        name="distanciaKm"
                        min="0.01"
                        step="0.01"
                        value="<%= distanciaTexto%>"
                        required>

                    <p id="mensajeDistancia" class="campo-error"></p>

                </div>


                <div class="campo">

                    <label for="precioBoleto">
                        Precio del boleto
                        <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="number"
                        id="precioBoleto"
                        name="precioBoleto"
                        min="0"
                        step="0.01"
                        value="<%= precioTexto%>"
                        required>

                    <p id="mensajePrecio" class="campo-error"></p>

                </div>


                <div class="botones">
                    <button type="submit">
                        Registrar ruta
                    </button>
                </div>
                  <!-- VOLVER -->
                    <div class="botones-inferiores">

                <a
                    href="../sucursal/viajes.jsp"
                    class="boton boton-volver">

                       regresar
                </a>

           

            </form>

        </div>
        <script src="../resources/js/registrarRuta.js"></script>
    </body>

</html>