<%-- 
    Document   : inicio
    Created on : 4 sept 2026, 1:36:36
    Author     : fernan
--%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario
            = (Usuario) session.getAttribute("usuario");

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
                    <strong><%= usuario.getUsuario()%></strong>
                </p>
                <p>
                    Rol:
                    <strong><%= usuario.getRol()%></strong>
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
                        <a href="sistema/reporteGanancias.jsp">
                            reporte de ganancias
                        </a>
                        <a href="sistema/reporteRutas.jsp">
                            Reporte de Rutas
                        </a>
                        <a href="sistema/reporteCostos.jsp">
                            reporte de costos
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
                
           <div class="card-menu">
    <div class="card-icon">
    </div>

    <h3>Alquileres privados</h3>

    <p>
        Gestiona las solicitudes y rutas privadas.
    </p>

    <div class="card-acciones">

        <a href="sucursal/alquileres.jsp">
            Gestionar alquileres
        </a>

        <a href="sucursal/registrarRutaPrivada.jsp">
            Registrar ruta privada
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
                y los mantenimientos realizados
                a los buses.
            </p>

            <div class="card-acciones">

                <a href="sucursal/mantenimientos.jsp">
                    Gestionar mantenimientos
                </a>

            </div>

            </div>

            <!-- REPUESTOS -->

            <div class="card-menu">
            <div class="card-icon">
            </div>

            <h3>Repuestos</h3>

            <p>
                Administra los repuestos disponibles
                para los mantenimientos de los buses.
            </p>

            <div class="card-acciones">

                <a href="sucursal/repuestos.jsp">
                    Gestionar repuestos
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

                        <a href="sucursal/reporteBuses.jsp">
                            Reportes de Buses
                        </a>
                        <a href="sucursal/reporteChoferes.jsp">
                            Reportes de Choferes
                        </a>
                        <a href="sucursal/reporteBoletos.jsp">
                            Reportes de Boletos
                        </a>
                        <a href="sucursal/reporteAlquileres.jsp">
                            Reportes de Alquileres
                        </a>
                        <a href="sucursal/reporteDepreciacion.jsp">
                            Reportes de depreciacion
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


                <!-- MIS BOLETOS -->
                <div class="card-menu">

                    <div class="card-icon">
                    </div>

                    <h3>Mis boletos</h3>

                    <p>
                        Consulta los boletos que
                        has comprado.
                    </p>

                    <div class="card-acciones">

                        <a href="cliente/boletos.jsp">
                            Ver mis boletos
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
                         <a href="cliente/misAlquileres.jsp">
                            Respuesta de solicitud de alquiler
                        </a>

                    </div>

                </div>
                
                <!-- MI CARTERA -->
                <div class="card-menu">

                    <div class="card-icon">
                        </div>

                            <h3>Mi cartera</h3>

                            <p>
                                Consulta tu saldo y realiza
                                recargas para tus compras.
                            </p>

                            <div class="card-acciones">

                                <a href="cliente/cartera.jsp">
                                    Ver mi cartera
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