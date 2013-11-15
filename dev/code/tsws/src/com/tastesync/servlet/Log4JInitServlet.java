package com.tastesync.servlet;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

import java.io.File;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;


public class Log4JInitServlet extends HttpServlet {
    /**
     * Logger for this class
     */
    private static final Logger logger = Logger.getLogger(Log4JInitServlet.class);
    private static final long serialVersionUID = 1L;

    @Override
    public void init(ServletConfig config) throws ServletException {
        if (logger.isDebugEnabled()) {
            logger.debug(
                "init(ServletConfig) - Log4JInitServlet is initializing log4j");
        }

        String log4jLocation = config.getInitParameter(
                "log4j-properties-location");
        ServletContext sc = config.getServletContext();

        if (log4jLocation == null) {
            logger.error("init(ServletConfig) - *** No log4j-properties-location init param, so initializing log4j with BasicConfigurator",
                null);
            BasicConfigurator.configure();
        } else {
            String webAppPath = sc.getRealPath("/");
            String log4jProp = webAppPath + log4jLocation;
            File log4File = new File(log4jProp);

            System.out.println("log4jProp=" + log4jProp);

            if (log4File.exists()) {
                if (logger.isDebugEnabled()) {
                    logger.debug(
                        "init(ServletConfig) - Initializing log4j with: " +
                        log4jProp);
                }

                PropertyConfigurator.configure(log4jProp);

                if (logger.isDebugEnabled()) {
                    logger.debug(
                        "init(ServletConfig) - Initialized log4j with: " +
                        log4jProp);
                }
            } else {
                logger.error("init(ServletConfig) - *** " + log4jProp +
                    " file not found, so initializing log4j with BasicConfigurator",
                    null);
                BasicConfigurator.configure();
            }
        }

        super.init(config);
    }
}
