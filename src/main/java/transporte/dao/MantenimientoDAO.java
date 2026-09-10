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
import transporte.modelo.Mantenimiento;

/**
 *
 * @author fernan
 */
public class MantenimientoDAO {
    // INSERTAR
    public boolean insertar(Mantenimiento mantenimiento) {

        String sql = """
            INSERT INTO mantenimiento
            (codigo_mantenimiento, placa_bus, fecha,
             monto_mano_obra, monto_repuestos, descripcion)
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, mantenimiento.getCodigoMantenimiento());
            ps.setString(2, mantenimiento.getPlacaBus());
            ps.setDate(3, mantenimiento.getFecha());
            ps.setDouble(4, mantenimiento.getMontoManoObra());
            ps.setDouble(5, mantenimiento.getMontoRepuestos());
            ps.setString(6, mantenimiento.getDescripcion());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar mantenimiento: "
                + e.getMessage()
            );

            return false;
        }
    }

    // OBTENER
    public Mantenimiento obtener(String codigoMantenimiento) {

        String sql = """
            SELECT codigo_mantenimiento,
                   placa_bus,
                   fecha,
                   monto_mano_obra,
                   monto_repuestos,
                   descripcion
            FROM mantenimiento
            WHERE codigo_mantenimiento = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoMantenimiento);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Mantenimiento mantenimiento =
                        new Mantenimiento();

                mantenimiento.setCodigoMantenimiento(
                    rs.getString("codigo_mantenimiento")
                );

                mantenimiento.setPlacaBus(
                    rs.getString("placa_bus")
                );

                mantenimiento.setFecha(
                    rs.getDate("fecha")
                );

                mantenimiento.setMontoManoObra(
                    rs.getDouble("monto_mano_obra")
                );

                mantenimiento.setMontoRepuestos(
                    rs.getDouble("monto_repuestos")
                );

                mantenimiento.setDescripcion(
                    rs.getString("descripcion")
                );

                return mantenimiento;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener mantenimiento: "
                + e.getMessage()
            );
        }

        return null;
    }

    // ACTUALIZAR
    public boolean actualizar(Mantenimiento mantenimiento) {

        String sql = """
            UPDATE mantenimiento
            SET placa_bus = ?,
                fecha = ?,
                monto_mano_obra = ?,
                monto_repuestos = ?,
                descripcion = ?
            WHERE codigo_mantenimiento = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, mantenimiento.getPlacaBus());
            ps.setDate(2, mantenimiento.getFecha());
            ps.setDouble(3, mantenimiento.getMontoManoObra());
            ps.setDouble(4, mantenimiento.getMontoRepuestos());
            ps.setString(5, mantenimiento.getDescripcion());
            ps.setString(6, mantenimiento.getCodigoMantenimiento());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar mantenimiento: "
                + e.getMessage()
            );

            return false;
        }
    }

    // LISTAR
    public void listar() {

        String sql = """
            SELECT codigo_mantenimiento,
                   placa_bus,
                   fecha,
                   monto_mano_obra,
                   monto_repuestos,
                   descripcion
            FROM mantenimiento
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Mantenimiento: "
                    + rs.getString("codigo_mantenimiento")
                    + " | Bus: "
                    + rs.getString("placa_bus")
                    + " | Fecha: "
                    + rs.getDate("fecha")
                    + " | Mano de obra: "
                    + rs.getDouble("monto_mano_obra")
                    + " | Repuestos: "
                    + rs.getDouble("monto_repuestos")
                    + " | Descripción: "
                    + rs.getString("descripcion")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar mantenimientos: "
                + e.getMessage()
            );
        }
    }
}
