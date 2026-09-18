/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.Reporte;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import transporte.conexion.Conexion;
import transporte.modelo.ReporteBoleto;
import transporte.modelo.Ruta;
import transporte.modelo.Bus;

/**
 *
 * @author fernan
 */
public class ReporteBoletosDAO {
public List<ReporteBoleto> obtenerReporte(
        String codigoSucursal,
        String fechaInicio,
        String fechaFin,
        String codigoRuta,
        String placaBus) throws SQLException {

    List<ReporteBoleto> reporte = new ArrayList<>();
    if (fechaInicio != null && fechaInicio.trim().isEmpty()) {
        fechaInicio = null;
    }

    if (fechaFin != null && fechaFin.trim().isEmpty()) {
        fechaFin = null;
    }

    if (codigoRuta != null && codigoRuta.trim().isEmpty()) {
        codigoRuta = null;
    }

    if (placaBus != null && placaBus.trim().isEmpty()) {
        placaBus = null;
    }

    String sql = """
        SELECT
            v.codigo_viaje,

            CONCAT(
                s_origen.nombre,
                ' -> ',
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
                OR v.fecha_salida >= ?
              )

          AND (
                ? IS NULL
                OR v.fecha_salida <= ?
              )

          AND (
                ? IS NULL
                OR r.codigo_ruta = ?
              )

          AND (
                ? IS NULL
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

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        int posicion = 1;

        // Sucursal
        ps.setString(posicion++, codigoSucursal);

        // Fecha inicial
        ps.setString(posicion++, fechaInicio);
        ps.setString(posicion++, fechaInicio);

        // Fecha final
        ps.setString(posicion++, fechaFin);
        ps.setString(posicion++, fechaFin);

        // Ruta
        ps.setString(posicion++, codigoRuta);
        ps.setString(posicion++, codigoRuta);

        // Bus
        ps.setString(posicion++, placaBus);
        ps.setString(posicion++, placaBus);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ReporteBoleto item = new ReporteBoleto();

                item.setCodigoViaje(
                        rs.getString("codigo_viaje")
                );

                item.setRuta(
                        rs.getString("ruta")
                );

                item.setBus(
                        rs.getString("bus")
                );

                item.setFechaSalida(
                        rs.getString("fecha_salida")
                );

                item.setBoletosVendidos(
                        rs.getInt("boletos_vendidos")
                );

                item.setIngresoTotal(
                        rs.getDouble("ingreso_total")
                );

                reporte.add(item);
            }
        }
    }

    return reporte;
}
    public List<Ruta> listarRutasPorSucursal(
            String codigoSucursal) throws SQLException {

        List<Ruta> rutas = new ArrayList<>();

        String sql = """
            SELECT
                codigo_ruta,
                codigo_sucursal_origen,
                codigo_sucursal_destino,
                distancia_km,
                precio_boleto,
                estado
            FROM ruta
            WHERE codigo_sucursal_origen = ?
            ORDER BY codigo_ruta ASC
            """;

        try (
            Connection conexion = Conexion.getConnection();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {

            ps.setString(1, codigoSucursal);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Ruta ruta = new Ruta(
                            rs.getString("codigo_ruta"),
                            rs.getString("codigo_sucursal_origen"),
                            rs.getString("codigo_sucursal_destino"),
                            rs.getDouble("distancia_km"),
                            rs.getDouble("precio_boleto"),
                            rs.getBoolean("estado")
                    );

                    rutas.add(ruta);
                }
            }
        }

        return rutas;
    }

    public List<Bus> listarBusesPorSucursal(String codigoSucursal) throws SQLException {

        List<Bus> buses = new ArrayList<>();

        String sql = """
            SELECT
                placa,
                codigo_sucursal,
                marca,
                modelo
            FROM bus
            WHERE codigo_sucursal = ?
            ORDER BY placa ASC
            """;

        try (
            Connection conexion = Conexion.getConnection();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {

            ps.setString(1, codigoSucursal);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Bus bus = new Bus();

                    bus.setPlaca(rs.getString("placa"));
                    bus.setCodigoSucursal(
                        rs.getString("codigo_sucursal")
                    );
                    bus.setMarca(rs.getString("marca"));
                    bus.setModelo(rs.getString("modelo"));

                    buses.add(bus);
                }
            }
        }

        return buses;
    }
}
