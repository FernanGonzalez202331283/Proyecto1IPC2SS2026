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
import transporte.modelo.SalidaViaje;

/**
 *
 * @author fernan
 */
public class SalidaViajeDAO {
    public boolean insertar(SalidaViaje salida) {

        String sql = """
            INSERT INTO salida_viaje
            (codigo_viaje, hora_real_salida,
             kilometraje_inicial, usuario_registro)
            VALUES (?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, salida.getCodigoViaje());
            ps.setTime(2, salida.getHoraRealSalida());
            ps.setDouble(3, salida.getKilometrajeInicial());
            ps.setString(4, salida.getUsuarioRegistro());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar salida del viaje: "
                + e.getMessage()
            );

            return false;
        }
    }
    
     public SalidaViaje obtener(String codigoViaje) {

        String sql = """
            SELECT codigo_viaje,
                   hora_real_salida,
                   kilometraje_inicial,
                   usuario_registro
            FROM salida_viaje
            WHERE codigo_viaje = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoViaje);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                SalidaViaje salida = new SalidaViaje();

                salida.setCodigoViaje(
                    rs.getString("codigo_viaje")
                );

                salida.setHoraRealSalida(
                    rs.getTime("hora_real_salida")
                );

                salida.setKilometrajeInicial(
                    rs.getDouble("kilometraje_inicial")
                );

                salida.setUsuarioRegistro(
                    rs.getString("usuario_registro")
                );

                return salida;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener salida del viaje: "
                + e.getMessage()
            );
        }

        return null;
    }
     
    public void listar() {

        String sql = """
            SELECT codigo_viaje,
                   hora_real_salida,
                   kilometraje_inicial,
                   usuario_registro
            FROM salida_viaje
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Viaje: "
                    + rs.getString("codigo_viaje")
                    + " | Hora salida: "
                    + rs.getTime("hora_real_salida")
                    + " | Kilometraje inicial: "
                    + rs.getDouble("kilometraje_inicial")
                    + " | Usuario: "
                    + rs.getString("usuario_registro")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar salidas: "
                + e.getMessage()
            );
        }
    }
}
