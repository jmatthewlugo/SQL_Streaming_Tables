SQL Streaming Reference Tables

This is a small grouping of scripts used to update company visualizations using SQL temporary tables.
Below is a quick look at what each of the files does.

- Populate Agg Tables is for creating stored tables in the database

- Temp_Table_Agg uses a temporary table to populate the visualations our
the company uses in Power BI.

- Temp_Track_Reference looks at the DSP tables in our streaming database
and creates a temporary table to bring in track level information to the
visualizations using aggregates from Temp_Table_agg in Power BI.