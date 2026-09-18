/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {
    const formulario =
            document.getElementById("formRutaPrivada");

    if (!formulario) {
        return;
    }


    const origen =
            document.getElementById("origen");

    const destino =
            document.getElementById("destino");

    const distancia =
            document.getElementById("distanciaKm");


    const mensajeOrigen =
            document.getElementById("mensajeOrigen");

    const mensajeDestino =
            document.getElementById("mensajeDestino");

    const mensajeDistancia =
            document.getElementById("mensajeDistancia");


    function limpiarErrores() {

        mensajeOrigen.textContent = "";
        mensajeDestino.textContent = "";
        mensajeDistancia.textContent = "";

        origen.classList.remove("campo-invalido");
        destino.classList.remove("campo-invalido");
        distancia.classList.remove("campo-invalido");
    }


    formulario.addEventListener("submit", function (event) {

        limpiarErrores();

        let valido = true;

        if (origen.value.trim() === "") {

            mensajeOrigen.textContent =
                    "Debe ingresar el origen.";

            origen.classList.add("campo-invalido");

            valido = false;
        }

        if (destino.value.trim() === "") {

            mensajeDestino.textContent =
                    "Debe ingresar el destino.";

            destino.classList.add("campo-invalido");

            valido = false;
        }

        if (
                origen.value.trim() !== ""
                && destino.value.trim() !== ""
                && origen.value.trim().toLowerCase()
                === destino.value.trim().toLowerCase()
                ) {

            mensajeDestino.textContent =
                    "El destino debe ser diferente al origen.";

            destino.classList.add("campo-invalido");

            valido = false;
        }

        const valorDistancia =
                parseFloat(distancia.value);

        if (distancia.value === "") {

            mensajeDistancia.textContent =
                    "Debe ingresar la distancia.";

            distancia.classList.add("campo-invalido");

            valido = false;

        } else if (
                isNaN(valorDistancia)
                || valorDistancia <= 0
                ) {

            mensajeDistancia.textContent =
                    "La distancia debe ser mayor que cero.";

            distancia.classList.add("campo-invalido");

            valido = false;
        }

        if (!valido) {
            event.preventDefault();
        }

    });
});

