
# View:
-------
CREATE or REPLACE VIEW table_subscription AS
  SELECT table1.org_id, table1.ext_state, table1.ext_state_override,
  CASE
    WHEN table1.ext_state_override IS NOT NULL THEN table1.ext_state_override
    ELSE table1.ext_state
  END AS overridden_ext_state
  FROM table1
  INNER JOIN table2
  ON table1.org_id = table2.org_id


# Trigger 

CREATE OR REPLACE FUNCTION sub_trigger()
RETURNS trigger AS
$BODY$
BEGIN
IF (new.ext_state_override IS NOT NULL)
	THEN
	UPDATE my_user su
	SET ext_state = new.ext_state_override
	WHERE su.org_id = new.org_id;

ELSE
	UPDATE my_user su
	SET ext_state = new.ext_state
	WHERE su.org_id = new.org_id;

END IF;

RETURN new; 

END;
$BODY$
 LANGUAGE plpgsql VOLATILE
 COST 100;



CREATE TRIGGER sub_trigger
AFTER INSERT OR UPDATE
ON sf_org
FOR EACH ROW
EXECUTE PROCEDURE sub_trigger();


# Tables

CREATE TABLE table1
(
  id integer NOT NULL,
  org_id character varying,
  ext_state character varying,
  ext_state_override character varying,
  CONSTRAINT table1_pkey PRIMARY KEY (id)
)


CREATE TABLE table2
(
  org_id character varying,
  id integer NOT NULL,
  ext_state character varying
 
)




