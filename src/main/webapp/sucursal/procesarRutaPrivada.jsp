<%-- 
    Document   : procesarRutaPrivada
    Created on : 12 sept 2026, 18:37:13
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

    String origen = request.getParameter("origen");
    String destino = request.getParameter("destino");
    String distanciaParametro = request.getParameter("distanciaKm");

    boolean correcto = false;
    String mensaje = "";

    if (origen == null
            || origen.trim().isEmpty()
            || destino == null
            || destino.trim().isEmpty()
            || distanciaParametro == null
            || distanciaParametro.trim().isEmpty()) {

        mensaje = "Todos los campos son obligatorios.";

    } else {

        origen = origen.trim();
        destino = destino.trim();

        double distanciaKm;

        try {

            distanciaKm = Double.parseDouble(distanciaParametro.trim());
            if (distanciaKm <= 0) {
                mensaje = "La distancia debe ser mayor que cero.";
            } else if (origen.equalsIgnoreCase(destino)) {

                mensaje = "El origen y destino no pueden ser iguales.";

            } else {

                RutaPrivadaDAO rutaDAO= new RutaPrivadaDAO();

                // Verificar si la ruta ya existe
                RutaPrivada rutaExistente
                        = rutaDAO.buscarPorOrigenDestino(
                                origen,
                                destino
                        );

                if (rutaExistente != null) {

                    mensaje = "La ruta ya existe en el sistema.";

                } else {

                    String codigoRuta = "RP-" + System.currentTimeMillis();

                    RutaPrivada ruta = new RutaPrivada();
                    ruta.setCodigoRutaPrivada(codigoRuta );
                    ruta.setOrigen(origen);
                    ruta.setDestino( destino);
                    ruta.setDistanciaKm(distanciaKm);
                    ruta.setEstado(true);
                    correcto = rutaDAO.insertar(ruta);

                    if (correcto) {

                        mensaje
                                = "La ruta privada fue registrada correctamente.";

                    } else {

                        mensaje
                                = "No se pudo registrar la ruta privada.";
                    }
                }
            }

        } catch (NumberFormatException e) {

            mensaje
                    = "La distancia ingresada no es válida.";
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Resultado</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Registro de ruta privada</h1>

            </header>


            <div class="card-menu">

                <% if (correcto) {%>

                <h2>Ruta registrada correctamente</h2>

                <p>
                    <%= mensaje%>
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
                    <%= distanciaParametro%> km
                </p>


                <% } else {%>

                <h2>No se pudo registrar la ruta</h2>

                <p>
                    <%= mensaje%>
                </p>

                <% }%>


                <div class="card-acciones">

                    <a href="registrarRutaPrivada.jsp">
                        Registrar otra ruta
                    </a>

                    <a href="../inicio.jsp">
                        Regresar al inicio
                    </a>

                </div>

            </div>

        </main>

    </body>

</html>
