# MIG MDR DAL

This iteration of MIG MDR DAL is based on the fundamental concepts of the [Samply.MDR](https://bitbucket.org/medicalinformatics/mig.samply.mdr.gui).
Based on the experience gained, the concept was revised and redeveloped, with particular emphasis on
the separation of the backend and frontend.

The MIG MDR Data Access Layer is a library that must be used to get elements from the MDR database.
It handles access rights accordingly to the database and user.


The layer distinguishes between:

- Elements (Dataelements, Dataelementgroup, Namespace, Record, Value Domain, etc.)
- Identified Elements (Scoped Identifier + Element + Definition/Designation + Slots)
- Described Elements (Namespaces + Definition/Designation)


## Build

Use maven to build the `jar` file:

```
mvn clean package
```


## Updating the Development Database

Run `mvn install` then `mvn flyway:migrate` to migrate your development database to the newest version.
Run `mvn jooq-codegen:generate` to generate JOOQ files for your database version.

```
CAUTION: This version of mdr.dal does only support upgrades from samply.mdr db version 32.
For any other database versions, please update to v32 first, and then use this library.
```