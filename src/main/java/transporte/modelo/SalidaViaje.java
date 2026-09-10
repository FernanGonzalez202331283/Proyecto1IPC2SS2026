/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

import java.sql.Time;

/**
 *
 * @author fernan
 */
public class SalidaViaje {
    
    private String codigoViaje;
    private Time horaRealSalida;
    private double kilometrajeInicial;
    private String usuarioRegistro;
    
    public SalidaViaje(){
        
    }

    public SalidaViaje(String codigoViaje, Time horaRealSalida, double kilometrajeInicial, String usuarioRegistro) {
        this.codigoViaje = codigoViaje;
        this.horaRealSalida = horaRealSalida;
        this.kilometrajeInicial = kilometrajeInicial;
        this.usuarioRegistro = usuarioRegistro;
    }

    public String getCodigoViaje() {
        return codigoViaje;
    }

    public void setCodigoViaje(String codigoViaje) {
        this.codigoViaje = codigoViaje;
    }

    public Time getHoraRealSalida() {
        return horaRealSalida;
    }

    public void setHoraRealSalida(Time horaRealSalida) {
        this.horaRealSalida = horaRealSalida;
    }

    public double getKilometrajeInicial() {
        return kilometrajeInicial;
    }

    public void setKilometrajeInicial(double kilometrajeInicial) {
        this.kilometrajeInicial = kilometrajeInicial;
    }

    public String getUsuarioRegistro() {
        return usuarioRegistro;
    }

    public void setUsuarioRegistro(String usuarioRegistro) {
        this.usuarioRegistro = usuarioRegistro;
    }
    
    
}
