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
public class Mantenimiento {
    private String codigoMantenimiento;
    private String placaBus;
    private Date fecha;
    private double montoManoObra;
    private double montoRepuestos;
    private String descripcion;

    public Mantenimiento() {
    }

    public Mantenimiento(String codigoMantenimiento, String placaBus, Date fecha, double montoManoObra, double montoRepuestos, String descripcion) {
        this.codigoMantenimiento = codigoMantenimiento;
        this.placaBus = placaBus;
        this.fecha = fecha;
        this.montoManoObra = montoManoObra;
        this.montoRepuestos = montoRepuestos;
        this.descripcion = descripcion;
    }

    public String getCodigoMantenimiento() {
        return codigoMantenimiento;
    }

    public void setCodigoMantenimiento(String codigoMantenimiento) {
        this.codigoMantenimiento = codigoMantenimiento;
    }

    public String getPlacaBus() {
        return placaBus;
    }

    public void setPlacaBus(String placaBus) {
        this.placaBus = placaBus;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public double getMontoManoObra() {
        return montoManoObra;
    }

    public void setMontoManoObra(double montoManoObra) {
        this.montoManoObra = montoManoObra;
    }

    public double getMontoRepuestos() {
        return montoRepuestos;
    }

    public void setMontoRepuestos(double montoRepuestos) {
        this.montoRepuestos = montoRepuestos;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    
}
