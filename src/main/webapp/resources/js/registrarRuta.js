/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {
    const formulario =
            document.getElementById("formularioRegistrarRuta");

    if (!formulario) {
        return;
    }

    const codigoRuta =
            document.getElementById("codigoRuta");

    const destino =
            document.getElementById("codigoSucursalDestino");

    const distancia =
            document.getElementById("distanciaKm");

    const precio =
            document.getElementById("precioBoleto");


    const mensajeCodigoRuta =
            document.getElementById("mensajeCodigoRuta");

    const mensajeDestino =
            document.getElementById("mensajeDestino");

    const mensajeDistancia =
            document.getElementById("mensajeDistancia");

    const mensajePrecio =
            document.getElementById("mensajePrecio");


    function limpiarErrores() {

        mensajeCodigoRuta.textContent = "";
        mensajeDestino.textContent = "";
        mensajeDistancia.textContent = "";
        mensajePrecio.textContent = "";

        codigoRuta.classList.remove("campo-invalido");
        destino.classList.remove("campo-invalido");
        distancia.classList.remove("campo-invalido");
        precio.classList.remove("campo-invalido");
    }


    formulario.addEventListener("submit", function (event) {

        limpiarErrores();

        let valido = true;

        if (codigoRuta.value.trim() === "") {

            mensajeCodigoRuta.textContent =
                    "Debe ingresar el código de la ruta.";

            codigoRuta.classList.add("campo-invalido");

            valido = false;
        }

        if (destino.value === "") {

            mensajeDestino.textContent =
                    "Debe seleccionar la sucursal de destino.";

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

        const valorPrecio =
                parseFloat(precio.value);

        if (precio.value === "") {

            mensajePrecio.textContent =
                    "Debe ingresar el precio del boleto.";

            precio.classList.add("campo-invalido");

            valido = false;

        } else if (
                isNaN(valorPrecio)
                || valorPrecio < 0
                ) {

            mensajePrecio.textContent =
                    "El precio del boleto no puede ser negativo.";

            precio.classList.add("campo-invalido");

            valido = false;
        }
        if (!valido) {
            event.preventDefault();
        }

    });

});

