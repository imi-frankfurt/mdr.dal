/*
 * This file is generated by jOOQ.
 */
package de.mig.mdr.dal.jooq.tables.pojos;


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
public class Hierarchy implements Serializable {

    private static final long serialVersionUID = 1326582601;

    private Integer root;
    private Integer super_;
    private Integer sub;

    public Hierarchy() {}

    public Hierarchy(Hierarchy value) {
        this.root = value.root;
        this.super_ = value.super_;
        this.sub = value.sub;
    }

    public Hierarchy(
        Integer root,
        Integer super_,
        Integer sub
    ) {
        this.root = root;
        this.super_ = super_;
        this.sub = sub;
    }

    public Integer getRoot() {
        return this.root;
    }

    public void setRoot(Integer root) {
        this.root = root;
    }

    public Integer getSuper() {
        return this.super_;
    }

    public void setSuper(Integer super_) {
        this.super_ = super_;
    }

    public Integer getSub() {
        return this.sub;
    }

    public void setSub(Integer sub) {
        this.sub = sub;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("Hierarchy (");

        sb.append(root);
        sb.append(", ").append(super_);
        sb.append(", ").append(sub);

        sb.append(")");
        return sb.toString();
    }
}
