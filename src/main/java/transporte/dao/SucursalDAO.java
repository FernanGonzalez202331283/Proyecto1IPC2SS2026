/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import transporte.conexion.Conexion;
import transporte.modelo.Sucursal;

/**
 *
 * @author fernan
 */
public class SucursalDAO {
    
    public boolean insertar(Sucursal sucursal){
        String sql = """
                     INSERT INTO sucursal
                     (codigo_sucursal, nombre, direccion, telefono, municipio, departamento, latitud, longitud, estado)
                     VALUES (?,?,?,?,?,?,?,?,?)
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            
            ps.setString(1, sucursal.getCodigoSucursal());
            ps.setString(2, sucursal.getNombre());
            ps.setString(3, sucursal.getDireccion());
            ps.setString(4, sucursal.getTelefono());
            ps.setString(5, sucursal.getMunicipio());
            ps.setString(6, sucursal.getDepartamento());
            ps.setDouble(7, sucursal.getLatitud());
            ps.setDouble(8, sucursal.getLongitud());
            ps.setBoolean(9, sucursal.isEstado());
            
            ps.executeUpdate();
            
            return true;
            
        } catch (SQLException e) {
            System.out.println("Sucursal creado correctamente"+e.getMessage());
            return false;
        }
    }
    
    public Sucursal buscar(String codigoSucursal){
        
        String sql = """
                     SELECT codigo_sucursal, nombre, direccion, telefono, municipio, departamento, latitud, longitud, estado
                     FROM sucursal
                     WHERE codigo_sucursal = ?
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ) {
            ps.setString(1, codigoSucursal);
            
            var rs = ps.executeQuery();
            
            if(rs.next()){
               Sucursal sucursal = new Sucursal();
               
               sucursal.setCodigoSucursal(rs.getString("codigo_sucursal"));
               sucursal.setNombre(rs.getString("nombre"));
               sucursal.setDireccion(rs.getString("direccion"));
               sucursal.setTelefono(rs.getString("telefono"));
               sucursal.setMunicipio(rs.getString("municipio"));
               sucursal.setDepartamento(rs.getString("departamento"));
               sucursal.setLatitud(rs.getDouble("latitud"));
               sucursal.setLongitud(rs.getDouble("longitud"));
               sucursal.setEstado(rs.getBoolean("estado"));
               
               return sucursal;
            }
            
        } catch (SQLException e) {
            System.out.println("error al buscar sucursal "+e.getMessage());
        }
        return null;
    }
    
    public Sucursal[] listar (){
        String sql = """
                     SELECT codigo_sucursal, nombre, direccion, telefono, municipio,
                     departamento, latitud, longitud, estado
                     FROM sucursal
                     """;
        Sucursal[] sucursales = new Sucursal[100];
        int contador = 0;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql);
                var rs = ps.executeQuery();
                ) {
            while (rs.next()) {
                Sucursal sucursal = new Sucursal();
                sucursal.setCodigoSucursal(rs.getString("codigo_sucursal"));
                sucursal.setNombre(rs.getString("nombre"));
                sucursal.setDireccion(rs.getString("direccion"));
                sucursal.setTelefono(rs.getString("telefono"));
                sucursal.setMunicipio(rs.getString("municipio"));
                sucursal.setDepartamento(rs.getString("departamento"));
                sucursal.setLatitud(rs.getDouble("latitud"));
                sucursal.setLongitud(rs.getDouble("longitud"));
                sucursal.setEstado(rs.getBoolean("estado"));
                
                sucursales[contador] = sucursal;
                contador++;
                
            }
            
            
        } catch (SQLException e) {
            System.out.println("Error allistar sucursales: "+e.getMessage());
        }
        return sucursales;
    }
    
    public boolean actualizar(Sucursal sucursal){
        String sql = """
                     UPDATE sucursal
                     SET nombre = ?,
                     direccion =?,
                     telefono =?,
                     municipio =?,
                     departamento =?,
                     latitud =?,
                     longitud =?
                     WHERE codigo_sucursal = ? 
                     """;
        
        try(Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ) {
            ps.setString(1, sucursal.getNombre());
            ps.setString(2, sucursal.getDireccion());
            ps.setString(3, sucursal.getTelefono());
            ps.setString(4, sucursal.getMunicipio());
            ps.setString(5, sucursal.getDepartamento());
            ps.setDouble(6, sucursal.getLatitud());
            ps.setDouble(7, sucursal.getLongitud());
            ps.setString(8, sucursal.getCodigoSucursal());
            
            int filas = ps.executeUpdate();
            return filas >0;
            
        } catch (SQLException e) {
            System.out.println(" Error al actualizar la sucursal "+ e.getMessage());
            return false;
        }
    }
    
    public boolean desactivar(String codigoSucursal){
        String sql = """
                     UPDATE sucursal
                     SET estado = FALSE
                     WHERE codigo_sucursal = ?
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            ps.setString(1, codigoSucursal);
            
            int filas = ps.executeUpdate();
            
            return filas > 0;
            
            
        } catch (SQLException e) {
            System.out.println("Error al desactivar sucursal"+e.getMessage());
            return false;
        }
    }
    
}
