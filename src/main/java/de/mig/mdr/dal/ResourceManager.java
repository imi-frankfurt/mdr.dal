package de.mig.mdr.dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.jooq.DSLContext;
import org.jooq.impl.DSL;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ResourceManager {

  private static String URL;
  private static String USER;
  private static String PASSWORD;

  /** Logger for the resource manager. */
  private static Logger logger = LoggerFactory.getLogger(ResourceManager.class);

  private ResourceManager() {

  }

  public static synchronized void initialize(
      String host, String database, String user, String password) {
    String url = String.format("jdbc:postgresql://%s/%s", host, database);
    initialize(url, user, password);
  }

  /**
   * Set the required parameters to get connections and context.
   */
  public static synchronized void initialize(String url, String user, String password) {
    URL = url;
    USER = user;
    PASSWORD = password;
  }

  /**
   * Get a SQL Connection with the previously initialized parameters.
   */
  public static synchronized Connection getConnection() {
    try {
      return DriverManager.getConnection(URL, USER, PASSWORD);
    } catch (SQLException e) {
      logger.error("Error while retrieving database connection: " + e);
    }
    return null;
  }

  // Find out if Configuration is a resource and can be closed, probably not
  // and the connection must be closed
  //  public static synchronized Configuration getConfiguration() {
  //    return new DefaultConfiguration().set(getConnection()).set(SQLDialect.POSTGRES);
  //  }

  /**
   * Creates a DSLContext for the previously initialized parameters.
   * This is a Resource and has to be closed after use!
   * https://stackoverflow.com/questions/27773698/how-to-manage-dslcontext-in-jooq-close-connection
   */
  public static synchronized DSLContext getDslContext()
      throws IllegalArgumentException {
    return DSL.using(URL, USER, PASSWORD);
  }

  public static String getUrl() {
    return URL;
  }

  public static String getUser() {
    return USER;
  }

  public static String getPassword() {
    return PASSWORD;
  }
}
