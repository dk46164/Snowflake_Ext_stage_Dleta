

---REFRESH EXT TABLE FOR NEW FILE
ALTER EXTERNAL TABLE DATA_SATGING_S3_EXT_TABLE REFRESH;
---MERGE FOR DELTA RECORDS
merge into dv_stag_table dv using(
select split_part(Record_column,',',1) as id,
 split_part(Record_column,',',2) as  year,
  split_part(Record_column,',',3) as name,
  DATA_SOURCE AS RECORD_SOURCE
  Reocrd_Hash
 from data_satging_s3_ext_stream
where METADATA$ACTION = 'INSERT')   delta_stream
ON dv.Reocrd_Hash=delta_stream.Reocrd_Hash
when matched  then
 update set dv.id = delta_stream.id,
        dv.year = delta_stream.year,
        dv.name = delta_stream.name,
        dv.RECORD_SOURCE = delta_stream.RECORD_SOURCE
when not matched then
insert  values( delta_stream.id,delta_stream.year,delta_stream.name,delta_stream.Reocrd_Hash,delta_stream.RECORD_SOURCE);


