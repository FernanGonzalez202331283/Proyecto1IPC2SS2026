/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.Reporte;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import transporte.conexion.Conexion;

/**
 *
 * @author fernan
 */
public class ReporteAlquileresDAO {
    public ResultSet obtenerReporte(
            String codigoSucursal,
            String fechaInicio,
            String fechaFin) throws SQLException {

        String sql = """
            SELECT
                a.codigo_alquiler,
                a.usuario_cliente AS cliente,
                v.origen,
                v.destino,
                v.fecha_salida,
                a.fecha_retorno,
                b.placa AS bus,
                a.precio_confirmado AS precio_total
            FROM alquiler a
            INNER JOIN viaje v
                ON v.codigo_viaje = a.codigo_viaje
            INNER JOIN bus b
                ON b.placa = v.placa_bus
            WHERE b.codigo_sucursal = ?
              AND (
                    ? IS NULL
                    OR ? = ''
                    OR v.fecha_salida >= ?
                  )
              AND (
                    ? IS NULL
                    OR ? = ''
                    OR v.fecha_salida <= ?
                  )
            ORDER BY
                v.fecha_salida DESC,
                a.codigo_alquiler ASC
            """;

        Connection conexion = Conexion.getConnection();

        PreparedStatement ps = conexion.prepareStatement(sql);

        int posicion = 1;

        // Sucursal
        ps.setString(posicion++, codigoSucursal);

        // Fecha inicial
        ps.setString(posicion++, fechaInicio);
        ps.setString(posicion++, fechaInicio);
        ps.setString(posicion++, fechaInicio);

        // Fecha final
        ps.setString(posicion++, fechaFin);
        ps.setString(posicion++, fechaFin);
        ps.setString(posicion++, fechaFin);

        return ps.executeQuery();
    }
}
