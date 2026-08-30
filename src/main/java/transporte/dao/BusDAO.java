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
import transporte.modelo.Bus;

/**
 *
 * @author fernan
 */
public class BusDAO {
     public boolean insertar(Bus bus) {

        String sql = """
            INSERT INTO bus
            (placa, codigo_sucursal, foto, marca, modelo,
             anio_fabricacion, capacidad, estado_operativo,
             kilometraje_actual)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, bus.getPlaca());
            ps.setString(2, bus.getCodigoSucursal());
            ps.setString(3, bus.getFoto());
            ps.setString(4, bus.getMarca());
            ps.setString(5, bus.getModelo());
            ps.setInt(6, bus.getAñoFabricacion());
            ps.setInt(7, bus.getCapacidad());
            ps.setString(8, bus.getEstadoOperativo());
            ps.setDouble(9, bus.getKilometrajeActual());

            ps.executeUpdate();

            return true;

        } catch (SQLException e) {

            System.out.println(
                "Error al insertar bus: " + e.getMessage()
            );

            return false;
        }
    }

    public boolean actualizar(Bus bus) {

        String sql = """
            UPDATE bus
            SET codigo_sucursal = ?,
                foto = ?,
                marca = ?,
                modelo = ?,
                anio_fabricacion = ?,
                capacidad = ?,
                estado_operativo = ?,
                kilometraje_actual = ?
            WHERE placa = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, bus.getCodigoSucursal());
            ps.setString(2, bus.getFoto());
            ps.setString(3, bus.getMarca());
            ps.setString(4, bus.getModelo());
            ps.setInt(5, bus.getAñoFabricacion());
            ps.setInt(6, bus.getCapacidad());
            ps.setString(7, bus.getEstadoOperativo());
            ps.setDouble(8, bus.getKilometrajeActual());
            ps.setString(9, bus.getPlaca());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                "Error al actualizar bus: " + e.getMessage()
            );

            return false;
        }
    }

    public Bus obtener(String placa) {

        String sql = """
            SELECT placa,
                   codigo_sucursal,
                   foto,
                   marca,
                   modelo,
                   anio_fabricacion,
                   capacidad,
                   estado_operativo,
                   kilometraje_actual
            FROM bus
            WHERE placa = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, placa);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Bus bus = new Bus();

                bus.setPlaca(
                    rs.getString("placa")
                );

                bus.setCodigoSucursal(
                    rs.getString("codigo_sucursal")
                );

                bus.setFoto(
                    rs.getString("foto")
                );

                bus.setMarca(
                    rs.getString("marca")
                );

                bus.setModelo(
                    rs.getString("modelo")
                );

                bus.setAñoFabricacion(
                    rs.getInt("anio_fabricacion")
                );

                bus.setCapacidad(
                    rs.getInt("capacidad")
                );

                bus.setEstadoOperativo(
                    rs.getString("estado_operativo")
                );

                bus.setKilometrajeActual(
                    rs.getDouble("kilometraje_actual")
                );

                return bus;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al obtener bus: " + e.getMessage()
            );
        }

        return null;
    }

    public void listar() {

        String sql = """
            SELECT placa,
                   codigo_sucursal,
                   marca,
                   modelo,
                   capacidad,
                   estado_operativo,
                   kilometraje_actual
            FROM bus
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                System.out.println(
                    "Placa: " + rs.getString("placa")
                    + " | Sucursal: " + rs.getString("codigo_sucursal")
                    + " | Marca: " + rs.getString("marca")
                    + " | Modelo: " + rs.getString("modelo")
                    + " | Capacidad: " + rs.getInt("capacidad")
                    + " | Estado: " + rs.getString("estado_operativo")
                    + " | Kilometraje: " + rs.getDouble("kilometraje_actual")
                );
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al listar buses: " + e.getMessage()
            );
        }
    }

    public boolean desactivar(String placa) {

        String sqlVerificar = """
            SELECT COUNT(*)
            FROM viaje
            WHERE placa_bus = ?
            AND estado IN ('PROGRAMADO', 'EN_CURSO')
            """;

        String sqlDesactivar = """
            UPDATE bus
            SET estado_operativo = 'INACTIVO'
            WHERE placa = ?
            """;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement psVerificar =
                 conexion.prepareStatement(sqlVerificar)) {

            psVerificar.setString(1, placa);

            ResultSet rs = psVerificar.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {

                System.out.println(
                    "No se puede desactivar el bus porque "
                    + "tiene viajes programados o en curso."
                );

                return false;
            }

            try (PreparedStatement psDesactivar =
                     conexion.prepareStatement(sqlDesactivar)) {

                psDesactivar.setString(1, placa);

                int filas = psDesactivar.executeUpdate();

                return filas > 0;
            }

        } catch (SQLException e) {

            System.out.println(
                "Error al desactivar bus: " + e.getMessage()
            );

            return false;
        }
    }
}
