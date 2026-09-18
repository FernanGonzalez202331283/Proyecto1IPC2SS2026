<%-- 
    Document   : modificarChofer
    Created on : 16 sept 2026, 1:48:25
    Author     : fernan
--%>
<%@page import="transporte.dao.ChoferDAO"%>
<%@page import="transporte.modelo.Chofer"%>
<%@page import="transporte.modelo.Usuario"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"ADMIN_SUCURSAL".equals(usuarioSesion.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    String codigoSucursal =
            usuarioSesion.getCodigoSucursal();

    String numeroLicencia =
            request.getParameter("numeroLicencia");

    if (numeroLicencia == null
            || numeroLicencia.trim().isEmpty()) {

        response.sendRedirect("choferes.jsp");
        return;
    }

    numeroLicencia =
            numeroLicencia.trim();

    ChoferDAO choferDAO =
            new ChoferDAO();

    Chofer chofer =
            choferDAO.obtener(numeroLicencia);

    if (chofer == null
            || !codigoSucursal.equals(
                    chofer.getCodigoSucursal())) {

        response.sendRedirect("choferes.jsp");
        return;
    }

    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String foto =
                request.getParameter("foto");

        String nombreCompleto =
                request.getParameter("nombreCompleto");

        String tipoLicencia =
                request.getParameter("tipoLicencia");

        String fechaVencimiento =
                request.getParameter(
                        "fechaVencimientoLicencia");

        String telefono =
                request.getParameter("telefono");

        String salarioTexto =
                request.getParameter(
                        "salarioBaseViaje");

        if (foto == null) {
            foto = "";
        }

        if (nombreCompleto == null) {
            nombreCompleto = "";
        }

        if (tipoLicencia == null) {
            tipoLicencia = "";
        }

        if (fechaVencimiento == null) {
            fechaVencimiento = "";
        }

        if (telefono == null) {
            telefono = "";
        }

        if (salarioTexto == null) {
            salarioTexto = "";
        }

        foto = foto.trim();
        nombreCompleto = nombreCompleto.trim();
        tipoLicencia = tipoLicencia.trim();
        fechaVencimiento = fechaVencimiento.trim();
        telefono = telefono.trim();
        salarioTexto = salarioTexto.trim();

        if (nombreCompleto.isEmpty()
                || tipoLicencia.isEmpty()
                || fechaVencimiento.isEmpty()
                || telefono.isEmpty()
                || salarioTexto.isEmpty()) {

            mensaje =
                    "Todos los campos obligatorios deben completarse.";

            tipoMensaje = "error";

        } else if (nombreCompleto.matches(".*\\d.*")) {

            mensaje =
                    "El nombre completo no debe contener números.";

            tipoMensaje = "error";

        } else if (nombreCompleto.length() < 3) {

            mensaje =
                    "Ingrese un nombre completo válido.";

            tipoMensaje = "error";

        } else if (!telefono.matches("\\d{8}")) {

            mensaje =
                    "El teléfono debe contener exactamente 8 dígitos.";

            tipoMensaje = "error";

        } else {

            try {

                double salarioBaseViaje =
                        Double.parseDouble(salarioTexto);

                if (salarioBaseViaje < 0) {

                    mensaje =
                            "El salario no puede ser negativo.";

                    tipoMensaje = "error";

                } else {
                    chofer.setFoto(foto);
                    chofer.setNombreCompleto(
                            nombreCompleto);
                    chofer.setTipoLicencia(
                            tipoLicencia);
                    chofer.setFechaVencimientoLicencia(
                            fechaVencimiento);
                    chofer.setTelefono(telefono);
                    chofer.setSalarioBaseViaje(
                            salarioBaseViaje);

                    boolean actualizado =
                            choferDAO.actualizar(chofer);

                    if (actualizado) {

                        response.sendRedirect(
                                "choferes.jsp");

                        return;

                    } else {

                        mensaje =
                                "No se pudo actualizar el chofer.";

                        tipoMensaje = "error";
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                        "El salario debe ser un número válido.";

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

        <title>Modificar Chofer</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Modificar chofer</h1>

                <p>
                    Actualice la información del chofer.
                </p>

            </header>


            <% if (!mensaje.isEmpty()) { %>

            <div class="mensaje <%= tipoMensaje%>">

                <%= mensaje%>

            </div>

            <% } %>


            <div class="card-menu">

                <form action="modificarChofer.jsp?numeroLicencia=<%= chofer.getNumeroLicencia()%>"
                      method="post"
                      id="formularioModificarChofer">


                    <!-- LICENCIA -->

                    <div class="form-group">

                        <label for="numeroLicencia">
                            Número de licencia
                        </label>

                        <input type="text"
                               id="numeroLicencia"
                               value="<%= chofer.getNumeroLicencia()%>"
                               readonly>

                    </div>


                    <!-- FOTO -->

                    <div class="form-group">

                        <label for="foto">
                            Foto
                        </label>

                        <input type="text"
                               id="foto"
                               name="foto"
                               maxlength="250"
                               value="<%= chofer.getFoto() != null
                                           ? chofer.getFoto()
                                           : ""%>">

                        <p id="mensajeFoto"
                           class="campo-error"></p>

                    </div>


                    <!-- NOMBRE -->

                    <div class="form-group">

                        <label for="nombreCompleto">
                            Nombre completo
                        </label>

                        <input type="text"
                               id="nombreCompleto"
                               name="nombreCompleto"
                               maxlength="150"
                               value="<%= chofer.getNombreCompleto()%>"
                               required>

                        <p id="mensajeNombre"
                           class="campo-error"></p>

                    </div>


                    <!-- TIPO LICENCIA -->

                    <div class="form-group">

                        <label for="tipoLicencia">
                            Tipo de licencia
                        </label>

                        <input type="text"
                               id="tipoLicencia"
                               name="tipoLicencia"
                               maxlength="50"
                               value="<%= chofer.getTipoLicencia()%>"
                               required>

                        <p id="mensajeTipoLicencia"
                           class="campo-error"></p>

                    </div>


                    <!-- VENCIMIENTO -->

                    <div class="form-group">

                        <label for="fechaVencimientoLicencia">
                            Fecha de vencimiento
                        </label>

                        <input type="date"
                               id="fechaVencimientoLicencia"
                               name="fechaVencimientoLicencia"
                               value="<%= chofer.getFechaVencimientoLicencia()%>"
                               required>

                        <p id="mensajeFecha"
                           class="campo-error"></p>

                    </div>


                    <!-- TELEFONO -->

                    <div class="form-group">

                        <label for="telefono">
                            Teléfono
                        </label>

                        <input type="text"
                               id="telefono"
                               name="telefono"
                               maxlength="8"
                               value="<%= chofer.getTelefono()%>"
                               required>

                        <p id="mensajeTelefono"
                           class="campo-error"></p>

                    </div>


                    <!-- SALARIO -->

                    <div class="form-group">

                        <label for="salarioBaseViaje">
                            Salario por viaje
                        </label>

                        <input type="number"
                               id="salarioBaseViaje"
                               name="salarioBaseViaje"
                               min="0"
                               step="0.01"
                               value="<%= chofer.getSalarioBaseViaje()%>"
                               required>

                        <p id="mensajeSalario"
                           class="campo-error"></p>

                    </div>


                    <!-- BOTONES -->

                    <div class="form-actions">

                        <button type="submit">
                            Guardar cambios
                        </button>
                    </div>
                    <div class="botones-inferiores">

                            <a href="choferes.jsp"  
                               class="boton boton-volver">
             
                            Cancelar
                            </a>
                    </div>

                </form>

            </div>

        </main>


        <script src="../resources/js/modificarChofer.js"></script>

    </body>

</html>

