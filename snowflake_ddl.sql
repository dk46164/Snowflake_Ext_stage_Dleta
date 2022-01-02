
---**********PLEASE USE ACCOUNTADMIN/SYSADMIN PRIVELAGE ROLE TO CREATE OBECTS*********************-------------------------
-----useful links for any reference---
--https://interworks.com/blog/hcalder/2020/01/23/snowpipe-101/
--https://docs.snowflake.com/en/user-guide/tables-external-s3.html
--https://www.youtube.com/watch?v=w9BQsOlJc5s


---CREATE WAREHOUSE
CREATE OR REPLACE WAREHOUSE LOAD_WH WAREHOUSE_SIZE='X-SMALL' 
INITIALLY_SUSPENDED=FALSE
AUTO_SUSPEND = 300;

---CREATE S3 INTEGRATION OBJECTS
CREATE  OR REPLACE STORAGE INTEGRATION S3_INTEGARTION   
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'ARN:AWS:IAM::{AWS_S3_ARN}'
  STORAGE_ALLOWED_LOCATIONS = ('S3://{S3_BUCKET_NAME}');
  
---CREATE FILE FORMAT 
CREATE OR REPLACE FILE FORMAT STAGE_FORMAT
  RECORD_DELIMITER = '\N'
  FIELD_DELIMITER = NONE
  SKIP_HEADER =1
 ENCODING = 'UTF-8';

----EXT  STAGE
CREATE  OR REPLACE STAGE DV_STAGE
  URL='S3://{S3_BUCKET_NAME}'
  STORAGE_INTEGRATION =S3_INTEGARTION
  DIRECTORY = (
    ENABLE = TRUE
    AUTO_REFRESH = TRUE
  );

// ______________________________
//|either use snowpipe/external table for ELT task_______________________________|
//

*******--SNOWPIPE OBJECTS
CREATE OR REPLACE  PIPE MYPIPE_S3
  AUTO_INGEST = TRUE
  AS
  COPY INTO DV_STAGE_TABLE
  FROM @DV_STAGE
  PATTERN='.*.CSV'
  FILE_FORMAT = STAGE_FORMAT;
  
-- CREATE AN EXTERNAL TABLE THAT POINTS TO THE MY_EXT_STAGE STAGE.
----Detailed Explanation
---load_date to track latest record
--data_source to chekc for source of origin
--reocrd_column will be populated on the  basis of file format obejct.
--Reocrd_hash will coantin md5 digest of entire record column,when new file is added or duplicates file is ingested
--again ,then in final merge statement  reocrds will be updated with latest records
---This  external table can works as datalake,since it conatain all records with hisotry preserved  
CREATE OR REPLACE  EXTERNAL TABLE DATA_SATGING_S3_EXT_TABLE (
  LOAD_DATE DATE AS (CURRENT_DATE()),
  DATA_SOURCE VARCHAR AS (METADATA$FILENAME::VARCHAR),
  RECORD_COLUMN VARCHAR AS (VALUE:C1::VARCHAR),
  REOCRD_HASH VARCHAR AS MD5((VALUE:C1::VARCHAR))
) 
  LOCATION=@DV_STAGE
  AUTO_REFRESH = TRUE
  FILE_FORMAT=STAGE_FORMAT;

--CREATE STREAM ON EXT TABLE
CREATE  OR REPLACE STREAM DATA_SATGING_S3_EXT_STREAM ON EXTERNAL TABLE DATA_SATGING_S3_EXT_TABLE INSERT_ONLY = TRUE;


---STAGING TABLE
CREATE  OR REPLACE TABLE DV_STAG_TABLE (
ID VARCHAR,
 YEAR VARCHAR,
  NAME VARCHAR,
  REOCRD_SOURCE VARCHAR,
  REOCRD_HASH VARCHAR
);





