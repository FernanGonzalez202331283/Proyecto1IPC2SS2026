/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formularioReporteBuses");

    if (!formulario) {
        return;
    }

    const estadoOperativo =
            document.getElementById("estadoOperativo");

    const mensajeEstado =
            document.getElementById("mensajeEstado");


    formulario.addEventListener("submit", function (event) {

        mensajeEstado.textContent = "";
        estadoOperativo.classList.remove("campo-invalido");


        /*
         * No es obligatorio seleccionar un estado.
         * Si queda vacío, se muestran todos los estados.
         */

        if (estadoOperativo.value === "") {
            return;
        }


        /*
         * Validar que el valor seleccionado
         * corresponda a uno de los estados permitidos.
         */

        const estadosPermitidos = [
            "DISPONIBLE",
            "EN_VIAJE",
            "MANTENIMIENTO",
            "INACTIVO"
        ];

        if (!estadosPermitidos.includes(estadoOperativo.value)) {

            mensajeEstado.textContent =
                    "Seleccione un estado operativo válido.";

            estadoOperativo.classList.add("campo-invalido");

            event.preventDefault();
        }

    });

});


