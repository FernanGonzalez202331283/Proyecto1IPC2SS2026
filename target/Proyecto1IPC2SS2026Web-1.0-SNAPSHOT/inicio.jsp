<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario =
            (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Inicio</title>

    <link rel="stylesheet"
          href="resources/css/styles.css">

</head>

<body>

    <main class="pagina">
        <header class="encabezado">
            <h1>Panel de administración</h1>
            <p>
                Bienvenido,
                <strong><%= usuario.getUsuario() %></strong>
            </p>
            <p>
                Rol:
                <strong><%= usuario.getRol() %></strong>
            </p>
        </header>
        <div class="cards-menu">

            <div class="card-menu">

                <h3>Mi perfil</h3>

                <p>
                    Consulta y modifica tus datos personales.
                </p>

                <div class="card-acciones">

                    <a href="sistema/miPerfil.jsp">
                        Ver mi perfil
                    </a>

                </div>

            </div>

        </div>
        <%
            if (usuario.getRol().equals("ADMIN_SISTEMA")) {
        %>
            <h2>Administración del sistema</h2>
            <div class="cards-menu">
                <!-- SUCURSALES -->
                <div class="card-menu">
                    <div class="card-icon">
                    </div>
                    <h3>Gestión de sucursales</h3>
                    <p>
                        Administra las sucursales de la empresa
                        de transporte.
                    </p>
                    <div class="card-acciones">
                        <a href="sistema/registrarSucursal.jsp">
                            Registrar sucursal
                        </a>
                        <a href="sistema/modificarSucursal.jsp">
                            Modificar sucursal
                        </a>
                        <a href="sistema/listarSucursales.jsp">
                            Listar sucursales
                        </a>
                        <a href="sistema/desactivarSucursales.jsp">
                            Activar o desactivar sucursales
                        </a>
                    </div>
                </div>

                <!-- ADMINISTRADORES -->
                <div class="card-menu">
                    <h3>
                        Administradores de sucursal
                    </h3>
                    <p>
                        Administra los usuarios encargados
                        de cada sucursal.
                    </p>
                    <div class="card-acciones">
                        <a href="sistema/crearUsuario.jsp">
                            Crear administrador
                        </a>
                        <a href="sistema/listarUsuarios.jsp">
                            Listar administradores
                        </a>
                        <a href="sistema/modificarUsuario.jsp">
                            Modificar usuario
                        </a>
                    </div>

                </div>

                <!-- CONFIGURACIÓN -->
                <div class="card-menu">
                    <h3>Configuración</h3>
                    <p>
                        Configura los valores generales
                        utilizados por el sistema.
                    </p>
                    <div class="card-acciones">
                        <a href="sistema/depreciacion.jsp">
                            Configurar depreciación
                        </a>
                    </div>
                </div>

                <!-- REPORTES -->
                <div class="card-menu">
                    <h3>Reportes</h3>
                    <p>
                        Consulta los reportes generales
                        de la empresa.
                    </p>
                    <div class="card-acciones">
                        <a href="sistema/reportes.jsp">
                            Ver reportes
                        </a>
                    </div>
                </div>
            </div>

        <%
            }
        %>
                <!-- ADMINISTRADORES DE SUCURSAL -->
        <%
            if (usuario.getRol().equals("ADMIN_SUCURSAL")) {
        %>
            <h2>Administración de sucursal</h2>
            <div class="cards-menu">
                <!-- BUSES -->
                <div class="card-menu">
                    <div class="card-icon">
                    </div>
                    <h3>Buses</h3>
                    <p>
                        Administra los buses pertenecientes
                        a tu sucursal.
                    </p>
                    <div class="card-acciones">
                        <a href="sucursal/buses.jsp">
                            Gestionar buses
                        </a>
                    </div>
                </div>


                <!-- CHOFERES -->
                <div class="card-menu">
                    <div class="card-icon">
                    </div>
                    <h3>Choferes</h3>
                    <p>
                        Administra los choferes de la sucursal.
                    </p>
                    <div class="card-acciones">
                        <a href="sucursal/choferes.jsp">
                            Gestionar choferes
                        </a>
                    </div>
                </div>


                <!-- RUTAS -->
                <div class="card-menu">
                    <div class="card-icon">
                    </div>
                    <h3>Rutas</h3>
                    <p>
                        Gestiona las rutas de la sucursal.
                    </p>
                    <div class="card-acciones">
                        <a href="sucursal/ruta.jsp">
                            Gestionar rutas
                        </a>
                    </div>
                </div>


                <!-- VIAJES -->
                <div class="card-menu">
                    <div class="card-icon">
                    </div>
                    <h3>Viajes</h3>
                    <p>
                        Administra los viajes programados.
                    </p>
                    <div class="card-acciones">

                        <a href="sucursal/viajes.jsp">
                            Gestionar viajes
                        </a>
                    </div>
                </div>


                <!-- SALIDAS -->
                <div class="card-menu">
                    <div class="card-icon">
                    </div>
                    <h3>Salidas y llegadas</h3>
                    <p>
                        Registra la salida y llegada
                        de los viajes.
                    </p>
                    <div class="card-acciones">
                        <a href="sucursal/salidas.jsp">
                            Gestionar salidas
                        </a>

                    </div>

                </div>


                <!-- MANTENIMIENTOS -->
                <div class="card-menu">

                    <div class="card-icon">
                    </div>
                    <h3>Mantenimientos</h3>
                    <p>
                        Registra los gastos de taller
                        y repuestos.
                    </p>
                    <div class="card-acciones">
                        <a href="sucursal/mantenimientos.jsp">
                            Gestionar mantenimientos
                        </a>
                    </div>
                </div>


                <!-- REPORTES -->
                <div class="card-menu">
                    <div class="card-icon">
                    </div>
                    <h3>Reportes</h3>
                    <p>
                        Consulta los reportes de la sucursal.
                    </p>

                    <div class="card-acciones">

                        <a href="sucursal/reportes.jsp">
                            Ver reportes
                        </a>

                    </div>

                </div>

            </div>

        <%
            }
        %>
        <!-- cliente -->
        <%
            if (usuario.getRol().equals("CLIENTE")) {
        %>

            <h2>Área del cliente</h2>

            <div class="cards-menu">


                <!-- VIAJES -->

                <div class="card-menu">

                    <div class="card-icon">
                    </div>

                    <h3>Viajes</h3>

                    <p>
                        Consulta los viajes regulares
                        disponibles.
                    </p>

                    <div class="card-acciones">

                        <a href="cliente/viajes.jsp">
                            Ver viajes
                        </a>

                    </div>

                </div>


                <!-- BOLETOS -->

                <div class="card-menu">

                    <div class="card-icon">
                    </div>

                    <h3>Boletos</h3>

                    <p>
                        Compra boletos para viajes regulares.
                    </p>

                    <div class="card-acciones">

                        <a href="cliente/boletos.jsp">
                            Comprar boletos
                        </a>

                    </div>

                </div>


                <!-- ALQUILER -->

                <div class="card-menu">

                    <div class="card-icon">
                    </div>

                    <h3>Alquiler privado</h3>

                    <p>
                        Solicita el alquiler de un bus.
                    </p>

                    <div class="card-acciones">

                        <a href="cliente/alquiler.jsp">
                            Solicitar alquiler
                        </a>

                    </div>

                </div>


                <!-- MI CUENTA -->

                <div class="card-menu">

                    <div class="card-icon">
                    </div>

                    <h3>Mi cuenta</h3>

                    <p>
                        Administra tu perfil y cartera digital.
                    </p>

                    <div class="card-acciones">

                        <a href="cliente/perfil.jsp">
                            Mi perfil
                        </a>

                    </div>

                </div>

            </div>

        <%
            }
        %>
        <div class="cerrar-sesion">

            <form action="logout.jsp"
                  method="post">

                <button type="submit">
                    Cerrar sesión
                </button>

            </form>

        </div>

    </main>

</body>

</html>