/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario =
        document.getElementById("formDepreciacion");

    const campo =
        document.getElementById("depreciacionPorKm");


    if (!formulario || !campo) {
        return;
    }


    formulario.addEventListener("submit", function (evento) {

        const valor =
            parseFloat(campo.value);


        if (isNaN(valor)) {

            evento.preventDefault();

            alert(
                "Ingrese una depreciación válida."
            );

            campo.focus();

            return;
        }


        if (valor < 0) {

            evento.preventDefault();

            alert(
                "La depreciación no puede ser negativa."
            );

            campo.focus();

            return;
        }


        const confirmar =
            confirm(
                "¿Está seguro de guardar esta configuración de depreciación?"
            );


        if (!confirmar) {

            evento.preventDefault();

        }

    });

});
