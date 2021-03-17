CREATE MATERIALIZED VIEW "hierarchy" AS
(
WITH RECURSIVE members(root, super, sub) AS
                   (SELECT "super_id", "super_id", "sub_id"
                    FROM "scoped_identifier_hierarchy"
                    UNION ALL
                    SELECT m."root", sc."super_id", sc."sub_id"
                    FROM members AS m
                             INNER JOIN "scoped_identifier_hierarchy" AS sc
                                        ON m."sub" = sc."super_id")
SELECT m.root, m.super, m.sub
FROM members AS m);

CREATE INDEX ON "hierarchy" ("super", "sub");
CREATE INDEX ON "hierarchy" ("sub");
CREATE INDEX ON "hierarchy" ("super");
CREATE INDEX ON "hierarchy" ("root");

CREATE OR REPLACE VIEW identified_element AS
SELECT si.id           as si_id,
       si.identifier   as si_identifier,
       si.version      as si_version,
       si.status       as si_status,
       si.namespace_id as si_namespace_id,
       e.*
FROM scoped_identifier si
         LEFT JOIN element ns
                   ON si.namespace_id = ns.id
         LEFT JOIN ELEMENT e
                   ON e.id = si.element_id;