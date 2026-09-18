<%-- 
    Document   : miPerfil
    Created on : 6 sept 2026
    Author     : fernan
--%>
<%@page import="transporte.modelo.Perfil"%>
<%@page import="transporte.dao.PerfilDAO"%>
<%@page import="transporte.modelo.Usuario"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    PerfilDAO perfilDAO = new PerfilDAO();

    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String nit = request.getParameter("nit");
        String dpi = request.getParameter("dpi");
        String nombreCompleto = request.getParameter("nombreCompleto");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");

        if (nit == null) nit = "";
        if (dpi == null) dpi = "";
        if (nombreCompleto == null) nombreCompleto = "";
        if (telefono == null) telefono = "";
        if (direccion == null) direccion = "";

        nit = nit.trim();
        dpi = dpi.trim();
        nombreCompleto = nombreCompleto.trim();
        telefono = telefono.trim();
        direccion = direccion.trim();

        if (nit.isEmpty()
                || dpi.isEmpty()
                || nombreCompleto.isEmpty()
                || telefono.isEmpty()
                || direccion.isEmpty()) {

            mensaje = "Todos los campos son obligatorios.";
            tipoMensaje = "error";

        } else if (!dpi.matches("\\d{13}")) {

            mensaje = "El DPI debe contener exactamente 13 dígitos.";
            tipoMensaje = "error";

        } else if (!telefono.matches("\\d{8}")) {

            mensaje = "El teléfono debe contener exactamente 8 dígitos.";
            tipoMensaje = "error";

        } else if (!nit.matches("\\d{1,13}")) {

            mensaje = "El NIT solamente debe contener números y tener como máximo 13 dígitos.";
            tipoMensaje = "error";

        } else if (nombreCompleto.matches(".*\\d.*")) {

            mensaje = "El nombre completo no debe contener números.";
            tipoMensaje = "error";

        } else if (nombreCompleto.length() < 3) {

            mensaje = "Ingrese un nombre completo válido.";
            tipoMensaje = "error";

        } else if (direccion.length() < 5) {

            mensaje = "Ingrese una dirección válida.";
            tipoMensaje = "error";

        } else {

            Perfil perfilActualizado = new Perfil(
                    usuarioSesion.getUsuario(),
                    nit,
                    dpi,
                    nombreCompleto,
                    telefono,
                    direccion
            );
            boolean actualizado =
                    perfilDAO.actualizar(perfilActualizado);

            if (actualizado) {

                mensaje = "Perfil actualizado correctamente.";
                tipoMensaje = "exito";

            } else {

                mensaje = "No se pudo actualizar el perfil.";
                tipoMensaje = "error";
            }
        }
    }


    Perfil perfil = perfilDAO.buscarPorUsuario(usuarioSesion.getUsuario() );
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Mi perfil</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

        <script
            src="../resources/js/miPerfil.js"
            defer>
        </script>

    </head>

    <body>

        <main class="pagina">

            <h1>Mi perfil</h1>

            <p>
                Información personal del usuario
            </p>


            <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">

                <%= mensaje %>

            </div>

            <% } %>


            <% if (perfil == null) { %>

            <div class="mensaje error">

                No se encontró el perfil del usuario.

            </div>

            <% } else { %>


            <!-- DATOS DE ACCESO -->

            <div class="formulario">

                <h2>Datos de acceso</h2>


                <div class="form-group">

                    <label for="usuario">
                        Usuario
                    </label>

                    <input
                        type="text"
                        id="usuario"
                        value="<%= usuarioSesion.getUsuario() %>"
                        readonly>

                </div>


                <div class="form-group">

                    <label for="rol">
                        Rol
                    </label>

                    <input
                        type="text"
                        id="rol"
                        value="<%= usuarioSesion.getRol() %>"
                        readonly>

                </div>

            </div>


            <!-- DATOS PERSONALES -->

            <div class="formulario">

                <h2>Datos personales</h2>


                <form
                    method="POST"
                    id="perfilForm">


                    <!-- MENSAJE DE JAVASCRIPT -->

                    <div
                        id="mensajePerfil"
                        class="mensaje">
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
                            value="<%= perfil.getNit() != null
                                    ? perfil.getNit()
                                    : "" %>"
                            placeholder="Ingrese su NIT"
                            maxlength="13"
                            inputmode="numeric"
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
                            value="<%= perfil.getDpi() != null
                                    ? perfil.getDpi()
                                    : "" %>"
                            placeholder="13 dígitos"
                            maxlength="13"
                            required>

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
                            value="<%= perfil.getNombreCompleto() != null
                                    ? perfil.getNombreCompleto()
                                    : "" %>"
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
                            value="<%= perfil.getTelefono() != null
                                    ? perfil.getTelefono()
                                    : "" %>"
                            placeholder="8 dígitos"
                            maxlength="8"
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
                            value="<%= perfil.getDireccion() != null
                                    ? perfil.getDireccion()
                                    : "" %>"
                            required>

                    </div>


                    <button type="submit">
                        Guardar cambios
                    </button>

                </form>

            </div>
            <% } %>
            <div class="botones-inferiores">
                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    regresar al inicio
                </a>

            </div>

        </main>

    </body>

</html>