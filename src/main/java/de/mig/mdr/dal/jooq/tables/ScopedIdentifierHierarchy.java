/*
 * This file is generated by jOOQ.
 */
package de.mig.mdr.dal.jooq.tables;


import de.mig.mdr.dal.jooq.Indexes;
import de.mig.mdr.dal.jooq.Keys;
import de.mig.mdr.dal.jooq.Public;
import de.mig.mdr.dal.jooq.tables.records.ScopedIdentifierHierarchyRecord;

import java.util.Arrays;
import java.util.List;

import javax.annotation.processing.Generated;

import org.jooq.Field;
import org.jooq.ForeignKey;
import org.jooq.Index;
import org.jooq.Name;
import org.jooq.Record;
import org.jooq.Row3;
import org.jooq.Schema;
import org.jooq.Table;
import org.jooq.TableField;
import org.jooq.TableOptions;
import org.jooq.UniqueKey;
import org.jooq.impl.DSL;
import org.jooq.impl.TableImpl;


/**
 * This class is generated by jOOQ.
 */
@Generated(
    value = {
        "https://www.jooq.org",
        "jOOQ version:3.13.4"
    },
    comments = "This class is generated by jOOQ"
)
@SuppressWarnings({ "all", "unchecked", "rawtypes" })
public class ScopedIdentifierHierarchy extends TableImpl<ScopedIdentifierHierarchyRecord> {

    private static final long serialVersionUID = 1654022561;

    /**
     * The reference instance of <code>public.scoped_identifier_hierarchy</code>
     */
    public static final ScopedIdentifierHierarchy SCOPED_IDENTIFIER_HIERARCHY = new ScopedIdentifierHierarchy();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<ScopedIdentifierHierarchyRecord> getRecordType() {
        return ScopedIdentifierHierarchyRecord.class;
    }

    /**
     * The column <code>public.scoped_identifier_hierarchy.super_id</code>.
     */
    public final TableField<ScopedIdentifierHierarchyRecord, Integer> SUPER_ID = createField(DSL.name("super_id"), org.jooq.impl.SQLDataType.INTEGER.nullable(false), this, "");

    /**
     * The column <code>public.scoped_identifier_hierarchy.sub_id</code>.
     */
    public final TableField<ScopedIdentifierHierarchyRecord, Integer> SUB_ID = createField(DSL.name("sub_id"), org.jooq.impl.SQLDataType.INTEGER.nullable(false), this, "");

    /**
     * The column <code>public.scoped_identifier_hierarchy.order</code>.
     */
    public final TableField<ScopedIdentifierHierarchyRecord, Integer> ORDER = createField(DSL.name("order"), org.jooq.impl.SQLDataType.INTEGER.nullable(false).defaultValue(org.jooq.impl.DSL.field("1", org.jooq.impl.SQLDataType.INTEGER)), this, "");

    /**
     * Create a <code>public.scoped_identifier_hierarchy</code> table reference
     */
    public ScopedIdentifierHierarchy() {
        this(DSL.name("scoped_identifier_hierarchy"), null);
    }

    /**
     * Create an aliased <code>public.scoped_identifier_hierarchy</code> table reference
     */
    public ScopedIdentifierHierarchy(String alias) {
        this(DSL.name(alias), SCOPED_IDENTIFIER_HIERARCHY);
    }

    /**
     * Create an aliased <code>public.scoped_identifier_hierarchy</code> table reference
     */
    public ScopedIdentifierHierarchy(Name alias) {
        this(alias, SCOPED_IDENTIFIER_HIERARCHY);
    }

    private ScopedIdentifierHierarchy(Name alias, Table<ScopedIdentifierHierarchyRecord> aliased) {
        this(alias, aliased, null);
    }

    private ScopedIdentifierHierarchy(Name alias, Table<ScopedIdentifierHierarchyRecord> aliased, Field<?>[] parameters) {
        super(alias, null, aliased, parameters, DSL.comment(""), TableOptions.table());
    }

    public <O extends Record> ScopedIdentifierHierarchy(Table<O> child, ForeignKey<O, ScopedIdentifierHierarchyRecord> key) {
        super(child, key, SCOPED_IDENTIFIER_HIERARCHY);
    }

    @Override
    public Schema getSchema() {
        return Public.PUBLIC;
    }

    @Override
    public List<Index> getIndexes() {
        return Arrays.<Index>asList(Indexes.SCOPED_IDENTIFIER_HIERARCHY_SUB_ID_IDX, Indexes.SCOPED_IDENTIFIER_HIERARCHY_SUPER_ID_IDX);
    }

    @Override
    public UniqueKey<ScopedIdentifierHierarchyRecord> getPrimaryKey() {
        return Keys.SCOPED_IDENTIFIER_HIERARCHY_PKEY;
    }

    @Override
    public List<UniqueKey<ScopedIdentifierHierarchyRecord>> getKeys() {
        return Arrays.<UniqueKey<ScopedIdentifierHierarchyRecord>>asList(Keys.SCOPED_IDENTIFIER_HIERARCHY_PKEY);
    }

    @Override
    public List<ForeignKey<ScopedIdentifierHierarchyRecord, ?>> getReferences() {
        return Arrays.<ForeignKey<ScopedIdentifierHierarchyRecord, ?>>asList(Keys.SCOPED_IDENTIFIER_HIERARCHY__SCOPED_IDENTIFIER_HIERARCHY_SUPER_ID_FKEY, Keys.SCOPED_IDENTIFIER_HIERARCHY__SCOPED_IDENTIFIER_HIERARCHY_SUB_ID_FKEY);
    }

    public ScopedIdentifier scopedIdentifierHierarchySuperIdFkey() {
        return new ScopedIdentifier(this, Keys.SCOPED_IDENTIFIER_HIERARCHY__SCOPED_IDENTIFIER_HIERARCHY_SUPER_ID_FKEY);
    }

    public ScopedIdentifier scopedIdentifierHierarchySubIdFkey() {
        return new ScopedIdentifier(this, Keys.SCOPED_IDENTIFIER_HIERARCHY__SCOPED_IDENTIFIER_HIERARCHY_SUB_ID_FKEY);
    }

    @Override
    public ScopedIdentifierHierarchy as(String alias) {
        return new ScopedIdentifierHierarchy(DSL.name(alias), this);
    }

    @Override
    public ScopedIdentifierHierarchy as(Name alias) {
        return new ScopedIdentifierHierarchy(alias, this);
    }

    /**
     * Rename this table
     */
    @Override
    public ScopedIdentifierHierarchy rename(String name) {
        return new ScopedIdentifierHierarchy(DSL.name(name), null);
    }

    /**
     * Rename this table
     */
    @Override
    public ScopedIdentifierHierarchy rename(Name name) {
        return new ScopedIdentifierHierarchy(name, null);
    }

    // -------------------------------------------------------------------------
    // Row3 type methods
    // -------------------------------------------------------------------------

    @Override
    public Row3<Integer, Integer, Integer> fieldsRow() {
        return (Row3) super.fieldsRow();
    }
}