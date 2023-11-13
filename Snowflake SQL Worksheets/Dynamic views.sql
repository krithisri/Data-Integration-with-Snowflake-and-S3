-- Create a JavaScript procedure named create_view.
CREATE OR REPLACE PROCEDURE create_view(TABLE_NAME_VAR varchar, COL_NAME_VAR varchar, VIEW_NAME_VAR varchar) RETURNS VARCHAR LANGUAGE JAVASCRIPT AS $$
var path_name_var = `regexp_replace(regexp_replace(f.path,'\\[(.+)\\]'),'(\\w+)','"\\1"')`;
var attribute_type_var = "DECODE (substr(typeof(f.value),1,1),'A','ARRAY','B','BOOLEAN','I','FLOAT','D','FLOAT','STRING')";
var alias_name_var = "REGEXP_REPLACE(REGEXP_REPLACE(f.path, '\\\\[(.+)\\\\]'),'[^a-zA-Z0-9]','_')";
var col_list_var = "";
// Build a query that returns a list of elements which will be used to build the column list for the CREATE VIEW statement
var element_query_var = "SELECT DISTINCT \n" + path_name_var + " AS path_name, \n" + attribute_type_var + " AS attribute_type, \n" + alias_name_var + " AS alias_name \n" + "FROM \n" + TABLE_NAME_VAR + ", \n" + "LATERAL FLATTEN(" + COL_NAME_VAR + ", RECURSIVE=>true) f \n" + "WHERE TYPEOF(f.value) != 'OBJECT' \n";
// Run the query...
var element_stmt_var = snowflake.createStatement({sqlText:element_query_var});
var element_res_var = element_stmt_var.execute();
// ...And loop through the list that was returned
while (element_res_var.next()) {
  if (col_list_var != "") {
    col_list_var += ", \n";
  }
  // Start with the element path name
  col_list_var += COL_NAME_VAR + ":" + element_res_var.getColumnValue(1);
  // Add the datatype
  col_list_var += "::" + element_res_var.getColumnValue(2);
  // And finally the element alias
  col_list_var += " as " + element_res_var.getColumnValue(3);
}
// Now build the CREATE VIEW statement
var view_ddl_var = "CREATE OR REPLACE VIEW " + VIEW_NAME_VAR + " AS \n" + "SELECT \n" + col_list_var + "\n" + "FROM " + TABLE_NAME_VAR;
// Now run the CREATE VIEW statement
var view_stmt_var = snowflake.createStatement({sqlText:view_ddl_var});
var view_res_var = view_stmt_var.execute();
return view_res_var.next();
$$;
-- Call the create_view procedure.
CALL create_view('SNOWFLAKE_SILVER.S3.SILVER', 'json_data', 'SNOWFLAKE_SILVER.S3.JSON_VIEW');
-- End the JavaScript procedure.

-- Create or replace a task named TASK_OF_VIEW to run the create_view procedure.
CREATE OR REPLACE TASK TASK_OF_VIEW WAREHOUSE = SAMPLE_WH SCHEDULE = '1 minute' AS CALL create_view('SNOWFLAKE_SILVER.S3.SILVER', 'json_data', 'SNOWFLAKE_SILVER.S3.JSON_VIEW');
-- Uncomment the following line to show tasks.
-- SHOW TASKS;
-- Resume the TASK_OF_VIEW task.
ALTER TASK TASK_OF_VIEW RESUME;

-- Select all records from the JSON_VIEW view.
SELECT * FROM JSON_VIEW;
