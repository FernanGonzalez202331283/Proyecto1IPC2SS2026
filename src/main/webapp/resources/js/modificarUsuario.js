/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
function mostrarUsuario() {

    const seleccion =
        document.getElementById("seleccionarUsuario");

    const formulario =
        document.getElementById("formularioModificar");

    const grupoSucursal =
        document.getElementById("grupoSucursal");

    const opcion =
        seleccion.options[seleccion.selectedIndex];


    if (seleccion.value === "") {

        formulario.style.display = "none";

        return;
    }

    formulario.style.display = "block";
    document.getElementById("usuario").value =
            opcion.value;
    const rol =
            opcion.dataset.rol;

    document.getElementById("rol").value =
            rol;

    if (rol === "ADMIN_SUCURSAL") {

        grupoSucursal.style.display = "block";

        document.getElementById("codigoSucursal").value =
                opcion.dataset.sucursal;

    } else {

        grupoSucursal.style.display = "none";

        document.getElementById("codigoSucursal").value =
                "";
    }

    document.getElementById("contrasena").value = "";

    document.getElementById("mensajeContrasena").textContent = "";
    document.getElementById("mensajeSucursal").textContent = "";

}


document.addEventListener("DOMContentLoaded", function () {

    const formulario =
            document.getElementById("modificarUsuarioForm");


    formulario.addEventListener("submit", function (event) {

        let valido = true;


        const contrasena =
                document.getElementById("contrasena");

        const sucursal =
                document.getElementById("codigoSucursal");


        const mensajeContrasena =
                document.getElementById("mensajeContrasena");

        const mensajeSucursal =
                document.getElementById("mensajeSucursal");


        mensajeContrasena.textContent = "";
        mensajeSucursal.textContent = "";


        contrasena.classList.remove("campo-invalido");
        sucursal.classList.remove("campo-invalido");

        if (contrasena.value.trim() === "") {

            mensajeContrasena.textContent =
                    "Ingrese una contraseña.";

            contrasena.classList.add("campo-invalido");

            valido = false;

        } else if (contrasena.value.length < 4) {

            mensajeContrasena.textContent =
                    "La contraseña debe tener al menos 4 caracteres.";

            contrasena.classList.add("campo-invalido");

            valido = false;
        }

        const rol =
                document.getElementById("rol").value;


        if (rol === "ADMIN_SUCURSAL" &&
            sucursal.value === "") {

            mensajeSucursal.textContent =
                    "Seleccione una sucursal.";

            sucursal.classList.add("campo-invalido");

            valido = false;
        }


        if (!valido) {

            event.preventDefault();
        }

    });

});