/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import transporte.conexion.Conexion;
import transporte.modelo.PagoAlquiler;

/**
 *
 * @author fernan
 */
public class PagoAlquilerDAO {

    public boolean insertar(PagoAlquiler pago) {

        String sql = """
            INSERT INTO pago_alquiler
            (codigo_pago, codigo_alquiler,
             codigo_movimiento, monto, fecha_pago)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, pago.getCodigoPago());
            ps.setString(2, pago.getCodigoAlquiler());
            ps.setString(3, pago.getCodigoMovimiento());
            ps.setDouble(4, pago.getMonto());
            ps.setDate(5, pago.getFechaPago());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                    "Error al insertar pago de alquiler: "
                    + e.getMessage()
            );

            return false;
        }
    }

    public PagoAlquiler obtener(String codigoPago) {

        String sql = """
            SELECT codigo_pago,
                   codigo_alquiler,
                   codigo_movimiento,
                   monto,
                   fecha_pago
            FROM pago_alquiler
            WHERE codigo_pago = ?
            """;

        try (Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoPago);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                PagoAlquiler pago = new PagoAlquiler();
                pago.setCodigoPago(rs.getString("codigo_pago"));
                pago.setCodigoAlquiler(rs.getString("codigo_alquiler"));
                pago.setCodigoMovimiento(rs.getString("codigo_movimiento"));
                pago.setMonto(rs.getDouble("monto"));
                pago.setFechaPago(rs.getDate("fecha_pago"));
                return pago;
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al obtener pago de alquiler: "
                    + e.getMessage()
            );
        }

        return null;
    }

    public boolean actualizar(PagoAlquiler pago) {

        String sql = """
            UPDATE pago_alquiler
            SET codigo_alquiler = ?,
                codigo_movimiento = ?,
                monto = ?,
                fecha_pago = ?
            WHERE codigo_pago = ?
            """;

        try (Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, pago.getCodigoAlquiler());
            ps.setString(2, pago.getCodigoMovimiento());
            ps.setDouble(3, pago.getMonto());
            ps.setDate(4, pago.getFechaPago());
            ps.setString(5, pago.getCodigoPago());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                    "Error al actualizar pago de alquiler: "
                    + e.getMessage()
            );

            return false;
        }
    }

    public void listar() {

        String sql = """
            SELECT codigo_pago,
                   codigo_alquiler,
                   codigo_movimiento,
                   monto,
                   fecha_pago
            FROM pago_alquiler
            """;

        try (Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                        "Pago: "
                        + rs.getString("codigo_pago")
                        + " | Alquiler: "
                        + rs.getString("codigo_alquiler")
                        + " | Movimiento: "
                        + rs.getString("codigo_movimiento")
                        + " | Monto: "
                        + rs.getDouble("monto")
                        + " | Fecha: "
                        + rs.getDate("fecha_pago")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al listar pagos de alquiler: "
                    + e.getMessage()
            );
        }
    }
    
public boolean procesarPago(
        String codigoAlquiler,
        String usuarioCliente) {

    Connection conexion = null;

    try {

        conexion = Conexion.getConnection();
        conexion.setAutoCommit(false);
        String sqlAlquiler = """
            SELECT usuario_cliente,
                   precio_confirmado,
                   estado
            FROM alquiler
            WHERE codigo_alquiler = ?
            FOR UPDATE
            """;

        double precioConfirmado = 0;

        try (PreparedStatement ps =
                conexion.prepareStatement(sqlAlquiler)) {

            ps.setString(1, codigoAlquiler);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {

                    conexion.rollback();
                    return false;
                }

                String usuarioAlquiler =
                        rs.getString("usuario_cliente");

                String estado =
                        rs.getString("estado");

                precioConfirmado =
                        rs.getDouble("precio_confirmado");

                if (!usuarioCliente.equals(usuarioAlquiler)) {

                    conexion.rollback();
                    return false;
                }

                if (!"CONFIRMADO".equals(estado)) {

                    conexion.rollback();
                    return false;
                }

                if (precioConfirmado <= 0) {

                    conexion.rollback();
                    return false;
                }
            }
        }

        double saldoActual = 0;

        String sqlCartera = """
            SELECT saldo
            FROM cartera
            WHERE usuario = ?
            FOR UPDATE
            """;

        try (PreparedStatement ps =
                conexion.prepareStatement(sqlCartera)) {

            ps.setString(1, usuarioCliente);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {

                    conexion.rollback();
                    return false;
                }

                saldoActual =
                        rs.getDouble("saldo");
            }
        }

        if (saldoActual < precioConfirmado) {

            conexion.rollback();
            return false;
        }

        String codigoMovimiento =
                "MOV-" + System.currentTimeMillis();

        String codigoPago =
                "PAG-" + System.currentTimeMillis();

        java.sql.Date fechaActual =
                new java.sql.Date(
                    System.currentTimeMillis()
                );

        double nuevoSaldo =
                saldoActual - precioConfirmado;

        String sqlActualizarCartera = """
            UPDATE cartera
            SET saldo = ?
            WHERE usuario = ?
            """;

        try (PreparedStatement ps =
                conexion.prepareStatement(
                    sqlActualizarCartera)) {

            ps.setDouble(1, nuevoSaldo);
            ps.setString(2, usuarioCliente);

            int filas = ps.executeUpdate();

            if (filas == 0) {

                conexion.rollback();
                return false;
            }
        }

        String sqlMovimiento = """
            INSERT INTO movimiento_cartera
            (codigo_movimiento,
             usuario,
             tipo,
             monto,
             fecha,
             descripcion)
            VALUES (?, ?, 'PAGO', ?, ?, ?)
            """;

        try (PreparedStatement ps =
                conexion.prepareStatement(sqlMovimiento)) {

            ps.setString(1, codigoMovimiento);
            ps.setString(2, usuarioCliente);
            ps.setDouble(3, precioConfirmado);
            ps.setDate(4, fechaActual);

            ps.setString(
                5,
                "Pago de alquiler " + codigoAlquiler
            );

            ps.executeUpdate();
        }
        String sqlPago = """
            INSERT INTO pago_alquiler
            (codigo_pago,
             codigo_alquiler,
             codigo_movimiento,
             monto,
             fecha_pago)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (PreparedStatement ps =
                conexion.prepareStatement(sqlPago)) {

            ps.setString(1, codigoPago);
            ps.setString(2, codigoAlquiler);
            ps.setString(3, codigoMovimiento);
            ps.setDouble(4, precioConfirmado);
            ps.setDate(5, fechaActual);

            ps.executeUpdate();
        }

        String sqlActualizarAlquiler = """
            UPDATE alquiler
            SET estado = 'PAGADO'
            WHERE codigo_alquiler = ?
              AND estado = 'CONFIRMADO'
            """;

        try (PreparedStatement ps =
                conexion.prepareStatement(
                    sqlActualizarAlquiler)) {

            ps.setString(1, codigoAlquiler);

            int filas = ps.executeUpdate();

            if (filas == 0) {

                conexion.rollback();
                return false;
            }
        }

        conexion.commit();

        return true;

    } catch (SQLException e) {

        if (conexion != null) {

            try {
                conexion.rollback();

            } catch (SQLException ex) {

                System.out.println(
                    "Error al hacer rollback: "
                    + ex.getMessage()
                );
            }
        }

        System.out.println(
            "Error al procesar pago de alquiler: "
            + e.getMessage()
        );

        return false;

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
}

}
