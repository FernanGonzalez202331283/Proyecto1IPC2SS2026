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
import transporte.modelo.Boleto;

/**
 *
 * @author fernan
 */
public class BoletoDAO {
    
    public boolean insertar(Boleto boleto) {

        String sql = """
            INSERT INTO boleto
            (codigo_boleto, codigo_viaje, usuario_cliente,
             numero_asiento, precio, fecha_pago,
             estado, codigo_movimiento)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, boleto.getCodigoBoleto());
            ps.setString(2, boleto.getCodigoViaje());
            ps.setString(3, boleto.getUsuarioCliente());
            ps.setInt(4, boleto.getNumeroAsiento());
            ps.setDouble(5, boleto.getPrecio());
            ps.setDate(6, boleto.getFechaPago());
            ps.setString(7, boleto.getEstado());
            ps.setString(8, boleto.getCodigoMovimiento());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar boleto: "
                + e.getMessage()
            );

            return false;
        }
    }
    
    public Boleto obtener(String codigoBoleto) {

        String sql = """
            SELECT codigo_boleto,
                   codigo_viaje,
                   usuario_cliente,
                   numero_asiento,
                   precio,
                   fecha_pago,
                   estado,
                   codigo_movimiento
            FROM boleto
            WHERE codigo_boleto = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoBoleto);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Boleto boleto = new Boleto();

                boleto.setCodigoBoleto(
                    rs.getString("codigo_boleto")
                );

                boleto.setCodigoViaje(
                    rs.getString("codigo_viaje")
                );

                boleto.setUsuarioCliente(
                    rs.getString("usuario_cliente")
                );

                boleto.setNumeroAsiento(
                    rs.getInt("numero_asiento")
                );

                boleto.setPrecio(
                    rs.getDouble("precio")
                );

                boleto.setFechaPago(
                    rs.getDate("fecha_pago")
                );

                boleto.setEstado(
                    rs.getString("estado")
                );

                boleto.setCodigoMovimiento(
                    rs.getString("codigo_movimiento")
                );

                return boleto;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener boleto: "
                + e.getMessage()
            );
        }

        return null;
    }
    
     public boolean actualizar(Boleto boleto) {

        String sql = """
            UPDATE boleto
            SET codigo_viaje = ?,
                usuario_cliente = ?,
                numero_asiento = ?,
                precio = ?,
                fecha_pago = ?,
                estado = ?,
                codigo_movimiento = ?
            WHERE codigo_boleto = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, boleto.getCodigoViaje());
            ps.setString(2, boleto.getUsuarioCliente());
            ps.setInt(3, boleto.getNumeroAsiento());
            ps.setDouble(4, boleto.getPrecio());
            ps.setDate(5, boleto.getFechaPago());
            ps.setString(6, boleto.getEstado());
            ps.setString(7, boleto.getCodigoMovimiento());
            ps.setString(8, boleto.getCodigoBoleto());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar boleto: "
                + e.getMessage()
            );

            return false;
        }
    }
     
    public void listar() {

        String sql = """
            SELECT codigo_boleto,
                   codigo_viaje,
                   usuario_cliente,
                   numero_asiento,
                   precio,
                   fecha_pago,
                   estado,
                   codigo_movimiento
            FROM boleto
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Boleto: "
                    + rs.getString("codigo_boleto")
                    + " | Viaje: "
                    + rs.getString("codigo_viaje")
                    + " | Cliente: "
                    + rs.getString("usuario_cliente")
                    + " | Asiento: "
                    + rs.getInt("numero_asiento")
                    + " | Precio: "
                    + rs.getDouble("precio")
                    + " | Fecha: "
                    + rs.getDate("fecha_pago")
                    + " | Estado: "
                    + rs.getString("estado")
                    + " | Movimiento: "
                    + rs.getString("codigo_movimiento")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar boletos: "
                + e.getMessage()
            );
        }
    }
}
