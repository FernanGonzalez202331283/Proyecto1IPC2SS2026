/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {
    const formulario =
            document.getElementById("formularioModificarBus");

    if (!formulario) {
        return;
    }

    const marca =
            document.getElementById("marca");

    const modelo =
            document.getElementById("modelo");

    const anio =
            document.getElementById("anioFabricacion");

    const capacidad =
            document.getElementById("capacidad");

    const kilometraje =
            document.getElementById("kilometrajeActual");


    const mensajeMarca =
            document.getElementById("mensajeMarca");

    const mensajeModelo =
            document.getElementById("mensajeModelo");

    const mensajeAnio =
            document.getElementById("mensajeAnio");

    const mensajeCapacidad =
            document.getElementById("mensajeCapacidad");

    const mensajeKilometraje =
            document.getElementById("mensajeKilometraje");


    function limpiarErrores() {

        mensajeMarca.textContent = "";
        mensajeModelo.textContent = "";
        mensajeAnio.textContent = "";
        mensajeCapacidad.textContent = "";
        mensajeKilometraje.textContent = "";

        marca.classList.remove("campo-invalido");
        modelo.classList.remove("campo-invalido");
        anio.classList.remove("campo-invalido");
        capacidad.classList.remove("campo-invalido");
        kilometraje.classList.remove("campo-invalido");
    }


    formulario.addEventListener("submit", function (event) {

        limpiarErrores();

        let valido = true;


        /* MARCA */

        if (marca.value.trim() === "") {

            mensajeMarca.textContent =
                    "Debe ingresar la marca.";

            marca.classList.add("campo-invalido");

            valido = false;
        }


        /* MODELO */

        if (modelo.value.trim() === "") {

            mensajeModelo.textContent =
                    "Debe ingresar el modelo.";

            modelo.classList.add("campo-invalido");

            valido = false;
        }


        /* AÑO */

        const valorAnio =
                parseInt(anio.value);

        const añoActual =
                new Date().getFullYear();

        if (anio.value === "") {

            mensajeAnio.textContent =
                    "Debe ingresar el año de fabricación.";

            anio.classList.add("campo-invalido");

            valido = false;

        } else if (
                isNaN(valorAnio)
                || valorAnio < 1900
                || valorAnio > añoActual) {

            mensajeAnio.textContent =
                    "El año debe estar entre 1900 y "
                    + añoActual + ".";

            anio.classList.add("campo-invalido");

            valido = false;
        }


        /* CAPACIDAD */

        const valorCapacidad =
                parseInt(capacidad.value);

        if (capacidad.value === "") {

            mensajeCapacidad.textContent =
                    "Debe ingresar la capacidad.";

            capacidad.classList.add("campo-invalido");

            valido = false;

        } else if (
                isNaN(valorCapacidad)
                || valorCapacidad <= 0) {

            mensajeCapacidad.textContent =
                    "La capacidad debe ser mayor que cero.";

            capacidad.classList.add("campo-invalido");

            valido = false;
        }


        /* KILOMETRAJE */

        const valorKilometraje =
                parseFloat(kilometraje.value);

        if (kilometraje.value === "") {

            mensajeKilometraje.textContent =
                    "Debe ingresar el kilometraje actual.";

            kilometraje.classList.add("campo-invalido");

            valido = false;

        } else if (
                isNaN(valorKilometraje)
                || valorKilometraje < 0) {

            mensajeKilometraje.textContent =
                    "El kilometraje no puede ser negativo.";

            kilometraje.classList.add("campo-invalido");

            valido = false;
        }


        if (!valido) {
            event.preventDefault();
        }

    });

});


