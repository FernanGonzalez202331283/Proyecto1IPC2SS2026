<%-- 
    Document   : registrarRutaPrivada
    Created on : 12 sept 2026, 18:35:07
    Author     : fernan
--%>

<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario
            = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }
    String origen
            = request.getParameter("origen");

    String destino
            = request.getParameter("destino");

    String codigoAlquiler
            = request.getParameter("codigoAlquiler");
    if (origen == null) {
        origen = "";
    }

    if (destino == null) {
        destino = "";
    }

    if (codigoAlquiler == null) {
        codigoAlquiler = "";
    }
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Registrar ruta privada</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Registrar ruta privada</h1>

                <p>
                    Registra una nueva ruta para utilizarla
                    posteriormente en los alquileres privados.
                </p>

                <p>
                    Administrador:
                    <strong>
                        <%= usuario.getUsuario()%>
                    </strong>
                </p>

            </header>


            <div class="card-menu">

                <h2>Datos de la ruta</h2>

                <%

                    if (!codigoAlquiler.trim().isEmpty()) {
                %>

                <div class="alert alert-info">

                    <strong>
                        Registro de ruta para una solicitud de alquiler
                    </strong>

                    <p>
                        Código de alquiler:
                        <strong>
                            <%= codigoAlquiler%>
                        </strong>
                    </p>

                    <p>
                        El origen y destino fueron obtenidos
                        automáticamente de la solicitud.
                    </p>

                </div>

                <%
                    }
                %>


                <form method="post"
                      action="procesarRutaPrivada.jsp"
                      id="formRutaPrivada">


                    <!-- CÓDIGO DEL ALQUILER -->

                    <input
                        type="hidden"
                        name="codigoAlquiler"
                        value="<%= codigoAlquiler%>">


                    <!-- ORIGEN -->

                    <div class="form-group">

                        <label for="origen">
                            Origen
                        </label>

                        <input
                            type="text"
                            id="origen"
                            name="origen"
                            maxlength="250"
                            value="<%= origen%>"
                            required>

                        <p id="mensajeOrigen" class="campo-error"></p>

                    </div>


                    <!-- DESTINO -->

                    <div class="form-group">

                        <label for="destino">
                            Destino
                        </label>

                        <input
                            type="text"
                            id="destino"
                            name="destino"
                            maxlength="250"
                            value="<%= destino%>"
                            required>

                        <p id="mensajeDestino" class="campo-error"></p>

                    </div>


                    <!-- DISTANCIA -->

                    <div class="form-group">

                        <label for="distanciaKm">
                            Distancia en kilómetros
                        </label>

                        <input
                            type="number"
                            id="distanciaKm"
                            name="distanciaKm"
                            min="0.01"
                            step="0.01"
                            required>

                        <small>
                            Ingresa la distancia aproximada entre
                            el origen y el destino.
                        </small>

                        <p id="mensajeDistancia" class="campo-error"></p>

                    </div>

                    <div class="form-actions">

                        <button type="submit">
                            Registrar ruta
                        </button>

                        <%

                            if (!codigoAlquiler.trim().isEmpty()) {
                        %>

                        <a href="confirmarAlquiler.jsp?codigoAlquiler=<%= codigoAlquiler%>">
                            Cancelar
                        </a>

                        <%
                        } else {
                        %>
                        <br>
                        <!-- VOLVER -->
                        <br>

                        <div class="botones-inferiores">

                            <a
                                href="../inicio.jsp"
                                class="boton boton-volver">
                                Cancelar
                            </a>

                        </div>

                        <%
                            }
                        %>

                    </div>

                </form>

            </div>


            <br>

            <%
                if (!codigoAlquiler.trim().isEmpty()) {
            %>

            <a href="confirmarAlquiler.jsp?codigoAlquiler=<%= codigoAlquiler%>">
                Regresar a la solicitud
            </a>

            <%
            } else {
            %>
            <!-- VOLVER -->
            <br>

            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">
                    regresar
                </a>

            </div>
            <%
                }
            %>

        </main>
        <script src="../resources/js/registrarRutaPrivada.js"></script>
    </body>

</html>