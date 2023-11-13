-- Drop existing databases.
DROP DATABASE SNOWFLAKE_PROJECT;
DROP DATABASE SNOWFLAKE_BRONZE;
DROP DATABASE SNOWFLAKE_SILVER;

-- Create the BRONZE database and switch to it.
CREATE DATABASE SNOWFLAKE_BRONZE;
USE DATABASE SNOWFLAKE_BRONZE;

-- Create the SAS schema and a BRONZE table with specified columns.
CREATE SCHEMA SAS;
USE SCHEMA SAS;
CREATE OR REPLACE TABLE BRONZE(ID INTEGER, DATE TIMESTAMP, JSON_DATA VARCHAR);
-- Select all records from the BRONZE table.
SELECT * FROM BRONZE;

-- Create the SILVER database and switch to it.
CREATE DATABASE SNOWFLAKE_SILVER;
USE DATABASE SNOWFLAKE_SILVER;

-- Create the SAS schema and a SILVER table with specified columns.
CREATE SCHEMA SAS;
USE SCHEMA SAS;
CREATE OR REPLACE TABLE SILVER(ID INTEGER, DATE TIMESTAMP, JSON_DATA VARCHAR);
-- Select all records from the SILVER table.
SELECT * FROM SILVER;
-- Uncomment the following lines to show tables and warehouses.
-- SHOW TABLES;
-- SHOW WAREHOUSES;

-- Create a warehouse for data processing.
CREATE WAREHOUSE IF NOT EXISTS SAMPLE_WH WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 1200;