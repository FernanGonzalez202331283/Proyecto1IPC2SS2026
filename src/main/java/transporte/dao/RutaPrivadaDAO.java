/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import transporte.conexion.Conexion;
import transporte.modelo.Alquiler;
import transporte.modelo.RutaPrivada;

/**
 *
 * @author fernan
 */
public class RutaPrivadaDAO {

    public boolean insertar(RutaPrivada rutaPrivada) {
        String sql = """
            INSERT INTO ruta_privada
            (codigo_ruta_privada, origen, destino, distancia_km, estado)
            VALUES (?, ?, ?, ?, ?)
            """;

        try (
                Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, rutaPrivada.getCodigoRutaPrivada());
            ps.setString(2, rutaPrivada.getOrigen());
            ps.setString(3, rutaPrivada.getDestino());
            ps.setDouble(4, rutaPrivada.getDistanciaKm());
            ps.setBoolean(5, rutaPrivada.isEstado());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                    "Error al insertar ruta privada: " + e.getMessage()
            );

            return false;
        }
    }
    public List<Alquiler> listarAlquileres() {

    List<Alquiler> alquileres = new ArrayList<>();

    String sql = """
        SELECT codigo_alquiler,
               codigo_viaje,
               usuario_cliente,
               numero_pasajeros,
               fecha_retorno,
               precio_estimado,
               precio_confirmado,
               estado
        FROM alquiler
        ORDER BY codigo_alquiler DESC
        """;

    try (Connection conexion = Conexion.getConnection();
         PreparedStatement ps = conexion.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            Alquiler alquiler = new Alquiler();

            alquiler.setCodigoAlquiler(
                rs.getString("codigo_alquiler")
            );

            alquiler.setCodigoViaje(
                rs.getString("codigo_viaje")
            );

            alquiler.setUsuarioCliente(
                rs.getString("usuario_cliente")
            );

            alquiler.setNumeroPasajeros(
                rs.getInt("numero_pasajeros")
            );

            alquiler.setFechaRetorno(
                rs.getDate("fecha_retorno")
            );

            alquiler.setPrecioEstimado(
                rs.getDouble("precio_estimado")
            );

            alquiler.setPrecioConfirmado(
                rs.getDouble("precio_confirmado")
            );

            alquiler.setEstado(
                rs.getString("estado")
            );

            alquileres.add(alquiler);
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al listar alquileres: " + e.getMessage()
        );
    }

    return alquileres;
}
    public List<Alquiler> listarSolicitados() {

    List<Alquiler> alquileres = new ArrayList<>();

    String sql = """
        SELECT codigo_alquiler,
               codigo_viaje,
               usuario_cliente,
               numero_pasajeros,
               fecha_retorno,
               precio_estimado,
               precio_confirmado,
               estado
        FROM alquiler
        WHERE estado = 'SOLICITADO'
        ORDER BY codigo_alquiler DESC
        """;

    try (Connection conexion = Conexion.getConnection();
         PreparedStatement ps = conexion.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            Alquiler alquiler = new Alquiler();

            alquiler.setCodigoAlquiler(
                rs.getString("codigo_alquiler")
            );

            alquiler.setCodigoViaje(
                rs.getString("codigo_viaje")
            );

            alquiler.setUsuarioCliente(
                rs.getString("usuario_cliente")
            );

            alquiler.setNumeroPasajeros(
                rs.getInt("numero_pasajeros")
            );

            alquiler.setFechaRetorno(
                rs.getDate("fecha_retorno")
            );

            alquiler.setPrecioEstimado(
                rs.getDouble("precio_estimado")
            );

            alquiler.setPrecioConfirmado(
                rs.getDouble("precio_confirmado")
            );

            alquiler.setEstado(
                rs.getString("estado")
            );

            alquileres.add(alquiler);
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al listar solicitudes: " + e.getMessage()
        );
    }

    return alquileres;
}
    public boolean confirmarAlquiler(
        String codigoAlquiler,
        double precioConfirmado) {

    String sql = """
        UPDATE alquiler
        SET precio_confirmado = ?,
            estado = 'CONFIRMADO'
        WHERE codigo_alquiler = ?
          AND estado = 'SOLICITADO'
        """;

    try (Connection conexion = Conexion.getConnection();
         PreparedStatement ps = conexion.prepareStatement(sql)) {

        ps.setDouble(1, precioConfirmado);
        ps.setString(2, codigoAlquiler);

        int filas = ps.executeUpdate();

        return filas > 0;

    } catch (SQLException e) {

        System.out.println(
            "Error al confirmar alquiler: " + e.getMessage()
        );

        return false;
    }
}

    public boolean cancelarAlquiler(String codigoAlquiler) {

    String sql = """
        UPDATE alquiler
        SET estado = 'CANCELADO'
        WHERE codigo_alquiler = ?
          AND estado = 'SOLICITADO'
        """;

    try (Connection conexion = Conexion.getConnection();
         PreparedStatement ps = conexion.prepareStatement(sql)) {

        ps.setString(1, codigoAlquiler);

        int filas = ps.executeUpdate();

        return filas > 0;

    } catch (SQLException e) {

        System.out.println(
            "Error al cancelar alquiler: " + e.getMessage()
        );

        return false;
    }
}
    public RutaPrivada obtener(String codigoRutaPrivada) {

        String sql = """
            SELECT codigo_ruta_privada,
                   origen,
                   destino,
                   distancia_km,
                   estado
            FROM ruta_privada
            WHERE codigo_ruta_privada = ?
            """;

        try (
                Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, codigoRutaPrivada);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RutaPrivada rutaPrivada = new RutaPrivada();
                    rutaPrivada.setCodigoRutaPrivada(rs.getString("codigo_ruta_privada"));
                    rutaPrivada.setOrigen(rs.getString("origen"));
                    rutaPrivada.setDestino(rs.getString("destino"));
                    rutaPrivada.setDistanciaKm(rs.getDouble("distancia_km"));
                    rutaPrivada.setEstado(rs.getBoolean("estado"));
                    return rutaPrivada;
                }
            }

        } catch (SQLException e) {
            System.out.println(
                    "Error al obtener ruta privada: " + e.getMessage()
            );
        }

        return null;
    }

    public RutaPrivada buscarPorOrigenDestino(
            String origen,
            String destino) {
        String sql = """
            SELECT codigo_ruta_privada,
                   origen,
                   destino,
                   distancia_km,
                   estado
            FROM ruta_privada
            WHERE LOWER(TRIM(origen)) = LOWER(TRIM(?))
              AND LOWER(TRIM(destino)) = LOWER(TRIM(?))
              AND estado = TRUE
            LIMIT 1
            """;
        try (
                Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, origen);
            ps.setString(2, destino);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RutaPrivada rutaPrivada = new RutaPrivada();
                    rutaPrivada.setCodigoRutaPrivada(rs.getString("codigo_ruta_privada"));
                    rutaPrivada.setOrigen(rs.getString("origen"));
                    rutaPrivada.setDestino(rs.getString("destino"));
                    rutaPrivada.setDistanciaKm(rs.getDouble("distancia_km"));
                    rutaPrivada.setEstado(rs.getBoolean("estado"));
                    return rutaPrivada;
                }
            }

        } catch (SQLException e) {
            System.out.println(
                    "Error al buscar ruta privada: "
                    + e.getMessage()
            );
        }
        return null;
    }

    public boolean actualizar(RutaPrivada rutaPrivada) {

        String sql = """
            UPDATE ruta_privada
            SET origen = ?,
                destino = ?,
                distancia_km = ?,
                estado = ?
            WHERE codigo_ruta_privada = ?
            """;

        try (
                Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, rutaPrivada.getOrigen());
            ps.setString(2, rutaPrivada.getDestino());
            ps.setDouble(3, rutaPrivada.getDistanciaKm());
            ps.setBoolean(4, rutaPrivada.isEstado());
            ps.setString(5, rutaPrivada.getCodigoRutaPrivada());

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                    "Error al actualizar ruta privada: "
                    + e.getMessage()
            );

            return false;
        }
    }

    public boolean activar(String codigoRutaPrivada) {
        String sql = """
            UPDATE ruta_privada
            SET estado = TRUE
            WHERE codigo_ruta_privada = ?
            """;
        try (
                Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, codigoRutaPrivada);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {

            System.out.println(
                    "Error al activar ruta privada: "
                    + e.getMessage()
            );

            return false;
        }
    }

    public boolean desactivar(String codigoRutaPrivada) {

        String sql = """
            UPDATE ruta_privada
            SET estado = FALSE
            WHERE codigo_ruta_privada = ?
            """;

        try (
                Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, codigoRutaPrivada);

            int filas = ps.executeUpdate();

            return filas > 0;

        } catch (SQLException e) {

            System.out.println(
                    "Error al desactivar ruta privada: "
                    + e.getMessage()
            );

            return false;
        }
    }

    public List<RutaPrivada> listar() {
        List<RutaPrivada> rutas = new ArrayList<>();
        String sql = """
            SELECT codigo_ruta_privada,
                   origen,
                   destino,
                   distancia_km,
                   estado
            FROM ruta_privada
            ORDER BY origen, destino
            """;

        try (
                Connection conexion = Conexion.getConnection(); PreparedStatement ps = conexion.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                RutaPrivada rutaPrivada = new RutaPrivada();
                rutaPrivada.setCodigoRutaPrivada(rs.getString("codigo_ruta_privada"));
                rutaPrivada.setOrigen(rs.getString("origen"));
                rutaPrivada.setDestino(rs.getString("destino"));
                rutaPrivada.setDistanciaKm(rs.getDouble("distancia_km"));
                rutaPrivada.setEstado(rs.getBoolean("estado"));
                rutas.add(rutaPrivada);
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al listar rutas privadas: "
                    + e.getMessage()
            );
        }

        return rutas;
    }
}
