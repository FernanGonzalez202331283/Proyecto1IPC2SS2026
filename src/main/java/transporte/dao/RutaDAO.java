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
import transporte.modelo.Ruta;

/**
 *
 * @author fernan
 */
public class RutaDAO {
    
    public boolean insertar(Ruta ruta) {

        String sql = """
            INSERT INTO ruta
            (codigo_ruta, codigo_sucursal_origen, codigo_sucursal_destino,
             distancia_km, precio_boleto, estado)
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, ruta.getCodigoRuta());
            ps.setString(2, ruta.getCodigoSucursalOrigen());
            ps.setString(3, ruta.getCodigoSucursalDestino());
            ps.setDouble(4, ruta.getDistanciaKm());
            ps.setDouble(5, ruta.getPrecioBoleto());
            ps.setBoolean(6, ruta.isEstado());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar ruta: " + e.getMessage()
            );

            return false;
        }
    }
    
    public Ruta obtener(String codigoRuta) {

        String sql = """
            SELECT codigo_ruta, codigo_sucursal_origen,
                   codigo_sucursal_destino, distancia_km,
                   precio_boleto, estado
            FROM ruta
            WHERE codigo_ruta = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoRuta);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return new Ruta(
                    rs.getString("codigo_ruta"),
                    rs.getString("codigo_sucursal_origen"),
                    rs.getString("codigo_sucursal_destino"),
                    rs.getDouble("distancia_km"),
                    rs.getDouble("precio_boleto"),
                    rs.getBoolean("estado")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener ruta: " + e.getMessage()
            );
        }

        return null;
    }
    
    public boolean actualizar(Ruta ruta) {

        String sql = """
            UPDATE ruta
            SET codigo_sucursal_origen = ?,
                codigo_sucursal_destino = ?,
                distancia_km = ?,
                precio_boleto = ?,
                estado = ?
            WHERE codigo_ruta = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, ruta.getCodigoSucursalOrigen());
            ps.setString(2, ruta.getCodigoSucursalDestino());
            ps.setDouble(3, ruta.getDistanciaKm());
            ps.setDouble(4, ruta.getPrecioBoleto());
            ps.setBoolean(5, ruta.isEstado());
            ps.setString(6, ruta.getCodigoRuta());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar ruta: " + e.getMessage()
            );

            return false;
        }
    }
    
    public void listar() {

        String sql = """
            SELECT codigo_ruta, codigo_sucursal_origen,
                   codigo_sucursal_destino, distancia_km,
                   precio_boleto, estado
            FROM ruta
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Ruta: " + rs.getString("codigo_ruta")
                    + " | Origen: " + rs.getString("codigo_sucursal_origen")
                    + " | Destino: " + rs.getString("codigo_sucursal_destino")
                    + " | Distancia: " + rs.getDouble("distancia_km")
                    + " km"
                    + " | Precio: " + rs.getDouble("precio_boleto")
                    + " | Estado: " + rs.getBoolean("estado")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar rutas: " + e.getMessage()
            );
        }
    }
    
     public boolean eliminar(String codigoRuta) {

        String sql = """
            DELETE FROM ruta
            WHERE codigo_ruta = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoRuta);

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al eliminar ruta: " + e.getMessage()
            );

            return false;
        }
    }
    
}
