package com.tastesync.servlet;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.util.TSConstants;

import org.apache.log4j.Logger;

import org.apache.tomcat.dbcp.dbcp.BasicDataSource;

//import org.apache.tomcat.jdbc.pool.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;


public class MySqlConnectionPoolInitServlet extends HttpServlet {
    private static final long serialVersionUID = -9130402505614323312L;

    /**
    * Logger for this class
    */
    private static final Logger logger = Logger.getLogger(MySqlConnectionPoolInitServlet.class);

    @Override
    public void init(ServletConfig config) throws ServletException {
        TSDataSource tsDataSource = TSDataSource.getInstance();

        if (TSDataSource.getPoolDSInstance() == null) {
            InitialContext initContext;
            Context envContext;

            try {
                initContext = new InitialContext();

                envContext = (Context) initContext.lookup("java:comp/env");
                TSDataSource.setPoolDSInstance((BasicDataSource) envContext.lookup(
                        TSConstants.TSDB_JNDI));
            } catch (Exception e) {
            	e.printStackTrace();
                logger.error("init(ServletConfig)", e);
            }
        }

        if (logger.isDebugEnabled()) {
            logger.debug("init(ServletConfig) - tsDataSource.poolDSInstance=" +
                TSDataSource.getPoolDSInstance() +
                " TSDataSource.getInstance()" + TSDataSource.getInstance() +
                " tsDataSource" + tsDataSource);
        }

        System.out.println("tsDataSource.poolDSInstance=" +
            TSDataSource.getPoolDSInstance() + " TSDataSource.getInstance()" +
            TSDataSource.getInstance() + " tsDataSource" + tsDataSource);
    }
}
