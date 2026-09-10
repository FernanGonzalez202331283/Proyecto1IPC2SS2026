<%-- 
    Document   : listarUsuarios
    Created on : 5 sept 2026
    Author     : fernan
--%>

<%@page import="transporte.modelo.Sucursal"%>
<%@page import="transporte.dao.SucursalDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.UsuarioDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SISTEMA".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    UsuarioDAO usuarioDAO = new UsuarioDAO();

    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String accion =
                request.getParameter("accion");

        String usuarioAccion =
                request.getParameter("usuario");

        if (usuarioAccion != null &&
            !usuarioAccion.trim().isEmpty()) {

            usuarioAccion = usuarioAccion.trim();

            if ("desactivar".equals(accion)) {

                mensaje =
                        usuarioDAO.desactivar(usuarioAccion);

                if ("Usuario desactivado correctamente."
                        .equals(mensaje)) {

                    tipoMensaje = "exito";

                } else {

                    tipoMensaje = "error";
                }
            }

            else if ("activar".equals(accion)) {

    mensaje =
            usuarioDAO.activar(usuarioAccion);

    if ("Usuario activado correctamente."
            .equals(mensaje)) {

        tipoMensaje = "exito";

    } else {

        tipoMensaje = "error";
    }
}
        }
    }

    Usuario[] usuarios =
            usuarioDAO.listar();

    SucursalDAO sucursalDAO =
            new SucursalDAO();
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Usuarios del sistema</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">

        <h1>Usuarios del sistema</h1>

        <p>
            Administración de usuarios
        </p>


        <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">

                <%= mensaje %>

            </div>

        <% } %>


        <div class="formulario">

            <h2>Lista de usuarios</h2>

            <div class="tabla">

                <table id="tablaUsuarios">

                    <thead>

                        <tr>

                            <th>
                                Usuario
                            </th>

                            <th>
                                Rol
                            </th>

                            <th>
                                Sucursal
                            </th>

                            <th>
                                Estado
                            </th>

                            <th>
                                Acción
                            </th>

                        </tr>

                    </thead>


                    <tbody>

                        <%
                            if (usuarios != null &&
                                usuarios.length > 0) {

                                for (Usuario usuario : usuarios) {

                                    if (usuario == null) {
                                        continue;
                                    }
                                    String nombreSucursal =
                                            "No aplica";


                                    if (usuario.getCodigoSucursal() != null &&
                                        !usuario.getCodigoSucursal()
                                                .trim()
                                                .isEmpty()) {

                                        Sucursal sucursal =
                                                sucursalDAO.buscar(
                                                        usuario.getCodigoSucursal()
                                                );

                                        if (sucursal != null) {

                                            nombreSucursal =
                                                    sucursal.getNombre();
                                        }
                                    }
                        %>


                        <tr>

                            <td>

                                <%= usuario.getUsuario() %>

                            </td>
                            <td>

                                <%= usuario.getRol() %>

                            </td>
                            <td>

                                <%= nombreSucursal %>

                            </td>


                            <td>

                                <%
                                    if (usuario.isEstado()) {
                                %>

                                    Activo

                                <%
                                    } else {
                                %>

                                    Inactivo

                                <%
                                    }
                                %>

                            </td>


                            <td>

                                <%
                                    if (usuario.isEstado()) {
                                %>


                                    <form method="POST"
                                          style="display: inline;"
                                          onsubmit="return confirmarDesactivacion('<%= usuario.getUsuario() %>');">


                                        <input type="hidden"
                                               name="accion"
                                               value="desactivar">


                                        <input type="hidden"
                                               name="usuario"
                                               value="<%= usuario.getUsuario() %>">


                                        <button type="submit">

                                            Desactivar

                                        </button>


                                    </form>


                                <%
                                    } else {
                                %>


                                    <form method="POST"
                                          style="display: inline;"
                                          onsubmit="return confirmarActivacion('<%= usuario.getUsuario() %>');">


                                        <input type="hidden"
                                               name="accion"
                                               value="activar">


                                        <input type="hidden"
                                               name="usuario"
                                               value="<%= usuario.getUsuario() %>">


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

                            } else {
                        %>

                        <tr>

                            <td colspan="5">

                                No hay usuarios registrados.

                            </td>

                        </tr>


                        <%
                            }
                        %>

                    </tbody>

                </table>

            </div>

        </div>

        <br>
        <a href="../inicio.jsp">

            Regresar al inicio

        </a>


    </main>
    <script src="../resources/js/listarUsuarios.js"></script>


</body>

</html>