/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import transporte.conexion.Conexion;
import transporte.modelo.Perfil;

/**
 *
 * @author fernan
 */
public class PerfilDAO {
    
    public boolean insertar(Perfil perfil){
        String sql = """
                     INSERT INTO perfil
                     (usuario, nit, dpi, nombre_completo, telefono, direccion)
                     VALUES (?,?,?,?,?,?)
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ) {
            ps.setString(1, perfil.getUsuario());
            ps.setString(2, perfil.getNit());
            ps.setString(3, perfil.getDpi());
            ps.setString(4, perfil.getNombreCompleto());
            ps.setString(5, perfil.getTelefono());
            ps.setString(6, perfil.getDireccion());
            
            ps.executeUpdate();
            return true;
            
            
        } catch (SQLException e) {
            System.out.println("Error al insertar Perfil"+e.getMessage());
            return false;
        }
    }
    
}
