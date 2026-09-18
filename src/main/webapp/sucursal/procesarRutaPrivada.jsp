<%-- 
    Document   : procesarRutaPrivada
    Created on : 12 sept 2026, 18:35:07
    Author     : fernan
--%>

<%@page import="transporte.dao.RutaPrivadaDAO"%>
<%@page import="transporte.modelo.RutaPrivada"%>
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

    String distanciaKmTexto
            = request.getParameter("distanciaKm");

    String codigoAlquiler
            = request.getParameter("codigoAlquiler");

    boolean correcto = false;

    String mensaje = "";

    String codigoRutaGenerado = "";

    double distanciaKm = 0;

    if (origen == null
            || origen.trim().isEmpty()
            || destino == null
            || destino.trim().isEmpty()
            || distanciaKmTexto == null
            || distanciaKmTexto.trim().isEmpty()) {

        mensaje = "Todos los campos de la ruta son obligatorios.";

    } else if (origen.trim().equalsIgnoreCase(destino.trim())) {

        mensaje = "El origen y el destino no pueden ser iguales.";

    } else {

        try {

            distanciaKm
                    = Double.parseDouble(
                            distanciaKmTexto.trim()
                    );

            if (distanciaKm <= 0) {

                mensaje
                        = "La distancia debe ser mayor que cero.";

            } else {
                RutaPrivadaDAO rutaDAO
                        = new RutaPrivadaDAO();

                RutaPrivada rutaExistente
                        = rutaDAO.buscarPorOrigenDestino(
                                origen.trim(),
                                destino.trim()
                        );


                if (rutaExistente != null) {

                    mensaje
                            = "Ya existe una ruta privada registrada "
                            + "para el origen y destino seleccionados.";

                } else {

                    codigoRutaGenerado
                            = "RP-" + System.currentTimeMillis();

                    RutaPrivada rutaPrivada
                            = new RutaPrivada();

                    rutaPrivada.setCodigoRutaPrivada(
                            codigoRutaGenerado
                    );

                    rutaPrivada.setOrigen(
                            origen.trim()
                    );

                    rutaPrivada.setDestino(
                            destino.trim()
                    );

                    rutaPrivada.setDistanciaKm(
                            distanciaKm
                    );

                    rutaPrivada.setEstado(true);

                    boolean insertado
                            = rutaDAO.insertar(
                                    rutaPrivada
                            );


                    if (insertado) {

                        correcto = true;

                        mensaje
                                = "La ruta privada fue registrada "
                                + "correctamente.";

                        if (codigoAlquiler != null
                                && !codigoAlquiler.trim().isEmpty()) {

                            response.sendRedirect(
                                    "confirmarAlquiler.jsp?codigoAlquiler="
                                    + codigoAlquiler.trim()
                            );

                            return;
                        }

                    } else {

                        mensaje
                                = "No se pudo registrar la ruta privada.";
                    }
                }
            }

        } catch (NumberFormatException e) {

            mensaje
                    = "La distancia debe ser un número válido.";

        } catch (Exception e) {

            mensaje
                    = "Ocurrió un error al registrar la ruta: "
                    + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            <%= correcto
                    ? "Ruta registrada"
                    : "Error al registrar ruta"%>
        </title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>
                    <%= correcto
                            ? "Ruta registrada correctamente"
                            : "No se pudo registrar la ruta"%>
                </h1>

            </header>


            <div class="card-menu">

                <p>
                    <%= mensaje%>
                </p>


                <%
                    if (correcto) {
                %>

                <p>
                    <strong>Código de ruta:</strong>
                    <%= codigoRutaGenerado%>
                </p>

                <p>
                    <strong>Origen:</strong>
                    <%= origen%>
                </p>

                <p>
                    <strong>Destino:</strong>
                    <%= destino%>
                </p>

                <p>
                    <strong>Distancia:</strong>
                    <%= String.format(
                            "%.2f",
                            distanciaKm
                    )%>
                    km
                </p>

                <%
                    }
                %>


                <div class="form-actions">

                    <%
                        if (correcto) {
                    %>

                    <a href="registrarRutaPrivada.jsp">
                        Registrar otra ruta
                    </a>

                    <a href="../inicio.jsp">
                        Regresar al inicio
                    </a>

                    <%
                    } else {
                        if (codigoAlquiler != null
                                && !codigoAlquiler.trim().isEmpty()) {
                    %>

                    <form action="registrarRutaPrivada.jsp"
                          method="post">

                        <input type="hidden"
                               name="origen"
                               value="<%= origen != null
                                       ? origen
                                       : ""%>">

                        <input type="hidden"
                               name="destino"
                               value="<%= destino != null
                                       ? destino
                                       : ""%>">

                        <input type="hidden"
                               name="codigoAlquiler"
                               value="<%= codigoAlquiler%>">

                        <button type="submit">
                            Volver a registrar ruta
                        </button>

                    </form>

                    <%
                        } else {
                    %>
                    <div class="botones-inferiores">

                        <a href="registrarRutaPrivada.jsp"
                            class="boton boton-volver">
                            volver a registar ruta
                        </a>

                    </div>

                    <%
                        }
                    %>
                        <!-- VOLVER -->
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

                </div>

            </div>

        </main>

    </body>

</html>