<%--
    Document   : procesarConfirmarAlquiler
    Created on : 13 sept 2026, 1:43:21
    Author     : fernan
--%>

<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Alquiler"%>
<%@page import="transporte.dao.AlquilerDAO"%>
<%@page import="transporte.dao.ViajeDAO"%>

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

    String codigoAlquiler =
            request.getParameter("codigoAlquiler");

    String codigoViaje =
            request.getParameter("codigoViaje");

    String placaBus =
            request.getParameter("placaBus");

    String numeroLicencia =
            request.getParameter("numeroLicencia");

    String precioConfirmadoParametro =
            request.getParameter("precioConfirmado");

    if (codigoAlquiler == null
            || codigoAlquiler.trim().isEmpty()
            || codigoViaje == null
            || codigoViaje.trim().isEmpty()
            || placaBus == null
            || placaBus.trim().isEmpty()
            || numeroLicencia == null
            || numeroLicencia.trim().isEmpty()
            || precioConfirmadoParametro == null
            || precioConfirmadoParametro.trim().isEmpty()) {
%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Error al confirmar alquiler</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">
</head>

<body>

<div class="contenedor">

    <h1>Error al confirmar alquiler</h1>

    <p>
        Todos los datos son obligatorios.
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

    double precioConfirmado;

    try {

        precioConfirmado =
                Double.parseDouble(
                        precioConfirmadoParametro
                );

        if (precioConfirmado <= 0) {
            throw new NumberFormatException();
        }

    } catch (NumberFormatException e) {
%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Precio inválido</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">
</head>

<body>

<div class="contenedor">

    <h1>Precio inválido</h1>

    <p>
        El precio confirmado debe ser
        un valor numérico mayor que cero.
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

    AlquilerDAO alquilerDAO =
            new AlquilerDAO();

    ViajeDAO viajeDAO =
            new ViajeDAO();

    Alquiler alquiler =
            alquilerDAO.obtener(codigoAlquiler);

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
        No se encontró el alquiler:
        <strong><%= codigoAlquiler %></strong>
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

    if (!codigoViaje.equals(alquiler.getCodigoViaje())) {
%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Error de solicitud</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">
</head>

<body>

<div class="contenedor">

    <h1>Error de solicitud</h1>

    <p>
        El viaje indicado no corresponde
        al alquiler seleccionado.
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
        Esta solicitud ya no está pendiente
        de confirmación.
    </p>

    <p>
        Estado actual:
        <strong><%= alquiler.getEstado() %></strong>
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

    boolean asignado =
            viajeDAO.asignarBusYChofer(
                    codigoViaje,
                    placaBus,
                    numeroLicencia,
                    usuarioSesion.getCodigoSucursal()
            );

    if (!asignado) {
%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>No se pudo confirmar</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">
</head>

<body>

<div class="contenedor">

    <h1>No se pudo confirmar el alquiler</h1>

    <p>
        No fue posible asignar el bus y el chofer.
    </p>

    <p>
        Puede que el bus o el chofer ya estén
        ocupados en ese horario.
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

    alquiler.setPrecioConfirmado(
            precioConfirmado
    );

    alquiler.setEstado(
            "CONFIRMADO"
    );

    boolean confirmado =
            alquilerDAO.actualizar(alquiler);

    if (!confirmado) {
%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Error al confirmar</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">
</head>

<body>

<div class="contenedor">

    <h1>Error al confirmar alquiler</h1>

    <p>
        El bus y el chofer fueron asignados,
        pero no se pudo actualizar el alquiler.
    </p>

    <p>
        El precio confirmado no pudo guardarse.
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

    response.sendRedirect(
            "alquileres.jsp?mensaje=confirmado"
    );
%>
