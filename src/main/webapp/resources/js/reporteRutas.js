/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formularioReporteRutas");

    if (!formulario) {
        return;
    }

    const fechaInicio =
            document.getElementById("fechaInicio");

    const fechaFin =
            document.getElementById("fechaFin");

    const mensajeFechaInicio =
            document.getElementById("mensajeFechaInicio");

    const mensajeFechaFin =
            document.getElementById("mensajeFechaFin");

    const mensajeReporte =
            document.getElementById("mensajeReporte");


    formulario.addEventListener("submit", function (event) {

        let valido = true;

        // Limpiar mensajes anteriores
        mensajeFechaInicio.textContent = "";
        mensajeFechaFin.textContent = "";
        mensajeReporte.textContent = "";

        // Quitar estilos de error
        fechaInicio.classList.remove("campo-invalido");
        fechaFin.classList.remove("campo-invalido");


        // Validar fecha inicial
        if (fechaInicio.value === "") {

            mensajeFechaInicio.textContent =
                    "Seleccione una fecha inicial.";

            fechaInicio.classList.add("campo-invalido");

            valido = false;
        }


        // Validar fecha final
        if (fechaFin.value === "") {

            mensajeFechaFin.textContent =
                    "Seleccione una fecha final.";

            fechaFin.classList.add("campo-invalido");

            valido = false;
        }


        // Comparar fechas
        if (fechaInicio.value !== "" &&
                fechaFin.value !== "") {

            if (fechaInicio.value > fechaFin.value) {

                mensajeReporte.textContent =
                        "La fecha inicial no puede ser posterior a la fecha final.";

                fechaInicio.classList.add("campo-invalido");
                fechaFin.classList.add("campo-invalido");

                valido = false;
            }
        }


        // Evitar enviar el formulario si hay errores
        if (!valido) {
            event.preventDefault();
        }

    });

});


