/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import transporte.conexion.Conexion;
import transporte.modelo.Bus;
import transporte.modelo.Chofer;
import transporte.modelo.Configuracion;
import transporte.modelo.Ruta;
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
    public boolean actualizarPorSucursal(
        Viaje viaje,
        String codigoSucursal) {

    String sql = """
        UPDATE viaje v
        INNER JOIN bus b
            ON v.placa_bus = b.placa
        SET v.placa_bus = ?,
            v.numero_licencia = ?,
            v.codigo_ruta = ?,
            v.origen = ?,
            v.destino = ?,
            v.fecha_salida = ?,
            v.hora_salida = ?,
            v.fecha_llegada_estimada = ?,
            v.hora_llegada_estimada = ?,
            v.estado = ?,
            v.depreciacion_por_km = ?,
            v.depreciacion_total = ?
        WHERE v.codigo_viaje = ?
          AND b.codigo_sucursal = ?
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps =
                conexion.prepareStatement(sql)
    ) {

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
        ps.setString(14, codigoSucursal);

        int filas = ps.executeUpdate();

        return filas > 0;

    } catch (SQLException e) {

        System.out.println(
            "Error al actualizar viaje por sucursal: "
            + e.getMessage()
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
    public List<Viaje> listarPorSucursal(String codigoSucursal) {

    List<Viaje> viajes = new ArrayList<>();

    String sql = """
        SELECT v.codigo_viaje,
               v.tipo_viaje,
               v.placa_bus,
               v.numero_licencia,
               v.codigo_ruta,
               v.origen,
               v.destino,
               v.fecha_salida,
               v.hora_salida,
               v.fecha_llegada_estimada,
               v.hora_llegada_estimada,
               v.estado,
               v.depreciacion_por_km,
               v.depreciacion_total
        FROM viaje v
        INNER JOIN bus b
            ON v.placa_bus = b.placa
        WHERE b.codigo_sucursal = ?
        ORDER BY v.fecha_salida, v.hora_salida
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoSucursal);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

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

            viajes.add(viaje);
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al listar viajes por sucursal: "
            + e.getMessage()
        );
    }

    return viajes;
}
    public List<Bus> listarBusesDisponiblesPorSucursal(
        String codigoSucursal) {

    List<Bus> buses = new ArrayList<>();

    String sql = """
        SELECT b.placa,
               b.codigo_sucursal,
               b.foto,
               b.marca,
               b.modelo,
               b.anio_fabricacion,
               b.capacidad,
               b.estado_operativo,
               b.kilometraje_actual
        FROM bus b
        WHERE b.codigo_sucursal = ?
          AND b.estado_operativo = 'DISPONIBLE'
        ORDER BY b.placa
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoSucursal);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

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

            buses.add(bus);
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al listar buses disponibles: "
            + e.getMessage()
        );
    }

    return buses;
}
    
    public List<Chofer> listarChoferesActivosPorSucursal(
        String codigoSucursal) {

    List<Chofer> choferes = new ArrayList<>();

    String sql = """
        SELECT numero_licencia,
               codigo_sucursal,
               foto,
               nombre_completo,
               tipo_licencia,
               fecha_vencimiento_licencia,
               telefono,
               salario_base_viaje,
               estado
        FROM chofer
        WHERE codigo_sucursal = ?
          AND estado = TRUE
        ORDER BY nombre_completo
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoSucursal);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            Chofer chofer = new Chofer(
                rs.getString("numero_licencia"),
                rs.getString("codigo_sucursal"),
                rs.getString("foto"),
                rs.getString("nombre_completo"),
                rs.getString("tipo_licencia"),
                rs.getString("fecha_vencimiento_licencia"),
                rs.getString("telefono"),
                rs.getDouble("salario_base_viaje"),
                rs.getBoolean("estado")
            );

            choferes.add(chofer);
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al listar choferes activos: "
            + e.getMessage()
        );
    }

    return choferes;
}
    public List<Ruta> listarRutasActivasPorSucursal(
        String codigoSucursal) {

    List<Ruta> rutas = new ArrayList<>();

    String sql = """
        SELECT codigo_ruta,
               codigo_sucursal_origen,
               codigo_sucursal_destino,
               distancia_km,
               precio_boleto,
               estado
        FROM ruta
        WHERE codigo_sucursal_origen = ?
          AND estado = TRUE
        ORDER BY codigo_ruta
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoSucursal);

        ResultSet rs = ps.executeQuery();

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

    } catch (SQLException e) {

        System.out.println(
            "Error al listar rutas activas: "
            + e.getMessage()
        );
    }

    return rutas;
}
    public Viaje obtenerPorSucursal(
        String codigoViaje,
        String codigoSucursal) {

    String sql = """
        SELECT v.codigo_viaje,
               v.tipo_viaje,
               v.placa_bus,
               v.numero_licencia,
               v.codigo_ruta,
               v.origen,
               v.destino,
               v.fecha_salida,
               v.hora_salida,
               v.fecha_llegada_estimada,
               v.hora_llegada_estimada,
               v.estado,
               v.depreciacion_por_km,
               v.depreciacion_total
        FROM viaje v
        INNER JOIN bus b
            ON v.placa_bus = b.placa
        WHERE v.codigo_viaje = ?
          AND b.codigo_sucursal = ?
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoViaje);
        ps.setString(2, codigoSucursal);

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
            "Error al obtener viaje por sucursal: "
            + e.getMessage()
        );
    }

    return null;
}
  public boolean iniciarViaje(
        String codigoViaje,
        String codigoSucursal,
        String horaRealSalida,
        String usuarioRegistro) {

    String sqlVerificar = """
        SELECT v.placa_bus,
               b.kilometraje_actual
        FROM viaje v
        INNER JOIN bus b
            ON v.placa_bus = b.placa
        WHERE v.codigo_viaje = ?
          AND b.codigo_sucursal = ?
          AND v.estado = 'PROGRAMADO'
          AND b.estado_operativo = 'DISPONIBLE'
        """;

    String sqlSalida = """
        INSERT INTO salida_viaje
        (
            codigo_viaje,
            hora_real_salida,
            kilometraje_inicial,
            usuario_registro
        )
        VALUES (?, ?, ?, ?)
        """;

    String sqlViaje = """
        UPDATE viaje
        SET estado = 'EN_CURSO'
        WHERE codigo_viaje = ?
          AND estado = 'PROGRAMADO'
        """;

    String sqlBus = """
        UPDATE bus
        SET estado_operativo = 'EN_VIAJE'
        WHERE placa = ?
          AND codigo_sucursal = ?
          AND estado_operativo = 'DISPONIBLE'
        """;

    try (Connection conexion = Conexion.getConnection()) {

        conexion.setAutoCommit(false);

        try (
            PreparedStatement psVerificar =
                    conexion.prepareStatement(sqlVerificar);

            PreparedStatement psSalida =
                    conexion.prepareStatement(sqlSalida);

            PreparedStatement psViaje =
                    conexion.prepareStatement(sqlViaje);

            PreparedStatement psBus =
                    conexion.prepareStatement(sqlBus)
        ) {

            // =========================================
            // 1. Buscar el bus y su kilometraje actual
            // =========================================

            psVerificar.setString(1, codigoViaje);
            psVerificar.setString(2, codigoSucursal);

            String placaBus;
            double kilometrajeInicial;

            try (ResultSet rs = psVerificar.executeQuery()) {

                if (!rs.next()) {

                    conexion.rollback();

                    System.out.println(
                            "No se encontró el viaje, "
                            + "no pertenece a la sucursal, "
                            + "no está PROGRAMADO o el bus "
                            + "no está DISPONIBLE."
                    );

                    return false;
                }

                placaBus =
                        rs.getString("placa_bus");

                kilometrajeInicial =
                        rs.getDouble("kilometraje_actual");
            }

            // =========================================
            // 2. Registrar salida
            // =========================================

            psSalida.setString(
                    1,
                    codigoViaje
            );

            psSalida.setTime(
                    2,
                    Time.valueOf(horaRealSalida)
            );

            // AQUÍ SE GUARDA AUTOMÁTICAMENTE
            // EL KILOMETRAJE ACTUAL DEL BUS
            psSalida.setDouble(
                    3,
                    kilometrajeInicial
            );

            psSalida.setString(
                    4,
                    usuarioRegistro
            );

            int filasSalida =
                    psSalida.executeUpdate();

            if (filasSalida == 0) {

                conexion.rollback();

                return false;
            }

            // =========================================
            // 3. Cambiar viaje a EN_CURSO
            // =========================================

            psViaje.setString(
                    1,
                    codigoViaje
            );

            int filasViaje =
                    psViaje.executeUpdate();

            if (filasViaje == 0) {

                conexion.rollback();

                return false;
            }

            // =========================================
            // 4. Cambiar bus a EN_VIAJE
            // =========================================

            psBus.setString(
                    1,
                    placaBus
            );

            psBus.setString(
                    2,
                    codigoSucursal
            );

            int filasBus =
                    psBus.executeUpdate();

            if (filasBus == 0) {

                conexion.rollback();

                return false;
            }

            // =========================================
            // 5. Confirmar toda la operación
            // =========================================

            conexion.commit();

            System.out.println(
                    "Viaje iniciado correctamente."
            );

            System.out.println(
                    "Kilometraje inicial registrado: "
                    + kilometrajeInicial
            );

            return true;

        } catch (SQLException e) {

            conexion.rollback();

            System.out.println(
                    "Error al iniciar viaje: "
                    + e.getMessage()
            );

            return false;
        }

    } catch (SQLException e) {

        System.out.println(
                "Error de conexión al iniciar viaje: "
                + e.getMessage()
        );

        return false;
    }
}
  
  public boolean finalizarViaje(
        String codigoViaje,
        String codigoSucursal,
        String horaRealLlegada,
        double kilometrajeFinal,
        double gastoCombustible,
        String usuarioRegistro) {

    ConfiguracionDAO configuracionDAO =
            new ConfiguracionDAO();

    Configuracion configuracion =
            configuracionDAO.obtenerConfiguracionVigente();

    // =========================================
    // Verificar configuración de depreciación
    // =========================================

    if (configuracion == null) {

        System.out.println(
                "No existe una configuración de "
                + "depreciación vigente."
        );

        return false;
    }

    double depreciacionPorKm =
            configuracion.getDepreciacionPorKm();

    String sqlVerificar = """
        SELECT v.placa_bus,
               sv.kilometraje_inicial
        FROM viaje v
        INNER JOIN bus b
            ON v.placa_bus = b.placa
        INNER JOIN salida_viaje sv
            ON v.codigo_viaje = sv.codigo_viaje
        WHERE v.codigo_viaje = ?
          AND b.codigo_sucursal = ?
          AND v.estado = 'EN_CURSO'
        """;

    String sqlLlegada = """
        INSERT INTO llegada_viaje
        (
            codigo_viaje,
            hora_real_llegada,
            kilometraje_final,
            gasto_combustible,
            usuario_registro
        )
        VALUES (?, ?, ?, ?, ?)
        """;

    String sqlViaje = """
        UPDATE viaje
        SET estado = 'FINALIZADO',
            depreciacion_por_km = ?,
            depreciacion_total = ?
        WHERE codigo_viaje = ?
          AND estado = 'EN_CURSO'
        """;

    String sqlBus = """
        UPDATE bus b
        INNER JOIN viaje v
            ON v.placa_bus = b.placa
        SET b.kilometraje_actual = ?,
            b.estado_operativo = 'DISPONIBLE'
        WHERE v.codigo_viaje = ?
          AND b.codigo_sucursal = ?
        """;

    try (Connection conexion =
            Conexion.getConnection()) {

        conexion.setAutoCommit(false);

        try (
            PreparedStatement psVerificar =
                    conexion.prepareStatement(sqlVerificar);

            PreparedStatement psLlegada =
                    conexion.prepareStatement(sqlLlegada);

            PreparedStatement psViaje =
                    conexion.prepareStatement(sqlViaje);

            PreparedStatement psBus =
                    conexion.prepareStatement(sqlBus)
        ) {

            // =========================================
            // 1. Obtener bus y kilometraje inicial
            // =========================================

            psVerificar.setString(
                    1,
                    codigoViaje
            );

            psVerificar.setString(
                    2,
                    codigoSucursal
            );

            String placaBus;
            double kilometrajeInicial;

            try (ResultSet rs =
                    psVerificar.executeQuery()) {

                if (!rs.next()) {

                    conexion.rollback();

                    System.out.println(
                            "El viaje no existe, no pertenece "
                            + "a la sucursal, no está EN_CURSO "
                            + "o no tiene registro de salida."
                    );

                    return false;
                }

                placaBus =
                        rs.getString("placa_bus");

                kilometrajeInicial =
                        rs.getDouble(
                                "kilometraje_inicial"
                        );
            }

            // =========================================
            // 2. Validar kilometraje final
            // =========================================

            if (kilometrajeFinal < kilometrajeInicial) {

                conexion.rollback();

                System.out.println(
                        "El kilometraje final no puede "
                        + "ser menor que el kilometraje inicial."
                );

                return false;
            }

            // =========================================
            // 3. Validar combustible
            // =========================================

            if (gastoCombustible < 0) {

                conexion.rollback();

                System.out.println(
                        "El gasto de combustible no "
                        + "puede ser negativo."
                );

                return false;
            }

            // =========================================
            // 4. Calcular kilómetros reales
            // =========================================

            double kilometrosReales =
                    kilometrajeFinal
                    - kilometrajeInicial;

            // =========================================
            // 5. Calcular depreciación
            // =========================================

            double depreciacionTotal =
                    kilometrosReales
                    * depreciacionPorKm;

            // =========================================
            // 6. Registrar llegada
            // =========================================

            psLlegada.setString(
                    1,
                    codigoViaje
            );

            psLlegada.setTime(
                    2,
                    Time.valueOf(horaRealLlegada)
            );

            psLlegada.setDouble(
                    3,
                    kilometrajeFinal
            );

            psLlegada.setDouble(
                    4,
                    gastoCombustible
            );

            psLlegada.setString(
                    5,
                    usuarioRegistro
            );

            int filasLlegada =
                    psLlegada.executeUpdate();

            if (filasLlegada == 0) {

                conexion.rollback();

                return false;
            }

            // =========================================
            // 7. Finalizar viaje
            // =========================================

            psViaje.setDouble(
                    1,
                    depreciacionPorKm
            );

            psViaje.setDouble(
                    2,
                    depreciacionTotal
            );

            psViaje.setString(
                    3,
                    codigoViaje
            );

            int filasViaje =
                    psViaje.executeUpdate();

            if (filasViaje == 0) {

                conexion.rollback();

                return false;
            }

            // =========================================
            // 8. Actualizar kilometraje del bus
            // =========================================

            psBus.setDouble(
                    1,
                    kilometrajeFinal
            );

            psBus.setString(
                    2,
                    codigoViaje
            );

            psBus.setString(
                    3,
                    codigoSucursal
            );

            int filasBus =
                    psBus.executeUpdate();

            if (filasBus == 0) {

                conexion.rollback();

                return false;
            }

            // =========================================
            // 9. Confirmar transacción
            // =========================================

            conexion.commit();

            System.out.println(
                    "Viaje finalizado correctamente."
            );

            System.out.println(
                    "Kilometraje inicial: "
                    + kilometrajeInicial
            );

            System.out.println(
                    "Kilometraje final: "
                    + kilometrajeFinal
            );

            System.out.println(
                    "Kilómetros reales: "
                    + kilometrosReales
            );

            System.out.println(
                    "Depreciación por km: Q"
                    + depreciacionPorKm
            );

            System.out.println(
                    "Depreciación total: Q"
                    + depreciacionTotal
            );

            return true;

        } catch (SQLException e) {

            conexion.rollback();

            System.out.println(
                    "Error al finalizar viaje: "
                    + e.getMessage()
            );

            return false;
        }

    } catch (SQLException e) {

        System.out.println(
                "Error de conexión al finalizar viaje: "
                + e.getMessage()
        );

        return false;
    }
}
    public boolean cancelarViaje(
        String codigoViaje,
        String codigoSucursal) {

    String sql = """
        UPDATE viaje v
        INNER JOIN bus b
            ON v.placa_bus = b.placa
        SET v.estado = 'CANCELADO',
            b.estado_operativo = 'DISPONIBLE'
        WHERE v.codigo_viaje = ?
          AND b.codigo_sucursal = ?
          AND v.estado = 'PROGRAMADO'
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps =
                conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoViaje);
        ps.setString(2, codigoSucursal);

        int filas = ps.executeUpdate();

        return filas > 0;

    } catch (SQLException e) {

        System.out.println(
            "Error al cancelar viaje: "
            + e.getMessage()
        );

        return false;
    }
}
   public boolean busTieneViajeActivo(
        String placaBus,
        java.sql.Date fechaSalida,
        java.sql.Time horaSalida,
        java.sql.Date fechaLlegada,
        java.sql.Time horaLlegada,
        String codigoViajeExcluir) {

    String sql = """
        SELECT COUNT(*)
        FROM viaje
        WHERE placa_bus = ?
          AND estado IN ('PROGRAMADO', 'EN_CURSO')

          AND TIMESTAMP(fecha_salida, hora_salida)
              < TIMESTAMP(?, ?)

          AND TIMESTAMP(fecha_llegada_estimada,
                        hora_llegada_estimada)
              > TIMESTAMP(?, ?)

          AND (
                ? IS NULL
                OR codigo_viaje <> ?
              )
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, placaBus);

        ps.setDate(2, fechaLlegada);
        ps.setTime(3, horaLlegada);

        ps.setDate(4, fechaSalida);
        ps.setTime(5, horaSalida);

        ps.setString(6, codigoViajeExcluir);
        ps.setString(7, codigoViajeExcluir);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1) > 0;
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al comprobar disponibilidad del bus: "
            + e.getMessage()
        );
    }

    return false;
}
   public boolean choferTieneViajeActivo(
        String numeroLicencia,
        java.sql.Date fechaSalida,
        java.sql.Time horaSalida,
        java.sql.Date fechaLlegada,
        java.sql.Time horaLlegada,
        String codigoViajeExcluir) {

    String sql = """
        SELECT COUNT(*)
        FROM viaje
        WHERE numero_licencia = ?
          AND estado IN ('PROGRAMADO', 'EN_CURSO')

          AND TIMESTAMP(fecha_salida, hora_salida)
              < TIMESTAMP(?, ?)

          AND TIMESTAMP(fecha_llegada_estimada,
                        hora_llegada_estimada)
              > TIMESTAMP(?, ?)

          AND (
                ? IS NULL
                OR codigo_viaje <> ?
              )
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, numeroLicencia);

        ps.setDate(2, fechaLlegada);
        ps.setTime(3, horaLlegada);

        ps.setDate(4, fechaSalida);
        ps.setTime(5, horaSalida);

        ps.setString(6, codigoViajeExcluir);
        ps.setString(7, codigoViajeExcluir);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1) > 0;
        }

    } catch (SQLException e) {

        System.out.println(
            "Error al comprobar disponibilidad del chofer: "
            + e.getMessage()
        );
    }

    return false;
}
   public double obtenerKilometrajeInicial(String codigoViaje) {

    String sql = """
                 SELECT kilometraje_inicial
                 FROM salida_viaje
                 WHERE codigo_viaje = ?
                 """;

    try (Connection conexion = Conexion.getConnection();
         PreparedStatement ps = conexion.prepareStatement(sql)) {

        ps.setString(1, codigoViaje);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("kilometraje_inicial");
            }

        }

    } catch (SQLException e) {

        System.out.println(
            "Error al obtener kilometraje inicial: "
            + e.getMessage()
        );
    }

    return -1;
}
   public List<Viaje> listarViajesRegularesDisponibles() {

    List<Viaje> viajes = new ArrayList<>();

    String sql = """
        SELECT v.codigo_viaje,
               v.tipo_viaje,
               v.placa_bus,
               v.numero_licencia,
               v.codigo_ruta,
               v.origen,
               v.destino,
               v.fecha_salida,
               v.hora_salida,
               v.fecha_llegada_estimada,
               v.hora_llegada_estimada,
               v.estado,
               v.depreciacion_por_km,
               v.depreciacion_total,
               r.precio_boleto,
               b.capacidad,
               COUNT(
                   CASE
                       WHEN bo.estado = 'PAGADO'
                       THEN bo.codigo_boleto
                   END
               ) AS boletos_vendidos
        FROM viaje v

        INNER JOIN ruta r
            ON v.codigo_ruta = r.codigo_ruta

        INNER JOIN bus b
            ON v.placa_bus = b.placa

        LEFT JOIN boleto bo
            ON v.codigo_viaje = bo.codigo_viaje

        WHERE v.tipo_viaje = 'REGULAR'
          AND v.estado = 'PROGRAMADO'
          AND r.estado = TRUE
          AND b.estado_operativo = 'DISPONIBLE'

        GROUP BY v.codigo_viaje,
                 v.tipo_viaje,
                 v.placa_bus,
                 v.numero_licencia,
                 v.codigo_ruta,
                 v.origen,
                 v.destino,
                 v.fecha_salida,
                 v.hora_salida,
                 v.fecha_llegada_estimada,
                 v.hora_llegada_estimada,
                 v.estado,
                 v.depreciacion_por_km,
                 v.depreciacion_total,
                 r.precio_boleto,
                 b.capacidad

        ORDER BY v.fecha_salida,
                 v.hora_salida
        """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql);
        ResultSet rs = ps.executeQuery()
    ) {

        while (rs.next()) {

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

            // Precio del boleto obtenido desde la ruta
            viaje.setPrecioBoletos(
                    rs.getDouble("precio_boleto")
            );

            // Capacidad del bus - boletos pagados
            int capacidad =
                    rs.getInt("capacidad");

            int boletosVendidos =
                    rs.getInt("boletos_vendidos");

            int asientosDisponibles =
                    capacidad - boletosVendidos;

            viaje.setAsientosDisponibles(
                    asientosDisponibles
            );

            viajes.add(viaje);
        }

    } catch (SQLException e) {

        System.out.println(
                "Error al listar viajes regulares disponibles: "
                + e.getMessage()
        );
    }

    return viajes;
}
}
