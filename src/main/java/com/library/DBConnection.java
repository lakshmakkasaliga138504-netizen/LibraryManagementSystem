
package com.library;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static String getEnv(String name, String fallback) {
        String value = System.getenv(name);
        return (value == null || value.isBlank()) ? fallback : value;
    }

    public static Connection getConnection() throws SQLException {

        String host = getEnv("DB_HOST", "127.0.0.1");
        String port = getEnv("DB_PORT", "3307");
        String database = getEnv("DB_NAME", "library_management");
        String username = getEnv("DB_USER", "root");
        String password = getEnv("DB_PASSWORD", "root123");

        String url = "jdbc:mysql://" + host + ":" + port + "/"
                + database + "?useSSL=false&serverTimezone=UTC";

        System.out.println("Login JDBC URL: " + url);

        return DriverManager.getConnection(url, username, password);
    }
}
