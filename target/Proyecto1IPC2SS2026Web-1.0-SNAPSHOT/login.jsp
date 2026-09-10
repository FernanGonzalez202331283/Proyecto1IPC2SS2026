<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.UsuarioDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String usuarioIngresado = request.getParameter("usuario");
        String contrasenaIngresada = request.getParameter("contrasena");

        if (usuarioIngresado == null || usuarioIngresado.trim().isEmpty()) {

            mensaje = "Debe ingresar un usuario.";
            tipoMensaje = "error";

        } else if (contrasenaIngresada == null || contrasenaIngresada.isEmpty()) {

            mensaje = "Debe ingresar una contraseña.";
            tipoMensaje = "error";

        } else {

            UsuarioDAO dao = new UsuarioDAO();

            Usuario usuarioEncontrado =
                    dao.buscarPorUsuario(usuarioIngresado.trim());

            if (usuarioEncontrado == null) {

                mensaje = "El usuario no existe.";
                tipoMensaje = "error";

            } else if (!usuarioEncontrado.getContraseña()
                    .equals(contrasenaIngresada)) {

                mensaje = "La contraseña es incorrecta.";
                tipoMensaje = "error";

            } else if (!usuarioEncontrado.isEstado()) {

                mensaje = "El usuario está inactivo.";
                tipoMensaje = "error";

            } else {

                session.setAttribute("usuario", usuarioEncontrado);
                session.setAttribute("rol", usuarioEncontrado.getRol());

                response.sendRedirect("inicio.jsp");
                return;
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

    <title>Inicio de Sesión</title>

    <link rel="stylesheet"
          href="resources/css/styles.css">

</head>

<body class= "login-page">

    <main class="login-container">

        <h1>Iniciar Sesión</h1>

        <p class="login-subtitle">
            Sistema de Transporte Extraurbano
        </p>

        <form method="post"
              id="loginForm">

            <div class="form-group">

                <label for="usuario">
                    Usuario
                </label>

                <input
                    type="text"
                    id="usuario"
                    name="usuario"
                    autocomplete="username"
                    maxlength="50"
                    required>

                <p id="mensajeUsuario"
                   class="campo-error"></p>

            </div>

            <div class="form-group">

                <label for="contrasena">
                    Contraseña
                </label>

                <input
                    type="password"
                    id="contrasena"
                    name="contrasena"
                    autocomplete="current-password"
                    required>

                <p id="mensajeContrasena"
                   class="campo-error"></p>

            </div>

            <button type="submit">
                Iniciar Sesión
            </button>
            <p class ="registro-link">
                ¿no tienes una cuenta?
                <a href='cliente/registrarse.jsp'>Crear un cuenta</a>
            </p>

        </form>

        <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">
                <%= mensaje %>
            </div>

        <% } %>

    </main>

    <script src="resources/js/login.js"></script>

</body>

</html>