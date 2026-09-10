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
import transporte.modelo.MovimientoCartera;

/**
 *
 * @author fernan
 */
public class MovimientoCarteraDAO {
    public boolean insertar(MovimientoCartera movimiento) {

        String sql = """
            INSERT INTO movimiento_cartera
            (codigo_movimiento, usuario, tipo, monto, fecha, descripcion)
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, movimiento.getCodigoMovimiento());
            ps.setString(2, movimiento.getUsuario());
            ps.setString(3, movimiento.getTipo());
            ps.setDouble(4, movimiento.getMonto());
            ps.setDate(5, movimiento.getFecha());
            ps.setString(6, movimiento.getDescripcion());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar movimiento: "
                + e.getMessage()
            );

            return false;
        }
    }
    
    public MovimientoCartera obtener(String codigoMovimiento) {

        String sql = """
            SELECT codigo_movimiento,
                   usuario,
                   tipo,
                   monto,
                   fecha,
                   descripcion
            FROM movimiento_cartera
            WHERE codigo_movimiento = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoMovimiento);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                MovimientoCartera movimiento =
                        new MovimientoCartera();

                movimiento.setCodigoMovimiento(
                    rs.getString("codigo_movimiento")
                );

                movimiento.setUsuario(
                    rs.getString("usuario")
                );

                movimiento.setTipo(
                    rs.getString("tipo")
                );

                movimiento.setMonto(
                    rs.getDouble("monto")
                );

                movimiento.setFecha(
                    rs.getDate("fecha")
                );

                movimiento.setDescripcion(
                    rs.getString("descripcion")
                );

                return movimiento;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener movimiento: "
                + e.getMessage()
            );
        }

        return null;
    }
    
    public boolean actualizar(MovimientoCartera movimiento) {

        String sql = """
            UPDATE movimiento_cartera
            SET usuario = ?,
                tipo = ?,
                monto = ?,
                fecha = ?,
                descripcion = ?
            WHERE codigo_movimiento = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, movimiento.getUsuario());
            ps.setString(2, movimiento.getTipo());
            ps.setDouble(3, movimiento.getMonto());
            ps.setDate(4, movimiento.getFecha());
            ps.setString(5, movimiento.getDescripcion());
            ps.setString(6, movimiento.getCodigoMovimiento());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar movimiento: "
                + e.getMessage()
            );

            return false;
        }
    }
    
    public void listar() {

        String sql = """
            SELECT codigo_movimiento,
                   usuario,
                   tipo,
                   monto,
                   fecha,
                   descripcion
            FROM movimiento_cartera
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Movimiento: "
                    + rs.getString("codigo_movimiento")
                    + " | Usuario: "
                    + rs.getString("usuario")
                    + " | Tipo: "
                    + rs.getString("tipo")
                    + " | Monto: "
                    + rs.getDouble("monto")
                    + " | Fecha: "
                    + rs.getDate("fecha")
                    + " | Descripción: "
                    + rs.getString("descripcion")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar movimientos: "
                + e.getMessage()
            );
        }
    }
}
