/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario = document.getElementById("formAlquiler");

    const origen = document.getElementById("origen");
    const destino = document.getElementById("destino");
    const numeroPasajeros = document.getElementById("numeroPasajeros");
    const fechaSalida = document.getElementById("fechaSalida");
    const horaSalida = document.getElementById("horaSalida");
    const fechaLlegada = document.getElementById("fechaLlegada");
    const horaLlegada = document.getElementById("horaLlegada");
    const fechaRetorno = document.getElementById("fechaRetorno");

    if (!formulario) {
        return;
    }

    formulario.addEventListener("submit", function (event) {

        let formularioValido = true;

        // Quitar errores anteriores
        origen.classList.remove("campo-invalido");
        destino.classList.remove("campo-invalido");
        numeroPasajeros.classList.remove("campo-invalido");
        fechaSalida.classList.remove("campo-invalido");
        horaSalida.classList.remove("campo-invalido");
        fechaLlegada.classList.remove("campo-invalido");
        horaLlegada.classList.remove("campo-invalido");
        fechaRetorno.classList.remove("campo-invalido");

        // ORIGEN
        if (origen.value.trim() === "") {

            origen.classList.add("campo-invalido");
            formularioValido = false;

        } else if (origen.value.trim().length < 3) {

            origen.classList.add("campo-invalido");
            formularioValido = false;
        }

        // DESTINO
        if (destino.value.trim() === "") {

            destino.classList.add("campo-invalido");
            formularioValido = false;

        } else if (destino.value.trim().length < 3) {

            destino.classList.add("campo-invalido");
            formularioValido = false;
        }

        // ORIGEN Y DESTINO NO PUEDEN SER IGUALES
        if (origen.value.trim() !== ""
                && destino.value.trim() !== ""
                && origen.value.trim().toLowerCase()
                === destino.value.trim().toLowerCase()) {

            origen.classList.add("campo-invalido");
            destino.classList.add("campo-invalido");

            formularioValido = false;
        }

        // NÚMERO DE PASAJEROS
        const pasajeros = Number(numeroPasajeros.value);

        if (numeroPasajeros.value.trim() === ""
                || !Number.isInteger(pasajeros)
                || pasajeros <= 0) {

            numeroPasajeros.classList.add("campo-invalido");
            formularioValido = false;
        }

        // FECHA Y HORA DE SALIDA
        if (fechaSalida.value === "") {

            fechaSalida.classList.add("campo-invalido");
            formularioValido = false;
        }

        if (horaSalida.value === "") {

            horaSalida.classList.add("campo-invalido");
            formularioValido = false;
        }

        // FECHA Y HORA DE LLEGADA
        if (fechaLlegada.value === "") {

            fechaLlegada.classList.add("campo-invalido");
            formularioValido = false;
        }

        if (horaLlegada.value === "") {

            horaLlegada.classList.add("campo-invalido");
            formularioValido = false;
        }

        // COMPARAR FECHA Y HORA DE LLEGADA CON SALIDA
        if (fechaSalida.value !== ""
                && horaSalida.value !== ""
                && fechaLlegada.value !== ""
                && horaLlegada.value !== "") {

            const salida = new Date(
                    fechaSalida.value + "T" + horaSalida.value
                    );

            const llegada = new Date(
                    fechaLlegada.value + "T" + horaLlegada.value
                    );

            if (llegada < salida) {

                fechaLlegada.classList.add("campo-invalido");
                horaLlegada.classList.add("campo-invalido");

                formularioValido = false;
            }
        }

        //  no puede ser anterior a la fecha de salida.
        if (fechaRetorno.value !== ""
                && fechaSalida.value !== "") {

            const salida = new Date(fechaSalida.value);
            const retorno = new Date(fechaRetorno.value);

            if (retorno < salida) {

                fechaRetorno.classList.add("campo-invalido");
                formularioValido = false;
            }
        }

        // EVITAR ENVÍO SI EXISTE ALGÚN ERROR
        if (!formularioValido) {

            event.preventDefault();
        }
    });
});

