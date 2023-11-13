--
CREATE STORAGE INTEGRATION IF NOT EXISTS aws_integration 
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::***:role/***'
--Removed AWS role details for security reasons
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakebucketfordata') ;

  DESC INTEGRATION aws_integration;

  USE DATABASE SNOWFLAKE_BRONZE;
-- Create a stage
CREATE STAGE s3_stage
URL = 's3://snowflakebucketfordata'
STORAGE_INTEGRATION = aws_integration;

-- Copy data from the S3 stage to the Bronze Snowflake table
COPY INTO SNOWFLAKE_BRONZE.SAS.BRONZE
FROM @s3_stage
FILES=('MOCK_DATA.json')
FILE_FORMAT=(TYPE = 'JSON', STRIP_OUTER_ARRAY = true)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

SELECT * FROM SNOWFLAKE_BRONZE.SAS.BRONZE;