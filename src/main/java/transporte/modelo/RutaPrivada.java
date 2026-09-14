/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

/**
 *
 * @author fernan
 */
public class RutaPrivada {
    private String codigoRutaPrivada;
    private String origen;
    private String destino;
    private double distanciaKm;
    private boolean estado;
    
    public RutaPrivada(){
    }

    public RutaPrivada(String codigoRutaPrivada, String origen, String destino, double distanciaKm, boolean estado) {
        this.codigoRutaPrivada = codigoRutaPrivada;
        this.origen = origen;
        this.destino = destino;
        this.distanciaKm = distanciaKm;
        this.estado = estado;
    }

    public String getCodigoRutaPrivada() {
        return codigoRutaPrivada;
    }

    public void setCodigoRutaPrivada(String codigoRutaPrivada) {
        this.codigoRutaPrivada = codigoRutaPrivada;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getDestino() {
        return destino;
    }

    public void setDestino(String destino) {
        this.destino = destino;
    }

    public double getDistanciaKm() {
        return distanciaKm;
    }

    public void setDistanciaKm(double distanciaKm) {
        this.distanciaKm = distanciaKm;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }
    
}
