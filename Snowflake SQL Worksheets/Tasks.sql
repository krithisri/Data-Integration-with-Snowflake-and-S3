-- Switch to the SILVER database.
USE DATABASE SNOWFLAKE_SILVER;

-- Create a task named MIGRATE_TO_SILVER to automate data migration.
CREATE OR REPLACE TASK MIGRATE_TO_SILVER WAREHOUSE = SAMPLE_WH SCHEDULE = '1 minute' WHEN SYSTEM$STREAM_HAS_DATA('SAMPLE_STREAM') AS MERGE INTO SILVER AS T USING (SELECT * FROM SAMPLE_STREAM WHERE NOT (METADATA$ACTION = 'DELETE' AND METADATA$ISUPDATE = TRUE)) AS S ON T.ID = S.ID WHEN MATCHED AND S.METADATA$ACTION = 'INSERT' AND S.METADATA$ISUPDATE THEN UPDATE SET T.DATE = S.DATE, T.JSON_DATA = PARSE_JSON(S.JSON_DATA) WHEN NOT MATCHED AND S.METADATA$ACTION = 'INSERT' THEN INSERT (ID, DATE, JSON_DATA) VALUES (S.ID, S.DATE, PARSE_JSON(S.JSON_DATA));

-- Uncomment the following line to show tasks.
-- SHOW TASKS;
-- Resume the MIGRATE_TO_SILVER task.
ALTER TASK MIGRATE_TO_SILVER RESUME;
