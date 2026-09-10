/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

/**
 *
 * @author fernan
 */
public class DetalleMantenimiento {
    private String codigoMantenimiento;
    private String codigoRepuesto;
    private int cantidad;
    private double precioUnitario;

    public DetalleMantenimiento() {
    }

    public DetalleMantenimiento(String codigoMantenimiento, String codigoRepuesto, int cantidad, double precioUnitario) {
        this.codigoMantenimiento = codigoMantenimiento;
        this.codigoRepuesto = codigoRepuesto;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
    }

    public String getCodigoMantenimiento() {
        return codigoMantenimiento;
    }

    public void setCodigoMantenimiento(String codigoMantenimiento) {
        this.codigoMantenimiento = codigoMantenimiento;
    }

    public String getCodigoRepuesto() {
        return codigoRepuesto;
    }

    public void setCodigoRepuesto(String codigoRepuesto) {
        this.codigoRepuesto = codigoRepuesto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }
    
    
}
