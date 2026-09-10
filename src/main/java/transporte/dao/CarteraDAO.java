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
import transporte.modelo.Cartera;

/**
 *
 * @author fernan
 */
public class CarteraDAO {
    
     public boolean insertar(Cartera cartera) {

        String sql = """
            INSERT INTO cartera
            (usuario, saldo)
            VALUES (?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, cartera.getUsuario());
            ps.setDouble(2, cartera.getSaldo());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar cartera: "
                + e.getMessage()
            );

            return false;
        }
    }
     
    public Cartera obtener(String usuario) {

        String sql = """
            SELECT usuario, saldo
            FROM cartera
            WHERE usuario = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, usuario);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Cartera cartera = new Cartera();

                cartera.setUsuario(
                    rs.getString("usuario")
                );

                cartera.setSaldo(
                    rs.getDouble("saldo")
                );

                return cartera;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener cartera: "
                + e.getMessage()
            );
        }

        return null;
    }
    
    public boolean actualizar(Cartera cartera) {

        String sql = """
            UPDATE cartera
            SET saldo = ?
            WHERE usuario = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setDouble(1, cartera.getSaldo());
            ps.setString(2, cartera.getUsuario());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar cartera: "
                + e.getMessage()
            );

            return false;
        }
    }
    
     public void listar() {

        String sql = """
            SELECT usuario, saldo
            FROM cartera
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Usuario: "
                    + rs.getString("usuario")
                    + " | Saldo: "
                    + rs.getDouble("saldo")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar carteras: "
                + e.getMessage()
            );
        }
    }
    
}
