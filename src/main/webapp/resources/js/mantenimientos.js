/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {
const cantidades =
        document.querySelectorAll(".cantidad-repuesto");

const manoObra =
        document.getElementById("montoManoObra");

const fecha =
        document.getElementById("fecha");

const totalRepuestos =
        document.getElementById("totalRepuestos");

const totalManoObra =
        document.getElementById("totalManoObra");

const totalMantenimiento =
        document.getElementById("totalMantenimiento");

const montoRepuestos =
        document.getElementById("montoRepuestos");


function calcularTotales() {

    let total = 0;

    cantidades.forEach(function (campo) {

        let cantidad =
                parseInt(campo.value) || 0;

        let precio =
                parseFloat(campo.dataset.precio) || 0;

        if (cantidad < 0) {
            cantidad = 0;
            campo.value = 0;
        }

        const subtotal =
                cantidad * precio;

        const fila =
                campo.closest("tr");

        const subtotalElemento =
                fila.querySelector(".subtotal-repuesto");

        subtotalElemento.textContent =
                subtotal.toFixed(2);

        total += subtotal;
    });


    let valorManoObra =
            parseFloat(manoObra.value) || 0;

    if (valorManoObra < 0) {
        valorManoObra = 0;
        manoObra.value = "0";
    }


    const costoTotal =
            total + valorManoObra;


    totalRepuestos.textContent =
            total.toFixed(2);

    totalManoObra.textContent =
            valorManoObra.toFixed(2);

    totalMantenimiento.textContent =
            costoTotal.toFixed(2);

    montoRepuestos.value =
            total.toFixed(2);
}


cantidades.forEach(function (campo) {

    campo.addEventListener(
            "input",
            calcularTotales
    );

});


manoObra.addEventListener(
        "input",
        calcularTotales
);

if (fecha) {

    const hoy =
            new Date();

    const año =
            hoy.getFullYear();

    const mes =
            String(
                    hoy.getMonth() + 1
            ).padStart(2, "0");

    const dia =
            String(
                    hoy.getDate()
            ).padStart(2, "0");

    fecha.max =
            año + "-" + mes + "-" + dia;
}


calcularTotales();

});

