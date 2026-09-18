/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formularioRepuesto");

    if (!formulario) {
        return;
    }

    const codigo =
            document.getElementById("codigoRepuesto");

    const nombre =
            document.getElementById("nombre");

    const descripcion =
            document.getElementById("descripcion");

    const precio =
            document.getElementById("precio");

    const mensajeCodigo =
            document.getElementById("mensajeCodigo");

    const mensajeNombre =
            document.getElementById("mensajeNombre");

    const mensajeDescripcion =
            document.getElementById("mensajeDescripcion");

    const mensajePrecio =
            document.getElementById("mensajePrecio");


    formulario.addEventListener("submit", function (event) {

        let valido = true;


        // Limpiar mensajes
        mensajeCodigo.textContent = "";
        mensajeNombre.textContent = "";
        mensajeDescripcion.textContent = "";
        mensajePrecio.textContent = "";


        // Quitar estilos de error
        codigo.classList.remove("campo-invalido");
        nombre.classList.remove("campo-invalido");
        descripcion.classList.remove("campo-invalido");
        precio.classList.remove("campo-invalido");


        // Código
        if (codigo.value.trim() === "") {

            mensajeCodigo.textContent =
                    "Debe ingresar el código del repuesto.";

            codigo.classList.add("campo-invalido");

            valido = false;

        } else if (codigo.value.trim().length > 20) {

            mensajeCodigo.textContent =
                    "El código no puede superar los 20 caracteres.";

            codigo.classList.add("campo-invalido");

            valido = false;
        }


        // Nombre
        if (nombre.value.trim() === "") {

            mensajeNombre.textContent =
                    "Debe ingresar el nombre del repuesto.";

            nombre.classList.add("campo-invalido");

            valido = false;

        } else if (nombre.value.trim().length < 2) {

            mensajeNombre.textContent =
                    "El nombre debe tener al menos 2 caracteres.";

            nombre.classList.add("campo-invalido");

            valido = false;
        }


        // Descripción
        if (descripcion.value.length > 250) {

            mensajeDescripcion.textContent =
                    "La descripción no puede superar los 250 caracteres.";

            descripcion.classList.add("campo-invalido");

            valido = false;
        }


        // Precio
        if (precio.value === "") {

            mensajePrecio.textContent =
                    "Debe ingresar el precio.";

            precio.classList.add("campo-invalido");

            valido = false;

        } else if (Number(precio.value) < 0) {

            mensajePrecio.textContent =
                    "El precio no puede ser negativo.";

            precio.classList.add("campo-invalido");

            valido = false;

        }


        // Evitar enviar si hay errores
        if (!valido) {
            event.preventDefault();
        }

    });

});

