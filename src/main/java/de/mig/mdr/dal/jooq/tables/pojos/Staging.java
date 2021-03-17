/*
 * This file is generated by jOOQ.
 */
package de.mig.mdr.dal.jooq.tables.pojos;


import de.mig.mdr.dal.jooq.enums.ElementType;

import java.io.Serializable;

import javax.annotation.processing.Generated;


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
public class Staging implements Serializable {

    private static final long serialVersionUID = -1445052234;

    private Integer     id;
    private String      data;
    private ElementType elementType;
    private String      designation;
    private Integer     parentId;
    private Integer     importId;
    private Integer     elementId;

    public Staging() {}

    public Staging(Staging value) {
        this.id = value.id;
        this.data = value.data;
        this.elementType = value.elementType;
        this.designation = value.designation;
        this.parentId = value.parentId;
        this.importId = value.importId;
        this.elementId = value.elementId;
    }

    public Staging(
        Integer     id,
        String      data,
        ElementType elementType,
        String      designation,
        Integer     parentId,
        Integer     importId,
        Integer     elementId
    ) {
        this.id = id;
        this.data = data;
        this.elementType = elementType;
        this.designation = designation;
        this.parentId = parentId;
        this.importId = importId;
        this.elementId = elementId;
    }

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getData() {
        return this.data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public ElementType getElementType() {
        return this.elementType;
    }

    public void setElementType(ElementType elementType) {
        this.elementType = elementType;
    }

    public String getDesignation() {
        return this.designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Integer getParentId() {
        return this.parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getImportId() {
        return this.importId;
    }

    public void setImportId(Integer importId) {
        this.importId = importId;
    }

    public Integer getElementId() {
        return this.elementId;
    }

    public void setElementId(Integer elementId) {
        this.elementId = elementId;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Staging (");

        sb.append(id);
        sb.append(", ").append(data);
        sb.append(", ").append(elementType);
        sb.append(", ").append(designation);
        sb.append(", ").append(parentId);
        sb.append(", ").append(importId);
        sb.append(", ").append(elementId);

        sb.append(")");
        return sb.toString();
    }
}
