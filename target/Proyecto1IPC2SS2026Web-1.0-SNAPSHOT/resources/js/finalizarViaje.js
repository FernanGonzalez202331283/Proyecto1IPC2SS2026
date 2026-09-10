/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario =
        document.getElementById("formFinalizarViaje");

    const kilometraje =
        document.getElementById("kilometrajeFinal");

    const combustible =
        document.getElementById("gastoCombustible");


    if (!formulario) {
        return;
    }


    formulario.addEventListener("submit", function (evento) {

        const km =
            parseFloat(kilometraje.value);

        const gasto =
            parseFloat(combustible.value);


        if (isNaN(km) || km < 0) {

            evento.preventDefault();

            alert(
                "Ingrese un kilometraje final válido."
            );

            kilometraje.focus();

            return;
        }


        if (isNaN(gasto) || gasto < 0) {

            evento.preventDefault();

            alert(
                "Ingrese un gasto de combustible válido."
            );

            combustible.focus();

            return;
        }


        const confirmar =
            confirm(
                "¿Está seguro de finalizar este viaje?\n\n"
                + "Los datos de llegada no podrán "
                + "modificarse ni eliminarse después."
            );


        if (!confirmar) {

            evento.preventDefault();

        }

    });

});


