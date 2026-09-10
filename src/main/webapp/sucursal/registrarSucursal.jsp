<%-- 
    Document   : registrarSucursal
    Created on : 5 sept 2026, 17:43:01
    Author     : fernan
--%>

<%@page import="transporte.dao.SucursalDAO"%>
<%@page import="transporte.modelo.Sucursal"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    SucursalDAO sucursalDAO = new SucursalDAO();

    String mensaje = "";
    String tipoMensaje = "";

    String accion = request.getParameter("accion");

    if ("registrar".equals(accion)) {

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

                Sucursal existente = sucursalDAO.buscar(codigo);

                if (existente != null) {

                    mensaje = "Ya existe una sucursal con ese código.";
                    tipoMensaje = "error";

                } else {

                    double latitud = Double.parseDouble(latitudTexto);
                    double longitud = Double.parseDouble(longitudTexto);

                    Sucursal sucursal = new Sucursal(
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

                    if (sucursalDAO.insertar(sucursal)) {

                        mensaje = "Sucursal registrada correctamente.";
                        tipoMensaje = "exito";

                    } else {

                        mensaje = "No se pudo registrar la sucursal.";
                        tipoMensaje = "error";
                    }
                }

            } catch (NumberFormatException e) {

                mensaje = "La latitud y longitud deben ser valores numéricos.";
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

    <title>Registrar sucursal</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

    <script src="../resources/js/sucursales.js"></script>

</head>

<body>

    <div class="pagina">

        <h1>Registrar sucursal</h1>

        <p>
            Registra una nueva sucursal de la empresa.
        </p>


        <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje %>">
                <%= mensaje %>
            </div>

        <% } %>


        <section class="formulario">

            <h2>Información de la sucursal</h2>

            <form method="post"
                  onsubmit="return validarSucursal();">

                <input type="hidden"
                       name="accion"
                       value="registrar">


                <div class="form-group">

                    <label for="codigo">
                        Código de sucursal:
                    </label>

                    <input type="text"
                           id="codigo"
                           name="codigo"
                           required>

                </div>


                <div class="form-group">

                    <label for="nombre">
                        Nombre:
                    </label>

                    <input type="text"
                           id="nombre"
                           name="nombre"
                           required>

                </div>


                <div class="form-group">

                    <label for="direccion">
                        Dirección:
                    </label>

                    <input type="text"
                           id="direccion"
                           name="direccion"
                           required>

                </div>


                <div class="form-group">

                    <label for="telefono">
                        Teléfono:
                    </label>

                    <input type="text"
                           id="telefono"
                           name="telefono"
                           required>

                </div>


                <div class="form-group">

                    <label for="municipio">
                        Municipio:
                    </label>

                    <input type="text"
                           id="municipio"
                           name="municipio"
                           required>

                </div>


                <div class="form-group">

                    <label for="departamento">
                        Departamento:
                    </label>

                    <input type="text"
                           id="departamento"
                           name="departamento"
                           required>

                </div>


                <div class="form-group">

                    <label for="latitud">
                        Latitud:
                    </label>

                    <input type="number"
                           id="latitud"
                           name="latitud"
                           step="any"
                           required>

                </div>


                <div class="form-group">

                    <label for="longitud">
                        Longitud:
                    </label>

                    <input type="number"
                           id="longitud"
                           name="longitud"
                           step="any"
                           required>

                </div>


                <button type="submit">
                    Registrar sucursal
                </button>

            </form>

        </section>

        <br>

        <a href="../inicio.jsp">
            Volver al menú principal
        </a>

    </div>

</body>

</html>

