--This is a general query to create a snowpipe and auto ingest the data. This cannot be implemented in free version.
-- Create a new stage named my_new_stage.
CREATE STAGE my_new_stage
URL = 's3://snowflakebucketfordata'
STORAGE_INTEGRATION = aws_integration;

-- Create a Snowpipe pipe named my_pipe (using a task instead for the free version).
CREATE PIPE my_pipe
AUTO_INGEST = TRUE 
AS
COPY INTO BRONZE FROM @my_new_stage FILE_FORMAT = (TYPE ='JSON', STRIP_OUTER_ARRAY = true);

-- Uncomment the following line to drop the my_pipe pipe.
-- DROP PIPE my_pipe;
-- Uncomment the following lines to show pipes and check the status of my_pipe.
-- SHOW PIPES;
-- SELECT SYSTEM$PIPE_STATUS('my_pipe');
