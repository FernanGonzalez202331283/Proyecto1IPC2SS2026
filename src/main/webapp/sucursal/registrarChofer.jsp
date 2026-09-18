<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.ChoferDAO"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    
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

                   
                    ChoferDAO choferDAO = new ChoferDAO();

                    Chofer choferExistente = choferDAO.obtener(numeroLicencia);

                    if (choferExistente != null) {

                        mensaje = "Ya existe un chofer registrado con esa licencia.";
                        tipoMensaje = "error";

                    } else {

                       
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

            <% if (!mensaje.isEmpty()) {%>

            <div class="mensaje <%= tipoMensaje%>">
                <%= mensaje%>
            </div>

            <% }%>

                <form id="formularioRegistrarChofer" method="POST" action="registrarChofer.jsp">
                <div class="campo">
                    <label for="numeroLicencia">
                        Número de licencia <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="text"
                        id="numeroLicencia"
                        name="numeroLicencia"
                        maxlength="50"
                        required>
                    <p id="mensajeLicencia" class="campo-error"></p>
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
                    <p id="mensajeNombre" class="campo-error"></p>
                </div>

                <div class="campo">
                    <label for="tipoLicencia">
                        Tipo de licencia <span class="obligatorio">*</span>
                    </label>

                    <select id="tipoLicencia" name="tipoLicencia" required>
                        <p id="mensajeTipoLicencia" class="campo-error"></p>

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
                    <p id="mensajeFecha" class="campo-error"></p>
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
                    <p id="mensajeTelefono" class="campo-error"></p>
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
                    <p id="mensajeSalario" class="campo-error"></p>
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
            <script src="../resources/js/registrarChofer.js"></script>
    </body>
</html>