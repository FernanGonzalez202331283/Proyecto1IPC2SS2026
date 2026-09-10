/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.modelo;

/**
 *
 * @author fernan
 */
public class AdministrarSucursal {
    private String usuario;
    private String codigoSucursal;
    
    public AdministrarSucursal(){
        
    }

    public AdministrarSucursal(String usuario, String codigoSucursal) {
        this.usuario = usuario;
        this.codigoSucursal = codigoSucursal;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getCodigoSucursal() {
        return codigoSucursal;
    }

    public void setCodigoSucursal(String codigoSucursal) {
        this.codigoSucursal = codigoSucursal;
    }
    
    
}
