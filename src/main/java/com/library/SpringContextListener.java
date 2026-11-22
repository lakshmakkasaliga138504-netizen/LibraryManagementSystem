
package com.library;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import org.springframework.context.annotation.AnnotationConfigApplicationContext;

@WebListener
public class SpringContextListener
        implements ServletContextListener {

    private AnnotationConfigApplicationContext context;

    @Override
    public void contextInitialized(ServletContextEvent event) {

        context = new AnnotationConfigApplicationContext(
        SpringConfig.class
);
        event.getServletContext().setAttribute(
                "springContext", context
        );

        System.out.println("Spring Context Started Successfully!");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {

        if (context != null) {
            context.close();
        }

        System.out.println("Spring Context Closed!");
    }
}
