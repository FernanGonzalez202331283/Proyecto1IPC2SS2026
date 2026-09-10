/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import transporte.conexion.Conexion;
import transporte.modelo.Usuario;

/**
 *
 * @author fernan
 */
public class UsuarioDAO {
    
    public boolean insertar(Usuario usuario) {

    String sql = """
                 INSERT INTO usuario(
                     usuario,
                     contrasena,
                     rol,
                     estado,
                     codigo_sucursal
                 )
                 VALUES (?,?,?,?,?)
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, usuario.getUsuario());
        ps.setString(2, usuario.getContraseña());
        ps.setString(3, usuario.getRol());
        ps.setBoolean(4, usuario.isEstado());
        ps.setString(5, usuario.getCodigoSucursal());

        ps.executeUpdate();

        return true;

    } catch (SQLException e) {

        System.out.println("Error al insertar usuario: " + e.getMessage());

        return false;
    }
}
    
   public Usuario buscarPorUsuario(String usuario) {

    String sql = """
                 SELECT usuario,
                        contrasena,
                        rol,
                        estado,
                        codigo_sucursal
                 FROM usuario
                 WHERE usuario = ?
                 """;

    Connection conexion = Conexion.getConnection();

    if (conexion == null) {

        System.out.println(
            "### DIAGNOSTICO: la conexion vino NULL desde Conexion.getConnection()"
        );

        return null;
    }

    System.out.println(
        "### DIAGNOSTICO: conexion obtenida correctamente -> " + conexion
    );

    try (
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, usuario);

        var rs = ps.executeQuery();

        if (rs.next()) {

            Usuario encontrado = new Usuario();

            encontrado.setUsuario(
                rs.getString("usuario")
            );

            encontrado.setContraseña(
                rs.getString("contrasena")
            );

            encontrado.setRol(
                rs.getString("rol")
            );

            encontrado.setEstado(
                rs.getBoolean("estado")
            );

            encontrado.setCodigoSucursal(
                rs.getString("codigo_sucursal")
            );

            return encontrado;
        }

    } catch (SQLException e) {

        System.out.println(
            "### DIAGNOSTICO: error al ejecutar query -> "
            + e.getMessage()
        );

        e.printStackTrace();

    } finally {

        try {
            conexion.close();
        } catch (Exception e) {
        }
    }

    return null;
}
    
  public String actualizar(Usuario usuario) {

    Usuario usuarioEncontrado =
            buscarPorUsuario(usuario.getUsuario());

    if (usuarioEncontrado == null) {
        return "El usuario no existe.";
    }

    String rol = usuarioEncontrado.getRol();

    String codigoSucursalActual =
            usuarioEncontrado.getCodigoSucursal();

    String codigoSucursalNueva =
            usuario.getCodigoSucursal();

    // ADMIN_SISTEMA no debe tener sucursal
    if ("ADMIN_SISTEMA".equals(rol)) {

        codigoSucursalNueva = null;
    }

    // ADMIN_SUCURSAL
    else if ("ADMIN_SUCURSAL".equals(rol)) {

        if (codigoSucursalNueva == null ||
            codigoSucursalNueva.trim().isEmpty()) {

            return "Debe seleccionar una sucursal.";
        }

        codigoSucursalNueva =
                codigoSucursalNueva.trim();

        // La nueva sucursal debe existir
        if (!sucursalExiste(codigoSucursalNueva)) {

            return "La sucursal seleccionada no existe.";
        }

        /*
         * Si el usuario está activo y está cambiando
         * de sucursal, debemos verificar que no sea
         * el último administrador activo de su sucursal actual.
         */
        if (usuarioEncontrado.isEstado() &&
            codigoSucursalActual != null &&
            !codigoSucursalActual.equals(codigoSucursalNueva)) {

            if (esUltimoAdminSucursalActivo(
                    usuarioEncontrado.getUsuario())) {

                return "No se puede cambiar de sucursal porque este usuario es el último administrador activo de su sucursal actual.";
            }
        }
    }

    // CLIENTE no debe tener sucursal
    else if ("CLIENTE".equals(rol)) {

        codigoSucursalNueva = null;
    }

    String sql = """
                 UPDATE usuario
                 SET contrasena = ?,
                     estado = ?,
                     codigo_sucursal = ?
                 WHERE usuario = ?
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, usuario.getContraseña());
        ps.setBoolean(2, usuario.isEstado());
        ps.setString(3, codigoSucursalNueva);
        ps.setString(4, usuario.getUsuario());

        int filas = ps.executeUpdate();

        if (filas > 0) {
            return "Usuario modificado correctamente.";
        }

    } catch (SQLException e) {

        System.out.println(
                "Error al actualizar usuario: "
                + e.getMessage()
        );

        return "Ocurrió un error al modificar el usuario.";
    }

    return "No se pudo modificar el usuario.";
}
   public boolean sucursalExiste(String codigoSucursal) {

    String sql = """
                 SELECT codigo_sucursal
                 FROM sucursal
                 WHERE codigo_sucursal = ?
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoSucursal);

        var rs = ps.executeQuery();

        return rs.next();

    } catch (SQLException e) {

        System.out.println(
                "Error al verificar sucursal: "
                + e.getMessage()
        );

        return false;
    }
}
    
    public boolean existe(String usuario){
        String sql = """
                     SELECT usuario
                     FROM usuario
                     WHERE usuario = ?
                     """;
        try (Connection conexion = Conexion.getConnection();
                PreparedStatement ps = conexion.prepareStatement(sql)
                ){
            ps.setString(1, usuario);
            
            var rs = ps.executeQuery();
            
            return rs.next();
            
        } catch (SQLException e) {
            System.out.println("Error al verificar usuario "+ e.getMessage());
            return false;
        }
    }
    
    public Usuario[] listar() {
        String sql = """
                     SELECT usuario,
                            contrasena,
                            rol,
                            estado,
                            codigo_sucursal
                     FROM usuario
                     ORDER BY usuario
                     """;

        java.util.ArrayList<Usuario> usuarios =
                new java.util.ArrayList<>();

        try (
            Connection conexion = Conexion.getConnection();
            PreparedStatement ps = conexion.prepareStatement(sql);
            var rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Usuario usuario = new Usuario();

                usuario.setUsuario(
                        rs.getString("usuario")
                );

                usuario.setContraseña(
                        rs.getString("contrasena")
                );

                usuario.setRol(
                        rs.getString("rol")
                );

                usuario.setEstado(
                        rs.getBoolean("estado")
                );

                usuario.setCodigoSucursal(
                        rs.getString("codigo_sucursal")
                );

                usuarios.add(usuario);
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al listar usuarios: "
                    + e.getMessage()
            );

            return new Usuario[0];
        }

        return usuarios.toArray(new Usuario[0]);
    }
    
       public String desactivar(String usuario) {

    Usuario usuarioEncontrado = buscarPorUsuario(usuario);

    if (usuarioEncontrado == null) {
        return "El usuario no existe.";
    }

    if (!usuarioEncontrado.isEstado()) {
        return "El usuario ya está inactivo.";
    }

    // Regla: siempre debe existir al menos
    // un ADMIN_SISTEMA activo
    if ("ADMIN_SISTEMA".equals(usuarioEncontrado.getRol())) {

        if (esUltimoAdminSistemaActivo(usuario)) {

            return "No se puede desactivar al último administrador del sistema.";
        }
    }

    // Regla: cada sucursal debe conservar
    // al menos un ADMIN_SUCURSAL activo
    if ("ADMIN_SUCURSAL".equals(usuarioEncontrado.getRol())) {

        if (esUltimoAdminSucursalActivo(usuario)) {

            return "No se puede desactivar al último administrador de la sucursal.";
        }
    }

    String sql = """
                 UPDATE usuario
                 SET estado = false
                 WHERE usuario = ?
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, usuario);

        int filas = ps.executeUpdate();

        if (filas > 0) {
            return "Usuario desactivado correctamente.";
        }

    } catch (SQLException e) {

        System.out.println(
                "Error al desactivar usuario: "
                + e.getMessage()
        );

        return "Ocurrió un error al desactivar el usuario.";
    }

    return "No se pudo desactivar el usuario.";
}
    
   public String activar(String usuario) {

    Usuario usuarioEncontrado = buscarPorUsuario(usuario);

    if (usuarioEncontrado == null) {
        return "El usuario no existe.";
    }

    if (usuarioEncontrado.isEstado()) {
        return "El usuario ya está activo.";
    }

    // Si es ADMIN_SUCURSAL,
    // su sucursal debe estar activa
    if ("ADMIN_SUCURSAL".equals(usuarioEncontrado.getRol())) {

        String codigoSucursal =
                usuarioEncontrado.getCodigoSucursal();

        if (codigoSucursal == null ||
            codigoSucursal.trim().isEmpty()) {

            return "No se puede activar el administrador porque no tiene una sucursal asignada.";
        }

        if (!sucursalEstaActiva(codigoSucursal)) {

            return "No se puede activar el administrador porque su sucursal está inactiva.";
        }
    }

    String sql = """
                 UPDATE usuario
                 SET estado = true
                 WHERE usuario = ?
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, usuario);

        int filas = ps.executeUpdate();

        if (filas > 0) {
            return "Usuario activado correctamente.";
        }

    } catch (SQLException e) {

        System.out.println(
                "Error al activar usuario: "
                + e.getMessage()
        );

        return "Ocurrió un error al activar el usuario.";
    }

    return "No se pudo activar el usuario.";
}
    
    public boolean esUltimoAdminSistemaActivo(String usuario) {

        String sql = """
                     SELECT COUNT(*) AS cantidad
                     FROM usuario
                     WHERE rol = 'ADMIN_SISTEMA'
                       AND estado = true
                       AND usuario <> ?
                     """;

        try (
            Connection conexion = Conexion.getConnection();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {

            ps.setString(1, usuario);

            var rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("cantidad") == 0;
            }

        } catch (SQLException e) {

            System.out.println(
                    "Error al verificar administradores del sistema: "
                    + e.getMessage()
            );
        }

        return false;
    }
       public boolean esUltimoAdminSucursalActivo(String usuario) {

    String sql = """
                 SELECT COUNT(*) AS cantidad
                 FROM usuario
                 WHERE rol = 'ADMIN_SUCURSAL'
                   AND estado = true
                   AND codigo_sucursal = (
                       SELECT codigo_sucursal
                       FROM usuario
                       WHERE usuario = ?
                   )
                   AND usuario <> ?
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, usuario);
        ps.setString(2, usuario);

        var rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt("cantidad") == 0;
        }

    } catch (SQLException e) {

        System.out.println(
                "Error al verificar último administrador de sucursal: "
                + e.getMessage()
        );
    }

    return false;
}
        public boolean sucursalEstaActiva(String codigoSucursal) {

    String sql = """
                 SELECT estado
                 FROM sucursal
                 WHERE codigo_sucursal = ?
                 """;

    try (
        Connection conexion = Conexion.getConnection();
        PreparedStatement ps = conexion.prepareStatement(sql)
    ) {

        ps.setString(1, codigoSucursal);

        var rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getBoolean("estado");
        }

    } catch (SQLException e) {

        System.out.println(
                "Error al verificar estado de la sucursal: "
                + e.getMessage()
        );
    }

    return false;
}

}
