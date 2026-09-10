/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

import java.sql.Date;

/**
 *
 * @author fernan
 */
public class Alquiler {
    private String codigoAlquiler;
    private String codigoViaje;
    private String usuarioCliente;
    private int numeroPasajeros;
    private Date fechaRetorno;
    private double precioEstimado;
    private double precioConfirmado;
    private String estado;
    
    public Alquiler() {
    }

    public Alquiler(String codigoAlquiler, String codigoViaje, String usuarioCliente, int numeroPasajeros, Date fechaRetorno, double precioEstimado, double precioConfirmado, String estado) {
        this.codigoAlquiler = codigoAlquiler;
        this.codigoViaje = codigoViaje;
        this.usuarioCliente = usuarioCliente;
        this.numeroPasajeros = numeroPasajeros;
        this.fechaRetorno = fechaRetorno;
        this.precioEstimado = precioEstimado;
        this.precioConfirmado = precioConfirmado;
        this.estado = estado;
    }

    public String getCodigoAlquiler() {
        return codigoAlquiler;
    }

    public void setCodigoAlquiler(String codigoAlquiler) {
        this.codigoAlquiler = codigoAlquiler;
    }

    public String getCodigoViaje() {
        return codigoViaje;
    }

    public void setCodigoViaje(String codigoViaje) {
        this.codigoViaje = codigoViaje;
    }

    public String getUsuarioCliente() {
        return usuarioCliente;
    }

    public void setUsuarioCliente(String usuarioCliente) {
        this.usuarioCliente = usuarioCliente;
    }

    public int getNumeroPasajeros() {
        return numeroPasajeros;
    }

    public void setNumeroPasajeros(int numeroPasajeros) {
        this.numeroPasajeros = numeroPasajeros;
    }

    public Date getFechaRetorno() {
        return fechaRetorno;
    }

    public void setFechaRetorno(Date fechaRetorno) {
        this.fechaRetorno = fechaRetorno;
    }

    public double getPrecioEstimado() {
        return precioEstimado;
    }

    public void setPrecioEstimado(double precioEstimado) {
        this.precioEstimado = precioEstimado;
    }

    public double getPrecioConfirmado() {
        return precioConfirmado;
    }

    public void setPrecioConfirmado(double precioConfirmado) {
        this.precioConfirmado = precioConfirmado;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    
    
    
    
}
