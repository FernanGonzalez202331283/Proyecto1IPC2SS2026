/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import transporte.conexion.Conexion;
import transporte.modelo.AdministrarSucursal;

/**
 *
 * @author fernan
 */
public class AdministrarSucursalDAO {
    
    public boolean insertar(AdministrarSucursal administrador){
        String sql = """
                     INSERT INTO administrador_sucursal
                     (usuario, codigo_sucursal)
                     VALUES (?,?)
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ) {
            ps.setString(1, administrador.getUsuario());
            ps.setString(2, administrador.getCodigoSucursal());
            
            ps.executeUpdate();
            
            return true;
            
        } catch (SQLException e) {
            System.out.println("Errora al insertar administrador de sucursal: "+e.getMessage());
        }
        return false;
    }
    
}
