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
    // ==========================================
    // VERIFICAR SESIÓN
    // ==========================================

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

    // ==========================================
    // OBTENER SUCURSAL DEL ADMINISTRADOR
    // ==========================================

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    // ==========================================
    // VARIABLES
    // ==========================================

    String mensaje = "";
    String tipoMensaje = "";

    String codigoRuta = "";
    String codigoSucursalDestino = "";
    String distanciaTexto = "";
    String precioTexto = "";

    // ==========================================
    // PROCESAR FORMULARIO
    // ==========================================

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        codigoRuta = request.getParameter("codigoRuta");
        codigoSucursalDestino =
                request.getParameter("codigoSucursalDestino");

        distanciaTexto =
                request.getParameter("distanciaKm");

        precioTexto =
                request.getParameter("precioBoleto");

        // Limpiar espacios

        if (codigoRuta != null) {
            codigoRuta = codigoRuta.trim();
        }

        if (codigoSucursalDestino != null) {
            codigoSucursalDestino =
                    codigoSucursalDestino.trim();
        }

        if (distanciaTexto != null) {
            distanciaTexto = distanciaTexto.trim();
        }

        if (precioTexto != null) {
            precioTexto = precioTexto.trim();
        }

        // ==========================================
        // VALIDACIONES
        // ==========================================

        if (codigoRuta == null || codigoRuta.isEmpty()
                || codigoSucursalDestino == null
                || codigoSucursalDestino.isEmpty()
                || distanciaTexto == null
                || distanciaTexto.isEmpty()
                || precioTexto == null
                || precioTexto.isEmpty()) {

            mensaje =
                "Todos los campos obligatorios deben ser completados.";

            tipoMensaje = "error";

        } else if (codigoSucursal.equals(codigoSucursalDestino)) {

            mensaje =
                "La sucursal de destino debe ser diferente a la sucursal de origen.";

            tipoMensaje = "error";

        } else {

            try {

                double distanciaKm =
                        Double.parseDouble(distanciaTexto);

                double precioBoleto =
                        Double.parseDouble(precioTexto);

                if (distanciaKm <= 0) {

                    mensaje =
                        "La distancia debe ser mayor que cero.";

                    tipoMensaje = "error";

                } else if (precioBoleto < 0) {

                    mensaje =
                        "El precio del boleto no puede ser negativo.";

                    tipoMensaje = "error";

                } else {

                    // ==========================================
                    // VERIFICAR QUE LA RUTA NO EXISTA
                    // ==========================================

                    RutaDAO rutaDAO = new RutaDAO();

                    Ruta rutaExistente =
                            rutaDAO.obtener(codigoRuta);

                    if (rutaExistente != null) {

                        mensaje =
                            "Ya existe una ruta con ese código.";

                        tipoMensaje = "error";

                    } else {

                        // ==========================================
                        // VERIFICAR QUE LA SUCURSAL DESTINO EXISTA
                        // ==========================================

                        SucursalDAO sucursalDAO =
                                new SucursalDAO();

                        Sucursal sucursalDestino =
                                sucursalDAO.buscar(codigoSucursalDestino);

                        if (sucursalDestino == null) {

                            mensaje =
                                "La sucursal de destino no existe.";

                            tipoMensaje = "error";

                        } else if (!sucursalDestino.isEstado()) {

                            mensaje =
                                "La sucursal de destino está inactiva.";

                            tipoMensaje = "error";

                        } else {

                            // ==========================================
                            // CREAR RUTA
                            // ==========================================

                            Ruta ruta = new Ruta(
                                codigoRuta,
                                codigoSucursal,
                                codigoSucursalDestino,
                                distanciaKm,
                                precioBoleto,
                                true
                            );

                            boolean registrado =
                                    rutaDAO.insertar(ruta);

                            if (registrado) {

                                response.sendRedirect("rutas.jsp");
                                return;

                            } else {

                                mensaje =
                                    "No se pudo registrar la ruta.";

                                tipoMensaje = "error";
                            }
                        }
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                    "La distancia y el precio deben ser números válidos.";

                tipoMensaje = "error";
            }
        }
    }

    // ==========================================
    // CARGAR SUCURSALES PARA EL DESTINO
    // ==========================================

    SucursalDAO sucursalDAO = new SucursalDAO();

    List<Sucursal> sucursales =
            sucursalDAO.listar();
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

    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 30px;
        }

        .contenedor {
            width: 600px;
            max-width: 100%;
            margin: 40px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.15);
            box-sizing: border-box;
        }

        h1 {
            text-align: center;
            margin-bottom: 10px;
        }

        .subtitulo {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
        }

        .campo {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input,
        select {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        input:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
        }

        input[readonly] {
            background-color: #e9ecef;
            cursor: not-allowed;
        }

        .info {
            background-color: #e9f5ff;
            border: 1px solid #b8daff;
            color: #004085;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .mensaje {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .obligatorio {
            color: red;
        }

        .botones {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
        }

        button,
        .boton-volver {
            padding: 11px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        button {
            background-color: #007bff;
            color: white;
        }

        button:hover {
            background-color: #0056b3;
        }

        .boton-volver {
            background-color: #6c757d;
            color: white;
        }

        .boton-volver:hover {
            background-color: #545b62;
        }

        .sin-destinos {
            padding: 15px;
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
            border-radius: 5px;
        }

    </style>

</head>

<body>

<div class="contenedor">

    <h1>Registrar Ruta</h1>

    <p class="subtitulo">
        Crear una nueva ruta de transporte
    </p>


    <div class="info">

        <strong>Origen:</strong>
        <%= codigoSucursal %>

        <br>

        La sucursal de origen se establece automáticamente
        según tu cuenta.

    </div>


    <% if (!mensaje.isEmpty()) { %>

        <div class="mensaje <%= tipoMensaje %>">

            <%= mensaje %>

        </div>

    <% } %>


    <form method="POST"
          action="registrarRuta.jsp"
          onsubmit="return validarFormulario();">


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
                value="<%= codigoRuta %>"
                required>

        </div>


        <div class="campo">

            <label for="origen">

                Sucursal de origen

            </label>

            <input
                type="text"
                id="origen"
                value="<%= codigoSucursal %>"
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
                        value="<%= sucursal.getCodigoSucursal() %>"
                        <%= sucursal.getCodigoSucursal()
                                .equals(codigoSucursalDestino)
                                ? "selected"
                                : "" %>>

                        <%= sucursal.getNombre() %>
                        -
                        <%= sucursal.getCodigoSucursal() %>

                    </option>

                <%
                        }
                    }
                %>

            </select>

            <% if (!hayDestinos) { %>

                <div class="sin-destinos">

                    No existen otras sucursales activas
                    disponibles como destino.

                </div>

            <% } %>

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
                value="<%= distanciaTexto %>"
                required>

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
                value="<%= precioTexto %>"
                required>

        </div>


        <div class="botones">

            <a href="ruta.jsp"
               class="boton-volver">

                Cancelar

            </a>

            <button type="submit">

                Registrar ruta

            </button>

        </div>

    </form>

</div>


<script>

    function validarFormulario() {

        const codigo =
            document.getElementById("codigoRuta").value.trim();

        const destino =
            document.getElementById("codigoSucursalDestino").value;

        const distancia =
            document.getElementById("distanciaKm").value;

        const precio =
            document.getElementById("precioBoleto").value;


        if (codigo === "") {

            alert("Ingrese el código de la ruta.");
            return false;
        }


        if (destino === "") {

            alert("Seleccione la sucursal de destino.");
            return false;
        }


        if (distancia === "" || Number(distancia) <= 0) {

            alert("La distancia debe ser mayor que cero.");
            return false;
        }


        if (precio === "" || Number(precio) < 0) {

            alert("Ingrese un precio de boleto válido.");
            return false;
        }


        return true;
    }

</script>

</body>

</html>