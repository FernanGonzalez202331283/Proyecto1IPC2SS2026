/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt
 * to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js
 * to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    const formulario =
        document.getElementById("crearUsuarioForm");

    const usuario =
        document.getElementById("usuario");

    const contrasena =
        document.getElementById("contrasena");

    const sucursal =
        document.getElementById("codigoSucursal");

    const nombreCompleto =
        document.getElementById("nombreCompleto");

    const nit =
        document.getElementById("nit");

    const dpi =
        document.getElementById("dpi");

    const telefono =
        document.getElementById("telefono");

    const direccion =
        document.getElementById("direccion");


    const mensajeUsuario =
        document.getElementById("mensajeUsuario");

    const mensajeContrasena =
        document.getElementById("mensajeContrasena");

    const mensajeSucursal =
        document.getElementById("mensajeSucursal");

    const mensajeNombre =
        document.getElementById("mensajeNombre");


    formulario.addEventListener("submit", function (event) {

        let formularioValido = true;

        mensajeUsuario.textContent = "";
        mensajeContrasena.textContent = "";
        mensajeSucursal.textContent = "";
        mensajeNombre.textContent = "";

        usuario.classList.remove("campo-invalido");
        contrasena.classList.remove("campo-invalido");
        sucursal.classList.remove("campo-invalido");
        nombreCompleto.classList.remove("campo-invalido");
        nit.classList.remove("campo-invalido");
        dpi.classList.remove("campo-invalido");
        telefono.classList.remove("campo-invalido");
        direccion.classList.remove("campo-invalido");


        if (usuario.value.trim() === "") {

            mensajeUsuario.textContent =
                "Ingrese un usuario.";

            usuario.classList.add("campo-invalido");

            formularioValido = false;

        } else if (usuario.value.trim().length < 4) {

            mensajeUsuario.textContent =
                "El usuario debe tener al menos 4 caracteres.";

            usuario.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (contrasena.value.trim() === "") {

            mensajeContrasena.textContent =
                "Ingrese una contraseña.";

            contrasena.classList.add("campo-invalido");

            formularioValido = false;

        } else if (contrasena.value.length < 4) {

            mensajeContrasena.textContent =
                "La contraseña debe tener al menos 4 caracteres.";

            contrasena.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (sucursal.value === "") {

            mensajeSucursal.textContent =
                "Seleccione una sucursal.";

            sucursal.classList.add("campo-invalido");

            formularioValido = false;
        }



        if (nombreCompleto.value.trim() === "") {

            mensajeNombre.textContent =
                "Ingrese el nombre completo.";

            nombreCompleto.classList.add("campo-invalido");

            formularioValido = false;

        } else if (nombreCompleto.value.trim().length < 5) {

            mensajeNombre.textContent =
                "Ingrese el nombre completo.";

            nombreCompleto.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (nit.value.trim() === "") {

            nit.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (dpi.value.trim() === "") {

            dpi.classList.add("campo-invalido");

            formularioValido = false;
        }


        if (telefono.value.trim() === "") {

            telefono.classList.add("campo-invalido");

            formularioValido = false;
        }

        if (direccion.value.trim() === "") {

            direccion.classList.add("campo-invalido");

            formularioValido = false;
        }

        if (!formularioValido) {

            event.preventDefault();
        }

    });

});