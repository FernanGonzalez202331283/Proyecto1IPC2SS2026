<%-- 
    Document   : procesarRepuesto
    Created on : 13 sept 2026, 19:40:13
    Author     : fernan
--%>

<%@page import="transporte.dao.RepuestoDAO"%>
<%@page import="transporte.modelo.Repuesto"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario
            = (Usuario) session.getAttribute("usuario");

    // Verificar sesión
    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Verificar rol
    if (!"ADMIN_SUCURSAL".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }


    // Obtener datos del formulario

    String codigoRepuesto
            = request.getParameter("codigoRepuesto");

    String nombre
            = request.getParameter("nombre");

    String descripcion
            = request.getParameter("descripcion");

    String precioTexto
            = request.getParameter("precio");


    // Validar campos obligatorios

    if (codigoRepuesto == null
            || codigoRepuesto.trim().isEmpty()
            || nombre == null
            || nombre.trim().isEmpty()
            || precioTexto == null
            || precioTexto.trim().isEmpty()) {

        response.sendRedirect("repuestos.jsp");
        return;
    }


    codigoRepuesto = codigoRepuesto.trim();
    nombre = nombre.trim();

    if (descripcion != null) {
        descripcion = descripcion.trim();
    }


    // Convertir precio

    double precio;

    try {

        precio = Double.parseDouble(
                precioTexto.trim()
        );

    } catch (NumberFormatException e) {

%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Error</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <div class="card-menu">

                <h1>Error al registrar repuesto</h1>

                <p>
                    El precio ingresado no es válido.
                </p>

                <div class="card-acciones">

                    <a href="repuestos.jsp">
                        Regresar a repuestos
                    </a>

                </div>

            </div>

        </main>

    </body>

</html>

<%
        return;
    }


    // Validar precio

    if (precio < 0) {
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Error</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <div class="card-menu">

                <h1>Error al registrar repuesto</h1>

                <p>
                    El precio no puede ser negativo.
                </p>

                <div class="card-acciones">

                    <a href="repuestos.jsp">
                        Regresar a repuestos
                    </a>

                </div>

            </div>

        </main>

    </body>

</html>

<%
        return;
    }


    // Crear objeto Repuesto

    Repuesto repuesto = new Repuesto();

    repuesto.setCodigoRepuesto(codigoRepuesto);
    repuesto.setNombre(nombre);
    repuesto.setDescripcion(descripcion);
    repuesto.setPrecio(precio);

    // Todo repuesto nuevo inicia activo
    repuesto.setEstado(true);


    // Insertar en la base de datos

    RepuestoDAO repuestoDAO
            = new RepuestoDAO();

    boolean registrado
            = repuestoDAO.insertar(repuesto);

%>


<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Registrar repuesto</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>


    <body>

        <main class="pagina">

            <div class="card-menu">

                <% if (registrado) { %>

                    <h1>Repuesto registrado</h1>

                    <p>
                        El repuesto
                        <strong>
                            <%= nombre %>
                        </strong>
                        fue registrado correctamente.
                    </p>

                <% } else { %>

                    <h1>No se pudo registrar</h1>

                    <p>
                        Ocurrió un error al guardar
                        el repuesto en la base de datos.
                    </p>

                <% } %>


                <div class="card-acciones">

                    <a href="repuestos.jsp">
                        Volver a repuestos
                    </a>

                    <a href="../inicio.jsp">
                        Ir al inicio
                    </a>

                </div>

            </div>

        </main>

    </body>

</html>

