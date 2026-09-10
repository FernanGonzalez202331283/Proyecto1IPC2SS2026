<%-- 
    Document   : depreciacion
    Created on : 9 sept 2026, 17:09:37
    Author     : fernan
--%>
<%@page import="java.sql.Date"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.modelo.Configuracion"%>
<%@page import="transporte.dao.ConfiguracionDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    // Verificar sesión
    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Solo ADMIN_SISTEMA puede acceder
    if (!"ADMIN_SISTEMA".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../index.jsp");
        return;
    }

    ConfiguracionDAO configuracionDAO =
            new ConfiguracionDAO();

    String mensaje = "";
    String tipoMensaje = "";

    /*
     * Procesar formulario
     */
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String depreciacionTexto =
                request.getParameter("depreciacionPorKm");

        if (depreciacionTexto == null
                || depreciacionTexto.trim().isEmpty()) {

            mensaje =
                    "Debe ingresar la depreciación por kilómetro.";

            tipoMensaje = "error";

        } else {

            try {

                double depreciacion =
                        Double.parseDouble(
                                depreciacionTexto.trim()
                        );

                if (depreciacion < 0) {

                    mensaje =
                            "La depreciación no puede ser negativa.";

                    tipoMensaje = "error";

                } else {

                    /*
                     * Generar automáticamente el código
                     * de configuración.
                     *
                     * Ejemplo:
                     * CFG001
                     * CFG002
                     * CFG003
                     */
                    int numeroConfiguracion = 1;

                    String codigoConfiguracion;

                    do {

                        codigoConfiguracion =
                                String.format(
                                        "CFG%03d",
                                        numeroConfiguracion
                                );

                        if (configuracionDAO.obtener(
                                codigoConfiguracion
                        ) == null) {

                            break;
                        }

                        numeroConfiguracion++;

                    } while (true);


                    /*
                     * Fecha de configuración
                     */
                    Date fechaConfiguracion =
                            new Date(
                                    System.currentTimeMillis()
                            );


                    /*
                     * Crear objeto configuración
                     */
                    Configuracion configuracion =
                            new Configuracion();

                    configuracion.setCodigoConfiguracion(
                            codigoConfiguracion
                    );

                    configuracion.setDepreciacionPorKm(
                            depreciacion
                    );

                    configuracion.setFechaConfiguracion(
                            fechaConfiguracion
                    );


                    /*
                     * Guardar en la base de datos
                     */
                    boolean insertado =
                            configuracionDAO.insertar(
                                    configuracion
                            );


                    if (insertado) {

                        mensaje =
                                "Configuración guardada correctamente. "
                                + "Código: "
                                + codigoConfiguracion;

                        tipoMensaje = "exito";

                    } else {

                        mensaje =
                                "No se pudo guardar la configuración.";

                        tipoMensaje = "error";
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                        "La depreciación debe ser un número válido.";

                tipoMensaje = "error";
            }
        }
    }


    /*
     * Obtener configuración vigente
     *
     * Se realiza después del POST para que,
     * si acabamos de guardar una configuración,
     * aparezca inmediatamente como vigente.
     */
    Configuracion configuracionVigente =
            configuracionDAO.obtenerConfiguracionVigente();

%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Configuración de depreciación</title>

    <link rel="stylesheet"
          href="../resources/css/styles.css">

</head>

<body>

    <main class="pagina">


        <!-- ENCABEZADO -->

        <header class="encabezado">

            <h1>Configuración de depreciación</h1>

            <p>
                Administrador:
                <strong>
                    <%= usuarioSesion.getUsuario() %>
                </strong>
            </p>

        </header>


        <!-- FORMULARIO -->

        <section class="card-menu">

            <h2>Depreciación por kilómetro</h2>

            <p>
                Configure el valor que utilizará el sistema
                para calcular automáticamente la depreciación
                de los buses.
            </p>


            <!-- MENSAJE -->

            <% if (!mensaje.isEmpty()) { %>

                <div class="<%= tipoMensaje %>">

                    <%= mensaje %>

                </div>

            <% } %>


            <form
                method="post"
                action="depreciacion.jsp"
                id="formDepreciacion">


                <div class="formulario-grupo">

                    <label for="depreciacionPorKm">

                        Depreciación por kilómetro

                    </label>


                    <input
                        type="number"
                        id="depreciacionPorKm"
                        name="depreciacionPorKm"
                        min="0"
                        step="0.01"
                        placeholder="Ejemplo: 2.50"
                        required>


                </div>


                <div class="card-acciones">

                    <button type="submit">

                        Guardar configuración

                    </button>


                    <a href="../index.jsp">

                        Regresar

                    </a>

                </div>


            </form>

        </section>


        <!-- CONFIGURACIÓN VIGENTE -->

        <section class="card-menu">

            <h2>Configuración vigente</h2>


            <% if (configuracionVigente != null) { %>


                <p>

                    <strong>
                        Código:
                    </strong>

                    <%= configuracionVigente
                            .getCodigoConfiguracion() %>

                </p>


                <p>

                    <strong>
                        Depreciación por kilómetro:
                    </strong>

                    Q<%= String.format(
                            "%.2f",
                            configuracionVigente
                                    .getDepreciacionPorKm()
                    ) %>

                </p>


                <p>
                    <strong>
                        Fecha de configuración:
                    </strong>

                    <%= configuracionVigente
                            .getFechaConfiguracion() %>

                </p>
            <% } else { %>
                <p>
                    No existe una configuración de
                    depreciación registrada.

                </p>
            <% } %>
        </section>
        <!-- CERRAR SESIÓN -->
        <div class="cerrar-sesion">

            <form
                action="../logout.jsp"
                method="post">

                <button type="submit">

                    Cerrar sesión

                </button>

            </form>

        </div>
    </main>
    <!-- JAVASCRIPT -->
    <script
        src="../resources/js/depreciacion.js">
    </script>
</body>
</html>

