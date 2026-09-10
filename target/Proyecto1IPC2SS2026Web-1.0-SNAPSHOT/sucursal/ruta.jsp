<%-- 
    Document   : ruta
    Created on : 8 sept 2026, 22:42:23
    Author     : fernan
--%>
<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Ruta"%>
<%@page import="transporte.dao.RutaDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // ==========================================
    // VERIFICAR SESIÓN
    // ==========================================

    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    String rolSesion =
            (String) session.getAttribute("rol");

    if (usuarioSesion == null
            || rolSesion == null
            || !"ADMIN_SUCURSAL".equals(rolSesion)) {

        response.sendRedirect("../login.jsp");
        return;
    }

    // ==========================================
    // OBTENER SUCURSAL DEL ADMINISTRADOR
    // ==========================================

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    // ==========================================
    // LISTAR RUTAS DE LA SUCURSAL
    // ==========================================

    RutaDAO rutaDAO = new RutaDAO();

    List<Ruta> rutas =
            rutaDAO.listarPorSucursal(codigoSucursal);
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestionar Rutas</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 30px;
        }

        .contenedor {
            max-width: 1100px;
            margin: auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.15);
        }

        .encabezado {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        h1 {
            margin: 0;
        }

        .subtitulo {
            color: #666;
            margin-top: 8px;
        }

        .boton {
            display: inline-block;
            padding: 10px 16px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            background-color: #007bff;
        }

        .boton:hover {
            background-color: #0056b3;
        }

        .boton-volver {
            background-color: #6c757d;
        }

        .boton-volver:hover {
            background-color: #545b62;
        }

        .tabla-contenedor {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th,
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            white-space: nowrap;
        }

        th {
            background-color: #f1f3f5;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .estado-activo {
            color: green;
            font-weight: bold;
        }

        .estado-inactivo {
            color: red;
            font-weight: bold;
        }

        .acciones {
            display: flex;
            gap: 8px;
        }

        .boton-modificar {
            background-color: #ffc107;
            color: #212529;
        }

        .boton-modificar:hover {
            background-color: #e0a800;
        }

        .boton-desactivar {
            background-color: #dc3545;
        }

        .boton-desactivar:hover {
            background-color: #c82333;
        }

        .boton-activar {
            background-color: #28a745;
        }

        .boton-activar:hover {
            background-color: #218838;
        }

        .mensaje-vacio {
            text-align: center;
            padding: 30px;
            color: #666;
            font-size: 16px;
        }

        .botones-inferiores {
            margin-top: 25px;
        }

    </style>

</head>

<body>

<div class="contenedor">

    <div class="encabezado">

        <div>

            <h1>Gestionar Rutas</h1>

            <p class="subtitulo">
                Rutas que salen de la sucursal
                <strong><%= codigoSucursal %></strong>
            </p>

        </div>

        <div>

            <a href="registrarRuta.jsp"
               class="boton">

                Registrar nueva ruta

            </a>

        </div>

    </div>


    <% if (rutas.isEmpty()) { %>

        <div class="mensaje-vacio">

            No hay rutas registradas para esta sucursal.

        </div>

    <% } else { %>


        <div class="tabla-contenedor">

            <table>

                <thead>

                    <tr>

                        <th>Código</th>
                        <th>Origen</th>
                        <th>Destino</th>
                        <th>Distancia</th>
                        <th>Precio boleto</th>
                        <th>Estado</th>
                        <th>Acciones</th>

                    </tr>

                </thead>

                <tbody>

                <% for (Ruta ruta : rutas) { %>

                    <tr>

                        <td>
                            <%= ruta.getCodigoRuta() %>
                        </td>

                        <td>
                            <%= ruta.getCodigoSucursalOrigen() %>
                        </td>

                        <td>
                            <%= ruta.getCodigoSucursalDestino() %>
                        </td>

                        <td>
                            <%= String.format("%.2f",
                                    ruta.getDistanciaKm()) %>
                            km
                        </td>

                        <td>
                            Q <%= String.format("%.2f",
                                    ruta.getPrecioBoleto()) %>
                        </td>

                        <td>

                            <% if (ruta.isEstado()) { %>

                                <span class="estado-activo">
                                    Activa
                                </span>

                            <% } else { %>

                                <span class="estado-inactivo">
                                    Inactiva
                                </span>

                            <% } %>

                        </td>

                        <td>

                            <div class="acciones">

                                <a href="modificarRuta.jsp?codigoRuta=<%= ruta.getCodigoRuta() %>"
                                   class="boton boton-modificar">

                                    Modificar

                                </a>


                                <% if (ruta.isEstado()) { %>

                                    <a href="desactivarRuta.jsp?codigoRuta=<%= ruta.getCodigoRuta() %>"
                                       class="boton boton-desactivar"
                                       onclick="return confirmarDesactivacion();">

                                        Desactivar

                                    </a>

                                <% } else { %>

                                    <a href="activarRuta.jsp?codigoRuta=<%= ruta.getCodigoRuta() %>"
                                       class="boton boton-activar">

                                        Activar

                                    </a>

                                <% } %>

                            </div>

                        </td>

                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>


    <% } %>


    <div class="botones-inferiores">

        <a href="../inicio.jsp"
           class="boton boton-volver">

            Volver al inicio

        </a>

    </div>

</div>


<script>

    function confirmarDesactivacion() {

    }

</script>

</body>

</html>