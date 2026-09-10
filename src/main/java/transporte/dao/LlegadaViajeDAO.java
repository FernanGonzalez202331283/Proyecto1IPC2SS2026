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
import transporte.modelo.LlegadaViaje;

/**
 *
 * @author fernan
 */
public class LlegadaViajeDAO {
    
    public boolean insertar(LlegadaViaje llegada) {

        String sql = """
            INSERT INTO llegada_viaje
            (codigo_viaje, hora_real_llegada,
             kilometraje_final, gasto_combustible,
             usuario_registro)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, llegada.getCodigoViaje());
            ps.setTime(2, llegada.getHoraRealLlegada());
            ps.setDouble(3, llegada.getKilometrajeFinal());
            ps.setDouble(4, llegada.getGastoCombustible());
            ps.setString(5, llegada.getUsuarioRegistro());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar llegada del viaje: "
                + e.getMessage()
            );

            return false;
        }
    }
    
     public LlegadaViaje obtener(String codigoViaje) {

        String sql = """
            SELECT codigo_viaje,
                   hora_real_llegada,
                   kilometraje_final,
                   gasto_combustible,
                   usuario_registro
            FROM llegada_viaje
            WHERE codigo_viaje = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoViaje);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                LlegadaViaje llegada = new LlegadaViaje();

                llegada.setCodigoViaje(
                    rs.getString("codigo_viaje")
                );

                llegada.setHoraRealLlegada(
                    rs.getTime("hora_real_llegada")
                );

                llegada.setKilometrajeFinal(
                    rs.getDouble("kilometraje_final")
                );

                llegada.setGastoCombustible(
                    rs.getDouble("gasto_combustible")
                );

                llegada.setUsuarioRegistro(
                    rs.getString("usuario_registro")
                );

                return llegada;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener llegada del viaje: "
                + e.getMessage()
            );
        }

        return null;
    }
     
    
     public void listar() {

        String sql = """
            SELECT codigo_viaje,
                   hora_real_llegada,
                   kilometraje_final,
                   gasto_combustible,
                   usuario_registro
            FROM llegada_viaje
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Viaje: "
                    + rs.getString("codigo_viaje")
                    + " | Hora llegada: "
                    + rs.getTime("hora_real_llegada")
                    + " | Kilometraje final: "
                    + rs.getDouble("kilometraje_final")
                    + " | Gasto combustible: "
                    + rs.getDouble("gasto_combustible")
                    + " | Usuario: "
                    + rs.getString("usuario_registro")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar llegadas: "
                + e.getMessage()
            );
        }
    }
    
}
