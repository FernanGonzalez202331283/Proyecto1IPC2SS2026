<%-- 
    Document   : listarSucursales
    Created on : 5 sept 2026, 18:39:05
    Author     : fernan
--%>
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
String codigo = request.getParameter("codigo");

if ("activar".equals(accion) && codigo != null) {

    if (sucursalDAO.activar(codigo)) {

        mensaje = "Sucursal activada correctamente.";
        tipoMensaje = "exito";

    } else {

        mensaje = "No se pudo activar la sucursal.";
        tipoMensaje = "error";
    }
}

if ("desactivar".equals(accion) && codigo != null) {

    if (sucursalDAO.desactivar(codigo)) {

        mensaje = "Sucursal desactivada correctamente.";
        tipoMensaje = "exito";

    } else {

        mensaje = "No se pudo desactivar la sucursal.";
        tipoMensaje = "error";
    }
}

Sucursal[] sucursales = sucursalDAO.listar();

%>

<!DOCTYPE html>

<html lang="es">

<head>
<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Listado de sucursales</title>

<link rel="stylesheet" href="../resources/css/styles.css">

<script src="../resources/js/sucursales.js"></script>

</head>

<body>

<main class="pagina">

```
<h1>Listado de sucursales</h1>

<p>
    Consulte la información de las sucursales registradas en el sistema.
</p>


<!-- MENSAJE -->

<% if (!mensaje.isEmpty()) { %>

    <div class="mensaje <%= tipoMensaje %>">

        <%= mensaje %>

    </div>

<% } %>


<!-- BUSCADOR -->

<section class="formulario">

    <label for="buscarSucursal">

        Buscar sucursal:

    </label>


    <input
        type="text"
        id="buscarSucursal"
        placeholder="Código, nombre, municipio..."
        onkeyup="filtrarSucursales()"
    >

</section>


<!-- TABLA DE SUCURSALES -->

<section class="tabla-contenedor">

    <table id="tablaSucursales">


        <thead>

            <tr>

                <th>Código</th>

                <th>Nombre</th>

                <th>Dirección</th>

                <th>Teléfono</th>

                <th>Municipio</th>

                <th>Departamento</th>

                <th>Latitud</th>

                <th>Longitud</th>

                <th>Estado</th>

                <th>Acción</th>

            </tr>

        </thead>


        <tbody>

            <%

                if (sucursales != null && sucursales.length > 0) {

                    for (Sucursal sucursal : sucursales) {

                        if (sucursal != null) {

            %>
            <tr>
                <!-- CÓDIGO -->
                <td>
                    <%= sucursal.getCodigoSucursal() %>
                </td>
                <!-- NOMBRE -->
                <td>
                    <%= sucursal.getNombre() %>
                </td>
                <!-- DIRECCIÓN -->
                <td>
                    <%= sucursal.getDireccion() %>
                </td>
                <!-- TELÉFONO -->
                <td>
                    <%= sucursal.getTelefono() %>
                </td>
                <!-- MUNICIPIO -->
                <td>
                    <%= sucursal.getMunicipio() %>
                </td>
                <!-- DEPARTAMENTO -->
                <td>
                    <%= sucursal.getDepartamento() %>
                </td>
                <!-- LATITUD -->
                <td>
                    <%= sucursal.getLatitud() %>
                </td>
                <!-- LONGITUD -->
                <td>
                    <%= sucursal.getLongitud() %>
                </td>
                <!-- ESTADO -->
                <td>
                    <%
                        if (sucursal.isEstado()) {
                    %>
                        <span class="estado activo">
                            Activa
                        </span>
                    <%
                        } else {
                    %>
                        <span class="estado inactivo">
                            Inactiva
                        </span>
                    <%
                        }
                    %>
                </td>

                <!-- ACCIÓN -->
                <td>
                    <%

                        if (sucursal.isEstado()) {

                    %>

                        <!-- DESACTIVAR -->

                        <form method="post">

                            <input
                                type="hidden"
                                name="accion"
                                value="desactivar"
                            >

                            <input
                                type="hidden"
                                name="codigo"
                                value="<%= sucursal.getCodigoSucursal() %>"
                            >

                            <button
                                type="submit"
                                onclick="return confirmarDesactivacion();"
                            >

                                Desactivar

                            </button>

                        </form>
                    <%

                        } else {

                    %>


                        <!-- ACTIVAR -->

                        <form method="post">

                            <input
                                type="hidden"
                                name="accion"
                                value="activar"
                            >

                            <input
                                type="hidden"
                                name="codigo"
                                value="<%= sucursal.getCodigoSucursal() %>"
                            >

                            <button type="submit">

                                Activar

                            </button>

                        </form>


                    <%

                        }

                    %>


                </td>


            </tr>


            <%

                        }

                    }

                } else {

            %>


            <tr>

                <td colspan="10">

                    No hay sucursales registradas.

                </td>

            </tr>


            <%

                }

            %>


        </tbody>

    </table>

</section>


<br>


<a href="../inicio.jsp">

    Volver al menú principal

</a>
</main>

</body>

</html>

