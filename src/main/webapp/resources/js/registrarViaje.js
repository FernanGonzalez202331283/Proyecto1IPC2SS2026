/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formViaje");

    if (!formulario) {
        return;
    }


    const tipoViaje =
            document.getElementById("tipoViaje");

    const grupoRuta =
            document.getElementById("grupoRuta");

    const grupoPrivado =
            document.getElementById("grupoPrivado");

    const codigoRuta =
            document.getElementById("codigoRuta");

    const origen =
            document.getElementById("origen");

    const destino =
            document.getElementById("destino");

    const codigoViaje =
            document.getElementById("codigoViaje");

    const bus =
            document.getElementById("placaBus");

    const chofer =
            document.getElementById("numeroLicencia");

    const fechaSalida =
            document.getElementById("fechaSalida");

    const horaSalida =
            document.getElementById("horaSalida");

    const fechaLlegada =
            document.getElementById("fechaLlegadaEstimada");

    const horaLlegada =
            document.getElementById("horaLlegadaEstimada");


    const mensajeCodigoViaje =
            document.getElementById("mensajeCodigoViaje");

    const mensajeTipoViaje =
            document.getElementById("mensajeTipoViaje");

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


    function actualizarTipoViaje() {

        if (tipoViaje.value === "REGULAR") {

            grupoRuta.style.display = "block";
            grupoPrivado.style.display = "none";

            codigoRuta.required = true;

            origen.required = false;
            destino.required = false;

        } else if (tipoViaje.value === "PRIVADO") {

            grupoRuta.style.display = "none";
            grupoPrivado.style.display = "block";

            codigoRuta.required = false;

            origen.required = true;
            destino.required = true;

        } else {

            grupoRuta.style.display = "block";
            grupoPrivado.style.display = "none";

            codigoRuta.required = false;

            origen.required = false;
            destino.required = false;
        }
    }


    tipoViaje.addEventListener(
            "change",
            actualizarTipoViaje
            );


    actualizarTipoViaje();

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

    formulario.addEventListener("submit", function (event) {

        limpiarErrores();

        let valido = true;

        if (codigoViaje.value.trim() === "") {

            mensajeCodigoViaje.textContent =
                    "Debe ingresar el código del viaje.";

            codigoViaje.classList.add("campo-invalido");

            valido = false;
        }

        if (tipoViaje.value === "") {

            mensajeTipoViaje.textContent =
                    "Debe seleccionar el tipo de viaje.";

            tipoViaje.classList.add("campo-invalido");

            valido = false;
        }

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


        if (
                tipoViaje.value === "REGULAR"
                && codigoRuta.value === ""
                ) {

            mensajeRuta.textContent =
                    "Debe seleccionar una ruta.";

            codigoRuta.classList.add("campo-invalido");

            valido = false;
        }

        if (
                tipoViaje.value === "PRIVADO"
                && origen.value.trim() === ""
                ) {

            mensajeOrigen.textContent =
                    "Debe ingresar el origen.";

            origen.classList.add("campo-invalido");

            valido = false;
        }

        if (
                tipoViaje.value === "PRIVADO"
                && destino.value.trim() === ""
                ) {

            mensajeDestino.textContent =
                    "Debe ingresar el destino.";

            destino.classList.add("campo-invalido");

            valido = false;
        }

        if (
                tipoViaje.value === "PRIVADO"
                && origen.value.trim() !== ""
                && destino.value.trim() !== ""
                && origen.value.trim().toLowerCase()
                === destino.value.trim().toLowerCase()
                ) {

            mensajeDestino.textContent =
                    "El destino debe ser diferente al origen.";

            destino.classList.add("campo-invalido");

            valido = false;
        }

        if (fechaSalida.value === "") {

            mensajeFechaSalida.textContent =
                    "Debe ingresar la fecha de salida.";

            fechaSalida.classList.add("campo-invalido");

            valido = false;
        }

        if (horaSalida.value === "") {

            mensajeHoraSalida.textContent =
                    "Debe ingresar la hora de salida.";

            horaSalida.classList.add("campo-invalido");

            valido = false;
        }

        if (fechaLlegada.value === "") {

            mensajeFechaLlegada.textContent =
                    "Debe ingresar la fecha de llegada estimada.";

            fechaLlegada.classList.add("campo-invalido");

            valido = false;
        }

        if (horaLlegada.value === "") {

            mensajeHoraLlegada.textContent =
                    "Debe ingresar la hora de llegada estimada.";

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

                mensajeHoraLlegada.textContent =
                        "La fecha y hora de llegada "
                        + "debe ser posterior a la salida.";

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


