SET SEARCH_PATH=:schema;

do $$
DECLARE
   tbl varchar;
   tblcnt int;
   tblsize bigint;
BEGIN
   FOREACH tbl  IN ARRAY ARRAY['sources', 'entries', 'page_structure', 'geocoded_address_gazetteer', 'persons', 'activities', 'titles', 'addresses'] loop
      EXECUTE 'SELECT COUNT(*) FROM ' || quote_ident(tbl) INTO tblcnt;
	  
	  IF tbl IN ('entries', 'page_structure') THEN -- Partitioned tables
	  	EXECUTE 'select sum(pg_total_relation_size(relid)) from pg_partition_tree($1::regclass)'
		INTO tblsize
		USING tbl;
	  ELSEIF tbl IN ('persons', 'activities', 'titles', 'addresses') THEN -- Inheritance
	 	EXECUTE 'WITH RECURSIVE inheritance AS (
					SELECT 
						inhrelid::regclass AS table_name
					FROM 
						pg_inherits 
					WHERE 
						inhparent = $1::regclass
					UNION ALL
					SELECT 
						c.inhrelid::regclass
					FROM 
						pg_inherits c 
						JOIN inheritance p ON c.inhparent = p.table_name
				)
				SELECT 
					sum(pg_total_relation_size(inheritance.table_name)) AS total_size
				FROM 
					inheritance;'
		INTO tblsize
		USING tbl;
	  ELSE  -- Classic tables
	  	EXECUTE 'SELECT pg_total_relation_size($1)'
		INTO tblsize
		USING tbl;
      END IF;
	  
	  RAISE NOTICE '%: %, %s', tbl, tblcnt, pg_size_pretty(tblsize);
   end loop;
end; $$
