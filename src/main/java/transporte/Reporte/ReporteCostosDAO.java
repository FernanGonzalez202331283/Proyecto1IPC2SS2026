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
public class ReporteCostosDAO {
    
    public ResultSet obtenerReporte(
            String fechaInicio,
            String fechaFin,
            String codigoSucursal) throws SQLException {

        String sql = """
            SELECT
                s.codigo_sucursal,
                s.nombre AS sucursal,

                COALESCE(combustible.combustible, 0) AS combustible,

                COALESCE(mantenimiento.mano_obra, 0) AS mano_obra,

                COALESCE(mantenimiento.repuestos, 0) AS repuestos,

                COALESCE(depreciacion.depreciacion, 0) AS depreciacion,

                COALESCE(combustible.combustible, 0)
                + COALESCE(mantenimiento.mano_obra, 0)
                + COALESCE(mantenimiento.repuestos, 0)
                + COALESCE(depreciacion.depreciacion, 0)
                AS total_costos

            FROM sucursal s

            LEFT JOIN (
                SELECT
                    bus.codigo_sucursal,
                    SUM(lv.gasto_combustible) AS combustible
                FROM bus
                INNER JOIN viaje v
                    ON v.placa_bus = bus.placa
                INNER JOIN llegada_viaje lv
                    ON lv.codigo_viaje = v.codigo_viaje
                WHERE v.fecha_salida BETWEEN ? AND ?
                GROUP BY bus.codigo_sucursal
            ) combustible
                ON combustible.codigo_sucursal = s.codigo_sucursal

            LEFT JOIN (
                SELECT
                    bus.codigo_sucursal,
                    SUM(m.monto_mano_obra) AS mano_obra,
                    SUM(m.monto_repuestos) AS repuestos
                FROM bus
                INNER JOIN mantenimiento m
                    ON m.placa_bus = bus.placa
                    AND m.fecha BETWEEN ? AND ?
                GROUP BY bus.codigo_sucursal
            ) mantenimiento
                ON mantenimiento.codigo_sucursal = s.codigo_sucursal

            LEFT JOIN (
                SELECT
                    bus.codigo_sucursal,
                    SUM(v.depreciacion_total) AS depreciacion
                FROM bus
                INNER JOIN viaje v
                    ON v.placa_bus = bus.placa
                    AND v.fecha_salida BETWEEN ? AND ?
                GROUP BY bus.codigo_sucursal
            ) depreciacion
                ON depreciacion.codigo_sucursal = s.codigo_sucursal

            WHERE (? IS NULL OR ? = '' OR s.codigo_sucursal = ?)

            ORDER BY s.nombre ASC
            """;

        Connection conexion = Conexion.getConnection();

        PreparedStatement ps = conexion.prepareStatement(sql);

        int posicion = 1;

        // Combustible
        ps.setString(posicion++, fechaInicio);
        ps.setString(posicion++, fechaFin);

        // Mantenimiento
        ps.setString(posicion++, fechaInicio);
        ps.setString(posicion++, fechaFin);

        // Depreciación
        ps.setString(posicion++, fechaInicio);
        ps.setString(posicion++, fechaFin);

        // Filtro de sucursal
        ps.setString(posicion++, codigoSucursal);
        ps.setString(posicion++, codigoSucursal);
        ps.setString(posicion++, codigoSucursal);

        return ps.executeQuery();
    }
}
