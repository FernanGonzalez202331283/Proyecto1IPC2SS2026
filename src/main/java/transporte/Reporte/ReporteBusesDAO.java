/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.Reporte;

import java.sql.Connection;
import java.sql.PreparedStatement;
import transporte.conexion.Conexion;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 *
 * @author fernan
 */
public class ReporteBusesDAO {
    public ResultSet obtenerReporte(
            String codigoSucursal,
            String estadoOperativo) throws SQLException {

        String sql = """
            SELECT
                b.placa,
                b.marca,
                b.modelo,
                b.capacidad,
                b.estado_operativo,

                COALESCE(
                    ultimo_chofer.nombre_completo,
                    'Sin chofer asignado'
                ) AS chofer_asignado,

                b.kilometraje_actual,

                COALESCE(
                    total_viajes.cantidad_viajes,
                    0
                ) AS total_viajes

            FROM bus b

            LEFT JOIN (
                SELECT
                    v1.placa_bus,
                    c1.nombre_completo

                FROM viaje v1

                INNER JOIN chofer c1
                    ON c1.numero_licencia = v1.numero_licencia

                WHERE NOT EXISTS (
                    SELECT 1
                    FROM viaje v2

                    WHERE v2.placa_bus = v1.placa_bus

                      AND (
                            v2.fecha_salida > v1.fecha_salida

                            OR (
                                v2.fecha_salida = v1.fecha_salida
                                AND v2.hora_salida > v1.hora_salida
                            )
                          )
                )
            ) ultimo_chofer

                ON ultimo_chofer.placa_bus = b.placa

            LEFT JOIN (
                SELECT
                    placa_bus,
                    COUNT(*) AS cantidad_viajes

                FROM viaje

                GROUP BY placa_bus
            ) total_viajes

                ON total_viajes.placa_bus = b.placa

            WHERE b.codigo_sucursal = ?

              AND (
                    ? IS NULL
                    OR ? = ''
                    OR b.estado_operativo = ?
                  )

            ORDER BY b.placa ASC
            """;

        Connection conexion = Conexion.getConnection();

        PreparedStatement ps = conexion.prepareStatement(sql);

        int posicion = 1;

        // Código de la sucursal del administrador
        ps.setString(posicion++, codigoSucursal);

        // Filtro opcional por estado
        ps.setString(posicion++, estadoOperativo);
        ps.setString(posicion++, estadoOperativo);
        ps.setString(posicion++, estadoOperativo);

        return ps.executeQuery();
    }
}
