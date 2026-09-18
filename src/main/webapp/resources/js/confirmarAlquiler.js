/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {
    const formulario =
            document.getElementById("formularioConfirmarAlquiler");

    if (!formulario) {
        return;
    }

    const precio =
            document.getElementById("precioConfirmado");

    const bus =
            document.getElementById("placaBus");

    const chofer =
            document.getElementById("numeroLicencia");

    const mensajePrecio =
            document.getElementById("mensajePrecio");

    const mensajeBus =
            document.getElementById("mensajeBus");

    const mensajeChofer =
            document.getElementById("mensajeChofer");


    formulario.addEventListener("submit", function (event) {

        let valido = true;


        mensajePrecio.textContent = "";
        mensajeBus.textContent = "";
        mensajeChofer.textContent = "";


        precio.classList.remove("campo-invalido");
        bus.classList.remove("campo-invalido");
        chofer.classList.remove("campo-invalido");


        const valorPrecio =
                parseFloat(precio.value);


        if (precio.value === "") {

            mensajePrecio.textContent =
                    "Ingrese el precio confirmado.";

            precio.classList.add("campo-invalido");

            valido = false;

        } else if (isNaN(valorPrecio)
                || valorPrecio <= 0) {

            mensajePrecio.textContent =
                    "El precio confirmado debe ser mayor que Q0.00.";

            precio.classList.add("campo-invalido");

            valido = false;
        }


        if (bus.value === "") {

            mensajeBus.textContent =
                    "Seleccione un bus.";

            bus.classList.add("campo-invalido");

            valido = false;
        }


        if (chofer.value === "") {

            mensajeChofer.textContent =
                    "Seleccione un chofer.";

            chofer.classList.add("campo-invalido");

            valido = false;
        }


        if (!valido) {
            event.preventDefault();
        }

    });
});

