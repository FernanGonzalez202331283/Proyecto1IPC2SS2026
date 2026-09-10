<%-- 
    Document   : crearUsuario
    Created on : 4 sept 2026, 16:07:37
    Author     : fernan
--%>

<%@page import="transporte.modelo.Perfil"%>
<%@page import="transporte.dao.PerfilDAO"%>
<%@page import="transporte.modelo.Sucursal"%>
<%@page import="transporte.dao.SucursalDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.UsuarioDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"ADMIN_SISTEMA".equals(usuarioSesion.getRol())) {
        response.sendRedirect("inicio.jsp");
        return;
    }

    String mensaje = "";
    String tipoMensaje = "";
    SucursalDAO sucursalDAO = new SucursalDAO();
    Sucursal[] sucursales = sucursalDAO.listar();


    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String usuarioIngresado =
                request.getParameter("usuario");

        String contrasenaIngresada =
                request.getParameter("contrasena");

        String codigoSucursal =
                request.getParameter("codigoSucursal");

        String nit =
                request.getParameter("nit");

        String dpi =
                request.getParameter("dpi");

        String nombreCompleto =
                request.getParameter("nombreCompleto");

        String telefono =
                request.getParameter("telefono");

        String direccion =
                request.getParameter("direccion");

        if (usuarioIngresado == null ||
            usuarioIngresado.trim().isEmpty()) {

            mensaje = "Debe ingresar un usuario.";
            tipoMensaje = "error";

        } else if (contrasenaIngresada == null ||
                   contrasenaIngresada.isEmpty()) {

            mensaje = "Debe ingresar una contraseña.";
            tipoMensaje = "error";

        } else if (codigoSucursal == null ||
                   codigoSucursal.trim().isEmpty()) {

            mensaje = "Debe seleccionar una sucursal.";
            tipoMensaje = "error";

        } else if (nit == null ||
                   nit.trim().isEmpty()) {

            mensaje = "Debe ingresar el NIT.";
            tipoMensaje = "error";

        } else if (dpi == null ||
                   dpi.trim().isEmpty()) {

            mensaje = "Debe ingresar el DPI.";
            tipoMensaje = "error";

        } else if (nombreCompleto == null ||
                   nombreCompleto.trim().isEmpty()) {

            mensaje = "Debe ingresar el nombre completo.";
            tipoMensaje = "error";

        } else if (telefono == null ||
                   telefono.trim().isEmpty()) {

            mensaje = "Debe ingresar el teléfono.";
            tipoMensaje = "error";

        } else if (direccion == null ||
                   direccion.trim().isEmpty()) {

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
                        contrasenaIngresada,
                        rol,
                        true,
                        codigoSucursal.trim()
                );


                boolean usuarioInsertado =
                        usuarioDAO.insertar(nuevoUsuario);


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

                    boolean perfilInsertado =
                            perfilDAO.insertar(nuevoPerfil);


                    if (perfilInsertado) {

                        mensaje =
                                "Administrador de sucursal creado correctamente.";

                        tipoMensaje = "exito";

                    } else {

                        mensaje =
                                "El usuario fue creado, pero no se pudo crear su perfil.";

                        tipoMensaje = "error";
                    }

                } else {

                    mensaje =
                            "No se pudo crear el administrador de sucursal.";

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

    <link rel="stylesheet"
          href="../resources/css/styles.css">

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
                    required>

                <p id="mensajeUsuario"
                   class="campo-error"></p>

            </div>


            <!-- CONTRASEÑA -->

            <div class="form-group">

                <label for="contrasena">
                    Contraseña
                </label>

                <input
                    type="password"
                    id="contrasena"
                    name="contrasena"
                    required>

                <p id="mensajeContrasena"
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
                                if (sucursal != null && sucursal.isEstado()) {
                    %>

                    <option value="<%= sucursal.getCodigoSucursal() %>">
                        <%= sucursal.getNombre() %>
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
                    required>

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
                    maxlength="30"
                    required>

            </div>


            <!-- TELEFONO -->

            <div class="form-group">

                <label for="telefono">
                    Teléfono
                </label>

                <input
                    type="text"
                    id="telefono"
                    name="telefono"
                    maxlength="30"
                    required>

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


        <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">
                <%= mensaje %>
            </div>

        <% } %>


        <br>


        <a href="../inicio.jsp">
            Regresar al inicio
        </a>


    </main>


    <script src="../resources/js/crearUsuario.js"></script>

</body>

</html>