<%-- 
    Document   : registrarRutaPrivada
    Created on : 12 sept 2026, 18:35:07
    Author     : fernan
--%>
<%@page import="transporte.dao.RutaPrivadaDAO"%>
<%@page import="transporte.modelo.RutaPrivada"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
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

                <form method="post"
                      action="procesarRutaPrivada.jsp"
                      id="formRutaPrivada">


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
                            required>

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
                            required>

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

                    </div>


                    <div class="form-actions">

                        <button type="submit">
                            Registrar ruta
                        </button>

                        <a href="../inicio.jsp">
                            Cancelar
                        </a>

                    </div>

                </form>

            </div>


            <br>

            <a href="../inicio.jsp">
                Regresar al inicio
            </a>

        </main>

    </body>

</html>
