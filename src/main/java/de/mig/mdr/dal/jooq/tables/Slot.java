/*
 * This file is generated by jOOQ.
 */
package de.mig.mdr.dal.jooq.tables;


import de.mig.mdr.dal.jooq.Indexes;
import de.mig.mdr.dal.jooq.Keys;
import de.mig.mdr.dal.jooq.Public;
import de.mig.mdr.dal.jooq.tables.records.SlotRecord;

import java.util.Arrays;
import java.util.List;

import javax.annotation.processing.Generated;

import org.jooq.Field;
import org.jooq.ForeignKey;
import org.jooq.Identity;
import org.jooq.Index;
import org.jooq.Name;
import org.jooq.Record;
import org.jooq.Row4;
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
public class Slot extends TableImpl<SlotRecord> {

    private static final long serialVersionUID = -1524650230;

    /**
     * The reference instance of <code>public.slot</code>
     */
    public static final Slot SLOT = new Slot();

    /**
     * The class holding records for this type
     */
    @Override
    public Class<SlotRecord> getRecordType() {
        return SlotRecord.class;
    }

    /**
     * The column <code>public.slot.id</code>.
     */
    public final TableField<SlotRecord, Integer> ID = createField(DSL.name("id"), org.jooq.impl.SQLDataType.INTEGER.nullable(false).defaultValue(org.jooq.impl.DSL.field("nextval('slot_id_seq'::regclass)", org.jooq.impl.SQLDataType.INTEGER)), this, "");

    /**
     * The column <code>public.slot.scoped_identifier_id</code>.
     */
    public final TableField<SlotRecord, Integer> SCOPED_IDENTIFIER_ID = createField(DSL.name("scoped_identifier_id"), org.jooq.impl.SQLDataType.INTEGER.nullable(false), this, "");

    /**
     * The column <code>public.slot.key</code>.
     */
    public final TableField<SlotRecord, String> KEY = createField(DSL.name("key"), org.jooq.impl.SQLDataType.CLOB.nullable(false), this, "");

    /**
     * The column <code>public.slot.value</code>.
     */
    public final TableField<SlotRecord, String> VALUE = createField(DSL.name("value"), org.jooq.impl.SQLDataType.CLOB.nullable(false), this, "");

    /**
     * Create a <code>public.slot</code> table reference
     */
    public Slot() {
        this(DSL.name("slot"), null);
    }

    /**
     * Create an aliased <code>public.slot</code> table reference
     */
    public Slot(String alias) {
        this(DSL.name(alias), SLOT);
    }

    /**
     * Create an aliased <code>public.slot</code> table reference
     */
    public Slot(Name alias) {
        this(alias, SLOT);
    }

    private Slot(Name alias, Table<SlotRecord> aliased) {
        this(alias, aliased, null);
    }

    private Slot(Name alias, Table<SlotRecord> aliased, Field<?>[] parameters) {
        super(alias, null, aliased, parameters, DSL.comment(""), TableOptions.table());
    }

    public <O extends Record> Slot(Table<O> child, ForeignKey<O, SlotRecord> key) {
        super(child, key, SLOT);
    }

    @Override
    public Schema getSchema() {
        return Public.PUBLIC;
    }

    @Override
    public List<Index> getIndexes() {
        return Arrays.<Index>asList(Indexes.SLOT_SCOPED_IDENTIFIER_ID_IDX);
    }

    @Override
    public Identity<SlotRecord, Integer> getIdentity() {
        return Keys.IDENTITY_SLOT;
    }

    @Override
    public UniqueKey<SlotRecord> getPrimaryKey() {
        return Keys.SLOT_PKEY;
    }

    @Override
    public List<UniqueKey<SlotRecord>> getKeys() {
        return Arrays.<UniqueKey<SlotRecord>>asList(Keys.SLOT_PKEY);
    }

    @Override
    public List<ForeignKey<SlotRecord, ?>> getReferences() {
        return Arrays.<ForeignKey<SlotRecord, ?>>asList(Keys.SLOT__SLOT_SCOPED_IDENTIFIER_ID_FKEY);
    }

    public ScopedIdentifier scopedIdentifier() {
        return new ScopedIdentifier(this, Keys.SLOT__SLOT_SCOPED_IDENTIFIER_ID_FKEY);
    }

    @Override
    public Slot as(String alias) {
        return new Slot(DSL.name(alias), this);
    }

    @Override
    public Slot as(Name alias) {
        return new Slot(alias, this);
    }

    /**
     * Rename this table
     */
    @Override
    public Slot rename(String name) {
        return new Slot(DSL.name(name), null);
    }

    /**
     * Rename this table
     */
    @Override
    public Slot rename(Name name) {
        return new Slot(name, null);
    }

    // -------------------------------------------------------------------------
    // Row4 type methods
    // -------------------------------------------------------------------------

    @Override
    public Row4<Integer, Integer, String, String> fieldsRow() {
        return (Row4) super.fieldsRow();
    }
}
