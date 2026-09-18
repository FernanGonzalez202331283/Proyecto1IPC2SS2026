/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formularioModificarViaje");

    if (!formulario) {
        return;
    }


    const bus =
            document.getElementById("placaBus");

    const chofer =
            document.getElementById("numeroLicencia");

    const ruta =
            document.getElementById("codigoRuta");

    const origen =
            document.getElementById("origen");

    const destino =
            document.getElementById("destino");

    const fechaSalida =
            document.getElementById("fechaSalida");

    const horaSalida =
            document.getElementById("horaSalida");

    const fechaLlegada =
            document.getElementById("fechaLlegada");

    const horaLlegada =
            document.getElementById("horaLlegada");


    const mensajeBus =
            document.getElementById("mensajeBus");

    const mensajeChofer =
            document.getElementById("mensajeChofer");

    const mensajeRuta =
            document.getElementById("mensajeRuta");

    const mensajeOrigen =
            document.getElementById("mensajeOrigen");

    const mensajeDestino =
            document.getElementById("mensajeDestino");

    const mensajeFechaSalida =
            document.getElementById("mensajeFechaSalida");

    const mensajeHoraSalida =
            document.getElementById("mensajeHoraSalida");

    const mensajeFechaLlegada =
            document.getElementById("mensajeFechaLlegada");

    const mensajeHoraLlegada =
            document.getElementById("mensajeHoraLlegada");

    function limpiarErrores() {

        document.querySelectorAll(".campo-error")
                .forEach(function (elemento) {

                    elemento.textContent = "";

                });


        document.querySelectorAll(".campo-invalido")
                .forEach(function (elemento) {

                    elemento.classList.remove(
                            "campo-invalido"
                            );

                });
    }

    if (ruta) {

        ruta.addEventListener("change", function () {

            const opcion =
                    this.options[this.selectedIndex];

            if (!opcion) {
                return;
            }

            origen.value =
                    opcion.dataset.origen || "";

            destino.value =
                    opcion.dataset.destino || "";

        });
    }

    formulario.addEventListener("submit", function (event) {

        limpiarErrores();

        let valido = true;

        if (bus.value === "") {

            mensajeBus.textContent =
                    "Debe seleccionar un bus.";

            bus.classList.add("campo-invalido");

            valido = false;
        }

        if (chofer.value === "") {

            mensajeChofer.textContent =
                    "Debe seleccionar un chofer.";

            chofer.classList.add("campo-invalido");

            valido = false;
        }

        if (ruta && ruta.value === "") {

            mensajeRuta.textContent =
                    "Debe seleccionar una ruta.";

            ruta.classList.add("campo-invalido");

            valido = false;
        }
        if (origen.value.trim() === "") {

            mensajeOrigen.textContent =
                    "Debe indicar el origen.";

            origen.classList.add("campo-invalido");

            valido = false;
        }

        if (destino.value.trim() === "") {

            mensajeDestino.textContent =
                    "Debe indicar el destino.";

            destino.classList.add("campo-invalido");

            valido = false;
        }

        if (fechaSalida.value === "") {

            mensajeFechaSalida.textContent =
                    "Debe indicar la fecha de salida.";

            fechaSalida.classList.add("campo-invalido");

            valido = false;
        }


        if (horaSalida.value === "") {

            mensajeHoraSalida.textContent =
                    "Debe indicar la hora de salida.";

            horaSalida.classList.add("campo-invalido");

            valido = false;
        }


        if (fechaLlegada.value === "") {

            mensajeFechaLlegada.textContent =
                    "Debe indicar la fecha de llegada.";

            fechaLlegada.classList.add("campo-invalido");

            valido = false;
        }

        if (horaLlegada.value === "") {

            mensajeHoraLlegada.textContent =
                    "Debe indicar la hora de llegada.";

            horaLlegada.classList.add("campo-invalido");

            valido = false;
        }


        if (
                fechaSalida.value !== ""
                && horaSalida.value !== ""
                && fechaLlegada.value !== ""
                && horaLlegada.value !== ""
                ) {

            const salida =
                    new Date(
                            fechaSalida.value
                            + "T"
                            + horaSalida.value
                            );

            const llegada =
                    new Date(
                            fechaLlegada.value
                            + "T"
                            + horaLlegada.value
                            );


            if (llegada <= salida) {

                mensajeFechaLlegada.textContent =
                        "La fecha y hora de llegada debe ser "
                        + "posterior a la salida.";

                fechaLlegada.classList.add(
                        "campo-invalido"
                        );

                horaLlegada.classList.add(
                        "campo-invalido"
                        );

                valido = false;
            }
        }

        if (!valido) {

            event.preventDefault();

        }

    });

});


