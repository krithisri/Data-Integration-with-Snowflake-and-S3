-- Create an external stage storage integration for AWS S3.
CREATE STORAGE INTEGRATION IF NOT EXISTS aws_integration 
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::NUMBER INSERT:role/ROLE NAME'
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakebucketfordata');

-- Describe the properties of the storage integration.
DESC INTEGRATION aws_integration;
-- Uncomment the following line if you want to drop the storage integration.
-- DROP INTEGRATION aws_integration;

-- Switch back to the BRONZE database.
USE DATABASE SNOWFLAKE_BRONZE;

-- Create a stage named s3_stage.
CREATE STAGE s3_stage
URL = 's3://snowflakebucketfordata'
STORAGE_INTEGRATION = aws_integration;

-- Copy data from the S3 stage to the BRONZE table.
COPY INTO SNOWFLAKE_BRONZE.SAS.BRONZE
FROM @s3_stage
FILES=('MOCK_DATA.json')
FILE_FORMAT=(TYPE = 'JSON', STRIP_OUTER_ARRAY = true)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Select all records from the BRONZE table.
SELECT * FROM SNOWFLAKE_BRONZE.SAS.BRONZE;
-- Select all records from the SAMPLE_STREAM stream.
SELECT * FROM SAMPLE_STREAM;
-- Select all records from the SILVER table.
SELECT * FROM SNOWFLAKE_SILVER.SAS.SILVER;
