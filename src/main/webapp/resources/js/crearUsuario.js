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

    const contraseña =
            document.getElementById("contraseña");

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

    const mensajeNit =
            document.getElementById("mensajeNit");

    const mensajeDpi =
            document.getElementById("mensajeDpi");

    const mensajeTelefono =
            document.getElementById("mensajeTelefono");


    if (!formulario) {
        return;
    }


    formulario.addEventListener("submit", function (event) {

        let formularioValido = true;


        mensajeUsuario.textContent = "";
        mensajeContrasena.textContent = "";
        mensajeSucursal.textContent = "";
        mensajeNombre.textContent = "";
        mensajeNit.textContent = "";
        mensajeDpi.textContent = "";
        mensajeTelefono.textContent = "";


        usuario.classList.remove("campo-invalido");
        contraseña.classList.remove("campo-invalido");
        sucursal.classList.remove("campo-invalido");
        nombreCompleto.classList.remove("campo-invalido");
        nit.classList.remove("campo-invalido");
        dpi.classList.remove("campo-invalido");
        telefono.classList.remove("campo-invalido");
        direccion.classList.remove("campo-invalido");


        // USUARIO
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


        // CONTRASEÑA
        if (contraseña.value.trim() === "") {

            mensajeContrasena.textContent =
                    "Ingrese una contraseña.";

            contrasena.classList.add("campo-invalido");

            formularioValido = false;

        } else if (contraseña.value.length < 4) {

            mensajeContrasena.textContent =
                    "La contraseña debe tener al menos 4 caracteres.";

            contraseña.classList.add("campo-invalido");

            formularioValido = false;
        }


        // SUCURSAL
        if (sucursal.value === "") {

            mensajeSucursal.textContent =
                    "Seleccione una sucursal.";

            sucursal.classList.add("campo-invalido");

            formularioValido = false;
        }


        // NOMBRE
        if (nombreCompleto.value.trim() === "") {

            mensajeNombre.textContent =
                    "Ingrese el nombre completo.";

            nombreCompleto.classList.add("campo-invalido");

            formularioValido = false;

        } else if (nombreCompleto.value.trim().length < 5) {

            mensajeNombre.textContent =
                    "El nombre debe tener al menos 5 caracteres.";

            nombreCompleto.classList.add("campo-invalido");

            formularioValido = false;

        } else if (!/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/.test(
                nombreCompleto.value.trim())) {

            mensajeNombre.textContent =
                    "El nombre solo debe contener letras y espacios.";
            nombreCompleto.classList.add("campo-invalido");
            formularioValido = false;
        }


        // NIT
        if (nit.value.trim() === "") {
            mensajeNit.textContent =
                    "Ingrese el NIT.";
            nit.classList.add("campo-invalido");
            formularioValido = false;
        } else if (!/^[0-9]+$/.test(nit.value.trim())) {
            mensajeNit.textContent =
                    "El NIT solamente debe contener números.";
            nit.classList.add("campo-invalido");
            formularioValido = false;
        }

        // DPI
        if (dpi.value.trim() === "") {
            mensajeDpi.textContent =
                    "Ingrese el DPI.";
            dpi.classList.add("campo-invalido");
            formularioValido = false;
        } else if (!/^[0-9]+$/.test(dpi.value.trim())) {
            mensajeDpi.textContent =
                    "El DPI solamente debe contener números.";
            dpi.classList.add("campo-invalido");
            formularioValido = false;
        } else if (dpi.value.trim().length !== 13) {
            mensajeDpi.textContent =
                    "El DPI debe contener 13 dígitos.";
            dpi.classList.add("campo-invalido");

            formularioValido = false;
        }

        // TELEFONO
        if (telefono.value.trim() === "") {

            mensajeTelefono.textContent =
                    "Ingrese el número de teléfono.";
            telefono.classList.add("campo-invalido");
            formularioValido = false;
        } else if (!/^[0-9]+$/.test(telefono.value.trim())) {
            mensajeTelefono.textContent =
                    "El teléfono solamente debe contener números.";
            telefono.classList.add("campo-invalido");
            formularioValido = false;
        } else if (telefono.value.trim().length !== 8) {

            mensajeTelefono.textContent =
                    "El teléfono debe contener 8 dígitos.";

            telefono.classList.add("campo-invalido");

            formularioValido = false;
        }

        // DIRECCIÓN
        if (direccion.value.trim() === "") {
            direccion.classList.add("campo-invalido");
            formularioValido = false;
        }

        if (!formularioValido) {
            event.preventDefault();
        }

    });
});