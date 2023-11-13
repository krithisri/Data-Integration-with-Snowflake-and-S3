# Data Integration with Snowflake and S3
![Overall Architecture](./Project%20Diagrams/Project%20Architecture.png)
# Project Overview
This project unfolds a streamlined data integration pipeline that harmonizes the capabilities of Snowflake and AWS S3. From the generation of synthetic data with Mockaroo to the orchestrated transfer to an S3 bucket, the project prioritizes efficiency and scalability. Embracing Snowflake, it lays a structured foundation enriched by real-time streams and automated tasks, ensuring precise and timely data updates. Positioned as a modern, cloud-native solution, this project caters to businesses seeking reliable and scalable data management practices, with the flexibility to embrace future enhancements.

## Objective
The primary objective of this project is to showcase a robust and contemporary data integration pipeline. Through the generation of data, processing using puthon and storage in an S3 bucket, and the utilization of Snowflake's capabilities, the project aims to exemplify efficient data movement and transformation processes. By doing so, it provides valuable insights into modern data engineering practices, emphasizing their relevance in addressing the evolving demands of data management.

## Why This Matters

- **Efficiency and Agility:**
  - The project emphasizes the efficiency and agility in handling data, crucial for dynamic business environments.
- **Scalability:**
  - Scalable storage and seamless integration ensure the system can accommodate the growing volume of data.
- **Real-time Responsiveness:**
  - The real-time stream and automated tasks enable the system to respond rapidly to changes, maintaining data accuracy.


## Prerequisites
Before running the project, ensure the following prerequisites are met:

- AWS account with S3 bucket access
- Snowflake account with necessary privileges
- Any Editor (Preferably Python editor) to generate and load the data into an s3 bucket

## Data Generation and Storage
For this project, data is generated using [Mockaroo](https://www.mockaroo.com/). Later python is used to store and process the data into an AWS S3 bucket named 'snowflakebucketfordata.'

## Snowflake Setup

### Worksheets 1
**Worksheet 1: Database and Schema creation for Bronze and Silver.**
- `CREATE DATABASE` and `USE DATABASE` commands establish Bronze and Silver databases.
- `CREATE TABLE` commands define structures for Bronze and Silver tables.

### Worksheets 2
**Worksheet 2: S3 to Snowflake Data Integration.**
![S3 to Snowflake Integration](./Project%20Diagrams/S3%20to%20Snowflake%20Integration/S3%20to%20Snowflake%20Integration.png)

- `CREATE STORAGE INTEGRATION` links Snowflake to AWS S3.
- `CREATE STAGE` establishes a connection to the S3 stage.
- `COPY INTO` command transfers data from S3 to the Bronze table.

### Worksheets 3
![Snowflake Pipeline](./Project%20Diagrams/Snowflake%20Schema.png)

**Worksheet 3: Stream creation.**
- `CREATE STREAM` sets up a stream named SAMPLE_STREAM on the Bronze table for real-time change tracking.

### Worksheets 4
**Worksheet 4: Task creation for automated data migration.**
- `CREATE OR REPLACE TASK` named MIGRATE_TO_SILVER automates merging data from the stream into the Silver table.

### Snowpipe Integration (Optional)
Snowpipe could be utilized for automatic data ingestion if not for the free version.

## Dynamic View on Data
A JavaScript procedure, `create_view`, dynamically creates a view on JSON data. An automated task schedules the view creation.

## Conclusion
The project successfully demonstrates a robust data integration pipeline with Snowflake and S3. Future work may include further analysis and machine learning model integration.

## References
- [Mockaroo](https://www.mockaroo.com/)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [AWS S3 Documentation](https://aws.amazon.com/s3/)

## Contributors
- Srikrithi Chamarthi
  - Data Engineer 
