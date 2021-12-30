package org.dbunit.operation;


public abstract class OpusDatabaseOperation extends DatabaseOperation {

    public static final DatabaseOperation TRUNCATE_CASCADE_TABLE = new TruncateCascadeTableOperation();

}
