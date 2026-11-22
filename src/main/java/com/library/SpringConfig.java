package com.library;

import org.hibernate.SessionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import(HibernateConfig.class)
public class SpringConfig {

    @Bean
    public StudentDAO studentDAO(SessionFactory sessionFactory) {
        StudentDAO dao = new StudentDAO();
        dao.setSessionFactory(sessionFactory);
        return dao;
    }

    @Bean
    public BookDAO bookDAO(SessionFactory sessionFactory) {
        BookDAO dao = new BookDAO();
        dao.setSessionFactory(sessionFactory);
        return dao;
    }

    @Bean
    public IssueDAO issueDAO(SessionFactory sessionFactory) {
        IssueDAO dao = new IssueDAO();
        dao.setSessionFactory(sessionFactory);
        return dao;
    }
}