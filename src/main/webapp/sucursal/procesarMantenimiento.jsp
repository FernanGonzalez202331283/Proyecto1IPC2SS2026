<%-- 
    Document   : procesarMantenimiento
    Created on : 13 sept 2026, 19:56:02
    Author     : fernan
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="transporte.conexion.Conexion"%>
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



    String placaBus
            = request.getParameter("placaBus");

    String fecha
            = request.getParameter("fecha");

    String montoManoObraTexto
            = request.getParameter("montoManoObra");

    String descripcion
            = request.getParameter("descripcion");


    // Repuestos enviados desde el formulario

    String[] codigosRepuesto
            = request.getParameterValues("codigoRepuesto");

    String[] cantidades
            = request.getParameterValues("cantidad");


    if (placaBus == null
            || placaBus.trim().isEmpty()
            || fecha == null
            || fecha.trim().isEmpty()
            || montoManoObraTexto == null
            || montoManoObraTexto.trim().isEmpty()) {

        response.sendRedirect("mantenimientos.jsp");
        return;
    }


    placaBus = placaBus.trim();

    fecha = fecha.trim();


    if (descripcion != null) {
        descripcion = descripcion.trim();
    }



    double montoManoObra;

    try {

        montoManoObra
                = Double.parseDouble(
                        montoManoObraTexto.trim()
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

                <h1>Error</h1>

                <p>
                    El monto de mano de obra no es válido.
                </p>

                <div class="card-acciones">

                    <a href="mantenimientos.jsp">
                        Regresar
                    </a>

                </div>

            </div>

        </main>

    </body>

</html>

<%
        return;
    }


    if (montoManoObra < 0) {
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

                <h1>Error</h1>

                <p>
                    El monto de mano de obra no puede ser negativo.
                </p>

                <div class="card-acciones">

                    <a href="mantenimientos.jsp">
                        Regresar
                    </a>

                </div>

            </div>

        </main>

    </body>

</html>

<%
        return;
    }



    Connection conexion = null;

    boolean registrado = false;

    String mensajeError = "";

    double montoRepuestos = 0;

    String codigoMantenimiento = "";


    try {

        conexion = Conexion.getConnection();

        conexion.setAutoCommit(false);



        String sqlBus = """
            SELECT placa
            FROM bus
            WHERE placa = ?
              AND codigo_sucursal = ?
              AND estado_operativo <> 'INACTIVO'
            """;


        try (PreparedStatement psBus
                = conexion.prepareStatement(sqlBus)) {

            psBus.setString(1, placaBus);

            psBus.setString(
                    2,
                    usuario.getCodigoSucursal()
            );


            try (ResultSet rs
                    = psBus.executeQuery()) {

                if (!rs.next()) {

                    throw new SQLException(
                            "El bus no pertenece a la sucursal "
                            + "o está inactivo."
                    );
                }
            }
        }


        codigoMantenimiento
                = "MAN-" + System.currentTimeMillis();


        if (codigosRepuesto != null
                && cantidades != null) {


            if (codigosRepuesto.length
                    != cantidades.length) {

                throw new SQLException(
                        "Los datos de repuestos son inválidos."
                );
            }


            String sqlRepuesto = """
                SELECT precio
                FROM repuesto
                WHERE codigo_repuesto = ?
                  AND estado = TRUE
                """;


            try (PreparedStatement psRepuesto
                    = conexion.prepareStatement(
                            sqlRepuesto
                    )) {


                for (int i = 0;
                        i < codigosRepuesto.length;
                        i++) {


                    String codigo
                            = codigosRepuesto[i];


                    int cantidad;


                    try {

                        cantidad
                                = Integer.parseInt(
                                        cantidades[i]
                                );

                    } catch (NumberFormatException e) {

                        throw new SQLException(
                                "La cantidad del repuesto "
                                + codigo
                                + " no es válida."
                        );
                    }


                    // Cantidad 0 significa
                    // que el repuesto no fue utilizado.

                    if (cantidad == 0) {
                        continue;
                    }


                    if (cantidad < 0) {

                        throw new SQLException(
                                "La cantidad de un repuesto "
                                + "no puede ser negativa."
                        );
                    }


                    psRepuesto.setString(
                            1,
                            codigo
                    );


                    try (ResultSet rs
                            = psRepuesto.executeQuery()) {


                        if (!rs.next()) {

                            throw new SQLException(
                                    "El repuesto "
                                    + codigo
                                    + " no existe o está inactivo."
                            );
                        }


                        double precio
                                = rs.getDouble("precio");


                        montoRepuestos
                                += cantidad * precio;
                    }
                }
            }
        }


        String sqlMantenimiento = """
            INSERT INTO mantenimiento
            (
                codigo_mantenimiento,
                placa_bus,
                fecha,
                monto_mano_obra,
                monto_repuestos,
                descripcion
            )
            VALUES (?, ?, ?, ?, ?, ?)
            """;


        try (PreparedStatement psMantenimiento
                = conexion.prepareStatement(
                        sqlMantenimiento
                )) {


            psMantenimiento.setString(
                    1,
                    codigoMantenimiento
            );


            psMantenimiento.setString(
                    2,
                    placaBus
            );


            psMantenimiento.setDate(
                    3,
                    java.sql.Date.valueOf(fecha)
            );


            psMantenimiento.setDouble(
                    4,
                    montoManoObra
            );


            psMantenimiento.setDouble(
                    5,
                    montoRepuestos
            );


            psMantenimiento.setString(
                    6,
                    descripcion
            );


            psMantenimiento.executeUpdate();
        }


        // ==============================
        // INSERTAR DETALLES
        // ==============================

        if (codigosRepuesto != null
                && cantidades != null) {


            String sqlDetalle = """
                INSERT INTO detalle_mantenimiento
                (
                    codigo_mantenimiento,
                    codigo_repuesto,
                    cantidad,
                    precio_unitario
                )
                VALUES (?, ?, ?, ?)
                """;


            String sqlPrecio = """
                SELECT precio
                FROM repuesto
                WHERE codigo_repuesto = ?
                  AND estado = TRUE
                """;


            try (
                    PreparedStatement psDetalle
                    = conexion.prepareStatement(
                            sqlDetalle
                    );

                    PreparedStatement psPrecio
                    = conexion.prepareStatement(
                            sqlPrecio
                    )
            ) {


                for (int i = 0;
                        i < codigosRepuesto.length;
                        i++) {


                    String codigo
                            = codigosRepuesto[i];


                    int cantidad
                            = Integer.parseInt(
                                    cantidades[i]
                            );


                    if (cantidad <= 0) {
                        continue;
                    }


                    // Obtener nuevamente
                    // el precio real de MySQL.

                    psPrecio.setString(
                            1,
                            codigo
                    );


                    double precioUnitario;


                    try (ResultSet rs
                            = psPrecio.executeQuery()) {


                        if (!rs.next()) {

                            throw new SQLException(
                                    "No se encontró el repuesto "
                                    + codigo
                            );
                        }


                        precioUnitario
                                = rs.getDouble(
                                        "precio"
                                );
                    }


                    // Preparar detalle

                    psDetalle.setString(
                            1,
                            codigoMantenimiento
                    );


                    psDetalle.setString(
                            2,
                            codigo
                    );


                    psDetalle.setInt(
                            3,
                            cantidad
                    );


                    psDetalle.setDouble(
                            4,
                            precioUnitario
                    );


                    psDetalle.addBatch();
                }


                psDetalle.executeBatch();
            }
        }


        // ==============================
        // CONFIRMAR
        // ==============================

        conexion.commit();

        registrado = true;


    } catch (Exception e) {


        // ==============================
        // ROLLBACK
        // ==============================

        if (conexion != null) {

            try {

                conexion.rollback();

            } catch (SQLException rollbackError) {

                System.out.println(
                        "Error al hacer rollback: "
                        + rollbackError.getMessage()
                );
            }
        }


        mensajeError = e.getMessage();


        System.out.println(
                "Error al procesar mantenimiento: "
                + mensajeError
        );


    } finally {


        if (conexion != null) {

            try {

                conexion.setAutoCommit(true);

                conexion.close();

            } catch (SQLException e) {

                System.out.println(
                        "Error al cerrar conexión: "
                        + e.getMessage()
                );
            }
        }
    }


    // ==============================
    // COSTO TOTAL
    // ==============================

    double costoTotal
            = montoManoObra + montoRepuestos;

%>


<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Resultado del mantenimiento
        </title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>


    <body>

        <main class="pagina">


            <div class="card-menu">


                <% if (registrado) { %>


                    <h1>
                        Mantenimiento registrado
                    </h1>


                    <p>

                        El mantenimiento del bus

                        <strong>
                            <%= placaBus %>
                        </strong>

                        fue registrado correctamente.

                    </p>


                    <p>

                        <strong>
                            Código:
                        </strong>

                        <%= codigoMantenimiento %>

                    </p>


                    <p>

                        <strong>
                            Mano de obra:
                        </strong>

                        Q<%= String.format(
                                "%.2f",
                                montoManoObra
                        ) %>

                    </p>


                    <p>

                        <strong>
                            Repuestos:
                        </strong>

                        Q<%= String.format(
                                "%.2f",
                                montoRepuestos
                        ) %>

                    </p>


                    <p>

                        <strong>
                            Costo total:
                        </strong>

                        Q<%= String.format(
                                "%.2f",
                                costoTotal
                        ) %>

                    </p>


                <% } else { %>


                    <h1>
                        No se pudo registrar
                    </h1>


                    <p>
                        Ocurrió un error al registrar
                        el mantenimiento.
                    </p>


                    <% if (mensajeError != null
                            && !mensajeError.isEmpty()) { %>

                        <p>

                            <strong>
                                Detalle:
                            </strong>

                            <%= mensajeError %>

                        </p>

                    <% } %>


                <% } %>


                <div class="card-acciones">


                    <a href="mantenimientos.jsp">
                        Volver a mantenimientos
                    </a>


                    <a href="../inicio.jsp">
                        Ir al inicio
                    </a>


                </div>


            </div>


        </main>

    </body>

</html>
