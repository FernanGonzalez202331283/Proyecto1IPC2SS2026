<%-- 
    Document   : alquileres
    Created on : 13 sept 2026, 0:06:35
    Author     : fernan
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="transporte.conexion.Conexion"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Alquileres privados</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Alquileres privados</h1>

                <p>
                    Gestiona las solicitudes de alquiler realizadas
                    por los clientes.
                </p>

                <p>
                    Administrador:
                    <strong>
                        <%= usuario.getUsuario()%>
                    </strong>
                </p>

            </header>

            <div class="card-menu">

                <h2>Solicitudes de alquiler</h2>

                <%
                    String sql = """
                        SELECT
                            a.codigo_alquiler,
                            a.codigo_viaje,
                            a.usuario_cliente,
                            a.numero_pasajeros,
                            a.fecha_retorno,
                            a.precio_estimado,
                            a.precio_confirmado,
                            a.estado,

                            v.origen,
                            v.destino,
                            v.fecha_salida,
                            v.hora_salida,
                            v.fecha_llegada_estimada,
                            v.hora_llegada_estimada

                        FROM alquiler a

                        INNER JOIN viaje v
                            ON a.codigo_viaje = v.codigo_viaje

                        ORDER BY a.codigo_alquiler DESC
                        """;

                    boolean hayAlquileres = false;

                    try (
                            Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                        while (rs.next()) {

                            hayAlquileres = true;

                            String codigoAlquiler
                                    = rs.getString("codigo_alquiler");

                            String codigoViaje
                                    = rs.getString("codigo_viaje");

                            String estado
                                    = rs.getString("estado");

                            String cliente
                                    = rs.getString("usuario_cliente");

                            String origen
                                    = rs.getString("origen");

                            String destino
                                    = rs.getString("destino");
                %>

                <div class="card-menu">

                    <h3>
                        Alquiler:
                        <%= codigoAlquiler%>
                    </h3>


                    <!-- CLIENTE -->

                    <p>
                        <strong>Cliente:</strong>
                        <%= cliente%>
                    </p>


                    <!-- ORIGEN -->

                    <p>
                        <strong>Origen:</strong>
                        <%= origen%>
                    </p>


                    <!-- DESTINO -->

                    <p>
                        <strong>Destino:</strong>
                        <%= destino%>
                    </p>


                    <!-- FECHA DE SALIDA -->

                    <p>
                        <strong>Fecha de salida:</strong>
                        <%= rs.getDate("fecha_salida")%>
                    </p>


                    <!-- HORA DE SALIDA -->

                    <p>
                        <strong>Hora de salida:</strong>
                        <%= rs.getTime("hora_salida")%>
                    </p>


                    <!-- LLEGADA ESTIMADA -->

                    <p>

                        <strong>Llegada estimada:</strong>

                        <%= rs.getDate("fecha_llegada_estimada")%>

                        -

                        <%= rs.getTime("hora_llegada_estimada")%>

                    </p>


                    <!-- CODIGO DEL VIAJE -->

                    <p>
                        <strong>Viaje:</strong>
                        <%= codigoViaje%>
                    </p>


                    <!-- PASAJEROS -->

                    <p>
                        <strong>Número de pasajeros:</strong>
                        <%= rs.getInt("numero_pasajeros")%>
                    </p>


                    <!-- FECHA DE RETORNO -->

                    <p>

                        <strong>Fecha de retorno:</strong>

                        <%
                            if (rs.getDate("fecha_retorno") != null) {
                        %>

                        <%= rs.getDate("fecha_retorno")%>

                        <%
                        } else {
                        %>

                        No especificada

                        <%
                            }
                        %>

                    </p>


                    <!-- PRECIO ESTIMADO -->

                    <p>

                        <strong>Precio estimado:</strong>

                        Q<%= String.format(
                                "%.2f",
                                rs.getDouble("precio_estimado")
                )%>

                    </p>


                    <!-- PRECIO CONFIRMADO -->

                    <p>

                        <strong>Precio confirmado:</strong>

                        <%
                            Object precioConfirmado
                                    = rs.getObject("precio_confirmado");

                            if (precioConfirmado != null) {
                        %>

                        Q<%= String.format(
                                "%.2f",
                                rs.getDouble("precio_confirmado")
                    )%>

                        <%
                        } else {
                        %>

                        Pendiente

                        <%
                            }
                        %>

                    </p>


                    <!-- ESTADO -->

                    <p>

                        <strong>Estado:</strong>

                        <%= estado%>

                    </p>

                    <div class="card-acciones">

                        <%
                            if ("SOLICITADO".equals(estado)) {
                        %>

                        <a href="confirmarAlquiler.jsp?codigoAlquiler=<%= codigoAlquiler%>">
                            Gestionar solicitud
                        </a>

                        <%
                        } else if ("CONFIRMADO".equals(estado)) {
                        %>

                        <a href="confirmarAlquiler.jsp?codigoAlquiler=<%= codigoAlquiler%>">
                            Ver alquiler
                        </a>

                        <%
                        } else {
                        %>

                        <a href="confirmarAlquiler.jsp?codigoAlquiler=<%= codigoAlquiler%>">
                            Ver detalles
                        </a>

                        <%
                            }
                        %>

                    </div>

                </div>


                <%
                    }

                } catch (Exception e) {
                %>

                <div class="card-menu">

                    <p>

                        <strong>
                            Ocurrió un error al consultar
                            los alquileres:
                        </strong>

                        <%= e.getMessage()%>

                    </p>

                </div>


                <%
                    }

                    if (!hayAlquileres) {
                %>


                <div class="card-menu">

                    <p>
                        Actualmente no existen solicitudes
                        de alquiler privado.
                    </p>

                </div>


                <%
                    }
                %>

            </div>
            <br>

            <a href="../inicio.jsp">
                Regresar al inicio
            </a>

        </main>

    </body>

</html>

