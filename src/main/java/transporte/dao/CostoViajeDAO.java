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
import transporte.modelo.CostoViaje;

/**
 *
 * @author fernan
 */
public class CostoViajeDAO {
     // INSERTAR
    public boolean insertar(CostoViaje costo) {

        String sql = """
            INSERT INTO costo_viaje
            (codigo_viaje, salario_chofer, combustible, depreciacion)
            VALUES (?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, costo.getCodigoViaje());
            ps.setDouble(2, costo.getSalarioChofer());
            ps.setDouble(3, costo.getCombustible());
            ps.setDouble(4, costo.getDepreciacion());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar costo de viaje: "
                + e.getMessage()
            );

            return false;
        }
    }

    // OBTENER
    public CostoViaje obtener(String codigoViaje) {

        String sql = """
            SELECT codigo_viaje,
                   salario_chofer,
                   combustible,
                   depreciacion
            FROM costo_viaje
            WHERE codigo_viaje = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoViaje);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                CostoViaje costo = new CostoViaje();

                costo.setCodigoViaje(
                    rs.getString("codigo_viaje")
                );

                costo.setSalarioChofer(
                    rs.getDouble("salario_chofer")
                );

                costo.setCombustible(
                    rs.getDouble("combustible")
                );

                costo.setDepreciacion(
                    rs.getDouble("depreciacion")
                );

                return costo;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener costo de viaje: "
                + e.getMessage()
            );
        }

        return null;
    }

    // ACTUALIZAR
    public boolean actualizar(CostoViaje costo) {

        String sql = """
            UPDATE costo_viaje
            SET salario_chofer = ?,
                combustible = ?,
                depreciacion = ?
            WHERE codigo_viaje = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setDouble(1, costo.getSalarioChofer());
            ps.setDouble(2, costo.getCombustible());
            ps.setDouble(3, costo.getDepreciacion());
            ps.setString(4, costo.getCodigoViaje());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar costo de viaje: "
                + e.getMessage()
            );

            return false;
        }
    }

    // LISTAR
    public void listar() {

        String sql = """
            SELECT codigo_viaje,
                   salario_chofer,
                   combustible,
                   depreciacion
            FROM costo_viaje
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Viaje: "
                    + rs.getString("codigo_viaje")
                    + " | Salario chofer: "
                    + rs.getDouble("salario_chofer")
                    + " | Combustible: "
                    + rs.getDouble("combustible")
                    + " | Depreciación: "
                    + rs.getDouble("depreciacion")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar costos de viaje: "
                + e.getMessage()
            );
        }
    }
}
