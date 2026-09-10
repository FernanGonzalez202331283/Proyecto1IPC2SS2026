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
import transporte.modelo.Alquiler;

/**
 *
 * @author fernan
 */
public class AlquilerDAO {
    
     public boolean insertar(Alquiler alquiler) {

        String sql = """
            INSERT INTO alquiler
            (codigo_alquiler, codigo_viaje, usuario_cliente,
             numero_pasajeros, fecha_retorno, precio_estimado,
             precio_confirmado, estado)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, alquiler.getCodigoAlquiler());
            ps.setString(2, alquiler.getCodigoViaje());
            ps.setString(3, alquiler.getUsuarioCliente());
            ps.setInt(4, alquiler.getNumeroPasajeros());
            ps.setDate(5, alquiler.getFechaRetorno());
            ps.setDouble(6, alquiler.getPrecioEstimado());
            ps.setDouble(7, alquiler.getPrecioConfirmado());
            ps.setString(8, alquiler.getEstado());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar alquiler: " + e.getMessage()
            );

            return false;
        }
    }
    
     public Alquiler obtener(String codigoAlquiler) {

        String sql = """
            SELECT codigo_alquiler, codigo_viaje,
                   usuario_cliente, numero_pasajeros,
                   fecha_retorno, precio_estimado,
                   precio_confirmado, estado
            FROM alquiler
            WHERE codigo_alquiler = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoAlquiler);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Alquiler alquiler = new Alquiler();

                alquiler.setCodigoAlquiler(
                    rs.getString("codigo_alquiler")
                );

                alquiler.setCodigoViaje(
                    rs.getString("codigo_viaje")
                );

                alquiler.setUsuarioCliente(
                    rs.getString("usuario_cliente")
                );

                alquiler.setNumeroPasajeros(
                    rs.getInt("numero_pasajeros")
                );

                alquiler.setFechaRetorno(
                    rs.getDate("fecha_retorno")
                );

                alquiler.setPrecioEstimado(
                    rs.getDouble("precio_estimado")
                );

                alquiler.setPrecioConfirmado(
                    rs.getDouble("precio_confirmado")
                );

                alquiler.setEstado(
                    rs.getString("estado")
                );

                return alquiler;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener alquiler: " + e.getMessage()
            );
        }

        return null;
    }
    
    public boolean actualizar(Alquiler alquiler) {

        String sql = """
            UPDATE alquiler
            SET usuario_cliente = ?,
                numero_pasajeros = ?,
                fecha_retorno = ?,
                precio_estimado = ?,
                precio_confirmado = ?,
                estado = ?
            WHERE codigo_alquiler = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, alquiler.getUsuarioCliente());
            ps.setInt(2, alquiler.getNumeroPasajeros());
            ps.setDate(3, alquiler.getFechaRetorno());
            ps.setDouble(4, alquiler.getPrecioEstimado());
            ps.setDouble(5, alquiler.getPrecioConfirmado());
            ps.setString(6, alquiler.getEstado());
            ps.setString(7, alquiler.getCodigoAlquiler());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar alquiler: " + e.getMessage()
            );

            return false;
        }
    }
   
    public void listar() {

        String sql = """
            SELECT codigo_alquiler, codigo_viaje,
                   usuario_cliente, numero_pasajeros,
                   fecha_retorno, precio_estimado,
                   precio_confirmado, estado
            FROM alquiler
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Alquiler: "
                    + rs.getString("codigo_alquiler")
                    + " | Viaje: "
                    + rs.getString("codigo_viaje")
                    + " | Cliente: "
                    + rs.getString("usuario_cliente")
                    + " | Pasajeros: "
                    + rs.getInt("numero_pasajeros")
                    + " | Retorno: "
                    + rs.getDate("fecha_retorno")
                    + " | Precio estimado: "
                    + rs.getDouble("precio_estimado")
                    + " | Precio confirmado: "
                    + rs.getDouble("precio_confirmado")
                    + " | Estado: "
                    + rs.getString("estado")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar alquileres: " + e.getMessage()
            );
        }
    }
    
    public boolean eliminar(String codigoAlquiler) {

        String sql = """
            DELETE FROM alquiler
            WHERE codigo_alquiler = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoAlquiler);

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al eliminar alquiler: " + e.getMessage()
            );

            return false;
    }
    
    
    }
    
    
}
