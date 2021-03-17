CREATE OR REPLACE FUNCTION urn(sc "scoped_identifier") RETURNS TEXT AS
$$
BEGIN
    RETURN 'urn:' || (SELECT si_identifier FROM identified_element WHERE id = sc."namespace_id") ||
           ':' || lower(sc."element_type"::text) || ':' || sc."identifier" || ':' || sc."version";
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getelementtype(id integer) RETURNS "element_type" AS
$$
SELECT "element_type"
from "element"
WHERE "id" = $1
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION remove_unreferenced_elements() RETURNS trigger AS
$$
BEGIN
    WITH deleted AS (
        DELETE FROM element e
            WHERE e."element_type" in ('DATAELEMENT', 'DATAELEMENTGROUP', 'RECORD', 'NAMESPACE')
                AND e.id NOT IN (SELECT DISTINCT "element_id" FROM "scoped_identifier" si)
            RETURNING e."element_id"
    )
    DELETE
    FROM element
    WHERE id IN (SELECT "element_id" FROM deleted)
       OR "element_id" IN (SELECT "element_id" FROM deleted);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remove_unreferenced_elements
    AFTER DELETE
    ON "scoped_identifier"
EXECUTE PROCEDURE remove_unreferenced_elements();

CREATE OR REPLACE FUNCTION get_scoped_identifier_by_urn(urn text) RETURNS scoped_identifier AS
$$
SELECT *
FROM scoped_identifier si
WHERE si.element_type::text = UPPER(SPLIT_PART(urn, ':', 3))
  AND si.identifier::text = SPLIT_PART(urn, ':', 4)
  AND si.version::text = SPLIT_PART(urn, ':', 5)
  AND si.namespace_id IN (
    SELECT id
    from identified_element
    where element_type = 'NAMESPACE'
      and si_identifier::text = SPLIT_PART(urn, ':', 2)
)
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_namespace_scoped_identifier_by_urn(urn text) RETURNS scoped_identifier AS
$$
SELECT *
FROM scoped_identifier si
WHERE si.element_type::text = UPPER(SPLIT_PART(urn, ':', 3))
  AND si.identifier::text = SPLIT_PART(urn, ':', 4)
  AND si.version::text = SPLIT_PART(urn, ':', 5)
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_element_by_urn(urn text) RETURNS element AS
$$
SELECT *
FROM element e
WHERE e.id = (SELECT element_id
              from get_scoped_identifier_by_urn(urn)
)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_definition_by_urn(urn text) RETURNS SETOF definition AS
$$
SELECT *
FROM definition d
WHERE d.scoped_identifier_id = (SELECT id
                                from get_scoped_identifier_by_urn(urn)
)
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_slot_by_urn(urn text) RETURNS SETOF slot AS
$$
SELECT *
FROM slot s
WHERE s.scoped_identifier_id = (SELECT id
                                from get_scoped_identifier_by_urn(urn)
)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_value_domain_by_urn(urn text) RETURNS SETOF element AS
$$
SELECT *
FROM element e
WHERE e.id = (SELECT element_id from get_element_by_urn(urn))
   OR (
        e.element_type IN ('PERMISSIBLE_VALUE', 'CODE')
        AND
        e.element_id = (SELECT element_id from get_element_by_urn(urn))
    )
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getelementtype(id integer)
    RETURNS element_type
    LANGUAGE sql
AS
$function$
SELECT "element_type"
from "element"
WHERE "id" = $1
$function$
;

CREATE OR REPLACE FUNCTION remove_unreferenced_elements()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$function$
BEGIN
    WITH deleted AS (
        DELETE FROM element e
            WHERE e."element_type" in ('DATAELEMENT', 'DATAELEMENTGROUP', 'RECORD', 'NAMESPACE')
                AND e.id NOT IN (SELECT DISTINCT "element_id" FROM "scoped_identifier" si)
            RETURNING e."element_id"
    )
    DELETE
    FROM element
    WHERE id IN (SELECT "element_id" FROM deleted)
       OR "element_id" IN (SELECT "element_id" FROM deleted);

    RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION unique_identifier() RETURNS trigger AS
$body_start$
BEGIN
    IF lower(NEW.element_type::text) = 'namespace' THEN
        SELECT NEW.id,
               NEW.element_type,
               1,
               COALESCE(MAX(identifier) + 1, 1),
               'none'::text,
               NEW.created_by,
               NEW.status,
               NEW.element_id,
               NEW.namespace_id,
               NEW.uuid
        INTO NEW
        FROM "scoped_identifier"
        WHERE element_type = NEW.element_type;
        RETURN NEW;
    ELSE
        SELECT NEW.id,
               NEW.element_type,
               1,
               COALESCE(MAX(identifier) + 1, 1),
               'none'::text,
               NEW.created_by,
               NEW.status,
               NEW.element_id,
               NEW.namespace_id,
               NEW.uuid
        INTO NEW
        FROM "scoped_identifier"
        WHERE element_type = NEW.element_type
          AND namespace_id = NEW.namespace_id;
        RETURN NEW;
    END IF;
END;
$body_start$ LANGUAGE plpgsql;

CREATE TRIGGER unique_identifier_trigger
    BEFORE INSERT
    ON "scoped_identifier"
    FOR EACH ROW
    WHEN ( NEW.version < 1)
EXECUTE PROCEDURE unique_identifier();

CREATE OR REPLACE FUNCTION urn(sc scoped_identifier)
    RETURNS text
    LANGUAGE plpgsql
AS
$function$
BEGIN
    RETURN 'urn:' || (SELECT si_identifier FROM identified_element WHERE id = sc."namespace_id") ||
           ':' || lower(sc."element_type"::text) || ':' || sc."identifier" || ':' || sc."version";
END;
$function$
;

CREATE FUNCTION to_tsvector_multilang(text) RETURNS tsvector AS
$$
SELECT to_tsvector('german', $1) ||
       to_tsvector('english', $1) ||
       to_tsvector('simple', $1)
$$ LANGUAGE sql IMMUTABLE;

CREATE INDEX search_index_0 ON definition USING gin (to_tsvector_multilang(definition));
CREATE INDEX search_index_1 ON definition USING gin (to_tsvector_multilang(designation));
CREATE INDEX search_index_2 ON slot USING gin (to_tsvector_multilang(key));
CREATE INDEX search_index_3 ON slot USING gin (to_tsvector_multilang(value));
CREATE INDEX search_index_4 ON concepts USING gin (to_tsvector_multilang(system));
CREATE INDEX search_index_5 ON concepts USING gin (to_tsvector_multilang(term));
CREATE INDEX search_index_6 ON concepts USING gin (to_tsvector_multilang(text));