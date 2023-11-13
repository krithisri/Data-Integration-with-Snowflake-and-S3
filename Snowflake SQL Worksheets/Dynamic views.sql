-- Create a JavaScript procedure named create_view_over_json3.
create or replace procedure create_view_over_json3(TABLE_NAME varchar, COL_NAME varchar, VIEW_NAME varchar) returns varchar language javascript as $$
var path_name = `regexp_replace(regexp_replace(f.path,'\\[(.+)\\]'),'(\\w+)','"\\1"')`;
var attribute_type = "DECODE (substr(typeof(f.value),1,1),'A','ARRAY','B','BOOLEAN','I','FLOAT','D','FLOAT','STRING')";
var alias_name = "REGEXP_REPLACE(REGEXP_REPLACE(f.path, '\\\\[(.+)\\\\]'),'[^a-zA-Z0-9]','_')";
var col_list = "";
// Build a query that returns a list of elements which will be used to build the column list for the CREATE VIEW statement
var element_query = "SELECT DISTINCT \n" + path_name + " AS path_name, \n" + attribute_type + " AS attribute_type, \n" + alias_name + " AS alias_name \n" + "FROM \n" + TABLE_NAME + ", \n" + "LATERAL FLATTEN(" + COL_NAME + ", RECURSIVE=>true) f \n" + "WHERE TYPEOF(f.value) != 'OBJECT' \n";
// Run the query...
var element_stmt = snowflake.createStatement({sqlText:element_query});
var element_res = element_stmt.execute();
// ...And loop through the list that was returned
while (element_res.next()) {
  if (col_list != "") {
    col_list += ", \n";
  }
  // Start with the element path name
  col_list += COL_NAME + ":" + element_res.getColumnValue(1);
  // Add the datatype
  col_list += "::" + element_res.getColumnValue(2);
  // And finally the element alias
  col_list += " as " + element_res.getColumnValue(3);
}
// Now build the CREATE VIEW statement
var view_ddl = "CREATE OR REPLACE VIEW " + VIEW_NAME + " AS \n" + "SELECT \n" + col_list + "\n" + "FROM " + TABLE_NAME;
// Now run the CREATE VIEW statement
var view_stmt = snowflake.createStatement({sqlText:view_ddl});
var view_res = view_stmt.execute();
return view_res.next();
$$;
-- Call the create_view_over_json3 procedure.
call create_view_over_json3('SNOWFLAKE_SILVER.SAS.SILVER', 'json_data', 'SNOWFLAKE_SILVER.SAS.JSON_VIEW');
-- End the JavaScript procedure.

-- Create or replace a task named AUTOMATE_VIEW to run the create_view_over_json3 procedure.
CREATE OR REPLACE TASK AUTOMATE_VIEW WAREHOUSE = SAMPLE_WH SCHEDULE = '1 minute' AS CALL create_view_over_json3('SNOWFLAKE_SILVER.SAS.SILVER', 'json_data', 'SNOWFLAKE_SILVER.SAS.JSON_VIEW');
-- Uncomment the following line to show tasks.
-- SHOW TASKS;
-- Resume the AUTOMATE_VIEW task.
ALTER TASK AUTOMATE_VIEW RESUME;

-- Select all records from the JSON_VIEW view.
SELECT * FROM JSON_VIEW;
