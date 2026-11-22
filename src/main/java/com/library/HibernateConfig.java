
package com.library;

import com.library.entity.StudentEntity;
import com.library.entity.BookEntity;
import com.library.entity.IssueEntity;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.springframework.context.annotation.Bean;

@org.springframework.context.annotation.Configuration
public class HibernateConfig {

    private String getEnv(String name, String fallback) {
        String value = System.getenv(name);
        return (value == null || value.isBlank()) ? fallback : value;
    }

    @Bean(destroyMethod = "close")
    public SessionFactory sessionFactory() {

        String host = getEnv("DB_HOST", "127.0.0.1");
        String port = getEnv("DB_PORT", "3307");
        String database = getEnv("DB_NAME", "library_management");
        String username = getEnv("DB_USER", "root");
        String password = getEnv("DB_PASSWORD", "");

        Configuration config = new Configuration();

        config.addAnnotatedClass(StudentEntity.class);
        config.addAnnotatedClass(BookEntity.class);
        config.addAnnotatedClass(IssueEntity.class);

        config.setProperty(
            "hibernate.connection.driver_class",
            "com.mysql.cj.jdbc.Driver"
        );

        config.setProperty(
            "hibernate.connection.url",
            "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=false&serverTimezone=UTC"
        );

        config.setProperty("hibernate.connection.username", username);
        config.setProperty("hibernate.connection.password", password);
        config.setProperty(
            "hibernate.dialect",
            "org.hibernate.dialect.MySQLDialect"
        );

        config.setProperty("hibernate.hbm2ddl.auto", "validate");
        config.setProperty("hibernate.show_sql", "true");

        return config.buildSessionFactory();
    }
}
