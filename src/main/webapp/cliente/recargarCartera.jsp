<%-- 
    Document   : recargarCartera
    Created on : 11 sept 2026, 11:07:13
    Author     : fernan
--%>

<%@page import="java.sql.Date"%>
<%@page import="transporte.modelo.MovimientoCartera"%>
<%@page import="transporte.dao.MovimientoCarteraDAO"%>
<%@page import="transporte.modelo.Cartera"%>
<%@page import="transporte.dao.CarteraDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (!"CLIENTE".equals(usuario.getRol())) {
        response.sendRedirect("../inicio.jsp");
        return;
    }

    CarteraDAO carteraDAO = new CarteraDAO();
    MovimientoCarteraDAO movimientoDAO = new MovimientoCarteraDAO();

    Cartera cartera = carteraDAO.obtener(usuario.getUsuario());

    String mensaje = "";
    String tipoMensaje = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String montoParametro = request.getParameter("monto");

        if (montoParametro == null || montoParametro.trim().isEmpty()) {

            mensaje = "Debes ingresar un monto.";
            tipoMensaje = "Error";

        } else {

            try {

                double monto = Double.parseDouble(
                    montoParametro.trim()
                );

                if (monto <= 0) {

                    mensaje = "El monto debe ser mayor que Q0.00.";
                    tipoMensaje = "Error";

                } else if (cartera == null) {

                    mensaje = "No se encontró una cartera asociada a tu usuario.";
                    tipoMensaje = "Error";

                } else {

                    double nuevoSaldo =
                        cartera.getSaldo() + monto;

                    cartera.setSaldo(nuevoSaldo);

                    boolean carteraActualizada =
                        carteraDAO.actualizar(cartera);

                    if (carteraActualizada) {

                        String codigoMovimiento =
                            "REC-" + System.currentTimeMillis();

                        MovimientoCartera movimiento =
                            new MovimientoCartera(
                                codigoMovimiento,
                                usuario.getUsuario(),
                                "RECARGA",
                                monto,
                                new Date(System.currentTimeMillis()),
                                "Recarga de cartera"
                            );

                        boolean movimientoInsertado =
                            movimientoDAO.insertar(movimiento);

                        if (movimientoInsertado) {

                            mensaje =
                                "Recarga realizada correctamente. "
                                + "Nuevo saldo: Q"
                                + String.format(
                                    "%.2f",
                                    nuevoSaldo
                                );

                            tipoMensaje = "Exito";

                        } else {

                            mensaje =
                                "El saldo fue actualizado, "
                                + "pero no se pudo registrar "
                                + "el movimiento.";

                            tipoMensaje = "Error";
                        }

                    } else {

                        mensaje =
                            "No se pudo actualizar el saldo.";

                        tipoMensaje = "Error";
                    }
                }

            } catch (NumberFormatException e) {

                mensaje =
                    "El monto ingresado no es válido.";

                tipoMensaje = "Error";
            }
        }
    }
    cartera = carteraDAO.obtener(usuario.getUsuario());
%>

<!DOCTYPE html>

<html lang="es">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Recargar cartera</title>

        <link rel="stylesheet"
              href="../resources/css/styles.css">

    </head>

    <body>

        <main class="pagina">

            <header class="encabezado">

                <h1>Recargar cartera</h1>

                <p>
                    Usuario:
                    <strong>
                        <%= usuario.getUsuario() %>
                    </strong>
                </p>

            </header>


            <% if (cartera != null) { %>

                <div class="card-menu">

                    <h2>Saldo actual</h2>

                    <p>
                        <strong>
                            Q<%= String.format(
                                "%.2f",
                                cartera.getSaldo()
                            ) %>
                        </strong>
                    </p>

                </div>

            <% } %>


            <br>


            <div class="card-menu">

                <h2>Realizar recarga</h2>

                <form method="post">

                    <div class="form-group">

                        <label for="monto">
                            Monto a recargar
                        </label>

                        <input
                            type="number"
                            id="monto"
                            name="monto"
                            min="0.01"
                            step="0.01"
                            placeholder="Ejemplo: 100.00"
                            required>

                    </div>

                    <div class="form-actions">

                        <button type="submit">
                            Recargar saldo
                        </button>

                        <a href="cartera.jsp">
                            Cancelar
                        </a>

                    </div>

                </form>

            </div>


            <% if (!mensaje.isEmpty()) { %>

                <div class="mensaje <%= tipoMensaje %>">

                    <%= mensaje %>

                </div>

            <% } %>


            <br>

            <a href="cartera.jsp">
                Regresar a mi cartera
            </a>

        </main>

    </body>

</html>

