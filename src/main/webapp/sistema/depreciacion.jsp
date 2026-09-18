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
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");// Verificar sesión
    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SISTEMA".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../index.jsp");
        return;
    }

    ConfiguracionDAO configuracionDAO
            = new ConfiguracionDAO();

    String mensaje = "";
    String tipoMensaje = "";

    String depreciacionTexto
            = request.getParameter("depreciacionPorKm");

    if (depreciacionTexto == null) {
        depreciacionTexto = "";
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        if (depreciacionTexto.trim().isEmpty()) {

            mensaje
                    = "Debe ingresar la depreciación por kilómetro.";

            tipoMensaje = "error";

        } else {

            try {

                double depreciacion
                        = Double.parseDouble(
                                depreciacionTexto.trim()
                        );

                if (depreciacion < 0) {

                    mensaje
                            = "La depreciación no puede ser negativa.";

                    tipoMensaje = "error";

                } else {

                    int numeroConfiguracion = 1;

                    String codigoConfiguracion;

                    do {

                        codigoConfiguracion
                                = String.format(
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

                    Date fechaConfiguracion
                            = new Date(
                                    System.currentTimeMillis()
                            );

                    Configuracion configuracion
                            = new Configuracion();

                    configuracion.setCodigoConfiguracion(
                            codigoConfiguracion
                    );

                    configuracion.setDepreciacionPorKm(
                            depreciacion
                    );
                    
                    configuracion.setPrecioKmAlquilerPrivado(
                            depreciacion
                    );

                    configuracion.setFechaConfiguracion(
                            fechaConfiguracion
                    );

                    boolean insertado
                            = configuracionDAO.insertar(
                                    configuracion
                            );

                    if (insertado) {

                        mensaje
                                = "Configuración guardada correctamente. "
                                + "Código: "
                                + codigoConfiguracion;

                        tipoMensaje = "exito";

                        // Limpiar solamente si se guardó correctamente
                        depreciacionTexto = "";

                    } else {

                        mensaje
                                = "No se pudo guardar la configuración.";

                        tipoMensaje = "error";
                    }
                }

            } catch (NumberFormatException e) {

                mensaje
                        = "La depreciación debe ser un número válido.";

                tipoMensaje = "error";
            }
        }
    }

    Configuracion configuracionVigente = configuracionDAO.obtenerConfiguracionVigente();
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

        <div class="pagina">

            <!-- ENCABEZADO -->

            <h1>
                Configuración de depreciación
            </h1>

            <p>
                Administrador:
                <strong>
                    <%= usuarioSesion.getUsuario()%>
                </strong>
            </p>


            <!-- FORMULARIO -->

            <section class="formulario">

                <h2>
                    Depreciación por kilómetro
                </h2>

                <p>
                    Configure el valor que utilizará el sistema
                    para calcular automáticamente la depreciación
                    de los buses.
                </p>


                <!-- MENSAJE -->

                <% if (!mensaje.isEmpty()) {%>

                <div class="mensaje <%= tipoMensaje%>">

                    <%= mensaje%>

                </div>

                <% }%>


                <form
                    method="post"
                    action="depreciacion.jsp"
                    id="formDepreciacion">


                    <div class="form-group">

                        <label for="depreciacionPorKm">

                            Depreciación por kilómetro:

                        </label>

                        <input
                            type="number"
                            id="depreciacionPorKm"
                            name="depreciacionPorKm"
                            min="0"
                            step="0.01"
                            placeholder="Ejemplo: 2.50"
                            value="<%= depreciacionTexto%>"
                            required>

                    </div>


                    <button type="submit">

                        Guardar configuración

                    </button>


                </form>

            </section>


            <!-- CONFIGURACIÓN VIGENTE -->

            <section class="formulario">

                <h2>
                    Configuración vigente
                </h2>


                <% if (configuracionVigente != null) {%>

                <div class="form-group">

                    <label>
                        Código:
                    </label>

                    <input
                        type="text"
                        value="<%= configuracionVigente.getCodigoConfiguracion()%>"
                        readonly>

                </div>


                <div class="form-group">

                    <label>
                        Depreciación por kilómetro:
                    </label>

                    <input
                        type="text"
                        value="Q<%= String.format(
                                "%.2f",
                                configuracionVigente
                                        .getDepreciacionPorKm()
                        )%>"
                        readonly>

                </div>


                <div class="form-group">

                    <label>
                        Fecha de configuración:
                    </label>

                    <input
                        type="text"
                        value="<%= configuracionVigente.getFechaConfiguracion()%>"
                        readonly>

                </div>


                <% } else { %>

                <p>
                    No existe una configuración de
                    depreciación registrada.
                </p>

                <% }%>

            </section>


            <!-- BOTÓN VOLVER -->

            <div class="botones-inferiores">

                <a
                    href="../inicio.jsp"
                    class="boton boton-volver">

                    Volver al menú principal

                </a>

            </div>

        <!-- JAVASCRIPT -->
        <script
            src="../resources/js/depreciacion.js">
        </script>

    </body>
</html>
