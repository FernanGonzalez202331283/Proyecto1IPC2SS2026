/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("formularioRegistrarChofer");

    if (!formulario) {
        return;
    }

    const licencia =
            document.getElementById("numeroLicencia");

    const nombre =
            document.getElementById("nombreCompleto");

    const tipoLicencia =
            document.getElementById("tipoLicencia");

    const fecha =
            document.getElementById("fechaVencimientoLicencia");

    const telefono =
            document.getElementById("telefono");

    const salario =
            document.getElementById("salarioBaseViaje");


    const mensajeLicencia =
            document.getElementById("mensajeLicencia");

    const mensajeNombre =
            document.getElementById("mensajeNombre");

    const mensajeTipoLicencia =
            document.getElementById("mensajeTipoLicencia");

    const mensajeFecha =
            document.getElementById("mensajeFecha");

    const mensajeTelefono =
            document.getElementById("mensajeTelefono");

    const mensajeSalario =
            document.getElementById("mensajeSalario");


    function limpiarErrores() {

        mensajeLicencia.textContent = "";
        mensajeNombre.textContent = "";
        mensajeTipoLicencia.textContent = "";
        mensajeFecha.textContent = "";
        mensajeTelefono.textContent = "";
        mensajeSalario.textContent = "";

        licencia.classList.remove("campo-invalido");
        nombre.classList.remove("campo-invalido");
        tipoLicencia.classList.remove("campo-invalido");
        fecha.classList.remove("campo-invalido");
        telefono.classList.remove("campo-invalido");
        salario.classList.remove("campo-invalido");
    }


    formulario.addEventListener("submit", function (event) {

        limpiarErrores();

        let valido = true;


        if (licencia.value.trim() === "") {

            mensajeLicencia.textContent =
                    "Debe ingresar el número de licencia.";

            licencia.classList.add("campo-invalido");

            valido = false;
        }


        if (nombre.value.trim() === "") {

            mensajeNombre.textContent =
                    "Debe ingresar el nombre completo.";

            nombre.classList.add("campo-invalido");

            valido = false;

        } else if (/\d/.test(nombre.value)) {

            mensajeNombre.textContent =
                    "El nombre completo no debe contener números.";

            nombre.classList.add("campo-invalido");

            valido = false;
        }


        if (tipoLicencia.value === "") {

            mensajeTipoLicencia.textContent =
                    "Debe seleccionar el tipo de licencia.";

            tipoLicencia.classList.add("campo-invalido");

            valido = false;
        }


        if (fecha.value === "") {

            mensajeFecha.textContent =
                    "Debe seleccionar la fecha de vencimiento.";

            fecha.classList.add("campo-invalido");

            valido = false;

        } else {

            const hoy = new Date();
            hoy.setHours(0, 0, 0, 0);

            const fechaVencimiento =
                    new Date(fecha.value + "T00:00:00");

            if (fechaVencimiento < hoy) {

                mensajeFecha.textContent =
                        "La fecha de vencimiento no puede ser anterior a hoy.";

                fecha.classList.add("campo-invalido");

                valido = false;
            }
        }


        if (telefono.value.trim() === "") {

            mensajeTelefono.textContent =
                    "Debe ingresar el número de teléfono.";

            telefono.classList.add("campo-invalido");

            valido = false;

        } else if (!/^\d{8}$/.test(telefono.value.trim())) {

            mensajeTelefono.textContent =
                    "El teléfono debe contener exactamente 8 dígitos.";

            telefono.classList.add("campo-invalido");

            valido = false;
        }


        const valorSalario =
                parseFloat(salario.value);


        if (salario.value === "") {

            mensajeSalario.textContent =
                    "Debe ingresar el salario base por viaje.";

            salario.classList.add("campo-invalido");

            valido = false;

        } else if (
                isNaN(valorSalario)
                || valorSalario < 0
        ) {

            mensajeSalario.textContent =
                    "El salario base por viaje no puede ser negativo.";

            salario.classList.add("campo-invalido");

            valido = false;
        }


        if (!valido) {
            event.preventDefault();
        }

    });

});


