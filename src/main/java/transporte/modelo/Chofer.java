/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

/**
 *
 * @author fernan
 */
public class Chofer {
    private String numeroLicencia;
    private String codigoSucursal;
    private String foto;
    private String nombreCompleto;
    private String tipoLicencia;
    private String fechaVencimientoLicencia;
    private String telefono;
    private double salarioBaseViaje;
    private boolean estado;

    public Chofer(String numeroLicencia, String codigoSucursal, String foto, String nombreCompleto, String tipoLicencia, String fechaVencimientoLicencia, String telefono, double salarioBaseViaje, boolean estado) {
        this.numeroLicencia = numeroLicencia;
        this.codigoSucursal = codigoSucursal;
        this.foto = foto;
        this.nombreCompleto = nombreCompleto;
        this.tipoLicencia = tipoLicencia;
        this.fechaVencimientoLicencia = fechaVencimientoLicencia;
        this.telefono = telefono;
        this.salarioBaseViaje = salarioBaseViaje;
        this.estado = estado;
    }

    public String getNumeroLicencia() {
        return numeroLicencia;
    }

    public void setNumeroLicencia(String numeroLicencia) {
        this.numeroLicencia = numeroLicencia;
    }

    public String getCodigoSucursal() {
        return codigoSucursal;
    }

    public void setCodigoSucursal(String codigoSucursal) {
        this.codigoSucursal = codigoSucursal;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getTipoLicencia() {
        return tipoLicencia;
    }

    public void setTipoLicencia(String tipoLicencia) {
        this.tipoLicencia = tipoLicencia;
    }

    public String getFechaVencimientoLicencia() {
        return fechaVencimientoLicencia;
    }

    public void setFechaVencimientoLicencia(String fechaVencimientoLicencia) {
        this.fechaVencimientoLicencia = fechaVencimientoLicencia;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public double getSalarioBaseViaje() {
        return salarioBaseViaje;
    }

    public void setSalarioBaseViaje(double salarioBaseViaje) {
        this.salarioBaseViaje = salarioBaseViaje;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }
    
    
    
}
