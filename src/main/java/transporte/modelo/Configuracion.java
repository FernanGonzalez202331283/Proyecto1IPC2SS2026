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
public class Configuracion {
    private String codigoConfiguracion;
    private double depreciacionPorKm;
    private Date fechaConfiguracion;
    
    public Configuracion(){
        
    }

    public Configuracion(String codigoConfiguracion, double depreciacionPorKm, Date fechaConfiguracion) {
        this.codigoConfiguracion = codigoConfiguracion;
        this.depreciacionPorKm = depreciacionPorKm;
        this.fechaConfiguracion = fechaConfiguracion;
    }

    public String getCodigoConfiguracion() {
        return codigoConfiguracion;
    }

    public void setCodigoConfiguracion(String codigoConfiguracion) {
        this.codigoConfiguracion = codigoConfiguracion;
    }

    public double getDepreciacionPorKm() {
        return depreciacionPorKm;
    }

    public void setDepreciacionPorKm(double depreciacionPorKm) {
        this.depreciacionPorKm = depreciacionPorKm;
    }

    public Date getFechaConfiguracion() {
        return fechaConfiguracion;
    }

    public void setFechaConfiguracion(Date fechaConfiguracion) {
        this.fechaConfiguracion = fechaConfiguracion;
    }
    
    
    
}
