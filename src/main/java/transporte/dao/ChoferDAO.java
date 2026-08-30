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
import transporte.modelo.Chofer;

/**
 *
 * @author fernan
 */
public class ChoferDAO {
    
    public boolean insertar(Chofer chofer){
        String sql = """
                     INSERT INTO chofer
                     (numero_licencia, codigo_sucursal, foto, nombre_completo, tipo_licencia, fecha_vencimiento_licencia, telefono, salario_base_viaje, estado)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                     """;
        
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ) {
            
            ps.setString(1, chofer.getNumeroLicencia());
            ps.setString(2, chofer.getCodigoSucursal());
            ps.setString(3, chofer.getFoto());
            ps.setString(4, chofer.getNombreCompleto());
            ps.setString(5, chofer.getTipoLicencia());
            ps.setString(6, chofer.getFechaVencimientoLicencia());
            ps.setString(7, chofer.getTelefono());
            ps.setDouble(8, chofer.getSalarioBaseViaje());
            ps.setBoolean(9, chofer.isEstado());
            
            ps.executeUpdate();
            
            return true;
            
        } catch (SQLException e) {
            System.out.println("Error al insertar chofer: "+e.getMessage());
        }
        return false;
    }
    
    public Chofer obtener(String numeroLicencia){
        String sql = """
                     SELECT numero_licencia, codigo_sucursal, foto,
                            nombre_completo, tipo_licencia,
                            fecha_vencimiento_licencia, telefono,
                            salario_base_viaje, estado
                     FROM chofer
                     WHERE numero_licencia = ?
                     """;
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            ps.setString(1, numeroLicencia);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {

            return new Chofer(
                rs.getString("numero_licencia"),
                rs.getString("codigo_sucursal"),
                rs.getString("foto"),
                rs.getString("nombre_completo"),
                rs.getString("tipo_licencia"),
                rs.getString("fecha_vencimiento_licencia"),
                rs.getString("telefono"),
                rs.getDouble("salario_base_viaje"),
                rs.getBoolean("estado")
            );
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al obtener chofer: " + e.getMessage()
        );
    }

    return null;
    }
    
     public boolean actualizar(Chofer chofer) {

        String sql = """
            UPDATE chofer
            SET codigo_sucursal = ?,
                foto = ?,
                nombre_completo = ?,
                tipo_licencia = ?,
                fecha_vencimiento_licencia = ?,
                telefono = ?,
                salario_base_viaje = ?,
                estado = ?
            WHERE numero_licencia = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, chofer.getCodigoSucursal());
            ps.setString(2, chofer.getFoto());
            ps.setString(3, chofer.getNombreCompleto());
            ps.setString(4, chofer.getTipoLicencia());
            ps.setString(5, chofer.getFechaVencimientoLicencia());
            ps.setString(6, chofer.getTelefono());
            ps.setDouble(7, chofer.getSalarioBaseViaje());
            ps.setBoolean(8, chofer.isEstado());

            ps.setString(9, chofer.getNumeroLicencia());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar chofer: " + e.getMessage()
            );

            return false;
        }
    }

    // listar 
    public void listar() {

        String sql = """
            SELECT numero_licencia, codigo_sucursal,
                   nombre_completo, tipo_licencia,
                   fecha_vencimiento_licencia,
                   telefono, salario_base_viaje, estado
            FROM chofer
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Licencia: " + rs.getString("numero_licencia")
                    + " | Sucursal: " + rs.getString("codigo_sucursal")
                    + " | Nombre: " + rs.getString("nombre_completo")
                    + " | Tipo: " + rs.getString("tipo_licencia")
                    + " | Vencimiento: " + rs.getString("fecha_vencimiento_licencia")
                    + " | Salario: " + rs.getDouble("salario_base_viaje")
                    + " | Estado: " + rs.getBoolean("estado")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar choferes: " + e.getMessage()
            );
        }
    }

    // desactivar
    public boolean desactivar(String numeroLicencia) {

        String sql = """
            UPDATE chofer
            SET estado = FALSE
            WHERE numero_licencia = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, numeroLicencia);

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al desactivar chofer: " + e.getMessage()
            );

            return false;
        }
    }
    
    
}
