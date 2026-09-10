<%-- 
    Document   : modificarBus
    Created on : 7 sept 2026, 0:11:13
    Author     : fernan
--%>

<%@page import="transporte.dao.BusDAO"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.modelo.Usuario"%>
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

    String placa =
            request.getParameter("placa");

    if (placa == null || placa.trim().isEmpty()) {
        response.sendRedirect("buses.jsp");
        return;
    }

    placa = placa.trim();

    BusDAO busDAO = new BusDAO();

    Bus bus =
            busDAO.obtenerPorSucursal(
                    placa,
                    codigoSucursal
            );

    if (bus == null) {
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Bus no encontrado</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <div class="mensaje error">

            El bus no existe o no pertenece
            a su sucursal.

        </div>

        <br>

        <a href="buses.jsp">
            Regresar a buses
        </a>

    </main>

</body>

</html>

<%
        return;
    }

    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String foto =
                request.getParameter("foto");

        String marca =
                request.getParameter("marca");

        String modelo =
                request.getParameter("modelo");

        String anioTexto =
                request.getParameter("anioFabricacion");

        String capacidadTexto =
                request.getParameter("capacidad");

        String kilometrajeTexto =
                request.getParameter("kilometrajeActual");


        if (marca == null || marca.trim().isEmpty()) {

            mensaje = "Debe ingresar la marca.";
            tipoMensaje = "error";

        } else if (modelo == null || modelo.trim().isEmpty()) {

            mensaje = "Debe ingresar el modelo.";
            tipoMensaje = "error";

        } else if (anioTexto == null ||
                   anioTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar el año de fabricación.";
            tipoMensaje = "error";

        } else if (capacidadTexto == null ||
                   capacidadTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar la capacidad.";
            tipoMensaje = "error";

        } else if (kilometrajeTexto == null ||
                   kilometrajeTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar el kilometraje actual.";
            tipoMensaje = "error";

        } else {

            try {

                int anioFabricacion =
                        Integer.parseInt(
                                anioTexto.trim()
                        );

                int capacidad =
                        Integer.parseInt(
                                capacidadTexto.trim()
                        );

                double kilometrajeActual =
                        Double.parseDouble(
                                kilometrajeTexto.trim()
                        );


                if (capacidad <= 0) {

                    mensaje =
                            "La capacidad debe ser mayor que cero.";
                    tipoMensaje = "error";

                } else if (kilometrajeActual < 0) {

                    mensaje =
                            "El kilometraje no puede ser negativo.";
                    tipoMensaje = "error";

                } else {

                    /*
                     * La placa no se modifica.
                     * La sucursal tampoco se modifica.
                     * Ambas pertenecen al contexto original del bus.
                     */
                    bus.setCodigoSucursal(
                            codigoSucursal
                    );

                    bus.setFoto(
                            foto != null &&
                            !foto.trim().isEmpty()
                            ? foto.trim()
                            : null
                    );

                    bus.setMarca(
                            marca.trim()
                    );

                    bus.setModelo(
                            modelo.trim()
                    );

                    bus.setAñoFabricacion(
                            anioFabricacion
                    );

                    bus.setCapacidad(
                            capacidad
                    );

                    /*
                     * NO modificamos el estado operativo.
                     *
                     * El estado se mantiene como estaba.
                     * Los cambios de estado se realizarán
                     * mediante las operaciones correspondientes.
                     */
                    bus.setEstadoOperativo(
                            bus.getEstadoOperativo()
                    );

                    bus.setKilometrajeActual(
                            kilometrajeActual
                    );


                    boolean actualizado =
                            busDAO.actualizar(bus);


                    if (actualizado) {

                        response.sendRedirect(
                                "buses.jsp"
                        );
                        return;

                    } else {

                        mensaje =
                                "No se pudo modificar el bus.";
                        tipoMensaje = "error";
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                        "Los valores numéricos ingresados "
                        + "no son válidos.";

                tipoMensaje = "error";
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

    <title>Modificar Bus</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <header class="encabezado">

            <h1>Modificar Bus</h1>

            <p>
                Sucursal:
                <strong><%= codigoSucursal %></strong>
            </p>

        </header>


        <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">

                <%= mensaje %>

            </div>

        <% } %>


        <div class="formulario">

            <h2>Datos del bus</h2>

            <form method="POST">


                <div class="form-group">

                    <label for="placa">
                        Placa
                    </label>

                    <input
                        type="text"
                        id="placa"
                        name="placa"
                        value="<%= bus.getPlaca() %>"
                        readonly>

                </div>


                <div class="form-group">

                    <label for="foto">
                        Foto
                    </label>

                    <input
                        type="text"
                        id="foto"
                        name="foto"
                        maxlength="500"
                        value="<%= bus.getFoto() != null
                                ? bus.getFoto()
                                : "" %>">

                    <small>
                        Por ahora puede ingresar la ruta
                        o referencia de la fotografía.
                    </small>

                </div>


                <div class="form-group">

                    <label for="marca">
                        Marca
                    </label>

                    <input
                        type="text"
                        id="marca"
                        name="marca"
                        maxlength="100"
                        value="<%= bus.getMarca() %>"
                        required>

                </div>


                <div class="form-group">

                    <label for="modelo">
                        Modelo
                    </label>

                    <input
                        type="text"
                        id="modelo"
                        name="modelo"
                        maxlength="100"
                        value="<%= bus.getModelo() %>"
                        required>

                </div>


                <div class="form-group">

                    <label for="anioFabricacion">
                        Año de fabricación
                    </label>

                    <input
                        type="number"
                        id="anioFabricacion"
                        name="anioFabricacion"
                        min="1900"
                        max="2100"
                        value="<%= bus.getAñoFabricacion() %>"
                        required>

                </div>


                <div class="form-group">

                    <label for="capacidad">
                        Capacidad de pasajeros
                    </label>

                    <input
                        type="number"
                        id="capacidad"
                        name="capacidad"
                        min="1"
                        value="<%= bus.getCapacidad() %>"
                        required>

                </div>


                <div class="form-group">

                    <label>
                        Estado operativo
                    </label>

                    <input
                        type="text"
                        value="<%= bus.getEstadoOperativo() %>"
                        readonly>

                    <small>
                        El estado operativo se administra
                        mediante las operaciones correspondientes.
                    </small>

                </div>


                <div class="form-group">

                    <label for="kilometrajeActual">
                        Kilometraje actual
                    </label>

                    <input
                        type="number"
                        id="kilometrajeActual"
                        name="kilometrajeActual"
                        min="0"
                        step="0.01"
                        value="<%= bus.getKilometrajeActual() %>"
                        required>

                </div>


                <button type="submit">
                    Guardar cambios
                </button>

            </form>

        </div>


        <br>


        <a href="buses.jsp">
            Regresar a buses
        </a>

    </main>

</body>

</html>