/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package transporte.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author fernan
 */
public class Conexion {
    private static final String URL = "jdbc:mysql://localhost:3306/";
    private static final String USER_NAME = "rootbd";
    private static final String PASSWORD = "Fernan16@2026";
    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER_NAME, PASSWORD);
        } catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos: " + e);
        }
        return null;
    }
    
}
