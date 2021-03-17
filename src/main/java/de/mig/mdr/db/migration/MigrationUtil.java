package de.mig.mdr.db.migration;

import de.mig.mdr.dal.ResourceManager;
import java.sql.SQLException;
import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.MigrationInfo;
import org.flywaydb.core.api.MigrationState;

public class MigrationUtil {

  private static final String V32_SCRIPT_NAME = "V32__add_convenience_functions.sql";
  private static final String INITIAL_BASELINE_VERSION = "5";
  public static final String MIGRATION_LOCATION = "classpath:de/mig/mdr/db/migration";

  /**
   * Apply all necessary database migrations via flyway.
   * When an old samply.mdr database with v32 applied is available, migration is possible as well.
   * In this case, flyway history table will be deleted and the baseline will be set to V5.
   */
  public static void migrateDatabase() {
    boolean baselineOnMigrate = false;
    String baselineDescription = "<< Flyway Baseline >>"; // Default flyway baseline description

    // Check if it is a samply.mdr database with Script V32 applied successfully.
    if (isSamplyDbV32()) {
      purgeFlywayHistoryTable();
      baselineOnMigrate = true;
      baselineDescription = "Samply.MDR DB V32 found and migrated. History purged.";
    }

    Flyway flyway =
        Flyway.configure()
            .baselineVersion(INITIAL_BASELINE_VERSION)
            .baselineOnMigrate(baselineOnMigrate)
            .baselineDescription(baselineDescription)
            .locations(MIGRATION_LOCATION)
            .dataSource(ResourceManager.getUrl(),
                ResourceManager.getUser(),
                ResourceManager.getPassword())
            .load();
    flyway.migrate();
  }

  /**
   * Check if the current database is Samply.MDR V32 In this case, a migration path is available.
   */
  private static boolean isSamplyDbV32() {
    Flyway flyway = Flyway.configure()
        .locations(MIGRATION_LOCATION)
        .dataSource(ResourceManager.getUrl(),
            ResourceManager.getUser(),
            ResourceManager.getPassword())
        .load();

    MigrationInfo migrationInfo = flyway.info().current();

    if (migrationInfo == null) {
      return false;
    } else {
      return (migrationInfo.getScript().equalsIgnoreCase(V32_SCRIPT_NAME) && (
          migrationInfo.getState()
              .equals(MigrationState.SUCCESS) || migrationInfo.getState()
              .equals(MigrationState.FUTURE_SUCCESS)));
    }
  }

  /**
   * Delete the flyway history table.
   * Use with utmost care.
   */
  private static void purgeFlywayHistoryTable() {
    try {
      ResourceManager.getConnection().createStatement()
          .execute("DROP TABLE flyway_schema_history;");
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
}
