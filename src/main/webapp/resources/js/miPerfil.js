/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("perfilForm");

    const nit =
            document.getElementById("nit");

    const dpi =
            document.getElementById("dpi");

    const nombreCompleto =
            document.getElementById("nombreCompleto");

    const telefono =
            document.getElementById("telefono");

    const direccion =
            document.getElementById("direccion");

    const mensaje =
            document.getElementById("mensajePerfil");


    if (!formulario || !mensaje) {
        return;
    }


    function mostrarMensaje(texto, tipo) {

        mensaje.textContent = texto;
        mensaje.className = "mensaje " + tipo;

    }


    formulario.addEventListener("submit", function (event) {

        let formularioValido = true;

        mensaje.textContent = "";
        mensaje.className = "mensaje";

        const valorNit =
                nit.value.trim();

        if (valorNit === "") {

            mostrarMensaje(
                    "Ingrese el NIT.",
                    "error"
                    );

            nit.focus();

            formularioValido = false;

        } else if (!/^\d{1,13}$/.test(valorNit)) {

            mostrarMensaje(
                    "El NIT solamente debe contener números y tener como máximo 13 dígitos.",
                    "error"
                    );

            nit.focus();

            formularioValido = false;
        }
        const valorDpi =
                dpi.value.trim();

        if (formularioValido && valorDpi === "") {

            mostrarMensaje(
                    "Ingrese el DPI.",
                    "error"
                    );

            dpi.focus();

            formularioValido = false;

        } else if (formularioValido
                && !/^\d{13}$/.test(valorDpi)) {

            mostrarMensaje(
                    "El DPI debe contener exactamente 13 dígitos.",
                    "error"
                    );

            dpi.focus();

            formularioValido = false;
        }


        const valorNombre =
                nombreCompleto.value.trim();

        if (formularioValido && valorNombre === "") {

            mostrarMensaje(
                    "Ingrese el nombre completo.",
                    "error"
                    );

            nombreCompleto.focus();

            formularioValido = false;

        } else if (formularioValido
                && valorNombre.length < 5) {

            mostrarMensaje(
                    "El nombre debe tener al menos 5 caracteres.",
                    "error"
                    );

            nombreCompleto.focus();

            formularioValido = false;

        } else if (formularioValido
                && !/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/.test(valorNombre)) {

            mostrarMensaje(
                    "El nombre solamente debe contener letras y espacios.",
                    "error"
                    );

            nombreCompleto.focus();

            formularioValido = false;
        }
        const valorTelefono =
                telefono.value.trim();

        if (formularioValido && valorTelefono === "") {

            mostrarMensaje(
                    "Ingrese el número de teléfono.",
                    "error"
                    );

            telefono.focus();

            formularioValido = false;

        } else if (formularioValido
                && !/^\d{8}$/.test(valorTelefono)) {

            mostrarMensaje(
                    "El teléfono debe contener exactamente 8 dígitos.",
                    "error"
                    );

            telefono.focus();

            formularioValido = false;
        }

        const valorDireccion =
                direccion.value.trim();

        if (formularioValido
                && valorDireccion === "") {

            mostrarMensaje(
                    "Ingrese una dirección.",
                    "error"
                    );

            direccion.focus();

            formularioValido = false;

        } else if (formularioValido
                && valorDireccion.length < 5) {

            mostrarMensaje(
                    "Ingrese una dirección válida.",
                    "error"
                    );

            direccion.focus();

            formularioValido = false;
        }
        if (!formularioValido) {

            event.preventDefault();

        }

    });

});