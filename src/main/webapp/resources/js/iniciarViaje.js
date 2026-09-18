/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {
const formulario =
        document.getElementById("formularioIniciarViaje");

if (!formulario) {
    return;
}

const horaSalida =
        document.getElementById("horaRealSalida");

const mensajeHoraSalida =
        document.getElementById("mensajeHoraSalida");


formulario.addEventListener("submit", function (event) {

    let valido = true;

    mensajeHoraSalida.textContent = "";

    horaSalida.classList.remove("campo-invalido");


    if (horaSalida.value === "") {

        mensajeHoraSalida.textContent =
                "Debe ingresar la hora real de salida.";

        horaSalida.classList.add("campo-invalido");

        valido = false;
    }


    if (!valido) {
        event.preventDefault();
    }

});
});


