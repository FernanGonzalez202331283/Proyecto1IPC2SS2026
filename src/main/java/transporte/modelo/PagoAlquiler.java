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
public class PagoAlquiler {
    private String codigoPago;
    private String codigoAlquiler;
    private String codigoMovimiento;
    private double monto;
    private Date fechaPago;

    public PagoAlquiler() {
    }

    public PagoAlquiler(String codigoPago, String codigoAlquiler, String codigoMovimiento, double monto, Date fechaPago) {
        this.codigoPago = codigoPago;
        this.codigoAlquiler = codigoAlquiler;
        this.codigoMovimiento = codigoMovimiento;
        this.monto = monto;
        this.fechaPago = fechaPago;
    }

    public String getCodigoPago() {
        return codigoPago;
    }

    public void setCodigoPago(String codigoPago) {
        this.codigoPago = codigoPago;
    }

    public String getCodigoAlquiler() {
        return codigoAlquiler;
    }

    public void setCodigoAlquiler(String codigoAlquiler) {
        this.codigoAlquiler = codigoAlquiler;
    }

    public String getCodigoMovimiento() {
        return codigoMovimiento;
    }

    public void setCodigoMovimiento(String codigoMovimiento) {
        this.codigoMovimiento = codigoMovimiento;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public Date getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Date fechaPago) {
        this.fechaPago = fechaPago;
    }
    
    
}
