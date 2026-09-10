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
    private static final String URL = "jdbc:mysql://localhost:3306/transporte_extraurbano";
    private static final String USER_NAME = "rootbd";
    private static final String PASSWORD = "Fernan16@2026";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("### DIAGNOSTICO: no se encontro la clase del driver MySQL");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            Connection c = DriverManager.getConnection(URL, USER_NAME, PASSWORD);
            System.out.println("### DIAGNOSTICO: conexion exitosa");
            return c;
        } catch (SQLException e) {
            System.out.println("### DIAGNOSTICO ERROR SQL: " + e.getClass().getName() + " -> " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    
}
