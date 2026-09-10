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

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

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

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoPago);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                PagoAlquiler pago = new PagoAlquiler();

                pago.setCodigoPago(
                    rs.getString("codigo_pago")
                );

                pago.setCodigoAlquiler(
                    rs.getString("codigo_alquiler")
                );

                pago.setCodigoMovimiento(
                    rs.getString("codigo_movimiento")
                );

                pago.setMonto(
                    rs.getDouble("monto")
                );

                pago.setFechaPago(
                    rs.getDate("fecha_pago")
                );

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

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

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

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
}
