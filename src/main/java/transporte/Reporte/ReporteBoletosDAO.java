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
public class ReporteBoletosDAO {
    public ResultSet obtenerReporte(
            String codigoSucursal,
            String fechaInicio,
            String fechaFin,
            String codigoRuta,
            String placaBus) throws SQLException {

        String sql = """
            SELECT
                v.codigo_viaje,

                CONCAT(
                    s_origen.nombre,
                    ' → ',
                    s_destino.nombre
                ) AS ruta,

                b.placa AS bus,

                v.fecha_salida,

                COUNT(bo.codigo_boleto)
                    AS boletos_vendidos,

                COALESCE(
                    SUM(bo.precio),
                    0
                ) AS ingreso_total

            FROM viaje v

            INNER JOIN ruta r
                ON r.codigo_ruta = v.codigo_ruta

            INNER JOIN sucursal s_origen
                ON s_origen.codigo_sucursal =
                   r.codigo_sucursal_origen

            INNER JOIN sucursal s_destino
                ON s_destino.codigo_sucursal =
                   r.codigo_sucursal_destino

            INNER JOIN bus b
                ON b.placa = v.placa_bus

            INNER JOIN boleto bo
                ON bo.codigo_viaje = v.codigo_viaje
                AND bo.estado = 'PAGADO'

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

              AND (
                    ? IS NULL
                    OR ? = ''
                    OR r.codigo_ruta = ?
                  )

              AND (
                    ? IS NULL
                    OR ? = ''
                    OR b.placa = ?
                  )

            GROUP BY
                v.codigo_viaje,
                s_origen.nombre,
                s_destino.nombre,
                b.placa,
                v.fecha_salida

            ORDER BY
                v.fecha_salida DESC,
                v.codigo_viaje ASC
            """;

        Connection conexion = Conexion.getConnection();

        PreparedStatement ps =
                conexion.prepareStatement(sql);

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

        // Ruta
        ps.setString(posicion++, codigoRuta);
        ps.setString(posicion++, codigoRuta);
        ps.setString(posicion++, codigoRuta);

        // Bus
        ps.setString(posicion++, placaBus);
        ps.setString(posicion++, placaBus);
        ps.setString(posicion++, placaBus);

        return ps.executeQuery();
    }
}
