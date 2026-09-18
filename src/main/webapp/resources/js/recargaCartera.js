document.addEventListener("DOMContentLoaded", function () {

    const formulario = document.getElementById("formRecarga");
    const monto = document.getElementById("monto");
    const mensaje = document.getElementById("mensajeJS");

    if (!formulario || !monto || !mensaje) {
        return;
    }

    formulario.addEventListener("submit", function (event) {

        const valor = parseFloat(monto.value);

        mensaje.textContent = "";
        mensaje.className = "mensaje";

        if (isNaN(valor)) {
            event.preventDefault();

            mensaje.textContent = "Debes ingresar un monto válido.";
            mensaje.classList.add("Error");

            monto.focus();
            return;
        }

        if (valor <= 0) {
            event.preventDefault();

            mensaje.textContent = "El monto debe ser mayor que Q0.00.";
            mensaje.classList.add("Error");

            monto.focus();
            return;
        }

        if (valor > 100000) {
            event.preventDefault();

            mensaje.textContent = "El monto máximo permitido es Q100,000.00.";
            mensaje.classList.add("Error");

            monto.focus();
            return;
        }

    });

});