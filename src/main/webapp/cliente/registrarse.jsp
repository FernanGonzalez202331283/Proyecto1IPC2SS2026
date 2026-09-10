<%-- 
    Document   : registrarse
    Created on : 9 sept 2026, 23:10:30
    Author     : fernan
--%>

<%@page import="transporte.modelo.Perfil"%>
<%@page import="transporte.dao.PerfilDAO"%>
<%@page import="transporte.modelo.Usuario"%>
<%@page import="transporte.dao.UsuarioDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mensaje = "";
    String tipoMensaje = "";
    
if ("POST".equalsIgnoreCase(request.getMethod())){
    String usuarioIngresado = request.getParameter("usuario");
    String contraseñaIngresada = request.getParameter("contrasena");
    String nit = request.getParameter("nit");
    String dpi = request.getParameter("dpi");
    String nombreCompleto = request.getParameter("nombreCompleto");
    String telefono = request.getParameter("telefono");
    String direccion = request.getParameter("direccion");
    
    if(usuarioIngresado == null || usuarioIngresado.trim().isEmpty()){
        mensaje= "deb de ingresar un usuario";
        tipoMensaje = "Error";
    }else if (contraseñaIngresada== null || contraseñaIngresada.trim().isEmpty()){
        mensaje ="debes de ingresar una contraseña";
        tipoMensaje = "Error";
    }else if (nit== null || nit.trim().isEmpty()){
        mensaje ="debes de ingresar un nit";
        tipoMensaje = "Error";
    }
    
    else if (dpi== null || dpi.trim().isEmpty()){
        mensaje ="debes de ingresar un dpi";
        tipoMensaje = "Error";
    }
    else if (nombreCompleto== null || nombreCompleto.trim().isEmpty()){
        mensaje ="debes de ingresar nombre completo";
        tipoMensaje = "Error";
    }
    else if (telefono== null || telefono.trim().isEmpty()){
        mensaje ="debes de ingresar el numero de telefono";
        tipoMensaje = "Error";
    }
    else if (direccion== null || direccion.trim().isEmpty()){
        mensaje ="debes de ingresar el numero de telefono";
        tipoMensaje = "Error";
    }else{
        usuarioIngresado = usuarioIngresado.trim();
        nit = nit.trim();
        dpi = dpi.trim();
        nombreCompleto = nombreCompleto.trim();
        telefono = telefono.trim();
        direccion = direccion.trim();
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        //verificacion de que el usuario exista
        
        if(usuarioDAO.existe(usuarioIngresado)){
            mensaje = "el usuario ya existe. debe de ingresar otro usuario";
            tipoMensaje = "Error";
        }else{
            String rol = "CLIENTE";
            boolean estado = true;
            
            Usuario nuevoUsuario = new Usuario(
                    usuarioIngresado,
                    contraseñaIngresada,
                    rol,
                    estado
            );
            
            boolean usuarioInsertado = usuarioDAO.insertar(nuevoUsuario);
            
            if(usuarioInsertado){
                PerfilDAO perfilDAO =  new PerfilDAO();
                Perfil nuevoPerfil = new Perfil(
                        usuarioIngresado,
                        nit, 
                        dpi,
                        nombreCompleto,
                        telefono,
                        direccion
                );
            boolean perfilInsertado = perfilDAO.insertar(nuevoPerfil);
            if(perfilInsertado){
                mensaje = "cuenta creada correctamente."+ " Ahora puede iniciar Secion";
                tipoMensaje = "Exito";
                
            }else{
                mensaje = "El usaurio fue creado" +" Pero no se pudo crear el perfil";
                tipoMensaje = "Error";
            }
            }else{
                mensaje = "no se pudo crear la cuenta";
                tipoMensaje = "Error";
            }
        }
    }
    
}
%>

<!DOCTYPE html>
<html lang = "es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Crear Cuenta</title>
        <link rel="stylesheet" href="../resources/styles.css">
    </head>
    <body class="login-page">
        <main class="login-container">
        <h1>Crear Cuenta</h1>
        <p class ="login-subtitle">
            Registrate en el Sistema de Transporte Extraurbano
        </p>
        
        <form method ="post"
            id="registroForm">
            <div class="form-group">
                <label for="usuario">
                    Usuario
                </label>
                
                <input type="text"
                       id="usuario"
                       name="usuario"
                       maxlength="50"
                       autocomplete="username"
                       required>
                <p id ="mensajeUsuario" class="campo-error"></p>
            </div>
            <div class ="form-group">
                <label for ="contrasena">
                    Contraseña
                </label>
                <input
                    type="password"
                    id="contrasena"
                    name="contrasena"
                    autocomplete="new-password"
                    required>
                    <p id="mensajeContrasena" class="campo-error"></p>
            </div>
            
            <div class ="form-group">
                <label for ="nit">
                    NIT
                </label>
                <input
                    type="text"
                    id="nit"
                    name="nit"
                    maxlength="30"
                    required>
            </div>
            <div class ="form-group">
                <label for ="dpi">
                    DPI
                </label>
                <input
                    type="text"
                    id="dpi"
                    name="dpi"
                    maxlength="30"
                    required>
            </div>
            <div class ="form-group">
                <label for ="nombreCompleto">
                    Nombre Completo
                </label>
                <input
                    type="text"
                    id="nombreCompleto"
                    name="nombreCompleto"
                    maxlength="150"
                    required>
            </div>
            <div class ="form-group">
                <label for ="telefono">
                    Telefono
                </label>
                <input
                    type="text"
                    id="telefono"
                    name="telefono"
                    maxlength="30"
                    required>
            </div>
            <div class ="form-group">
                <label for ="direccion">
                    Direccion
                </label>
                <input
                    type="text"
                    id="direccion"
                    name="direccion"
                    maxlength="250"
                    required>
            </div>
            
            <button type ="submit">
                crear Cuenta
            </button>
        </form>
        
        <%if(!mensaje.isEmpty()){ %>
        <div class="mensaje <%=tipoMensaje %>">
             <%=mensaje%>
        </div>
        <%}%>
        <p class="registro-link">
          ¿ya tienes una cuenta?
          <a href='../login.jsp'>
              Iniciar Secion
          </a>
        </p>
        </main>
    </body>
</html>
