<%-- 
    Document   : modificarRuta
    Created on : 16 sept 2026
    Author     : fernan
--%>

<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Ruta"%>
<%@page import="transporte.modelo.Sucursal"%>
<%@page import="transporte.dao.RutaDAO"%>
<%@page import="transporte.dao.SucursalDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    String codigoRuta =
            request.getParameter("codigoRuta");

    String mensaje = "";
    String tipoMensaje = "";

    String codigoSucursalDestino = "";
    String distanciaTexto = "";
    String precioTexto = "";

    RutaDAO rutaDAO = new RutaDAO();

    if (codigoRuta == null || codigoRuta.trim().isEmpty()) {

        response.sendRedirect("ruta.jsp");
        return;
    }

    codigoRuta = codigoRuta.trim();

    Ruta ruta = rutaDAO.obtener(codigoRuta);

    if (ruta == null) {

        mensaje = "La ruta que desea modificar no existe.";
        tipoMensaje = "error";

    } else if (!codigoSucursal.equals(
            ruta.getCodigoSucursalOrigen())) {

        mensaje =
                "No tienes permiso para modificar esta ruta.";

        tipoMensaje = "error";

    } else {

        codigoSucursalDestino =
                ruta.getCodigoSucursalDestino();

        distanciaTexto =
                String.valueOf(ruta.getDistanciaKm());

        precioTexto =
                String.valueOf(ruta.getPrecioBoleto());
    }

    if ("POST".equalsIgnoreCase(request.getMethod())
            && ruta != null
            && codigoSucursal.equals(
                    ruta.getCodigoSucursalOrigen())) {

        codigoSucursalDestino =
                request.getParameter("codigoSucursalDestino");

        distanciaTexto =
                request.getParameter("distanciaKm");

        precioTexto =
                request.getParameter("precioBoleto");

        if (codigoSucursalDestino != null) {
            codigoSucursalDestino =
                    codigoSucursalDestino.trim();
        }

        if (distanciaTexto != null) {
            distanciaTexto =
                    distanciaTexto.trim();
        }

        if (precioTexto != null) {
            precioTexto =
                    precioTexto.trim();
        }
        if (codigoSucursalDestino == null
                || codigoSucursalDestino.isEmpty()
                || distanciaTexto == null
                || distanciaTexto.isEmpty()
                || precioTexto == null
                || precioTexto.isEmpty()) {

            mensaje =
                    "Todos los campos obligatorios deben ser completados.";

            tipoMensaje = "error";

        } else if (codigoSucursal.equals(
                codigoSucursalDestino)) {

            mensaje =
                    "La sucursal de destino debe ser diferente "
                    + "a la sucursal de origen.";

            tipoMensaje = "error";

        } else {

            try {

                double distanciaKm =
                        Double.parseDouble(distanciaTexto);

                double precioBoleto =
                        Double.parseDouble(precioTexto);

                if (distanciaKm <= 0) {

                    mensaje =
                            "La distancia debe ser mayor que cero.";

                    tipoMensaje = "error";

                } else if (precioBoleto < 0) {

                    mensaje =
                            "El precio del boleto no puede ser negativo.";

                    tipoMensaje = "error";

                } else {

                    SucursalDAO sucursalDAO =
                            new SucursalDAO();

                    Sucursal sucursalDestino =
                            sucursalDAO.buscar(
                                    codigoSucursalDestino
                            );

                    if (sucursalDestino == null) {

                        mensaje =
                                "La sucursal de destino no existe.";

                        tipoMensaje = "error";

                    } else if (!sucursalDestino.isEstado()) {

                        mensaje =
                                "La sucursal de destino está inactiva.";

                        tipoMensaje = "error";

                    } else {
                        Ruta rutaActualizada =
                                new Ruta(
                                        codigoRuta,
                                        codigoSucursal,
                                        codigoSucursalDestino,
                                        distanciaKm,
                                        precioBoleto,
                                        ruta.isEstado()
                                );


                        boolean actualizado =
                                rutaDAO.actualizar(
                                        rutaActualizada
                                );


                        if (actualizado) {

                            response.sendRedirect("ruta.jsp");
                            return;

                        } else {

                            mensaje =
                                    "No se pudo modificar la ruta.";

                            tipoMensaje = "error";
                        }
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                        "La distancia y el precio deben ser números válidos.";

                tipoMensaje = "error";
            }
        }
    }
    SucursalDAO sucursalDAO =
            new SucursalDAO();

    List<Sucursal> sucursales =
            sucursalDAO.listar();
%>

<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>Modificar Ruta</title>

        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <!-- ENCABEZADO -->

            <header class="encabezado">

                <h1>
                    Modificar Ruta
                </h1>

                <p>
                    Actualiza la información de la ruta
                    seleccionada.
                </p>

                <p>
                    Sucursal de origen:
                    <strong>
                        <%= codigoSucursal%>
                    </strong>
                </p>

            </header>


            <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje%>">

                <%= mensaje%>

            </div>

            <% } %>


            <% if (ruta != null
                    && codigoSucursal.equals(
                            ruta.getCodigoSucursalOrigen())) { %>


            <!-- FORMULARIO -->

            <section class="formulario">

                <h2>
                    Información de la ruta
                </h2>

                <form
                    id="formularioModificarRuta"
                    method="POST"
                    action="modificarRuta.jsp?codigoRuta=<%= codigoRuta%>">


                    <!-- CÓDIGO -->

                    <div class="campo">

                        <label for="codigoRuta">
                            Código de ruta
                        </label>

                        <input
                            type="text"
                            id="codigoRuta"
                            value="<%= codigoRuta%>"
                            readonly>

                        <p class="campo-ayuda">
                            El código de la ruta no puede modificarse.
                        </p>

                    </div>


                    <!-- ORIGEN -->

                    <div class="campo">

                        <label for="origen">
                            Sucursal de origen
                        </label>

                        <input
                            type="text"
                            id="origen"
                            value="<%= codigoSucursal%>"
                            readonly>

                        <p class="campo-ayuda">
                            La sucursal de origen pertenece
                            automáticamente a tu cuenta.
                        </p>

                    </div>


                    <!-- DESTINO -->

                    <div class="campo">

                        <label for="codigoSucursalDestino">
                            Sucursal de destino
                            <span class="obligatorio">*</span>
                        </label>

                        <select
                            id="codigoSucursalDestino"
                            name="codigoSucursalDestino"
                            required>

                            <option value="">
                                -- Seleccione la sucursal destino --
                            </option>

                            <%
                                boolean hayDestinos = false;

                                for (Sucursal sucursal : sucursales) {

                                    if (sucursal.isEstado()
                                            && !codigoSucursal.equals(
                                                    sucursal.getCodigoSucursal())) {

                                        hayDestinos = true;
                            %>

                            <option
                                value="<%= sucursal.getCodigoSucursal()%>"
                                <%= sucursal.getCodigoSucursal()
                                        .equals(codigoSucursalDestino)
                                        ? "selected"
                                        : ""%>>

                                <%= sucursal.getNombre()%>
                                -
                                <%= sucursal.getCodigoSucursal()%>

                            </option>

                            <%
                                    }
                                }
                            %>

                        </select>

                        <p
                            id="mensajeDestino"
                            class="campo-error">
                        </p>

                        <% if (!hayDestinos) { %>

                        <div class="sin-destinos">

                            No existen otras sucursales activas
                            disponibles como destino.

                        </div>

                        <% } %>

                    </div>


                    <!-- DISTANCIA -->

                    <div class="campo">

                        <label for="distanciaKm">

                            Distancia en kilómetros

                            <span class="obligatorio">
                                *
                            </span>

                        </label>

                        <input
                            type="number"
                            id="distanciaKm"
                            name="distanciaKm"
                            min="0.01"
                            step="0.01"
                            value="<%= distanciaTexto%>"
                            required>

                        <p
                            id="mensajeDistancia"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- PRECIO -->

                    <div class="campo">

                        <label for="precioBoleto">

                            Precio del boleto

                            <span class="obligatorio">
                                *
                            </span>

                        </label>

                        <input
                            type="number"
                            id="precioBoleto"
                            name="precioBoleto"
                            min="0"
                            step="0.01"
                            value="<%= precioTexto%>"
                            required>

                        <p
                            id="mensajePrecio"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- BOTONES -->

                    <div class="botones-formulario">

                        <button
                            type="submit"
                            class="boton">

                            Guardar cambios

                        </button>

                    </div>

                </form>

            </section>


            <% } %>


            <!-- VOLVER -->

            <div class="botones-inferiores">

                <a
                    href="ruta.jsp"
                    class="boton boton-volver">

                    Volver a rutas

                </a>

            </div>

        </main>


        <script
            src="../resources/js/registrarRuta.js">
        </script>
    </body>
</html>
