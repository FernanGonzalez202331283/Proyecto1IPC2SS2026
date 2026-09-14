<%-- 
    Document   : confirmarAlquiler
    Created on : 13 sept 2026, 1:31:52
    Author     : fernan
--%>


<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Alquiler"%>
<%@page import="transporte.dao.AlquilerDAO"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page import="transporte.modelo.Usuario"%>

<%
    Usuario usuarioSesion
            = (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoAlquiler
            = request.getParameter("codigoAlquiler");

    if (codigoAlquiler == null
            || codigoAlquiler.trim().isEmpty()) {

        response.sendRedirect("alquileres.jsp");
        return;
    }

    AlquilerDAO alquilerDAO
            = new AlquilerDAO();

    ViajeDAO viajeDAO
            = new ViajeDAO();

    Alquiler alquiler
            = alquilerDAO.obtener(codigoAlquiler);

    if (alquiler == null) {
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Alquiler no encontrado</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">
    </head>

    <body>

        <div class="contenedor">

            <h1>Alquiler no encontrado</h1>

            <p>
                No se encontró la solicitud:
                <strong><%= codigoAlquiler%></strong>
            </p>

            <a href="alquileres.jsp">
                Volver a alquileres
            </a>

        </div>

    </body>
</html>

<%
        return;
    }

    if (!"SOLICITADO".equals(alquiler.getEstado())) {
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Solicitud no disponible</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">
    </head>

    <body>

        <div class="contenedor">

            <h1>Solicitud no disponible</h1>

            <p>
                Esta solicitud ya no se encuentra en estado
                <strong>SOLICITADO</strong>.
            </p>

            <p>
                Estado actual:
                <strong><%= alquiler.getEstado()%></strong>
            </p>

            <a href="alquileres.jsp">
                Volver a alquileres
            </a>

        </div>

    </body>
</html>

<%
        return;
    }

    Viaje viaje
            = viajeDAO.obtenerPrivado(
                    alquiler.getCodigoViaje()
            );

    if (viaje == null) {
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Viaje no encontrado</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">
    </head>

    <body>

        <div class="contenedor">

            <h1>Viaje no encontrado</h1>

            <p>
                No se encontró el viaje asociado
                a esta solicitud.
            </p>

            <a href="alquileres.jsp">
                Volver a alquileres
            </a>

        </div>

    </body>
</html>

<%
        return;
    }

    List<Bus> buses
            = viajeDAO.listarBusesDisponiblesPorSucursal(
                    usuarioSesion.getCodigoSucursal()
            );

    List<Chofer> choferes
            = viajeDAO.listarChoferesActivosPorSucursal(
                    usuarioSesion.getCodigoSucursal()
            );
%>

<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Confirmar alquiler</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <div class="contenedor">

            <h1>Confirmar alquiler privado</h1>

            <div class="card">

                <h2>Datos de la solicitud</h2>

                <p>
                    <strong>Código de alquiler:</strong>
                    <%= alquiler.getCodigoAlquiler()%>
                </p>

                <p>
                    <strong>Código de viaje:</strong>
                    <%= alquiler.getCodigoViaje()%>
                </p>

                <p>
                    <strong>Cliente:</strong>
                    <%= alquiler.getUsuarioCliente()%>
                </p>

                <p>
                    <strong>Origen:</strong>
                    <%= viaje.getOrigen()%>
                </p>

                <p>
                    <strong>Destino:</strong>
                    <%= viaje.getDestino()%>
                </p>

                <p>
                    <strong>Número de pasajeros:</strong>
                    <%= alquiler.getNumeroPasajeros()%>
                </p>

                <p>
                    <strong>Fecha de salida:</strong>
                    <%= viaje.getFechaSalida()%>
                </p>

                <p>
                    <strong>Hora de salida:</strong>
                    <%= viaje.getHoraSalida()%>
                </p>

                <p>
                    <strong>Llegada estimada:</strong>
                    <%= viaje.getFechaLlegadaEstimada()%>
                    <%= viaje.getHoraLlegadaEstimada()%>
                </p>

                <p>
                    <strong>Fecha de retorno:</strong>

                    <%= alquiler.getFechaRetorno() != null
                            ? alquiler.getFechaRetorno()
                            : "No especificada"%>

                </p>

                <p>
                    <strong>Precio estimado:</strong>
                    Q<%= String.format(
                            "%.2f",
                            alquiler.getPrecioEstimado()
                    )%>
                </p>

                <p>
                    <strong>Estado:</strong>
                    <%= alquiler.getEstado()%>
                </p>

            </div>

            <div class="card">

                <h2>Asignar bus y chofer</h2>

                <form
                    action="procesarConfirmarAlquiler.jsp"
                    method="post">

                    <!-- Código alquiler -->
                    <input
                        type="hidden"
                        name="codigoAlquiler"
                        value="<%= alquiler.getCodigoAlquiler()%>"
                        >

                    <!-- Código viaje -->
                    <input
                        type="hidden"
                        name="codigoViaje"
                        value="<%= alquiler.getCodigoViaje()%>"
                        >
                    <div class="form-group">

                        <label for="precioConfirmado">
                            Precio confirmado:
                        </label>

                        <input
                            type="number"
                            id="precioConfirmado"
                            name="precioConfirmado"
                            step="0.01"
                            min="0.01"
                            required
                            placeholder="Ingrese el precio final"
                            >

                    </div>


                    <div class="form-group">

                        <label for="placaBus">
                            Bus:
                        </label>

                        <select
                            id="placaBus"
                            name="placaBus"
                            required
                            >

                            <option value="">
                                -- Seleccione un bus --
                            </option>

                            <%
                                if (buses != null
                                        && !buses.isEmpty()) {

                                    for (Bus bus : buses) {
                            %>

                            <option value="<%= bus.getPlaca()%>">

                                <%= bus.getPlaca()%>
                                -
                                <%= bus.getMarca()%>
                                -
                                <%= bus.getModelo()%>
                                -
                                Capacidad:
                                <%= bus.getCapacidad()%>

                            </option>

                            <%
                                }

                            } else {
                            %>

                            <option value="" disabled>

                                No hay buses disponibles

                            </option>

                            <%
                                }
                            %>

                        </select>

                    </div>

                    <div class="form-group">

                        <label for="numeroLicencia">
                            Chofer:
                        </label>

                        <select
                            id="numeroLicencia"
                            name="numeroLicencia"
                            required
                            >

                            <option value="">
                                -- Seleccione un chofer --
                            </option>

                            <%
                                if (choferes != null
                                        && !choferes.isEmpty()) {

                                    for (Chofer chofer : choferes) {
                            %>

                            <option
                                value="<%= chofer.getNumeroLicencia()%>"
                                >

                                <%= chofer.getNombreCompleto()%>
                                -
                                Licencia:
                                <%= chofer.getNumeroLicencia()%>

                            </option>

                            <%
                                }

                            } else {
                            %>

                            <option value="" disabled>

                                No hay choferes disponibles

                            </option>

                            <%
                                }
                            %>

                        </select>

                    </div>
                    <div class="acciones">

                        <button type="submit">
                            Confirmar alquiler
                        </button>

                        <a href="alquileres.jsp">
                            Cancelar
                        </a>

                    </div>

                </form>

            </div>

        </div>

    </body>

</html>