<%-- 
    Document   : alquiler
    Created on : 11 sept 2026, 13:13:03
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

    if (!"CLIENTE".equals(usuario.getRol())) {
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

        <title>Solicitar alquiler</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>
    <body>
        <main class="pagina">
            <header class="encabezado">
                <h1>Solicitar alquiler privado</h1>
                <p>
                    Solicita un bus para realizar un viaje privado.
                </p>
                <p>
                    Usuario:
                    <strong>
                        <%= usuario.getUsuario()%>
                    </strong>
                </p>
            </header>

            <div class="card-menu">
                <h2>Datos del viaje</h2>
                <form method="post"
                      action="procesarAlquiler.jsp"
                      id="formAlquiler">
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


                    <!-- NUMERO DE PASAJEROS -->
                    <div class="form-group">
                        <label for="numeroPasajeros">
                            Número de pasajeros
                        </label>
                        <input
                            type="number"
                            id="numeroPasajeros"
                            name="numeroPasajeros"
                            min="1"
                            step="1"
                            required>
                    </div>

                    <!-- FECHA DE SALIDA -->
                    <div class="form-group">
                        <label for="fechaSalida">
                            Fecha de salida
                        </label>
                        <input
                            type="date"
                            id="fechaSalida"
                            name="fechaSalida"
                            required>
                    </div>

                    <!-- HORA DE SALIDA -->
                    <div class="form-group">
                        <label for="horaSalida">
                            Hora de salida
                        </label>
                        <input
                            type="time"
                            id="horaSalida"
                            name="horaSalida"
                            required>

                    </div>

                    <!-- FECHA DE LLEGADA ESTIMADA -->
                    <div class="form-group">
                        <label for="fechaLlegada">
                            Fecha de llegada estimada
                        </label>
                        <input
                            type="date"
                            id="fechaLlegada"
                            name="fechaLlegada"
                            required>

                    </div>

                    <!-- HORA DE LLEGADA ESTIMADA -->
                    <div class="form-group">
                        <label for="horaLlegada">
                            Hora de llegada estimada
                        </label>

                        <input
                            type="time"
                            id="horaLlegada"
                            name="horaLlegada"
                            required>

                    </div>
                    <!-- FECHA DE RETORNO -->
                    <div class="form-group">

                        <label for="fechaRetorno">
                            Fecha de retorno
                        </label>

                        <input
                            type="date"
                            id="fechaRetorno"
                            name="fechaRetorno">

                        <small>
                            Déjala vacía si el viaje es solamente de ida.
                        </small>

                    </div>


                    <div class="form-actions">

                        <button type="submit">
                            Solicitar alquiler
                        </button>
                    </div>
                    
                      <div class="botones-inferiores">
                        <a
                            href="../inicio.jsp"
                            class="boton boton-volver">
                            Cancelar
                        </a>
                    </div>

                </form>

            </div>
              <div class="botones-inferiores">
                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal
                </a>
            </div>

        </main>
            <script src="../resources/js/alquiler.js"></script>
    </body>

</html>
