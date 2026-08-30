/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import transporte.conexion.Conexion;
import transporte.modelo.Usuario;

/**
 *
 * @author fernan
 */
public class UsuarioDAO {
    
    public boolean insertar(Usuario usuario){
        String sql = """
                     INSERT INTO usuario(
                     usuario, contrasena, rol, estado
                     )
                     VALUES (?,?,?,?)
                     """;
        
        try (
            Connection conexion = Conexion.getConnection();
            PreparedStatement ps = conexion.prepareStatement(sql)
                    ){
            ps.setString(1, usuario.getUsuario());
            ps.setString(2, usuario.getContraseña());
            ps.setString(3, usuario.getRol());
            ps.setBoolean(4, usuario.isEstado());
            
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
                System.out.println("Error al insertar usuario: "+ e.getMessage());
                return false;
        }
    }
    
    public Usuario buscarPorUsuario(String usuario){
        String sql = """
                     SELECT usuario, contrasena, rol, estado
                     FROM usuario
                     WHERE usuario = ?
                     """;
        try (
                Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            ps.setString(1, usuario);
            var rs = ps.executeQuery();
            
            if(rs.next()){
                Usuario encontrado = new Usuario();
                encontrado.setUsuario(rs.getString("usuario"));
                encontrado.setContraseña(rs.getString("contrasena"));
                encontrado.setRol(rs.getString("rol"));
                encontrado.setEstado(rs.getBoolean("estado"));
                return encontrado;

            }
            
        } catch (SQLException e) {
            System.out.println("error al buscar usuario "+e.getMessage());
            
        }
        return null;
    }
    
    public boolean actualizar(Usuario usuario){
        String sql = """
                     UPDATE usuario
                     SET contrasena = ?,
                     rol = ?,
                     estado = ?
                     WHERE usuario = ? 
                     """;
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            
            ps.setString(1, usuario.getContraseña());
            ps.setString(2, usuario.getRol());
            ps.setBoolean(3, usuario.isEstado());
            ps.setString(4, usuario.getUsuario());
            
            ps.executeUpdate();
            
            return true;
        } catch (SQLException e) {
            System.out.println("Usuario actualizado "+e.getMessage());
        }
        return false;
    }
}
