/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

/**
 *
 * @author fernan
 */
public class Ruta {
    private String codigoRuta;
    private String codigoSucursalOrigen;
    private String codigoSucursalDestino;
    private double distanciaKm;
    private double precioBoleto;
    private boolean estado;

    public Ruta(String codigoRuta, String codigoSucursalOrigen, String codigoSucursalDestino, double distanciaKm, double precioBoleto, boolean estado) {
        this.codigoRuta = codigoRuta;
        this.codigoSucursalOrigen = codigoSucursalOrigen;
        this.codigoSucursalDestino = codigoSucursalDestino;
        this.distanciaKm = distanciaKm;
        this.precioBoleto = precioBoleto;
        this.estado = estado;
    }

    public String getCodigoRuta() {
        return codigoRuta;
    }

    public void setCodigoRuta(String codigoRuta) {
        this.codigoRuta = codigoRuta;
    }

    public String getCodigoSucursalOrigen() {
        return codigoSucursalOrigen;
    }

    public void setCodigoSucursalOrigen(String codigoSucursalOrigen) {
        this.codigoSucursalOrigen = codigoSucursalOrigen;
    }

    public String getCodigoSucursalDestino() {
        return codigoSucursalDestino;
    }

    public void setCodigoSucursalDestino(String codigoSucursalDestino) {
        this.codigoSucursalDestino = codigoSucursalDestino;
    }

    public double getDistanciaKm() {
        return distanciaKm;
    }

    public void setDistanciaKm(double distanciaKm) {
        this.distanciaKm = distanciaKm;
    }

    public double getPrecioBoleto() {
        return precioBoleto;
    }

    public void setPrecioBoleto(double precioBoleto) {
        this.precioBoleto = precioBoleto;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }
    
    
    
}
