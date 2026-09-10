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

    PerfilDAO perfilDAO =
            new PerfilDAO();

    Perfil perfil =
            perfilDAO.buscarPorUsuario(
                    usuarioSesion.getUsuario()
            );

    String mensaje = "";
    String tipoMensaje = "";
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

</head>

<body>

    <main class="pagina">

        <h1>Mi perfil</h1>

        <p>
            Información personal del usuario
        </p>


        <% if (perfil == null) { %>

            <div class="mensaje error">

                No se encontró el perfil del usuario.

            </div>

        <% } else { %>


            <div class="formulario">

                <h2>Datos de acceso</h2>

                <div class="form-group">

                    <label>
                        Usuario
                    </label>

                    <input
                        type="text"
                        value="<%= usuarioSesion.getUsuario() %>"
                        readonly>

                </div>


                <div class="form-group">

                    <label>
                        Rol
                    </label>

                    <input
                        type="text"
                        value="<%= usuarioSesion.getRol() %>"
                        readonly>

                </div>

            </div>


            <div class="formulario">

                <h2>Datos personales</h2>

                <form method="POST"
                      id="perfilForm">


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
                            required>

                    </div>


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
                            required>

                    </div>


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
                            required>

                    </div>


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


        <br>

        <a href="../inicio.jsp">
            Regresar al inicio
        </a>

    </main>

</body>

</html>