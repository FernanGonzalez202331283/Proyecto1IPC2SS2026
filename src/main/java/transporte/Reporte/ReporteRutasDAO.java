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
public class ReporteRutasDAO {
    public ResultSet obtenerReporte(
        String fechaInicio,
        String fechaFin) throws SQLException {

    String sql = """
        SELECT
            r.codigo_ruta,
            s_origen.nombre AS sucursal_origen,
            s_destino.nombre AS sucursal_destino,
            r.distancia_km,
            r.precio_boleto,
            COUNT(b.codigo_boleto) AS boletos_vendidos

        FROM ruta r

        INNER JOIN sucursal s_origen
            ON s_origen.codigo_sucursal =
               r.codigo_sucursal_origen

        INNER JOIN sucursal s_destino
            ON s_destino.codigo_sucursal =
               r.codigo_sucursal_destino

        INNER JOIN viaje v
            ON v.codigo_ruta = r.codigo_ruta
            AND v.tipo_viaje = 'REGULAR'

        INNER JOIN boleto b
            ON b.codigo_viaje = v.codigo_viaje
            AND b.estado = 'PAGADO'
            AND b.fecha_pago BETWEEN ? AND ?

        GROUP BY
            r.codigo_ruta,
            s_origen.nombre,
            s_destino.nombre,
            r.distancia_km,
            r.precio_boleto

        ORDER BY
            boletos_vendidos DESC
        """;

    Connection conexion = Conexion.getConnection();

    PreparedStatement ps = conexion.prepareStatement(sql);

    ps.setString(1, fechaInicio);
    ps.setString(2, fechaFin);

    return ps.executeQuery();
}
}
