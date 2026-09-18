<%-- 
    Document   : confirmarAlquiler
    Created on : 13 sept 2026, 1:31:52
    Author     : fernan
--%>
<%@page import="transporte.dao.ConfiguracionDAO"%>
<%@page import="transporte.modelo.Configuracion"%>
<%@page import="transporte.dao.RutaPrivadaDAO"%>
<%@page import="transporte.modelo.RutaPrivada"%>
<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Alquiler"%>
<%@page import="transporte.dao.AlquilerDAO"%>
<%@page import="transporte.modelo.Viaje"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page import="transporte.modelo.Bus"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page import="transporte.modelo.Usuario"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

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

<html lang="es">
<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Alquiler no encontrado</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">

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

    </main>

</body>

</html>

<%
return;
}

if (!"SOLICITADO".equals(alquiler.getEstado())) {

%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Solicitud no disponible</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">

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

    </main>

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

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Viaje no encontrado</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">

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

    </main>

</body>

</html>

<%
return;
}

RutaPrivadaDAO rutaPrivadaDAO
        = new RutaPrivadaDAO();

RutaPrivada rutaPrivada
        = rutaPrivadaDAO.buscarPorOrigenDestino(
                viaje.getOrigen(),
                viaje.getDestino()
        );

if (rutaPrivada == null) {

%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Ruta no registrada</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <div class="contenedor">

            <h1>Ruta privada no registrada</h1>

            <div class="card">

                <h2>Solicitud de alquiler</h2>

                <p>
                    <strong>Código de alquiler:</strong>
                    <%= alquiler.getCodigoAlquiler()%>
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
                    No existe una ruta privada registrada
                    para este origen y destino.
                </p>

                <p>
                    Debe registrar la ruta antes de poder
                    confirmar el alquiler.
                </p>

                <form action="registrarRutaPrivada.jsp"
                      method="post">

                    <input
                        type="hidden"
                        name="origen"
                        value="<%= viaje.getOrigen()%>"
                        >

                    <input
                        type="hidden"
                        name="destino"
                        value="<%= viaje.getDestino()%>"
                        >

                    <input
                        type="hidden"
                        name="codigoAlquiler"
                        value="<%= alquiler.getCodigoAlquiler()%>"
                        >

                    <button type="submit">
                        Registrar ruta
                    </button>

                </form>

                <br>

                <a href="alquileres.jsp">
                    Volver a solicitudes
                </a>

            </div>

        </div>

    </main>

</body>

</html>

<%
return;
}
ConfiguracionDAO configuracionDAO
        = new ConfiguracionDAO();

Configuracion configuracion
        = configuracionDAO.obtenerConfiguracionVigente();

double precioEstimadoActual = 0;
boolean precioDisponible = false;

if (configuracion != null
        && configuracion.getPrecioKmAlquilerPrivado() > 0) {

    precioEstimadoActual
            = rutaPrivada.getDistanciaKm()
            * configuracion.getPrecioKmAlquilerPrivado();

    precioDisponible = true;
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

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Confirmar alquiler</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">

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
                    <strong>Distancia:</strong>

                    <%= String.format(
                            "%.2f",
                            rutaPrivada.getDistanciaKm()
                    )%>

                    km
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
                    -
                    <%= viaje.getHoraLlegadaEstimada()%>
                </p>

                <p>
                    <strong>Fecha de retorno:</strong>

                    <%= alquiler.getFechaRetorno() != null
                            ? alquiler.getFechaRetorno()
                            : "No especificada"%>

                </p>


                <%
                    if (precioDisponible) {
                %>

                <p>
                    <strong>Precio estimado:</strong>

                    Q<%= String.format(
                            "%.2f",
                            precioEstimadoActual
                    )%>
                </p>

                <%
                    } else {
                %>

                <div class="mensaje error">

                    <strong>
                        Precio no disponible
                    </strong>

                    <p>
                        No existe una configuración válida
                        para calcular el precio del alquiler privado.
                    </p>

                </div>

                <%
                    }
                %>


                <p>
                    <strong>Estado:</strong>
                    <%= alquiler.getEstado()%>
                </p>

            </div>


            <%
                if (precioDisponible) {
            %>


            <div class="card">

                <h2>Asignar bus y chofer</h2>

                <form
                    id="formularioConfirmarAlquiler"
                    action="procesarConfirmarAlquiler.jsp"
                    method="post">


                    <input
                        type="hidden"
                        name="codigoAlquiler"
                        value="<%= alquiler.getCodigoAlquiler()%>"
                        >


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
                            value="<%= String.format(
                                    "%.2f",
                                    precioEstimadoActual
                            )%>"
                            required
                            placeholder="Ingrese el precio final"
                            >

                        <p id="mensajePrecio"
                           class="campo-error"></p>

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

                        <p id="mensajeBus"
                           class="campo-error"></p>

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

                        <p id="mensajeChofer"
                           class="campo-error"></p>

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


            <%
                } else {
            %>


            <div class="card">

                <a href="alquileres.jsp">
                    Volver a solicitudes
                </a>

            </div>


            <%
                }
            %>


        </div>

    </main>
    <script src="../resources/js/confirmarAlquiler.js"></script>
</body>
</html>
