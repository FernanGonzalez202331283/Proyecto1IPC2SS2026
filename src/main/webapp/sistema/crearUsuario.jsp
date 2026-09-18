<%--
Document   : crearUsuario
Created on : 4 sept 2026, 16:07:37
Author     : fernan
--%>
<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Perfil"%>
<%@page import="transporte.dao.PerfilDAO"%>
<%@page import="transporte.modelo.Sucursal"%>
<%@page import="transporte.dao.SucursalDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.UsuarioDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SISTEMA".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String mensaje = "";
    String tipoMensaje = "";

    // Valores del formulario
    String usuarioIngresado = request.getParameter("usuario");
    String contraseñaIngresada = request.getParameter("contraseña");
    String codigoSucursal = request.getParameter("codigoSucursal");
    String nit = request.getParameter("nit");
    String dpi = request.getParameter("dpi");
    String nombreCompleto = request.getParameter("nombreCompleto");
    String telefono = request.getParameter("telefono");
    String direccion = request.getParameter("direccion");

    // Evitar valores null al mostrar el formulario
    if (usuarioIngresado == null) {
        usuarioIngresado = "";
    }

    if (codigoSucursal == null) {
        codigoSucursal = "";
    }

    if (nit == null) {
        nit = "";
    }

    if (dpi == null) {
        dpi = "";
    }

    if (nombreCompleto == null) {
        nombreCompleto = "";
    }

    if (telefono == null) {
        telefono = "";
    }

    if (direccion == null) {
        direccion = "";
    }

    SucursalDAO sucursalDAO = new SucursalDAO();
    List<Sucursal> sucursales = sucursalDAO.listar();

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        // VALIDACIONES
        if (usuarioIngresado.trim().isEmpty()) {

            mensaje = "Debe ingresar un usuario.";
            tipoMensaje = "error";

        } else if (usuarioIngresado.trim().length() < 4) {

            mensaje = "El usuario debe tener al menos 4 caracteres.";
            tipoMensaje = "error";

        } else if (contraseñaIngresada == null
                || contraseñaIngresada.trim().isEmpty()) {

            mensaje = "Debe ingresar una contraseña.";
            tipoMensaje = "error";

        } else if (contraseñaIngresada.length() < 4) {

            mensaje = "La contraseña debe tener al menos 4 caracteres.";
            tipoMensaje = "error";

        } else if (codigoSucursal.trim().isEmpty()) {

            mensaje = "Debe seleccionar una sucursal.";
            tipoMensaje = "error";

        } else if (nit.trim().isEmpty()) {

            mensaje = "Debe ingresar el NIT.";
            tipoMensaje = "error";

        } else if (!nit.trim().matches("\\d+")) {

            mensaje = "El NIT solamente debe contener números.";
            tipoMensaje = "error";

        } else if (dpi.trim().isEmpty()) {

            mensaje = "Debe ingresar el DPI.";
            tipoMensaje = "error";

        } else if (!dpi.trim().matches("\\d+")) {

            mensaje = "El DPI solamente debe contener números.";
            tipoMensaje = "error";

        } else if (dpi.trim().length() != 13) {

            mensaje = "El DPI debe contener 13 dígitos.";
            tipoMensaje = "error";

        } else if (nombreCompleto.trim().isEmpty()) {

            mensaje = "Debe ingresar el nombre completo.";
            tipoMensaje = "error";

        } else if (!nombreCompleto.trim().matches(
                "[a-zA-ZáéíóúÁÉÍÓÚñÑ\\s]+")) {

            mensaje = "El nombre solamente debe contener letras y espacios.";
            tipoMensaje = "error";

        } else if (nombreCompleto.trim().length() < 5) {

            mensaje = "El nombre debe tener al menos 5 caracteres.";
            tipoMensaje = "error";

        } else if (telefono.trim().isEmpty()) {

            mensaje = "Debe ingresar el teléfono.";
            tipoMensaje = "error";

        } else if (!telefono.trim().matches("\\d+")) {

            mensaje = "El teléfono solamente debe contener números.";
            tipoMensaje = "error";

        } else if (telefono.trim().length() != 8) {

            mensaje = "El teléfono debe contener 8 dígitos.";
            tipoMensaje = "error";

        } else if (direccion.trim().isEmpty()) {

            mensaje = "Debe ingresar la dirección.";
            tipoMensaje = "error";

        } else {

            UsuarioDAO usuarioDAO = new UsuarioDAO();

            if (usuarioDAO.existe(usuarioIngresado.trim())) {

                mensaje = "El usuario ya existe.";
                tipoMensaje = "error";

            } else {

                String rol = "ADMIN_SUCURSAL";

                Usuario nuevoUsuario = new Usuario(
                        usuarioIngresado.trim(),
                        contraseñaIngresada,
                        rol,
                        true,
                        codigoSucursal.trim()
                );

                boolean usuarioInsertado
                        = usuarioDAO.insertar(nuevoUsuario);

                if (usuarioInsertado) {

                    Perfil nuevoPerfil = new Perfil(
                            usuarioIngresado.trim(),
                            nit.trim(),
                            dpi.trim(),
                            nombreCompleto.trim(),
                            telefono.trim(),
                            direccion.trim()
                    );

                    PerfilDAO perfilDAO = new PerfilDAO();

                    boolean perfilInsertado
                            = perfilDAO.insertar(nuevoPerfil);

                    if (perfilInsertado) {

                        mensaje = "Administrador de sucursal creado correctamente.";
                        tipoMensaje = "exito";
                        usuarioIngresado = "";
                        contraseñaIngresada = "";
                        codigoSucursal = "";
                        nit = "";
                        dpi = "";
                        nombreCompleto = "";
                        telefono = "";
                        direccion = "";

                    } else {

                        mensaje = "El usuario fue creado, pero no se pudo crear su perfil.";
                        tipoMensaje = "error";
                    }

                } else {

                    mensaje = "No se pudo crear el administrador de sucursal.";
                    tipoMensaje = "error";
                }
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
        <title>Crear Administrador de Sucursal</title>
        <link rel="stylesheet"href="../resources/css/styles.css">
    </head>
    <body>
        <main class="login-container">
            <h1>Crear Administrador de Sucursal</h1>
            <p class="login-subtitle">
                Administración del sistema
            </p>
            <form method="POST"
                  id="crearUsuarioForm">
                <!-- USUARIO -->
                <div class="form-group">
                    <label for="usuario">
                        Usuario
                    </label>
                    <input
                        type="text"
                        id="usuario"
                        name="usuario"
                        maxlength="50"
                        value="<%= usuarioIngresado%>"
                        required>

                    <p id="mensajeUsuario"
                       class="campo-error"></p>
                </div>
                <!-- CONTRASEÑA -->
                <div class="form-group">

                    <label for="contraseña">
                        Contraseña
                    </label>

                    <input
                        type="password"
                        id="contraseña"
                        name="contraseña"
                        required>

                    <p id="mensajeContraseña"
                       class="campo-error"></p>
                </div>


                <!-- SUCURSAL -->
                <div class="form-group">

                    <label for="codigoSucursal">
                        Sucursal
                    </label>

                    <select
                        id="codigoSucursal"
                        name="codigoSucursal"
                        required>

                        <option value="">
                            Seleccione una sucursal
                        </option>

                        <%
                            if (sucursales != null) {

                                for (Sucursal sucursal : sucursales) {

                                    if (sucursal != null
                                            && sucursal.isEstado()) {

                                        String seleccionado = "";

                                        if (sucursal.getCodigoSucursal()
                                                .equals(codigoSucursal)) {

                                            seleccionado = "selected";
                                        }
                        %>

                        <option
                            value="<%= sucursal.getCodigoSucursal()%>"
                            <%= seleccionado%>>

                            <%= sucursal.getNombre()%>
                        </option>

                        <%
                                    }
                                }
                            }
                        %>

                    </select>

                    <p id="mensajeSucursal"
                       class="campo-error"></p>
                </div>
                <hr>
                <h2>Datos personales</h2>


                <!-- NOMBRE COMPLETO -->
                <div class="form-group">

                    <label for="nombreCompleto">
                        Nombre completo
                    </label>

                    <input
                        type="text"
                        id="nombreCompleto"
                        name="nombreCompleto"
                        maxlength="150"
                        value="<%= nombreCompleto%>"
                        required>

                    <p id="mensajeNombre"
                       class="campo-error"></p>
                </div>
                        
                <!-- NIT -->
                <div class="form-group">
                    <label for="nit">
                        NIT
                    </label>
                    <input
                        type="text"
                        id="nit"
                        name="nit"
                        maxlength="30"
                        inputmode="numeric"
                        value="<%= nit%>"
                        required>

                    <p id="mensajeNit"
                       class="campo-error"></p>
                </div>


                <!-- DPI -->
                <div class="form-group">
                    <label for="dpi">
                        DPI
                    </label>
                    <input
                        type="text"
                        id="dpi"
                        name="dpi"
                        maxlength="13"
                        inputmode="numeric"
                        value="<%= dpi%>"
                        required>
                    <p id="mensajeDpi"
                       class="campo-error"></p>

                </div>


                <!-- TELEFONO -->
                <div class="form-group">
                    <label for="telefono">
                        Teléfono
                    </label>
                    <input
                        type="tel"
                        id="telefono"
                        name="telefono"
                        maxlength="8"
                        inputmode="numeric"
                        value="<%= telefono%>"
                        required>
                    <p id="mensajeTelefono"
                       class="campo-error"></p>

                </div>


                <!-- DIRECCION -->
                <div class="form-group">
                    <label for="direccion">
                        Dirección
                    </label>
                    <input
                        type="text"
                        id="direccion"
                        name="direccion"
                        maxlength="250"
                        value="<%= direccion%>"
                        required>
                </div>


                <!-- ROL -->
                <div class="form-group">
                    <label>
                        Rol
                    </label>
                    <input
                        type="text"
                        value="Administrador de sucursal"
                        readonly>
                </div>


                <button type="submit">
                    Crear administrador
                </button>
            </form>
            <% if (!mensaje.isEmpty()) {%>
            <div class="mensaje <%= tipoMensaje%>">
                <%= mensaje%>
            </div>
            <% }%>
            <br>
            <div class="botones-inferiores">
                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal
                </a>
            </div>
        </main>
        <script src="../resources/js/crearUsuario.js"></script>
    </body>
</html>
