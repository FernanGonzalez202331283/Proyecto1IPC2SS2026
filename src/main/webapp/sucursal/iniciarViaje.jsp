<%-- 
    Document   : iniciarViaje
    Created on : 9 sept 2026, 0:06:52
    Author     : fernan
--%>

<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.ViajeDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
Usuario usuarioSesion =
        (Usuario) session.getAttribute("usuario");

String rolSesion =
        (String) session.getAttribute("rol");

// =========================================
// Verificar sesión y rol
// =========================================

if (usuarioSesion == null
        || rolSesion == null
        || !"ADMIN_SUCURSAL".equals(rolSesion)) {

    response.sendRedirect("../login.jsp");
    return;
}

// =========================================
// Datos de sesión
// =========================================

String codigoSucursal =
        usuarioSesion.getCodigoSucursal();

String usuarioRegistro =
        usuarioSesion.getUsuario();

// =========================================
// Obtener código del viaje
// =========================================

String codigoViaje =
        request.getParameter("codigoViaje");

if (codigoViaje == null
        || codigoViaje.trim().isEmpty()) {

    response.sendRedirect("viajes.jsp");
    return;
}

codigoViaje =
        codigoViaje.trim();

String mensaje = "";
boolean exito = false;

// =========================================
// Procesar formulario
// =========================================

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String horaRealSalida =
            request.getParameter("horaRealSalida");

    // =========================================
    // Validar hora
    // =========================================

    if (horaRealSalida == null
            || horaRealSalida.trim().isEmpty()) {

        mensaje =
                "Debe ingresar la hora real de salida.";

    } else {

        try {

            horaRealSalida =
                    horaRealSalida.trim();

            // =========================================
            // input type="time" normalmente devuelve
            // HH:mm, pero Time.valueOf necesita
            // HH:mm:ss
            // =========================================

            if (horaRealSalida.length() == 5) {

                horaRealSalida += ":00";
            }

            // =========================================
            // Iniciar viaje
            // =========================================

            ViajeDAO viajeDAO =
                    new ViajeDAO();

            exito =
                    viajeDAO.iniciarViaje(
                            codigoViaje,
                            codigoSucursal,
                            horaRealSalida,
                            usuarioRegistro
                    );

            if (exito) {

                response.sendRedirect(
                        "viajes.jsp"
                );

                return;

            } else {

                mensaje =
                        "No se pudo iniciar el viaje. "
                        + "Verifique que el viaje esté "
                        + "programado, pertenezca a su "
                        + "sucursal y que el bus esté "
                        + "disponible.";
            }

        } catch (IllegalArgumentException e) {

            mensaje =
                    "La hora de salida no tiene "
                    + "un formato válido.";
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

    <title>Registrar salida</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

<div class="container">

    <h1>Registrar salida del viaje</h1>

    <p>
        Viaje:
        <strong>
            <%= codigoViaje %>
        </strong>
    </p>

    <p>
        Registre la hora real en la que el bus
        inicia el viaje.
    </p>

    <p>
        <strong>
            El kilometraje inicial será tomado
            automáticamente del kilometraje actual
            registrado para el bus.
        </strong>
    </p>

    <% if (!mensaje.isEmpty()) { %>

        <div class="mensaje">
            <%= mensaje %>
        </div>

    <% } %>

    <form method="post"
          action="iniciarViaje.jsp?codigoViaje=<%= codigoViaje %>">

        <div class="form-group">

            <label for="horaRealSalida">
                Hora real de salida:
            </label>

            <input
                type="time"
                id="horaRealSalida"
                name="horaRealSalida"
                required>

        </div>

        <div class="form-actions">

            <button type="submit">
                Registrar salida
            </button>

            <a href="viajes.jsp">
                Cancelar
            </a>

        </div>

    </form>

</div>

</body>

</html>