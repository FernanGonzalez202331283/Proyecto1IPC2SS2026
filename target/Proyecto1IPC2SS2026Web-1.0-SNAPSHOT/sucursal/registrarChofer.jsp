<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.ChoferDAO"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // ==============================
    // VERIFICAR SESIÓN
    // ==============================
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String rolSesion = (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null
            || !"ADMIN_SUCURSAL".equals(rolSesion)) {

        response.sendRedirect("../login.jsp");
        return;
    }

    String codigoSucursal = usuarioSesion.getCodigoSucursal();

    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String numeroLicencia = request.getParameter("numeroLicencia");
        String nombreCompleto = request.getParameter("nombreCompleto");
        String tipoLicencia = request.getParameter("tipoLicencia");
        String fechaVencimiento = request.getParameter("fechaVencimientoLicencia");
        String telefono = request.getParameter("telefono");
        String salarioTexto = request.getParameter("salarioBaseViaje");

        // Limpiar espacios
        if (numeroLicencia != null) {
            numeroLicencia = numeroLicencia.trim();
        }

        if (nombreCompleto != null) {
            nombreCompleto = nombreCompleto.trim();
        }

        if (tipoLicencia != null) {
            tipoLicencia = tipoLicencia.trim();
        }

        if (telefono != null) {
            telefono = telefono.trim();
        }

        // ==============================
        // VALIDACIONES
        // ==============================

        if (numeroLicencia == null || numeroLicencia.isEmpty()
                || nombreCompleto == null || nombreCompleto.isEmpty()
                || tipoLicencia == null || tipoLicencia.isEmpty()
                || fechaVencimiento == null || fechaVencimiento.isEmpty()
                || telefono == null || telefono.isEmpty()
                || salarioTexto == null || salarioTexto.isEmpty()) {

            mensaje = "Todos los campos obligatorios deben ser completados.";
            tipoMensaje = "error";

        } else {

            try {

                double salarioBaseViaje = Double.parseDouble(salarioTexto);

                if (salarioBaseViaje < 0) {

                    mensaje = "El salario base por viaje no puede ser negativo.";
                    tipoMensaje = "error";

                } else {

                    // ==============================
                    // VERIFICAR SI YA EXISTE
                    // ==============================

                    ChoferDAO choferDAO = new ChoferDAO();

                    Chofer choferExistente = choferDAO.obtener(numeroLicencia);

                    if (choferExistente != null) {

                        mensaje = "Ya existe un chofer registrado con esa licencia.";
                        tipoMensaje = "error";

                    } else {

                        // ==============================
                        // CREAR CHOFER
                        // ==============================

                        Chofer chofer = new Chofer(
                            numeroLicencia,
                            codigoSucursal,
                            null,
                            nombreCompleto,
                            tipoLicencia,
                            fechaVencimiento,
                            telefono,
                            salarioBaseViaje,
                            true
                        );

                        boolean registrado = choferDAO.insertar(chofer);

                        if (registrado) {

                            response.sendRedirect("choferes.jsp");
                            return;

                        } else {

                            mensaje = "No se pudo registrar el chofer.";
                            tipoMensaje = "error";
                        }
                    }
                }

            } catch (NumberFormatException e) {

                mensaje = "El salario base por viaje debe ser un número válido.";
                tipoMensaje = "error";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Chofer</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        .contenedor {
            width: 600px;
            margin: 40px auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.15);
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

        .info {
            background-color: #e9f5ff;
            border: 1px solid #b8daff;
            color: #004085;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>

<div class="contenedor">

    <h1>Registrar Chofer</h1>

    <p class="subtitulo">
        Registro de nuevo chofer
    </p>

    <div class="info">
        El chofer será registrado automáticamente en la sucursal
        correspondiente a tu cuenta.
    </div>

    <% if (!mensaje.isEmpty()) { %>

        <div class="mensaje <%= tipoMensaje %>">
            <%= mensaje %>
        </div>

    <% } %>

    <form method="POST" action="registrarChofer.jsp" onsubmit="return validarFormulario();">

        <div class="campo">
            <label for="numeroLicencia">
                Número de licencia <span class="obligatorio">*</span>
            </label>

            <input
                type="text"
                id="numeroLicencia"
                name="numeroLicencia"
                maxlength="50"
                required
            >
        </div>

        <div class="campo">
            <label for="nombreCompleto">
                Nombre completo <span class="obligatorio">*</span>
            </label>

            <input
                type="text"
                id="nombreCompleto"
                name="nombreCompleto"
                maxlength="150"
                required
            >
        </div>

        <div class="campo">
            <label for="tipoLicencia">
                Tipo de licencia <span class="obligatorio">*</span>
            </label>

            <select id="tipoLicencia" name="tipoLicencia" required>

                <option value="">
                    -- Seleccione el tipo de licencia --
                </option>

                <option value="A">
                    Tipo A
                </option>

                <option value="B">
                    Tipo B
                </option>

                <option value="C">
                    Tipo C
                </option>

                <option value="E">
                    Tipo E
                </option>

            </select>
        </div>

        <div class="campo">
            <label for="fechaVencimientoLicencia">
                Fecha de vencimiento de licencia
                <span class="obligatorio">*</span>
            </label>

            <input
                type="date"
                id="fechaVencimientoLicencia"
                name="fechaVencimientoLicencia"
                required
            >
        </div>

        <div class="campo">
            <label for="telefono">
                Teléfono <span class="obligatorio">*</span>
            </label>

            <input
                type="text"
                id="telefono"
                name="telefono"
                maxlength="30"
                required
            >
        </div>

        <div class="campo">
            <label for="salarioBaseViaje">
                Salario base por viaje
                <span class="obligatorio">*</span>
            </label>

            <input
                type="number"
                id="salarioBaseViaje"
                name="salarioBaseViaje"
                min="0"
                step="0.01"
                required
            >
        </div>

        <div class="botones">

            <a href="choferes.jsp" class="boton-volver">
                Cancelar
            </a>

            <button type="submit">
                Registrar chofer
            </button>

        </div>

    </form>

</div>

<script>

    function validarFormulario() {

        const licencia = document.getElementById("numeroLicencia").value.trim();
        const nombre = document.getElementById("nombreCompleto").value.trim();
        const tipoLicencia = document.getElementById("tipoLicencia").value;
        const fecha = document.getElementById("fechaVencimientoLicencia").value;
        const telefono = document.getElementById("telefono").value.trim();
        const salario = document.getElementById("salarioBaseViaje").value;

        if (licencia === "") {
            alert("Ingrese el número de licencia.");
            return false;
        }

        if (nombre === "") {
            alert("Ingrese el nombre completo del chofer.");
            return false;
        }

        if (tipoLicencia === "") {
            alert("Seleccione el tipo de licencia.");
            return false;
        }

        if (fecha === "") {
            alert("Seleccione la fecha de vencimiento de la licencia.");
            return false;
        }

        if (telefono === "") {
            alert("Ingrese el número de teléfono.");
            return false;
        }

        if (salario === "" || Number(salario) < 0) {
            alert("Ingrese un salario base por viaje válido.");
            return false;
        }

        return true;
    }

</script>

</body>
</html>