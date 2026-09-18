document.addEventListener("DOMContentLoaded", function () {

    const formulario = document.getElementById("loginForm");

    const usuario = document.getElementById("usuario");
    const contrasena = document.getElementById("contrasena");

    const mensajeUsuario = document.getElementById("mensajeUsuario");

    const mensajeContrasena = document.getElementById("mensajeContrasena");

    if (!formulario) {
        return;
    }

    formulario.addEventListener("submit", function (event) {

        let formularioValido = true;

        // Limpiar mensajes anteriores
        mensajeUsuario.textContent = "";
        mensajeContraseña.textContent = "";

        usuario.classList.remove("campo-invalido");
        contraseña.classList.remove("campo-invalido");

        // Validar usuario
        if (usuario.value.trim() === "") {

            mensajeUsuario.textContent =
                    "Ingrese su usuario.";

            usuario.classList.add("campo-invalido");

            formularioValido = false;
        }

        // Validar contraseña vacia
        if (contraseña.value.trim() === "") {

            mensajeContraseña.textContent =
                    "Ingrese su contraseña.";

            contraseña.classList.add("campo-invalido");

            formularioValido = false;

        } else if (contraseña.value.length < 4) {

            mensajeContrasña.textContent ="La contraseña debe tener al menos 4 caracteres.";

            contraseña.classList.add("campo-invalido");

            formularioValido = false;
        }

        // Detiene  el envío si existe error
        if (!formularioValido) {

            event.preventDefault();
        }

    });
});