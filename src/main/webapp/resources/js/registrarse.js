/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("registroForm");

    const usuario =
            document.getElementById("usuario");

    const contraseña =
            document.getElementById("contraseña");

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

    const mensajeUsuario =
            document.getElementById("mensajeUsuario");

    const mensajeContraseña =
            document.getElementById("mensajeContraseña");

    const mensajeNit =
            document.getElementById("mensajeNit");

    const mensajeDpi =
            document.getElementById("mensajeDpi");

    const mensajeNombre =
            document.getElementById("mensajeNombre");

    const mensajeTelefono =
            document.getElementById("mensajeTelefono");


    if (!formulario) {
        return;
    }


    formulario.addEventListener("submit", function (event) {

        let formularioValido = true;


        mensajeUsuario.textContent = "";
        mensajeContraseña.textContent = "";
        mensajeNit.textContent = "";
        mensajeDpi.textContent = "";
        mensajeNombre.textContent = "";
        mensajeTelefono.textContent = "";

        usuario.classList.remove("campo-invalido");
        contraseña.classList.remove("campo-invalido");
        nit.classList.remove("campo-invalido");
        dpi.classList.remove("campo-invalido");
        nombreCompleto.classList.remove("campo-invalido");
        telefono.classList.remove("campo-invalido");
        direccion.classList.remove("campo-invalido");

        const valorUsuario =
                usuario.value.trim();

        if (valorUsuario === "") {

            mensajeUsuario.textContent =
                    "Ingrese un usuario.";

            usuario.classList.add("campo-invalido");

            formularioValido = false;

        } else if (valorUsuario.length < 4) {

            mensajeUsuario.textContent =
                    "El usuario debe tener al menos 4 caracteres.";

            usuario.classList.add("campo-invalido");

            formularioValido = false;
        }

        const valorContraseña =
                contraseña.value;

        if (valorContraseña.trim() === "") {

            mensajeContraseña.textContent =
                    "Ingrese una contraseña.";

            contraseña.classList.add("campo-invalido");

            formularioValido = false;

        } else if (valorContraseña.length < 4) {

            mensajeContraseña.textContent =
                    "La contraseña debe tener al menos 4 caracteres.";

            contraseña.classList.add("campo-invalido");

            formularioValido = false;
        }

        const valorNit =
                nit.value.trim();

        if (valorNit === "") {

            mensajeNit.textContent =
                    "Ingrese el NIT.";

            nit.classList.add("campo-invalido");

            formularioValido = false;

        } else if (!/^\d+$/.test(valorNit)) {

            mensajeNit.textContent =
                    "El NIT solamente debe contener números.";

            nit.classList.add("campo-invalido");

            formularioValido = false;
        }

        const valorDpi =
                dpi.value.trim();

        if (valorDpi === "") {

            mensajeDpi.textContent =
                    "Ingrese el DPI.";

            dpi.classList.add("campo-invalido");

            formularioValido = false;

        } else if (!/^\d{13}$/.test(valorDpi)) {

            mensajeDpi.textContent =
                    "El DPI debe contener exactamente 13 dígitos.";

            dpi.classList.add("campo-invalido");

            formularioValido = false;
        }

        const valorNombre =
                nombreCompleto.value.trim();

        if (valorNombre === "") {

            mensajeNombre.textContent =
                    "Ingrese el nombre completo.";

            nombreCompleto.classList.add("campo-invalido");

            formularioValido = false;

        } else if (valorNombre.length < 5) {

            mensajeNombre.textContent =
                    "El nombre debe tener al menos 5 caracteres.";

            nombreCompleto.classList.add("campo-invalido");

            formularioValido = false;

        } else if (!/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/.test(valorNombre)) {

            mensajeNombre.textContent =
                    "El nombre solamente debe contener letras y espacios.";

            nombreCompleto.classList.add("campo-invalido");

            formularioValido = false;
        }

        const valorTelefono =
                telefono.value.trim();

        if (valorTelefono === "") {

            mensajeTelefono.textContent =
                    "Ingrese el número de teléfono.";

            telefono.classList.add("campo-invalido");

            formularioValido = false;

        } else if (!/^\d{8}$/.test(valorTelefono)) {

            mensajeTelefono.textContent =
                    "El teléfono debe contener exactamente 8 dígitos.";

            telefono.classList.add("campo-invalido");

            formularioValido = false;
        }

        const valorDireccion =
                direccion.value.trim();

        if (valorDireccion === "") {

            direccion.classList.add("campo-invalido");

            formularioValido = false;
        }
        if (!formularioValido) {

            event.preventDefault();
        }

    });

});