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
import transporte.modelo.DetalleMantenimiento;

/**
 *
 * @author fernan
 */
public class DetalleMantenimientoDAO {
    // INSERTAR
    public boolean insertar(DetalleMantenimiento detalle) {

        String sql = """
            INSERT INTO detalle_mantenimiento
            (codigo_mantenimiento, codigo_repuesto,
             cantidad, precio_unitario)
            VALUES (?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, detalle.getCodigoMantenimiento());
            ps.setString(2, detalle.getCodigoRepuesto());
            ps.setInt(3, detalle.getCantidad());
            ps.setDouble(4, detalle.getPrecioUnitario());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar detalle de mantenimiento: "
                + e.getMessage()
            );

            return false;
        }
    }

    // OBTENER
    public DetalleMantenimiento obtener(String codigoMantenimiento,
                                        String codigoRepuesto) {

        String sql = """
            SELECT codigo_mantenimiento,
                   codigo_repuesto,
                   cantidad,
                   precio_unitario
            FROM detalle_mantenimiento
            WHERE codigo_mantenimiento = ?
              AND codigo_repuesto = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoMantenimiento);
            ps.setString(2, codigoRepuesto);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                DetalleMantenimiento detalle =
                        new DetalleMantenimiento();

                detalle.setCodigoMantenimiento(
                    rs.getString("codigo_mantenimiento")
                );

                detalle.setCodigoRepuesto(
                    rs.getString("codigo_repuesto")
                );

                detalle.setCantidad(
                    rs.getInt("cantidad")
                );

                detalle.setPrecioUnitario(
                    rs.getDouble("precio_unitario")
                );

                return detalle;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener detalle de mantenimiento: "
                + e.getMessage()
            );
        }

        return null;
    }

    // ACTUALIZAR
    public boolean actualizar(DetalleMantenimiento detalle) {

        String sql = """
            UPDATE detalle_mantenimiento
            SET cantidad = ?,
                precio_unitario = ?
            WHERE codigo_mantenimiento = ?
              AND codigo_repuesto = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, detalle.getCantidad());
            ps.setDouble(2, detalle.getPrecioUnitario());
            ps.setString(3, detalle.getCodigoMantenimiento());
            ps.setString(4, detalle.getCodigoRepuesto());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar detalle de mantenimiento: "
                + e.getMessage()
            );

            return false;
        }
    }

    // LISTAR
    public void listar() {

        String sql = """
            SELECT codigo_mantenimiento,
                   codigo_repuesto,
                   cantidad,
                   precio_unitario
            FROM detalle_mantenimiento
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Mantenimiento: "
                    + rs.getString("codigo_mantenimiento")
                    + " | Repuesto: "
                    + rs.getString("codigo_repuesto")
                    + " | Cantidad: "
                    + rs.getInt("cantidad")
                    + " | Precio unitario: "
                    + rs.getDouble("precio_unitario")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar detalles de mantenimiento: "
                + e.getMessage()
            );
        }
    }
}
