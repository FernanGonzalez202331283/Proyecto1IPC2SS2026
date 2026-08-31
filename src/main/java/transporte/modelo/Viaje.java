/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

import java.sql.Date;
import java.sql.Time;

/**
 *
 * @author fernan
 */
public class Viaje {
    private String codigoViaje;
    private String tipoViaje;
    private String placaBus;
    private String numeroLicencia;
    private String codigoRuta;
    private String origen;
    private String destino;
    private Date fechaSalida;
    private Time horaSalida;
    private Date fechaLlegadaEstimada;
    private Time horaLlegadaEstimada;
    private String estado;
    private double depreciacionPorKm;
    private double depreciacionTotal;
    
    public Viaje(){
    }

    public Viaje(String codigoViaje, String tipoViaje, String placaBus, String numeroLicencia, String codigoRuta, String origen, String destino, Date fechaSalida, Time horaSalida, Date fechaLlegadaEstimada, Time horaLLegadaEstimada, String estado, double depreciacionPorKm, double depreciacionTotal) {
        this.codigoViaje = codigoViaje;
        this.tipoViaje = tipoViaje;
        this.placaBus = placaBus;
        this.numeroLicencia = numeroLicencia;
        this.codigoRuta = codigoRuta;
        this.origen = origen;
        this.destino = destino;
        this.fechaSalida = fechaSalida;
        this.horaSalida = horaSalida;
        this.fechaLlegadaEstimada = fechaLlegadaEstimada;
        this.horaLlegadaEstimada = horaLLegadaEstimada;
        this.estado = estado;
        this.depreciacionPorKm = depreciacionPorKm;
        this.depreciacionTotal = depreciacionTotal;
    }

    public String getCodigoViaje() {
        return codigoViaje;
    }

    public void setCodigoViaje(String codigoViaje) {
        this.codigoViaje = codigoViaje;
    }

    public String getTipoViaje() {
        return tipoViaje;
    }

    public void setTipoViaje(String tipoViaje) {
        this.tipoViaje = tipoViaje;
    }

    public String getPlacaBus() {
        return placaBus;
    }

    public void setPlacaBus(String placaBus) {
        this.placaBus = placaBus;
    }

    public String getNumeroLicencia() {
        return numeroLicencia;
    }

    public void setNumeroLicencia(String numeroLicencia) {
        this.numeroLicencia = numeroLicencia;
    }

    public String getCodigoRuta() {
        return codigoRuta;
    }

    public void setCodigoRuta(String codigoRuta) {
        this.codigoRuta = codigoRuta;
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

    public Date getFechaSalida() {
        return fechaSalida;
    }

    public void setFechaSalida(Date fechaSalida) {
        this.fechaSalida = fechaSalida;
    }

    public Time getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(Time horaSalida) {
        this.horaSalida = horaSalida;
    }

    public Date getFechaLlegadaEstimada() {
        return fechaLlegadaEstimada;
    }

    public void setFechaLlegadaEstimada(Date fechaLlegadaEstimada) {
        this.fechaLlegadaEstimada = fechaLlegadaEstimada;
    }

    public Time getHoraLlegadaEstimada() {
        return horaLlegadaEstimada;
    }

    public void setHoraLlegadaEstimada(Time horaLLegadaEstimada) {
        this.horaLlegadaEstimada = horaLLegadaEstimada;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public double getDepreciacionPorKm() {
        return depreciacionPorKm;
    }

    public void setDepreciacionPorKm(double depreciacionPorKm) {
        this.depreciacionPorKm = depreciacionPorKm;
    }

    public double getDepreciacionTotal() {
        return depreciacionTotal;
    }

    public void setDepreciacionTotal(double depreciacionTotal) {
        this.depreciacionTotal = depreciacionTotal;
    }
    
}
