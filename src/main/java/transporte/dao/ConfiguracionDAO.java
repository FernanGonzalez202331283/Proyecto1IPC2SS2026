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
import transporte.modelo.Configuracion;

/**
 *
 * @author fernan
 */
public class ConfiguracionDAO {
    
    public boolean insertar(Configuracion configuracion){
        String sql = """
                     INSERT INTO configuracion
                     (codigo_configuracion, depreciacion_por_km, fecha_configuracion)
                     VALUES (?,?,?)
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            ps.setString(1, configuracion.getCodigoConfiguracion());
            ps.setDouble(2, configuracion.getDepreciacionPorKm());
            ps.setDate(3, configuracion.getFechaConfiguracion());
            
            ps.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            System.out.println("eror al insertar configuracion: "+e.getMessage());
        }
        return false;
    }
    
    public boolean actualizar(Configuracion configuracion){
        String sql = """
                     UPDATE configuracion
                     SET depreciacion_por_km = ?,
                     fecha_configuracion = ?
                     WHERE codigo_configuracion = ?
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            
            ps.setDouble(1, configuracion.getDepreciacionPorKm());
            ps.setDate(2, configuracion.getFechaConfiguracion());
            ps.setString(3, configuracion.getCodigoConfiguracion());
            
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar configuracion: "+e.getMessage());
        }
        return false;
    }
    
    public Configuracion obtener(String codigoConfiguracion){
        String sql = """
                     SELECT codigo_configuracion,
                            depreciacion_por_km,
                            fecha_configuracion
                     FROM configuracion
                     WHERE codigo_configuracion = ?
                     """;
        
        try (Connection conexion = Conexion.getConnection();    
            PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, codigoConfiguracion);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Configuracion configuracion = new Configuracion();

                configuracion.setCodigoConfiguracion(
                    rs.getString("codigo_configuracion")
                );

                configuracion.setDepreciacionPorKm(
                    rs.getDouble("depreciacion_por_km")
                );

                configuracion.setFechaConfiguracion(
                    rs.getDate("fecha_configuracion")
                );

                return configuracion;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener configuracion: "
                + e.getMessage()
            );
        }

        return null;
    }
    
}
