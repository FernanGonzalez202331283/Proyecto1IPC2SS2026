<%-- 
    Document   : registrarse
    Created on : 9 sept 2026, 23:10:30
    Author     : fernan
--%>

<%@page import="transporte.modelo.Cartera"%>
<%@page import="transporte.dao.CarteraDAO"%>
<%@page import="transporte.modelo.Perfil"%>
<%@page import="transporte.dao.PerfilDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.UsuarioDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String usuarioIngresado
                = request.getParameter("usuario");

        String contraseñaIngresada
                = request.getParameter("contraseña");

        String nit
                = request.getParameter("nit");

        String dpi
                = request.getParameter("dpi");

        String nombreCompleto
                = request.getParameter("nombreCompleto");

        String telefono
                = request.getParameter("telefono");

        String direccion
                = request.getParameter("direccion");

        // VALIDACIONES
        if (usuarioIngresado == null
                || usuarioIngresado.trim().isEmpty()) {
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

        } else if (nit == null
                || nit.trim().isEmpty()) {
            mensaje = "Debe ingresar el NIT.";
            tipoMensaje = "error";

        } else if (!nit.trim().matches("\\d+")) {

            mensaje = "El NIT solamente debe contener números.";
            tipoMensaje = "error";

        } else if (dpi == null
                || dpi.trim().isEmpty()) {

            mensaje = "Debe ingresar el DPI.";
            tipoMensaje = "error";

        } else if (!dpi.trim().matches("\\d+")) {

            mensaje = "El DPI solamente debe contener números.";
            tipoMensaje = "error";

        } else if (dpi.trim().length() != 13) {

            mensaje = "El DPI debe contener 13 dígitos.";
            tipoMensaje = "error";

        } else if (nombreCompleto == null
                || nombreCompleto.trim().isEmpty()) {

            mensaje = "Debe ingresar el nombre completo.";
            tipoMensaje = "error";

        } else if (!nombreCompleto.trim().matches(
                "[a-zA-ZáéíóúÁÉÍÓÚñÑ\\s]+")) {

            mensaje = "El nombre solamente debe contener letras y espacios.";
            tipoMensaje = "error";

        } else if (nombreCompleto.trim().length() < 5) {

            mensaje = "El nombre debe tener al menos 5 caracteres.";
            tipoMensaje = "error";

        } else if (telefono == null
                || telefono.trim().isEmpty()) {

            mensaje = "Debe ingresar el teléfono.";
            tipoMensaje = "error";

        } else if (!telefono.trim().matches("\\d+")) {

            mensaje = "El teléfono solamente debe contener números.";
            tipoMensaje = "error";

        } else if (telefono.trim().length() != 8) {

            mensaje = "El teléfono debe contener 8 dígitos.";
            tipoMensaje = "error";

        } else if (direccion == null
                || direccion.trim().isEmpty()) {

            mensaje = "Debe ingresar la dirección.";
            tipoMensaje = "error";

        } else {

            usuarioIngresado = usuarioIngresado.trim();
            nit = nit.trim();
            dpi = dpi.trim();
            nombreCompleto = nombreCompleto.trim();
            telefono = telefono.trim();
            direccion = direccion.trim();

            UsuarioDAO usuarioDAO = new UsuarioDAO();

            if (usuarioDAO.existe(usuarioIngresado)) {

                mensaje = "El usuario ya existe. Debe ingresar otro usuario.";
                tipoMensaje = "error";

            } else {

                String rol = "CLIENTE";
                boolean estado = true;

                Usuario nuevoUsuario = new Usuario(
                        usuarioIngresado,
                        contraseñaIngresada,
                        rol,
                        estado
                );

                boolean usuarioInsertado
                        = usuarioDAO.insertar(nuevoUsuario);

                if (usuarioInsertado) {

                    PerfilDAO perfilDAO = new PerfilDAO();

                    Perfil nuevoPerfil = new Perfil(
                            usuarioIngresado,
                            nit,
                            dpi,
                            nombreCompleto,
                            telefono,
                            direccion
                    );

                    boolean perfilInsertado
                            = perfilDAO.insertar(nuevoPerfil);

                    if (perfilInsertado) {

                        CarteraDAO carteraDAO = new CarteraDAO();

                        Cartera nuevaCartera = new Cartera(
                                usuarioIngresado,
                                0.00
                        );

                        boolean carteraInsertada
                                = carteraDAO.insertar(nuevaCartera);

                        if (carteraInsertada) {

                            mensaje
                                    = "Cuenta creada correctamente. "
                                    + "Ahora puede iniciar sesión.";

                            tipoMensaje = "exito";

                        } else {

                            mensaje
                                    = "El usuario y perfil fueron creados, "
                                    + "pero no se pudo crear la cartera.";

                            tipoMensaje = "error";
                        }

                    } else {

                        mensaje
                                = "El usuario fue creado, "
                                + "pero no se pudo crear el perfil.";

                        tipoMensaje = "error";
                    }

                } else {

                    mensaje = "No se pudo crear la cuenta.";
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

        <title>Crear Cuenta</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>


    <body class="login-page">

        <main class="login-container">

            <h1>Crear Cuenta</h1>

            <p class="login-subtitle">
                Regístrate en el Sistema de Transporte Extraurbano
            </p>


            <form method="POST"
                  id="registroForm">


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
                        autocomplete="username"
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
                        autocomplete="new-password"
                        required>

                    <p id="mensajeContraseña"
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
                        placeholder="Ingrese su NIT"
                        maxlength="13"
                        inputmode="numeric"
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
                        minlength="13"
                        maxlength="13"
                        inputmode="numeric"
                        required>

                    <p id="mensajeDpi"
                       class="campo-error"></p>

                </div>


                <!-- NOMBRE -->

                <div class="form-group">

                    <label for="nombreCompleto">
                        Nombre completo
                    </label>

                    <input
                        type="text"
                        id="nombreCompleto"
                        name="nombreCompleto"
                        maxlength="150"
                        required>

                    <p id="mensajeNombre"
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
                        required>

                </div>


                <button type="submit">
                    Crear cuenta
                </button>

            </form>


            <% if (!mensaje.isEmpty()) {%>

            <div class="mensaje <%= tipoMensaje%>">
                <%= mensaje%>
            </div>

            <% }%>


            <p class="registro-link">

                ¿Ya tienes una cuenta?

                <a href="../login.jsp">
                    Iniciar sesión
                </a>

            </p>


        </main>


        <script src="../resources/js/registrarse.js"></script>

    </body>

</html>