# Project Title

This script will create a delta Lake on top of s3. 

## Description

A simpler approach to directly query data on s3 file in snowflake.
feature that has been used to implement delta lake
 * External Tables
 * External Stages
 * Storage Integration
 * SnowPipe

## Getting Started

* Need to have Snowflake ,AWS account it can be a free tier one.
* Basic  understanding of SQL


### Executing program
First run the DDL query  from repo.

Then run in same db in which all ddl has been executed

```
show pipes;
```
 Noted te AWS sqs id, Then configure s3 with this sqs arn.
 For more setup guide.please refer to this  guide.
 * https://interworks.com/blog/hcalder/2020/01/23/snowpipe-101/
 
## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```


## Version History
* 0.1
    * Initial Release

## Acknowledgments
-----useful links for any reference---
* https://interworks.com/blog/hcalder/2020/01/23/snowpipe-101/
* https://docs.snowflake.com/en/user-guide/tables-external-s3.html
* https://www.youtube.com/watch?v=w9BQsOlJc5s
