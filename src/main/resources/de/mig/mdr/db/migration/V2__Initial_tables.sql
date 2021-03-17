CREATE TABLE config
(
    id     SERIAL PRIMARY KEY,
    "name" text NOT NULL UNIQUE,
    value  json NOT NULL
);

CREATE TABLE "import"
(
    id           SERIAL PRIMARY KEY,
    created_at   timestamp NOT NULL DEFAULT current_timestamp,
    created_by   INTEGER   NOT NULL,
    namespace_id INTEGER   NOT NULL,
    "source"     text,
    "label"      text,
    uuid         uuid,
    converted_at timestamp
);

CREATE TABLE mdr_user
(
    id         SERIAL PRIMARY KEY,
    auth_id    text NOT NULL UNIQUE,
    first_name text,
    last_name  text,
    user_name  text NOT NULL,
    email      text NOT NULL
);

CREATE TABLE "source"
(
    id       serial PRIMARY KEY,
    "name"   text NOT NULL UNIQUE,
    prefix   text NOT NULL UNIQUE,
    base_url text NOT NULL UNIQUE
);

CREATE TABLE concepts
(
    id         SERIAL PRIMARY KEY,
    "system"   text      NOT NULL,
    "version"  text      NOT NULL,
    term       text,
    "text"     text,
    source_id  INTEGER   NOT NULL,
    created_by INTEGER,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    CONSTRAINT concepts_source_id_system_version_term_text_key UNIQUE (source_id, system, version, term, text),
    CONSTRAINT source_id_fkey FOREIGN KEY (source_id) REFERENCES source (id) ON DELETE CASCADE
);

CREATE TABLE user_source_credentials
(
    user_id    INTEGER NOT NULL,
    credential text    NOT NULL,
    source_id  INTEGER NOT NULL,
    CONSTRAINT credentials_unique UNIQUE (user_id, credential, source_id),
    CONSTRAINT user_source_credentials_pkey PRIMARY KEY (user_id, source_id),
    CONSTRAINT source_id_fkey FOREIGN KEY (source_id) REFERENCES source (id) ON DELETE CASCADE,
    CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES mdr_user (id) ON DELETE CASCADE
);

CREATE TABLE concept_element_associations
(
    concept_id          INTEGER       NOT NULL,
    scopedidentifier_id INTEGER       NOT NULL,
    linktype            relation_type NULL,
    created_by          INTEGER       NOT NULL,
    created_at          timestamp     NOT NULL DEFAULT current_timestamp,
    CONSTRAINT concept_element_associations_pkey PRIMARY KEY (concept_id, scopedidentifier_id)
);

CREATE TABLE definition
(
    id                   serial PRIMARY KEY,
    scoped_identifier_id INTEGER,
    designation          text    NOT NULL,
    definition           text,
    "language"           text    NOT NULL,
    element_id           INTEGER NOT NULL
);
CREATE INDEX definition_element_id_idx ON public.definition USING btree (element_id);
CREATE INDEX definition_scoped_identifier_id_idx ON public.definition USING btree (scoped_identifier_id);

CREATE TABLE "element"
(
    id                   serial       NOT NULL,
    "element_type"       element_type NOT NULL,
    hidden               bool,
    created_by           INTEGER,
    element_id           INTEGER,
    scoped_identifier_id INTEGER,
    code                 text,
    is_valid             bool,
    format               text,
    "datatype"           text,
    unit_of_measure      text,
    maximum_characters   INTEGER,
    description          text,
    "validation_type"    validation_type,
    validation_data      text,
    permitted_value      text,
    "data"               json DEFAULT '{}'::json,
    uuid                 uuid         NOT NULL,
    external_id          text,
    CONSTRAINT catalog_check CHECK (((element_type <> 'CATALOG_VALUE_DOMAIN'::element_type) OR
                                     ((format IS NOT NULL) AND (datatype IS NOT NULL) AND
                                      (maximum_characters IS NOT NULL) AND
                                      (scoped_identifier_id IS NOT NULL)))),
    CONSTRAINT code_check CHECK (((element_type <> 'CODE'::element_type) OR
                                  ((code IS NOT NULL) AND (is_valid IS NOT NULL) AND
                                   (element_id IS NOT NULL)))),
    CONSTRAINT de_check CHECK (((element_type <> 'DATAELEMENT'::element_type) OR
                                (element_id IS NOT NULL))),
    CONSTRAINT desc_check CHECK (((element_type <> 'DESCRIBED_VALUE_DOMAIN'::element_type) OR
                                  ((format IS NOT NULL) AND (datatype IS NOT NULL) AND
                                   (maximum_characters IS NOT NULL) AND
                                   (validation_type IS NOT NULL)))),
    CONSTRAINT element_pkey PRIMARY KEY (id),
    CONSTRAINT enu_check CHECK (((element_type <> 'ENUMERATED_VALUE_DOMAIN'::element_type) OR
                                 ((format IS NOT NULL) AND (datatype IS NOT NULL) AND
                                  (maximum_characters IS NOT NULL)))),
    CONSTRAINT pv_check CHECK (((element_type <> 'PERMISSIBLE_VALUE'::element_type) OR
                                ((permitted_value IS NOT NULL) AND (element_id IS NOT NULL))))
);
CREATE INDEX element_created_by_idx ON public.element USING btree (created_by);
CREATE INDEX element_element_id_idx ON public.element USING btree (element_id);
CREATE INDEX element_element_type_idx ON public.element USING btree (element_type);
CREATE INDEX element_id_element_type_idx ON public.element USING btree (id, element_type);

CREATE TABLE permissible_code
(
    code_scoped_identifier_id INTEGER NOT NULL,
    catalog_value_domain_id   INTEGER NOT NULL
);
CREATE INDEX permissible_code_catalog_id_idx ON public.permissible_code USING btree (catalog_value_domain_id);
CREATE INDEX permissible_code_code_scoped_identifier_id_idx ON public.permissible_code USING btree (code_scoped_identifier_id);

CREATE TABLE scoped_identifier
(
    id             SERIAL PRIMARY KEY,
    "element_type" element_type NOT NULL,
    "version"      int4         NOT NULL,
    identifier     int4         NOT NULL,
    url            text         NOT NULL,
    created_by     int4         NOT NULL,
    "status"       status       NOT NULL,
    element_id     int4         NOT NULL,
    namespace_id   int4         NOT NULL,
    uuid           uuid         NOT NULL,
    CONSTRAINT unique_element_type_identifier UNIQUE (element_type, identifier, version, namespace_id)
);
CREATE INDEX ON "scoped_identifier" ("namespace_id");
CREATE INDEX ON "scoped_identifier" ("element_id");
CREATE INDEX ON "scoped_identifier" ("created_by");
CREATE INDEX ON "scoped_identifier" ("version");
CREATE INDEX ON "scoped_identifier" ("identifier");
CREATE INDEX ON "scoped_identifier" ("uuid");
CREATE INDEX ON "scoped_identifier" ("status");


CREATE TABLE scoped_identifier_hierarchy
(
    super_id INTEGER NOT NULL,
    sub_id   INTEGER NOT NULL,
    "order"  INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT scoped_identifier_hierarchy_pkey PRIMARY KEY (super_id, sub_id)
);
CREATE INDEX scoped_identifier_hierarchy_sub_id_idx ON public.scoped_identifier_hierarchy USING btree (sub_id);
CREATE INDEX scoped_identifier_hierarchy_super_id_idx ON public.scoped_identifier_hierarchy USING btree (super_id);


CREATE TABLE scoped_identifier_relation
(
    left_identifier_id  INTEGER       NOT NULL,
    right_identifier_id INTEGER       NOT NULL,
    relation            relation_type NOT NULL,
    created_by          INTEGER       NOT NULL,
    created_at          timestamp     NOT NULL DEFAULT current_timestamp,
    CONSTRAINT scoped_identifier_relation_pkey PRIMARY KEY (left_identifier_id, right_identifier_id)
);

CREATE TABLE slot
(
    id                   serial PRIMARY KEY,
    scoped_identifier_id INTEGER NOT NULL,
    "key"                text    NOT NULL,
    value                text    NOT NULL
);
CREATE INDEX slot_scoped_identifier_id_idx ON public.slot USING btree (scoped_identifier_id);

CREATE TABLE staging
(
    id             SERIAL PRIMARY KEY,
    "data"         text    NOT NULL,
    "element_type" element_type,
    designation    text,
    parent_id      INTEGER,
    import_id      INTEGER NOT NULL,
    element_id     INTEGER
);

CREATE TABLE user_namespace_grants
(
    user_id      INTEGER    NOT NULL,
    namespace_id INTEGER    NOT NULL,
    "grant_type" grant_type NULL,
    CONSTRAINT user_namespace_grants_unique UNIQUE (user_id, namespace_id, grant_type)
);
CREATE INDEX user_namespace_grants_namespace_id_idx ON public.user_namespace_grants USING btree (namespace_id);
CREATE INDEX user_namespace_grants_user_id_idx ON public.user_namespace_grants USING btree (user_id);


ALTER TABLE concept_element_associations
    ADD CONSTRAINT concept_id_fkey FOREIGN KEY (concept_id) REFERENCES concepts (id) ON DELETE CASCADE;
ALTER TABLE concept_element_associations
    ADD CONSTRAINT scopedidentifier_id_fkey FOREIGN KEY (scopedidentifier_id) REFERENCES scoped_identifier (id) ON DELETE CASCADE;


ALTER TABLE definition
    ADD CONSTRAINT definition_element_id_fkey FOREIGN KEY (element_id) REFERENCES element (id) ON DELETE CASCADE;
ALTER TABLE definition
    ADD CONSTRAINT definition_scopedidentifier_id_fkey FOREIGN KEY (scoped_identifier_id) REFERENCES scoped_identifier (id) ON DELETE CASCADE;

ALTER TABLE "element"
    ADD CONSTRAINT element_created_by_fkey FOREIGN KEY (created_by) REFERENCES mdr_user (id);
ALTER TABLE "element"
    ADD CONSTRAINT element_element_id_fkey FOREIGN KEY (element_id) REFERENCES element (id);
ALTER TABLE "element"
    ADD CONSTRAINT element_scoped_identifier_id_fkey FOREIGN KEY (scoped_identifier_id) REFERENCES scoped_identifier (id);

ALTER TABLE permissible_code
    ADD CONSTRAINT permissible_code_catalog_id_fkey FOREIGN KEY (catalog_value_domain_id) REFERENCES element (id) ON DELETE CASCADE;
ALTER TABLE permissible_code
    ADD CONSTRAINT permissible_code_code_scoped_identifier_id_fkey FOREIGN KEY (code_scoped_identifier_id) REFERENCES scoped_identifier (id);

ALTER TABLE scoped_identifier
    ADD CONSTRAINT scoped_identifier_created_by_fkey FOREIGN KEY (created_by) REFERENCES mdr_user (id);
ALTER TABLE scoped_identifier
    ADD CONSTRAINT scoped_identifier_element_id_fkey FOREIGN KEY (element_id) REFERENCES element (id);
ALTER TABLE scoped_identifier
    ADD CONSTRAINT scoped_identifier_namespace_id2_fkey FOREIGN KEY (namespace_id) REFERENCES element (id);

ALTER TABLE scoped_identifier_hierarchy
    ADD CONSTRAINT scoped_identifier_hierarchy_sub_id_fkey FOREIGN KEY (sub_id) REFERENCES scoped_identifier (id) ON DELETE CASCADE;
ALTER TABLE scoped_identifier_hierarchy
    ADD CONSTRAINT scoped_identifier_hierarchy_super_id_fkey FOREIGN KEY (super_id) REFERENCES scoped_identifier (id) ON DELETE CASCADE;

ALTER TABLE scoped_identifier_relation
    ADD CONSTRAINT scoped_identifier_relation_created_by_fkey FOREIGN KEY (created_by) REFERENCES mdr_user (id) ON DELETE CASCADE;
ALTER TABLE scoped_identifier_relation
    ADD CONSTRAINT scoped_identifier_relation_left_identifier_id_fkey FOREIGN KEY (left_identifier_id) REFERENCES scoped_identifier (id) ON DELETE CASCADE;
ALTER TABLE scoped_identifier_relation
    ADD CONSTRAINT scoped_identifier_relation_right_identifier_id_fkey FOREIGN KEY (right_identifier_id) REFERENCES scoped_identifier (id) ON DELETE CASCADE;

ALTER TABLE slot
    ADD CONSTRAINT slot_scoped_identifier_id_fkey FOREIGN KEY (scoped_identifier_id) REFERENCES scoped_identifier (id) ON DELETE CASCADE;

ALTER TABLE staging
    ADD CONSTRAINT staging_element_fkey FOREIGN KEY (element_id) REFERENCES element (id) ON DELETE CASCADE;
ALTER TABLE staging
    ADD CONSTRAINT staging_import_fkey FOREIGN KEY (import_id) REFERENCES import (id) ON DELETE CASCADE;
ALTER TABLE staging
    ADD CONSTRAINT staging_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES staging (id) ON DELETE CASCADE;

ALTER TABLE user_namespace_grants
    ADD CONSTRAINT user_namespace_grants_namespace_fkey FOREIGN KEY (namespace_id) REFERENCES element (id) ON DELETE CASCADE;
ALTER TABLE user_namespace_grants
    ADD CONSTRAINT user_namespace_grants_user_fkey FOREIGN KEY (user_id) REFERENCES mdr_user (id) ON DELETE CASCADE;