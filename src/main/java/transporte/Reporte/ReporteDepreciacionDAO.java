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
public class ReporteDepreciacionDAO {
     public ResultSet obtenerReporte(String codigoSucursal) throws SQLException {

        String sql = """
            SELECT
                b.placa,
                b.kilometraje_actual AS total_km_recorridos,
                c.depreciacion_por_km,
                (
                    b.kilometraje_actual * c.depreciacion_por_km
                ) AS depreciacion_total
            FROM bus b
            CROSS JOIN (
                SELECT depreciacion_por_km
                FROM configuracion
                ORDER BY fecha_configuracion DESC
                LIMIT 1
            ) c
            WHERE b.codigo_sucursal = ?
            ORDER BY b.placa ASC
            """;

        Connection conexion = Conexion.getConnection();

        PreparedStatement ps = conexion.prepareStatement(sql);

        ps.setString(1, codigoSucursal);

        return ps.executeQuery();
    }
}
