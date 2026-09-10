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
public class Boleto {
    
    private String codigoBoleto;
    private String codigoViaje;
    private String usuarioCliente;
    private int numeroAsiento;
    private double precio;
    private Date fechaPago;
    private String estado;
    private String codigoMovimiento;

    public Boleto() {
    }

    public Boleto(String codigoBoleto, String codigoViaje, String usuarioCliente, int numeroAsiento, double precio, Date fechaPago, String estado, String codigoMovimiento) {
        this.codigoBoleto = codigoBoleto;
        this.codigoViaje = codigoViaje;
        this.usuarioCliente = usuarioCliente;
        this.numeroAsiento = numeroAsiento;
        this.precio = precio;
        this.fechaPago = fechaPago;
        this.estado = estado;
        this.codigoMovimiento = codigoMovimiento;
    }

    public String getCodigoBoleto() {
        return codigoBoleto;
    }

    public void setCodigoBoleto(String codigoBoleto) {
        this.codigoBoleto = codigoBoleto;
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

    public int getNumeroAsiento() {
        return numeroAsiento;
    }

    public void setNumeroAsiento(int numeroAsiento) {
        this.numeroAsiento = numeroAsiento;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public Date getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Date fechaPago) {
        this.fechaPago = fechaPago;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getCodigoMovimiento() {
        return codigoMovimiento;
    }

    public void setCodigoMovimiento(String codigoMovimiento) {
        this.codigoMovimiento = codigoMovimiento;
    }
    
    
}
