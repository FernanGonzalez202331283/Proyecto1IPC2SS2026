/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

/**
 *
 * @author fernan
 */
public class CostoViaje {
    private String codigoViaje;
    private double salarioChofer;
    private double combustible;
    private double depreciacion;

    public CostoViaje() {
    }

    public CostoViaje(String codigoViaje, double salarioChofer, double combustible, double depreciacion) {
        this.codigoViaje = codigoViaje;
        this.salarioChofer = salarioChofer;
        this.combustible = combustible;
        this.depreciacion = depreciacion;
    }

    public String getCodigoViaje() {
        return codigoViaje;
    }

    public void setCodigoViaje(String codigoViaje) {
        this.codigoViaje = codigoViaje;
    }

    public double getSalarioChofer() {
        return salarioChofer;
    }

    public void setSalarioChofer(double salarioChofer) {
        this.salarioChofer = salarioChofer;
    }

    public double getCombustible() {
        return combustible;
    }

    public void setCombustible(double combustible) {
        this.combustible = combustible;
    }

    public double getDepreciacion() {
        return depreciacion;
    }

    public void setDepreciacion(double depreciacion) {
        this.depreciacion = depreciacion;
    }
    
    
}
