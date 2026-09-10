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
public class LlegadaViaje {
    private String codigoViaje;
    private Time horaRealLlegada;
    private double kilometrajeFinal;
    private double gastoCombustible;
    private String usuarioRegistro;

    public LlegadaViaje() {
    }

    public LlegadaViaje(String codigoViaje, Time horaRealLlegada, double kilometrajeFinal, double gastoCombustible, String usuarioRegistro) {
        this.codigoViaje = codigoViaje;
        this.horaRealLlegada = horaRealLlegada;
        this.kilometrajeFinal = kilometrajeFinal;
        this.gastoCombustible = gastoCombustible;
        this.usuarioRegistro = usuarioRegistro;
    }

    public String getCodigoViaje() {
        return codigoViaje;
    }

    public void setCodigoViaje(String codigoViaje) {
        this.codigoViaje = codigoViaje;
    }

    public Time getHoraRealLlegada() {
        return horaRealLlegada;
    }

    public void setHoraRealLlegada(Time horaRealLlegada) {
        this.horaRealLlegada = horaRealLlegada;
    }

    public double getKilometrajeFinal() {
        return kilometrajeFinal;
    }

    public void setKilometrajeFinal(double kilometrajeFinal) {
        this.kilometrajeFinal = kilometrajeFinal;
    }

    public double getGastoCombustible() {
        return gastoCombustible;
    }

    public void setGastoCombustible(double gastoCombustible) {
        this.gastoCombustible = gastoCombustible;
    }

    public String getUsuarioRegistro() {
        return usuarioRegistro;
    }

    public void setUsuarioRegistro(String usuarioRegistro) {
        this.usuarioRegistro = usuarioRegistro;
    }
    
    
}
