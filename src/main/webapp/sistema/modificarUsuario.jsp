<%-- 
    Document   : modificarUsuario
    Created on : 5 sept 2026
    Author     : fernan
--%>

<%@page import="transporte.modelo.Sucursal"%>
<%@page import="transporte.dao.SucursalDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.UsuarioDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SISTEMA".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    UsuarioDAO usuarioDAO =
            new UsuarioDAO();

    SucursalDAO sucursalDAO =
            new SucursalDAO();

    Usuario[] usuarios =
            usuarioDAO.listar();

    Sucursal[] sucursales =
            sucursalDAO.listar();

    String mensaje = "";
    String tipoMensaje = "";

    Usuario usuarioSeleccionado = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String usuarioIngresado =
                request.getParameter("usuario");

        String contrasena =
                request.getParameter("contrasena");

        String codigoSucursal =
                request.getParameter("codigoSucursal");

        if (usuarioIngresado != null &&
            !usuarioIngresado.trim().isEmpty()) {

            usuarioIngresado =
                    usuarioIngresado.trim();

            usuarioSeleccionado =
                    usuarioDAO.buscarPorUsuario(
                            usuarioIngresado
                    );
        }

        if (usuarioSeleccionado == null) {

            mensaje =
                    "No se encontró el usuario seleccionado.";

            tipoMensaje = "error";

        } else {

            if (contrasena == null ||
                contrasena.trim().isEmpty()) {

                mensaje =
                        "Debe ingresar una contraseña.";

                tipoMensaje = "error";

            } else if (contrasena.length() < 4) {

                mensaje =
                        "La contraseña debe tener al menos 4 caracteres.";

                tipoMensaje = "error";

            } else {

                usuarioSeleccionado.setContraseña(
                        contrasena
                );

                if ("ADMIN_SUCURSAL".equals(
                        usuarioSeleccionado.getRol())) {

                    if (codigoSucursal == null ||
                        codigoSucursal.trim().isEmpty()) {

                        mensaje =
                                "Debe seleccionar una sucursal.";

                        tipoMensaje = "error";

                    } else {

                        usuarioSeleccionado.setCodigoSucursal(
                                codigoSucursal.trim()
                        );

                        String resultado =
                                usuarioDAO.actualizar(
                                        usuarioSeleccionado
                                );

                        mensaje = resultado;

                        if ("Usuario modificado correctamente."
                                .equals(resultado)) {

                            tipoMensaje = "exito";

                        } else {

                            tipoMensaje = "error";
                        }
                    }

                } else {

                    usuarioSeleccionado.setCodigoSucursal(
                            null
                    );

                    String resultado =
                            usuarioDAO.actualizar(
                                    usuarioSeleccionado
                            );

                    mensaje = resultado;

                    if ("Usuario modificado correctamente."
                            .equals(resultado)) {

                        tipoMensaje = "exito";

                    } else {

                        tipoMensaje = "error";
                    }
                }
            }
        }

        usuarios =
                usuarioDAO.listar();
    }
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Modificar usuario</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <h1>Modificar usuario</h1>

        <p>
            Administración del sistema
        </p>


        <div class="formulario">

            <h2>Seleccionar usuario</h2>

            <div class="form-group">

                <label for="seleccionarUsuario">
                    Usuario
                </label>

                <select
                    id="seleccionarUsuario"
                    onchange="mostrarUsuario()">

                    <option value="">
                        Seleccione un usuario
                    </option>

                    <%
                        if (usuarios != null) {

                            for (Usuario usuario : usuarios) {

                                if (usuario != null) {
                    %>

                    <option
                        value="<%= usuario.getUsuario() %>"
                        data-contrasena=""
                        data-rol="<%= usuario.getRol() %>"
                        data-sucursal="<%= usuario.getCodigoSucursal() != null
                                ? usuario.getCodigoSucursal()
                                : "" %>">

                        <%= usuario.getUsuario() %>

                    </option>

                    <%
                                }
                            }
                        }
                    %>

                </select>

            </div>

        </div>

        <div
            class="formulario"
            id="formularioModificar"
            style="display: none;">

            <h2>Datos del usuario</h2>

            <form method="POST"
                  id="modificarUsuarioForm">

                <div class="form-group">

                    <label for="usuario">
                        Usuario
                    </label>

                    <input
                        type="text"
                        id="usuario"
                        name="usuario"
                        readonly>

                </div>

                <div class="form-group">

                    <label for="rol">
                        Rol
                    </label>

                    <input
                        type="text"
                        id="rol"
                        readonly>

                </div>

                <div
                    class="form-group"
                    id="grupoSucursal">

                    <label for="codigoSucursal">
                        Sucursal
                    </label>

                    <select
                        id="codigoSucursal"
                        name="codigoSucursal">

                        <option value="">
                            Seleccione una sucursal
                        </option>

                        <%
                            if (sucursales != null) {

                                for (Sucursal sucursal : sucursales) {

                                    if (sucursal != null &&
                                        sucursal.isEstado()) {
                        %>

                        <option
                            value="<%= sucursal.getCodigoSucursal() %>">

                            <%= sucursal.getNombre() %>

                        </option>

                        <%
                                    }
                                }
                            }
                        %>

                    </select>

                    <p
                        id="mensajeSucursal"
                        class="campo-error">
                    </p>

                </div>

                <div class="form-group">

                    <label for="contrasena">
                        Nueva contraseña
                    </label>

                    <input
                        type="password"
                        id="contrasena"
                        name="contrasena"
                        minlength="4"
                        required>

                    <p
                        id="mensajeContrasena"
                        class="campo-error">
                    </p>

                </div>

                <button type="submit">
                    Guardar cambios
                </button>

            </form>

        </div>

       <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">

                <%= mensaje %>

            </div>

        <% } %>


        <br>


        <a href="listarUsuarios.jsp">
            Regresar a usuarios
        </a>

        <br><br>

        <a href="../inicio.jsp">
            Regresar al inicio
        </a>

    </main>


    <script src="../resources/js/modificarUsuario.js"></script>

</body>

</html>