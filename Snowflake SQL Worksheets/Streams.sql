-- Switch back to the BRONZE database.
USE DATABASE SNOWFLAKE_BRONZE;

-- Create a stream named SAMPLE_STREAM on the BRONZE table.
CREATE OR REPLACE STREAM SAMPLE_STREAM ON TABLE SAS.BRONZE;
-- Uncomment the following line to show streams.
-- SHOW STREAMS;
-- Select all records from the SAMPLE_STREAM stream.
SELECT * FROM SAMPLE_STREAM;
