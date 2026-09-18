document.addEventListener("DOMContentLoaded", function () {

    const formularioModificar =
            document.getElementById("formularioModificar");

    const seleccionarSucursal =
            document.getElementById("seleccionarSucursal");

    const formularioRegistrar =
            document.querySelector(
                    'form[onsubmit="return validarSucursal();"]'
                    );

    window.mostrarSucursal = function () {

        const mensaje =
                document.getElementById("mensajeSucursal");

        const opcion =
                seleccionarSucursal.options[
                    seleccionarSucursal.selectedIndex
                ];


        if (mensaje) {
            mensaje.textContent = "";
        }


        if (seleccionarSucursal.value === "") {

            formularioModificar.style.display = "none";

            return;
        }


        formularioModificar.style.display = "block";


        document.getElementById("codigo").value =
                opcion.value;

        document.getElementById("nombre").value =
                opcion.dataset.nombre || "";

        document.getElementById("direccion").value =
                opcion.dataset.direccion || "";

        document.getElementById("telefono").value =
                opcion.dataset.telefono || "";

        document.getElementById("municipio").value =
                opcion.dataset.municipio || "";

        document.getElementById("departamento").value =
                opcion.dataset.departamento || "";

        document.getElementById("latitud").value =
                opcion.dataset.latitud || "";

        document.getElementById("longitud").value =
                opcion.dataset.longitud || "";
    };

    window.validarSucursal = function () {

        const codigo =
                document.getElementById("codigo");

        const nombre =
                document.getElementById("nombre");

        const direccion =
                document.getElementById("direccion");

        const telefono =
                document.getElementById("telefono");

        const municipio =
                document.getElementById("municipio");

        const departamento =
                document.getElementById("departamento");

        const latitud =
                document.getElementById("latitud");

        const longitud =
                document.getElementById("longitud");

        let mensaje =
                document.getElementById("mensajeSucursal");

        if (!mensaje) {

            mensaje =
                    document.createElement("div");

            mensaje.id =
                    "mensajeSucursal";

            mensaje.className =
                    "mensaje";

            const formulario =
                    codigo.closest("form");

            formulario.insertBefore(
                    mensaje,
                    formulario.firstChild
                    );
        }


        mensaje.textContent = "";
        mensaje.className = "mensaje";

        if (!codigo.value.trim()) {

            mensaje.textContent =
                    "Ingrese el código de la sucursal.";

            mensaje.className =
                    "mensaje error";

            codigo.focus();

            return false;
        }

        if (!nombre.value.trim()) {

            mensaje.textContent =
                    "Ingrese el nombre de la sucursal.";

            mensaje.className =
                    "mensaje error";

            nombre.focus();

            return false;
        }


        if (nombre.value.trim().length < 3) {

            mensaje.textContent =
                    "El nombre de la sucursal debe tener al menos 3 caracteres.";

            mensaje.className =
                    "mensaje error";

            nombre.focus();

            return false;
        }

        if (!direccion.value.trim()) {

            mensaje.textContent =
                    "Ingrese la dirección de la sucursal.";

            mensaje.className =
                    "mensaje error";

            direccion.focus();

            return false;
        }


        if (direccion.value.trim().length < 5) {

            mensaje.textContent =
                    "Ingrese una dirección válida.";

            mensaje.className =
                    "mensaje error";

            direccion.focus();

            return false;
        }

        if (!telefono.value.trim()) {

            mensaje.textContent =
                    "Ingrese el teléfono de la sucursal.";

            mensaje.className =
                    "mensaje error";

            telefono.focus();

            return false;
        }


        if (!/^\d{8}$/.test(telefono.value.trim())) {

            mensaje.textContent =
                    "El teléfono debe contener exactamente 8 dígitos.";

            mensaje.className =
                    "mensaje error";

            telefono.focus();

            return false;
        }

        if (!municipio.value.trim()) {

            mensaje.textContent =
                    "Ingrese el municipio.";

            mensaje.className =
                    "mensaje error";

            municipio.focus();

            return false;
        }

        if (!departamento.value.trim()) {

            mensaje.textContent =
                    "Ingrese el departamento.";

            mensaje.className =
                    "mensaje error";

            departamento.focus();

            return false;
        }

        if (!latitud.value.trim()) {

            mensaje.textContent =
                    "Ingrese la latitud.";

            mensaje.className =
                    "mensaje error";

            latitud.focus();

            return false;
        }


        const valorLatitud =
                Number(latitud.value);


        if (isNaN(valorLatitud)
                || valorLatitud < -90
                || valorLatitud > 90) {

            mensaje.textContent =
                    "La latitud debe estar entre -90 y 90.";

            mensaje.className =
                    "mensaje error";

            latitud.focus();

            return false;
        }

        if (!longitud.value.trim()) {

            mensaje.textContent =
                    "Ingrese la longitud.";

            mensaje.className =
                    "mensaje error";

            longitud.focus();

            return false;
        }


        const valorLongitud =
                Number(longitud.value);


        if (isNaN(valorLongitud)
                || valorLongitud < -180
                || valorLongitud > 180) {

            mensaje.textContent =
                    "La longitud debe estar entre -180 y 180.";

            mensaje.className =
                    "mensaje error";

            longitud.focus();

            return false;
        }

        return true;
    };

});
