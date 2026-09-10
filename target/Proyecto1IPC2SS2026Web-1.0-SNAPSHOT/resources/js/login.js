/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    const formulario = document.getElementById("loginForm");

    const usuario = document.getElementById("usuario");
    const contrasena = document.getElementById("contrasena");

    const mensajeUsuario =
        document.getElementById("mensajeUsuario");

    const mensajeContrasena =
        document.getElementById("mensajeContrasena");


    formulario.addEventListener("submit", function (event) {

        let formularioValido = true;

        mensajeUsuario.textContent = "";
        mensajeContrasena.textContent = "";

        usuario.classList.remove("campo-invalido");
        contrasena.classList.remove("campo-invalido");


        if (usuario.value.trim() === "") {

            mensajeUsuario.textContent =
                "Ingrese su usuario.";

            usuario.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (contrasena.value.trim() === "") {

            mensajeContrasena.textContent =
                "Ingrese su contraseña.";

            contrasena.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (contrasena.value.length > 0 &&
            contrasena.value.length < 4) {

            mensajeContrasena.textContent =
                "La contraseña debe tener al menos 4 caracteres.";

            contrasena.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (!formularioValido) {

            event.preventDefault();
        }

    });

});
