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
import transporte.modelo.Viaje;

/**
 *
 * @author fernan
 */
public class ViajeDAO {
    public boolean insertar(Viaje viaje){
         String sql = """
                INSERT INTO viaje
                (codigo_viaje, tipo_viaje, placa_bus, numero_licencia,
                 codigo_ruta, origen, destino, fecha_salida, hora_salida,
                 fecha_llegada_estimada, hora_llegada_estimada, estado,
                 depreciacion_por_km, depreciacion_total)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
         try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, viaje.getCodigoViaje());
            ps.setString(2, viaje.getTipoViaje());
            ps.setString(3, viaje.getPlacaBus());
            ps.setString(4, viaje.getNumeroLicencia());
            ps.setString(5, viaje.getCodigoRuta());
            ps.setString(6, viaje.getOrigen());
            ps.setString(7, viaje.getDestino());
            ps.setDate(8, viaje.getFechaSalida());
            ps.setTime(9, viaje.getHoraSalida());
            ps.setDate(10, viaje.getFechaLlegadaEstimada());
            ps.setTime(11, viaje.getHoraLlegadaEstimada());
            ps.setString(12, viaje.getEstado());
            ps.setDouble(13, viaje.getDepreciacionPorKm());
            ps.setDouble(14, viaje.getDepreciacionTotal());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar viaje: " + e.getMessage()
            );

            return false;
        }
    }
    
     public Viaje obtener(String codigoViaje) {

        String sql = """
            SELECT codigo_viaje, tipo_viaje, placa_bus,
                   numero_licencia, codigo_ruta, origen, destino,
                   fecha_salida, hora_salida,
                   fecha_llegada_estimada, hora_llegada_estimada,
                   estado, depreciacion_por_km, depreciacion_total
            FROM viaje
            WHERE codigo_viaje = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoViaje);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Viaje viaje = new Viaje();

                viaje.setCodigoViaje(
                    rs.getString("codigo_viaje")
                );

                viaje.setTipoViaje(
                    rs.getString("tipo_viaje")
                );

                viaje.setPlacaBus(
                    rs.getString("placa_bus")
                );

                viaje.setNumeroLicencia(
                    rs.getString("numero_licencia")
                );

                viaje.setCodigoRuta(
                    rs.getString("codigo_ruta")
                );

                viaje.setOrigen(
                    rs.getString("origen")
                );

                viaje.setDestino(
                    rs.getString("destino")
                );

                viaje.setFechaSalida(
                    rs.getDate("fecha_salida")
                );

                viaje.setHoraSalida(
                    rs.getTime("hora_salida")
                );

                viaje.setFechaLlegadaEstimada(
                    rs.getDate("fecha_llegada_estimada")
                );

                viaje.setHoraLlegadaEstimada(
                    rs.getTime("hora_llegada_estimada")
                );

                viaje.setEstado(
                    rs.getString("estado")
                );

                viaje.setDepreciacionPorKm(
                    rs.getDouble("depreciacion_por_km")
                );

                viaje.setDepreciacionTotal(
                    rs.getDouble("depreciacion_total")
                );

                return viaje;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener viaje: " + e.getMessage()
            );
        }

        return null;
    }
     
    public boolean actualizar(Viaje viaje) {

        String sql = """
            UPDATE viaje
            SET placa_bus = ?,
                numero_licencia = ?,
                codigo_ruta = ?,
                origen = ?,
                destino = ?,
                fecha_salida = ?,
                hora_salida = ?,
                fecha_llegada_estimada = ?,
                hora_llegada_estimada = ?,
                estado = ?,
                depreciacion_por_km = ?,
                depreciacion_total = ?
            WHERE codigo_viaje = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, viaje.getPlacaBus());
            ps.setString(2, viaje.getNumeroLicencia());
            ps.setString(3, viaje.getCodigoRuta());
            ps.setString(4, viaje.getOrigen());
            ps.setString(5, viaje.getDestino());
            ps.setDate(6, viaje.getFechaSalida());
            ps.setTime(7, viaje.getHoraSalida());
            ps.setDate(8, viaje.getFechaLlegadaEstimada());
            ps.setTime(9, viaje.getHoraLlegadaEstimada());
            ps.setString(10, viaje.getEstado());
            ps.setDouble(11, viaje.getDepreciacionPorKm());
            ps.setDouble(12, viaje.getDepreciacionTotal());
            ps.setString(13, viaje.getCodigoViaje());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar viaje: " + e.getMessage()
            );

            return false;
        }
    }
    
    public void listar() {

        String sql = """
            SELECT codigo_viaje, tipo_viaje, placa_bus,
                   numero_licencia, codigo_ruta,
                   fecha_salida, hora_salida,
                   fecha_llegada_estimada, hora_llegada_estimada,
                   estado, depreciacion_por_km,
                   depreciacion_total
            FROM viaje
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Viaje: " + rs.getString("codigo_viaje")
                    + " | Tipo: " + rs.getString("tipo_viaje")
                    + " | Bus: " + rs.getString("placa_bus")
                    + " | Chofer: " + rs.getString("numero_licencia")
                    + " | Ruta: " + rs.getString("codigo_ruta")
                    + " | Salida: " + rs.getDate("fecha_salida")
                    + " " + rs.getTime("hora_salida")
                    + " | Estado: " + rs.getString("estado")
                    + " | Depreciación: "
                    + rs.getDouble("depreciacion_total")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar viajes: " + e.getMessage()
            );
        }
    }

    //eliminar
    public boolean eliminar(String codigoViaje) {

        String sql = """
            DELETE FROM viaje
            WHERE codigo_viaje = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoViaje);

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al eliminar viaje: " + e.getMessage()
            );

            return false;
        }
    }
    
    
}
