function mostrarSucursal() {

    const seleccion = document.getElementById("seleccionarSucursal");
    const formulario = document.getElementById("formularioModificar");

    const opcion = seleccion.options[seleccion.selectedIndex];


    if (seleccion.value === "") {

        formulario.style.display = "none";

        return;
    }


    formulario.style.display = "block";


    document.getElementById("codigo").value =
        opcion.value;

    document.getElementById("nombre").value =
        opcion.dataset.nombre;

    document.getElementById("direccion").value =
        opcion.dataset.direccion;

    document.getElementById("telefono").value =
        opcion.dataset.telefono;

    document.getElementById("municipio").value =
        opcion.dataset.municipio;

    document.getElementById("departamento").value =
        opcion.dataset.departamento;

    document.getElementById("latitud").value =
        opcion.dataset.latitud;

    document.getElementById("longitud").value =
        opcion.dataset.longitud;
}


function validarSucursal() {

    const codigo = document.getElementById("codigo").value.trim();
    const nombre = document.getElementById("nombre").value.trim();
    const direccion = document.getElementById("direccion").value.trim();
    const telefono = document.getElementById("telefono").value.trim();
    const municipio = document.getElementById("municipio").value.trim();
    const departamento = document.getElementById("departamento").value.trim();

    const latitud = document.getElementById("latitud").value;
    const longitud = document.getElementById("longitud").value;


    if (codigo === "") {
        alert("Ingrese el código de la sucursal.");
        return false;
    }

    if (nombre === "") {
        alert("Ingrese el nombre de la sucursal.");
        return false;
    }

    if (direccion === "") {
        alert("Ingrese la dirección de la sucursal.");
        return false;
    }

    if (telefono === "") {
        alert("Ingrese el teléfono de la sucursal.");
        return false;
    }

    if (municipio === "") {
        alert("Ingrese el municipio.");
        return false;
    }

    if (departamento === "") {
        alert("Ingrese el departamento.");
        return false;
    }

    if (latitud === "" || longitud === "") {
        alert("Ingrese las coordenadas de la sucursal.");
        return false;
    }

    return true;
}
function filtrarSucursales() {
const texto = document
    .getElementById("buscarSucursal")
    .value
    .toLowerCase();

const tabla = document.getElementById("tablaSucursales");

const filas = tabla
    .getElementsByTagName("tbody")[0]
    .getElementsByTagName("tr");


for (let i = 0; i < filas.length; i++) {

    const contenido = filas[i]
        .textContent
        .toLowerCase();

    if (contenido.includes(texto)) {

        filas[i].style.display = "";

    } else {

        filas[i].style.display = "none";
    }
}

}
