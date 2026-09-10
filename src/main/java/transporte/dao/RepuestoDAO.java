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
import transporte.modelo.Repuesto;

/**
 *
 * @author fernan
 */
public class RepuestoDAO {
    
    // INSERTAR
    public boolean insertar(Repuesto repuesto) {

        String sql = """
            INSERT INTO repuesto
            (codigo_repuesto, nombre, descripcion, precio, estado)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, repuesto.getCodigoRepuesto());
            ps.setString(2, repuesto.getNombre());
            ps.setString(3, repuesto.getDescripcion());
            ps.setDouble(4, repuesto.getPrecio());
            ps.setBoolean(5, repuesto.isEstado());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar repuesto: "
                + e.getMessage()
            );

            return false;
        }
    }

    // OBTENER
    public Repuesto obtener(String codigoRepuesto) {

        String sql = """
            SELECT codigo_repuesto,
                   nombre,
                   descripcion,
                   precio,
                   estado
            FROM repuesto
            WHERE codigo_repuesto = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoRepuesto);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Repuesto repuesto = new Repuesto();

                repuesto.setCodigoRepuesto(
                    rs.getString("codigo_repuesto")
                );

                repuesto.setNombre(
                    rs.getString("nombre")
                );

                repuesto.setDescripcion(
                    rs.getString("descripcion")
                );

                repuesto.setPrecio(
                    rs.getDouble("precio")
                );

                repuesto.setEstado(
                    rs.getBoolean("estado")
                );

                return repuesto;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener repuesto: "
                + e.getMessage()
            );
        }

        return null;
    }

    // ACTUALIZAR
    public boolean actualizar(Repuesto repuesto) {

        String sql = """
            UPDATE repuesto
            SET nombre = ?,
                descripcion = ?,
                precio = ?,
                estado = ?
            WHERE codigo_repuesto = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, repuesto.getNombre());
            ps.setString(2, repuesto.getDescripcion());
            ps.setDouble(3, repuesto.getPrecio());
            ps.setBoolean(4, repuesto.isEstado());
            ps.setString(5, repuesto.getCodigoRepuesto());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar repuesto: "
                + e.getMessage()
            );

            return false;
        }
    }

    // LISTAR
    public void listar() {

        String sql = """
            SELECT codigo_repuesto,
                   nombre,
                   descripcion,
                   precio,
                   estado
            FROM repuesto
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Repuesto: "
                    + rs.getString("codigo_repuesto")
                    + " | Nombre: "
                    + rs.getString("nombre")
                    + " | Descripción: "
                    + rs.getString("descripcion")
                    + " | Precio: "
                    + rs.getDouble("precio")
                    + " | Estado: "
                    + rs.getBoolean("estado")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar repuestos: "
                + e.getMessage()
            );
        }
    }
}
