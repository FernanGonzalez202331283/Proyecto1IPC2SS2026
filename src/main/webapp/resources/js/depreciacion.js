/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formDepreciacion");

    const campo =
            document.getElementById("depreciacionPorKm");

    const mensaje =
            document.getElementById("mensajeDepreciacion");


    if (!formulario || !campo || !mensaje) {
        return;
    }


    formulario.addEventListener("submit", function (evento) {

        const valor =
                parseFloat(campo.value);


        mensaje.textContent = "";
        mensaje.className = "";


        if (isNaN(valor)) {

            evento.preventDefault();

            mensaje.textContent =
                    "Ingrese una depreciación válida.";

            mensaje.className = "error";

            campo.focus();

            return;
        }


        if (valor < 0) {

            evento.preventDefault();

            mensaje.textContent =
                    "La depreciación no puede ser negativa.";

            mensaje.className = "error";

            campo.focus();

            return;
        }

    });

});