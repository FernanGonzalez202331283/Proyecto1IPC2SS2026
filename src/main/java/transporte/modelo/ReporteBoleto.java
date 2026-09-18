/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

/**
 *
 * @author fernan
 */
public class ReporteBoleto {
    private String codigoViaje;
    private String ruta;
    private String bus;
    private String fechaSalida;
    private int boletosVendidos;
    private double ingresoTotal;
    
    public ReporteBoleto(){
        
    }

    public ReporteBoleto(String codigoViaje, String ruta, String bus, String fechaSalida, int boletosVendidos, double ingresoTotal) {
        this.codigoViaje = codigoViaje;
        this.ruta = ruta;
        this.bus = bus;
        this.fechaSalida = fechaSalida;
        this.boletosVendidos = boletosVendidos;
        this.ingresoTotal = ingresoTotal;
    }

    public String getCodigoViaje() {
        return codigoViaje;
    }

    public void setCodigoViaje(String codigoViaje) {
        this.codigoViaje = codigoViaje;
    }

    public String getRuta() {
        return ruta;
    }

    public void setRuta(String ruta) {
        this.ruta = ruta;
    }

    public String getBus() {
        return bus;
    }

    public void setBus(String bus) {
        this.bus = bus;
    }

    public String getFechaSalida() {
        return fechaSalida;
    }

    public void setFechaSalida(String fechaSalida) {
        this.fechaSalida = fechaSalida;
    }

    public int getBoletosVendidos() {
        return boletosVendidos;
    }

    public void setBoletosVendidos(int boletosVendidos) {
        this.boletosVendidos = boletosVendidos;
    }

    public double getIngresoTotal() {
        return ingresoTotal;
    }

    public void setIngresoTotal(double ingresoTotal) {
        this.ingresoTotal = ingresoTotal;
    }
    
}
