<%-- 
    Document   : choferes
    Created on : 8 sept 2026, 22:27:58
    Author     : fernan
--%>
<%@page import="java.util.List"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page import="transporte.dao.ChoferDAO"%>

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
    // LISTAR CHOFERES DE LA SUCURSAL
    // ==========================================

    ChoferDAO choferDAO = new ChoferDAO();

    List<Chofer> choferes =
            choferDAO.listarPorSucursal(codigoSucursal);
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestionar Choferes</title>

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
            max-width: 1200px;
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

            <h1>Gestionar Choferes</h1>

            <p class="subtitulo">
                Choferes registrados en la sucursal
                <strong><%= codigoSucursal %></strong>
            </p>

        </div>

        <div>

            <a href="registrarChofer.jsp"
               class="boton">

                Registrar nuevo chofer

            </a>

        </div>

    </div>


    <% if (choferes.isEmpty()) { %>

        <div class="mensaje-vacio">

            No hay choferes registrados para esta sucursal.

        </div>

    <% } else { %>


        <div class="tabla-contenedor">

            <table>

                <thead>

                    <tr>

                        <th>Licencia</th>
                        <th>Nombre</th>
                        <th>Tipo de licencia</th>
                        <th>Vencimiento</th>
                        <th>Teléfono</th>
                        <th>Salario por viaje</th>
                        <th>Estado</th>
                        <th>Acciones</th>

                    </tr>

                </thead>

                <tbody>

                <% for (Chofer chofer : choferes) { %>

                    <tr>

                        <td>
                            <%= chofer.getNumeroLicencia() %>
                        </td>

                        <td>
                            <%= chofer.getNombreCompleto() %>
                        </td>

                        <td>
                            <%= chofer.getTipoLicencia() %>
                        </td>

                        <td>
                            <%= chofer.getFechaVencimientoLicencia() %>
                        </td>

                        <td>
                            <%= chofer.getTelefono() %>
                        </td>

                        <td>
                            Q <%= String.format("%.2f",
                                    chofer.getSalarioBaseViaje()) %>
                        </td>

                        <td>

                            <% if (chofer.isEstado()) { %>

                                <span class="estado-activo">
                                    Activo
                                </span>

                            <% } else { %>

                                <span class="estado-inactivo">
                                    Inactivo
                                </span>

                            <% } %>

                        </td>

                        <td>

                            <div class="acciones">

                                <a href="modificarChofer.jsp?numeroLicencia=<%= chofer.getNumeroLicencia() %>"
                                   class="boton boton-modificar">

                                    Modificar

                                </a>


                                <% if (chofer.isEstado()) { %>

                                    <a href="desactivarChofer.jsp?numeroLicencia=<%= chofer.getNumeroLicencia() %>"
                                       class="boton boton-desactivar"
                                       onclick="return confirmarDesactivacion();">

                                        Desactivar

                                    </a>

                                <% } else { %>

                                    <a href="activarChofer.jsp?numeroLicencia=<%= chofer.getNumeroLicencia() %>"
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

        return confirm(
            "¿Está seguro de que desea desactivar este chofer?"
        );

    }

</script>

</body>

</html>
