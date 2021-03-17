CREATE TYPE element_type AS ENUM (
    'DATAELEMENTGROUP',
    'RECORD',
    'DATAELEMENT',
    'CATALOG',
    'CODE',
    'NAMESPACE',
    'ENUMERATED_VALUE_DOMAIN',
    'DESCRIBED_VALUE_DOMAIN',
    'CATALOG_VALUE_DOMAIN',
    'PERMISSIBLE_VALUE');

CREATE TYPE grant_type AS ENUM (
    'READ',
    'WRITE',
    'ADMIN');

CREATE TYPE relation_type AS ENUM (
    'undefined',
    'equal',
    'equivalent',
    'wider',
    'subsumes',
    'narrower',
    'specializes',
    'inexact');

CREATE TYPE status AS ENUM (
    'DRAFT',
    'RELEASED',
    'OUTDATED',
    'STAGED');

CREATE TYPE validation_type AS ENUM (
    'NONE',
    'BOOLEAN',
    'INTEGER',
    'FLOAT',
    'INTEGERRANGE',
    'FLOATRANGE',
    'DATE',
    'DATETIME',
    'TIME',
    'REGEX',
    'JS',
    'LUA',
    'TBD');
