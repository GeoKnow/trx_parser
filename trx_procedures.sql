
CREATE PROCEDURE elds_read_trx (
	IN 	file 	ANY	, 
	IN 	inpos 	INTEGER := 0
) 
{   
	DECLARE fhandle, operation, g, s, p, o ANY;
	DECLARE pos int;
	result_names (operation, g, s, p, o);
	fhandle := file_open (file, inpos);
	DECLARE line, lines ANY;
	WHILE ((lines := read_log (fhandle, pos)) is not null)
    {
		DECLARE quad, quad_key ANY;
		DECLARE i int;
		quad := null;
		quad_key := null;
		FOR (i := 1; i < length (lines); i := i + 1)
		{
			line := lines[i];
			IF (line[0] = 13) -- key insert
			{
				quad := line[2];
				operation := 'I';
			}
			ELSE IF (line[0] in (1,8,9)) -- insert,soft,replacing
			{
				quad := line[1];
				operation := 'I';
			}
			ELSE IF (line[0] in (3,14)) -- delete
			{
				quad := line[1];
				operation := 'D';
			}
			IF (quad is not null)
			{
				quad_key := quad[0];
				IF (quad_key = 273) -- RDF_QUAD, should check with SYS_KEYS
				{
					result (operation, __ro2sq (quad[1]), __ro2sq (quad[2]), __ro2sq (quad[3]), __ro2sq (quad[4]));
				}
			}
		}
    } 
  result (pos + inpos, '', '', '', '');
}
;

