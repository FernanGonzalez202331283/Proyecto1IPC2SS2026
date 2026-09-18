/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import transporte.conexion.Conexion;

/**
 *
 * @author fernan
 */
public class CompraBoletoDAO {
    public boolean comprarBoletos(
            String codigoViaje,
            String usuarioCliente,
            int[] numerosAsientos,
            String codigoMovimiento,
            Date fechaPago) {

        Connection conexion = null;

        try {

            conexion = Conexion.getConnection();

            conexion.setAutoCommit(false);


            String sqlViaje = """
                SELECT v.codigo_viaje,
                       v.estado,
                       r.precio_boleto
                FROM viaje v
                INNER JOIN ruta r
                    ON v.codigo_ruta = r.codigo_ruta
                WHERE v.codigo_viaje = ?
                FOR UPDATE
                """;

            double precioBoleto;

            try (PreparedStatement ps
                    = conexion.prepareStatement(sqlViaje)) {

                ps.setString(1, codigoViaje);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {

                        conexion.rollback();
                        return false;
                    }

                    String estado
                            = rs.getString("estado");

                    if (!"PROGRAMADO".equals(estado)) {

                        conexion.rollback();
                        return false;
                    }

                    precioBoleto
                            = rs.getDouble("precio_boleto");
                }
            }

            

            String sqlAsiento = """
                SELECT codigo_boleto
                FROM boleto
                WHERE codigo_viaje = ?
                  AND numero_asiento = ?
                  AND estado = 'PAGADO'
                FOR UPDATE
                """;

            try (PreparedStatement ps
                    = conexion.prepareStatement(sqlAsiento)) {

                for (int numeroAsiento : numerosAsientos) {

                    if (numeroAsiento <= 0) {

                        conexion.rollback();
                        return false;
                    }

                    ps.setString(1, codigoViaje);
                    ps.setInt(2, numeroAsiento);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (rs.next()) {

                            conexion.rollback();
                            return false;
                        }
                    }
                }
            }

        
            int cantidadBoletos
                    = numerosAsientos.length;

            double precioTotal
                    = precioBoleto * cantidadBoletos;

           

            String sqlCartera = """
                SELECT saldo
                FROM cartera
                WHERE usuario = ?
                FOR UPDATE
                """;

            double saldoActual;

            try (PreparedStatement ps
                    = conexion.prepareStatement(sqlCartera)) {

                ps.setString(1, usuarioCliente);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {

                        conexion.rollback();
                        return false;
                    }

                    saldoActual
                            = rs.getDouble("saldo");
                }
            }

            if (saldoActual < precioTotal) {

                conexion.rollback();
                return false;
            }


            String sqlMovimiento = """
                INSERT INTO movimiento_cartera
                (
                    codigo_movimiento,
                    usuario,
                    tipo,
                    monto,
                    fecha,
                    descripcion
                )
                VALUES (?, ?, 'PAGO', ?, ?, ?)
                """;

            try (PreparedStatement ps
                    = conexion.prepareStatement(sqlMovimiento)) {

                ps.setString(1, codigoMovimiento);
                ps.setString(2, usuarioCliente);
                ps.setDouble(3, precioTotal);
                ps.setDate(4, fechaPago);

                ps.setString(
                        5,
                        "Compra de "
                        + cantidadBoletos
                        + " boleto(s) para el viaje "
                        + codigoViaje
                );

                ps.executeUpdate();
            }

            String sqlActualizarCartera = """
                UPDATE cartera
                SET saldo = saldo - ?
                WHERE usuario = ?
                """;

            try (PreparedStatement ps
                    = conexion.prepareStatement(
                            sqlActualizarCartera)) {

                ps.setDouble(1, precioTotal);
                ps.setString(2, usuarioCliente);

                int filas
                        = ps.executeUpdate();

                if (filas == 0) {

                    conexion.rollback();
                    return false;
                }
            }

            String sqlBoleto = """
                INSERT INTO boleto
                (
                    codigo_boleto,
                    codigo_viaje,
                    usuario_cliente,
                    numero_asiento,
                    precio,
                    fecha_pago,
                    estado,
                    codigo_movimiento
                )
                VALUES (?, ?, ?, ?, ?, ?, 'PAGADO', ?)
                """;

            try (PreparedStatement ps
                    = conexion.prepareStatement(sqlBoleto)) {

                for (int numeroAsiento : numerosAsientos) {

                    String codigoBoleto
                            = "BOL-"
                            + System.currentTimeMillis()
                            + "-"
                            + numeroAsiento;

                    ps.setString(1, codigoBoleto);
                    ps.setString(2, codigoViaje);
                    ps.setString(3, usuarioCliente);
                    ps.setInt(4, numeroAsiento);
                    ps.setDouble(5, precioBoleto);
                    ps.setDate(6, fechaPago);
                    ps.setString(7, codigoMovimiento);

                    ps.addBatch();
                }

                ps.executeBatch();
            }
            conexion.commit();

            return true;

        } catch (SQLException e) {

            System.out.println(
                    "Error al realizar compra de boletos: "
                    + e.getMessage()
            );

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

