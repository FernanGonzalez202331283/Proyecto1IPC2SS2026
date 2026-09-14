<%-- 
    Document   : procesarEstadoSucursal
    Created on : 13 sept 2026, 23:07:39
    Author     : fernan
--%>
<%@page import="transporte.dao.SucursalDAO"%>
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

String codigoSucursal = request.getParameter("codigoSucursal");
String accion = request.getParameter("accion");

if (codigoSucursal == null
        || codigoSucursal.trim().isEmpty()
        || accion == null
        || accion.trim().isEmpty()) {

    response.sendRedirect("sucursales.jsp");
    return;
}

codigoSucursal = codigoSucursal.trim();
accion = accion.trim();

SucursalDAO sucursalDAO = new SucursalDAO();

boolean resultado = false;
String mensaje = "";

if ("desactivar".equals(accion)) {

    resultado = sucursalDAO.desactivar(codigoSucursal);

    if (resultado) {
        mensaje = "La sucursal fue desactivada correctamente.";
    } else {
        mensaje = "No se pudo desactivar la sucursal.";
    }

} else if ("activar".equals(accion)) {

    resultado = sucursalDAO.activar(codigoSucursal);

    if (resultado) {
        mensaje = "La sucursal fue activada correctamente.";
    } else {
        mensaje = "No se pudo activar la sucursal.";
    }

} else {
    mensaje = "La acción solicitada no es válida.";
}

%>

<!DOCTYPE html>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Estado de sucursal</title>
    <link rel="stylesheet" href="../resources/css/styles.css">
</head>

<body>

```
<main class="login-container">

    <h1>
        Estado de sucursal
    </h1>

    <p>
        <%= mensaje %>
    </p>

    <div class="card-acciones">

        <a href="sucursales.jsp">
            Volver a sucursales
        </a>

        <a href="../inicio.jsp">
            Ir al inicio
        </a>

    </div>

</main>
</body>
</html>

