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
public class ReporteChoferesDAO {
    public ResultSet obtenerReporte(
            String codigoSucursal) throws SQLException {

        String sql = """
            SELECT
                c.numero_licencia,
                c.nombre_completo,
                c.tipo_licencia,
                c.fecha_vencimiento_licencia,
                c.estado,

                COALESCE(
                    total_viajes.cantidad_viajes,
                    0
                ) AS total_viajes

            FROM chofer c

            LEFT JOIN (
                SELECT
                    numero_licencia,
                    COUNT(*) AS cantidad_viajes

                FROM viaje

                GROUP BY numero_licencia
            ) total_viajes

                ON total_viajes.numero_licencia =
                   c.numero_licencia

            WHERE c.codigo_sucursal = ?

            ORDER BY c.nombre_completo ASC
            """;

        Connection conexion = Conexion.getConnection();

        PreparedStatement ps =
                conexion.prepareStatement(sql);

        ps.setString(1, codigoSucursal);

        return ps.executeQuery();
    }
}
