/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formComprarBoleto");

    const mensajeAsientos =
            document.getElementById("mensajeAsientos");

    const cantidadSeleccionada =
            document.getElementById("cantidadSeleccionada");

    const totalCompra =
            document.getElementById("totalCompra");

    if (!formulario) {
        return;
    }

    const precio =
            Number(formulario.dataset.precio);

    const asientosDisponibles =
            Number(formulario.dataset.disponibles);

    const asientos =
            formulario.querySelectorAll(
                    'input[name="numeroAsiento"]:not(:disabled)'
                    );

    function actualizarInformacion() {

        const seleccionados =
                formulario.querySelectorAll(
                        'input[name="numeroAsiento"]:checked'
                        );

        const cantidad =
                seleccionados.length;

        const total =
                precio * cantidad;

        cantidadSeleccionada.textContent =
                cantidad;

        totalCompra.textContent =
                total.toFixed(2);

        mensajeAsientos.textContent =
                "";

        if (cantidad > asientosDisponibles) {

            mensajeAsientos.textContent =
                    "No puede seleccionar más asientos "
                    + "que los disponibles.";

            mensajeAsientos.classList.add(
                    "campo-invalido"
                    );
        } else {

            mensajeAsientos.classList.remove(
                    "campo-invalido"
                    );
        }
    }

    asientos.forEach(function (asiento) {

        asiento.addEventListener(
                "change",
                actualizarInformacion
                );
    });

    formulario.addEventListener("submit", function (event) {

        const seleccionados =
                formulario.querySelectorAll(
                        'input[name="numeroAsiento"]:checked'
                        );

        const cantidad =
                seleccionados.length;

        mensajeAsientos.textContent =
                "";

        mensajeAsientos.classList.remove(
                "campo-invalido"
                );

        if (cantidad === 0) {

            event.preventDefault();

            mensajeAsientos.textContent =
                    "Debe seleccionar al menos un asiento.";

            mensajeAsientos.classList.add(
                    "campo-invalido"
                    );

            return;
        }

        if (cantidad > asientosDisponibles) {

            event.preventDefault();

            mensajeAsientos.textContent =
                    "No puede seleccionar más asientos "
                    + "que los disponibles.";

            mensajeAsientos.classList.add(
                    "campo-invalido"
                    );

            return;
        }

        actualizarInformacion();
    });

    actualizarInformacion();
});
