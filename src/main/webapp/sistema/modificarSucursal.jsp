<%-- 
    Document   : modificarSucursal
    Created on : 5 sept 2026, 17:56:06
    Author     : fernan
--%>
<%@page import="java.util.List"%>
<%@page import="transporte.dao.SucursalDAO"%>
<%@page import="transporte.modelo.Sucursal"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SISTEMA".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    SucursalDAO sucursalDAO = new SucursalDAO();

    String mensaje = "";
    String tipoMensaje = "";
    String accion = request.getParameter("accion");

    if ("modificar".equals(accion)) {

        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String municipio = request.getParameter("municipio");
        String departamento = request.getParameter("departamento");

        String latitudTexto = request.getParameter("latitud");
        String longitudTexto = request.getParameter("longitud");

        if (codigo != null && nombre != null
                && direccion != null && telefono != null
                && municipio != null && departamento != null
                && latitudTexto != null && longitudTexto != null) {

            try {

                double latitud = Double.parseDouble(latitudTexto);
                double longitud = Double.parseDouble(longitudTexto);

                Sucursal sucursalModificada = new Sucursal(
                        codigo,
                        nombre,
                        direccion,
                        telefono,
                        municipio,
                        departamento,
                        latitud,
                        longitud,
                        true
                );

                if (sucursalDAO.actualizar(sucursalModificada)) {

                    mensaje = "Sucursal modificada correctamente.";
                    tipoMensaje = "exito";

                } else {

                    mensaje = "No se pudo modificar la sucursal.";
                    tipoMensaje = "error";
                }

            } catch (NumberFormatException e) {

                mensaje = "La latitud y longitud deben ser valores numéricos.";
                tipoMensaje = "error";
            }
        }
    }
    List<Sucursal> sucursales = sucursalDAO.listar();
%>


<!DOCTYPE html>
<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Modificar sucursal</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

        <script src="../resources/js/sucursales.js"></script>

    </head>

    <body>

        <main class="pagina">

            <div class="encabezado">

                <div>

                    <h1>Modificar sucursal</h1>

                    <p class="subtitulo">
                        Seleccione una sucursal para modificar su información.
                    </p>

                </div>

            </div>


            <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">
                <%= mensaje %>
            </div>

            <% } %>


            <!-- SELECCIONAR SUCURSAL -->

            <section class="formulario">

                <h2>Seleccionar sucursal</h2>

                <div class="campo">

                    <label for="seleccionarSucursal">
                        Sucursal
                    </label>

                    <select
                        id="seleccionarSucursal"
                        onchange="mostrarSucursal()">

                        <option value="">
                            -- Seleccione una sucursal --
                        </option>

                        <%
                            for (Sucursal sucursal : sucursales) {

                                if (sucursal != null) {
                        %>

                        <option
                            value="<%= sucursal.getCodigoSucursal() %>"
                            data-nombre="<%= sucursal.getNombre() %>"
                            data-direccion="<%= sucursal.getDireccion() %>"
                            data-telefono="<%= sucursal.getTelefono() %>"
                            data-municipio="<%= sucursal.getMunicipio() %>"
                            data-departamento="<%= sucursal.getDepartamento() %>"
                            data-latitud="<%= sucursal.getLatitud() %>"
                            data-longitud="<%= sucursal.getLongitud() %>"
                            >

                            <%= sucursal.getCodigoSucursal() %>
                            -
                            <%= sucursal.getNombre() %>

                        </option>

                        <%
                                }
                            }
                        %>

                    </select>

                </div>

            </section>


            <!-- FORMULARIO DE MODIFICACIÓN -->

            <section
                class="formulario"
                id="formularioModificar"
                style="display: none;">

                <h2>Información de la sucursal</h2>

                <div
                    id="mensajeSucursal"
                    class="mensaje">
                </div>


                <form
                    method="post"
                    onsubmit="return validarSucursal();">

                    <input
                        type="hidden"
                        name="accion"
                        value="modificar">


                    <!-- CÓDIGO -->

                    <div class="form-group">

                        <label for="codigo">
                            Código
                        </label>

                        <input
                            type="text"
                            id="codigo"
                            name="codigo"
                            readonly>

                    </div>


                    <!-- NOMBRE -->

                    <div class="form-group">

                        <label for="nombre">
                            Nombre
                        </label>

                        <input
                            type="text"
                            id="nombre"
                            name="nombre"
                            maxlength="100">

                        <p
                            id="mensajeNombre"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- DIRECCIÓN -->

                    <div class="form-group">

                        <label for="direccion">
                            Dirección
                        </label>

                        <input
                            type="text"
                            id="direccion"
                            name="direccion"
                            maxlength="250">

                        <p
                            id="mensajeDireccion"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- TELÉFONO -->

                    <div class="form-group">

                        <label for="telefono">
                            Teléfono
                        </label>

                        <input
                            type="text"
                            id="telefono"
                            name="telefono"
                            maxlength="8"
                            inputmode="numeric">

                        <p
                            id="mensajeTelefono"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- MUNICIPIO -->

                    <div class="form-group">

                        <label for="municipio">
                            Municipio
                        </label>

                        <input
                            type="text"
                            id="municipio"
                            name="municipio"
                            maxlength="100">

                        <p
                            id="mensajeMunicipio"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- DEPARTAMENTO -->

                    <div class="form-group">

                        <label for="departamento">
                            Departamento
                        </label>

                        <input
                            type="text"
                            id="departamento"
                            name="departamento"
                            maxlength="100">

                        <p
                            id="mensajeDepartamento"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- LATITUD -->

                    <div class="form-group">

                        <label for="latitud">
                            Latitud
                        </label>

                        <input
                            type="number"
                            step="any"
                            id="latitud"
                            name="latitud">

                        <p
                            id="mensajeLatitud"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- LONGITUD -->

                    <div class="form-group">

                        <label for="longitud">
                            Longitud
                        </label>

                        <input
                            type="number"
                            step="any"
                            id="longitud"
                            name="longitud">

                        <p
                            id="mensajeLongitud"
                            class="campo-error">
                        </p>

                    </div>


                    <!-- BOTONES -->

                    <div class="botones">

                        <a
                            href="../inicio.jsp"
                            class="boton boton-volver">

                            Cancelar

                        </a>

                        <button
                            type="submit"
                            class="boton-principal">

                            Guardar cambios

                        </button>

                    </div>

                </form>

            </section>


            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal

                </a>

            </div>

        </main>

    </body>

</html>