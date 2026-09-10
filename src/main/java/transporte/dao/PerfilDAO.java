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
    
     public Perfil buscarPorUsuario(String usuario) {

        String sql = """
                     SELECT usuario,
                            nit,
                            dpi,
                            nombre_completo,
                            telefono,
                            direccion
                     FROM perfil
                     WHERE usuario = ?
                     """;

        try (
            Connection conexion = Conexion.getConnection();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {

            ps.setString(1, usuario);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return new Perfil(
                        rs.getString("usuario"),
                        rs.getString("nit"),
                        rs.getString("dpi"),
                        rs.getString("nombre_completo"),
                        rs.getString("telefono"),
                        rs.getString("direccion")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al buscar Perfil: "
                    + e.getMessage()
            );
        }

        return null;
    }


    public boolean actualizar(Perfil perfil) {

        String sql = """
                     UPDATE perfil
                     SET nit = ?,
                         dpi = ?,
                         nombre_completo = ?,
                         telefono = ?,
                         direccion = ?
                     WHERE usuario = ?
                     """;

        try (
            Connection conexion = Conexion.getConnection();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {

            ps.setString(1, perfil.getNit());
            ps.setString(2, perfil.getDpi());
            ps.setString(3, perfil.getNombreCompleto());
            ps.setString(4, perfil.getTelefono());
            ps.setString(5, perfil.getDireccion());
            ps.setString(6, perfil.getUsuario());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                    "Error al actualizar Perfil: "
                    + e.getMessage()
            );

            return false;
        }
    }
    public boolean estaCompleto(String usuario) {

    String sql = """
                 SELECT COUNT(*) AS cantidad
                 FROM perfil
                 WHERE usuario = ?
                   AND nit IS NOT NULL
                   AND TRIM(nit) <> ''
                   AND dpi IS NOT NULL
                   AND TRIM(dpi) <> ''
                   AND nombre_completo IS NOT NULL
                   AND TRIM(nombre_completo) <> ''
                   AND telefono IS NOT NULL
                   AND TRIM(telefono) <> ''
                   AND direccion IS NOT NULL
                   AND TRIM(direccion) <> ''
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, usuario);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt("cantidad") > 0;
        }

    } catch (SQLException e) {

        System.out.println(
                "Error al verificar si el perfil está completo: "
                + e.getMessage()
        );
    }

    return false;
}
    
}
