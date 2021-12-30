package org.dbunit.operation;

import org.dbunit.database.IDatabaseConnection;

/**
 * 
 * Truncate table operation with CASCADE option.
 * 
 * Note: works for Postgres, not necessarily for any other database.
 * 
 * Note that this class needs to be in the same package as the super class
 * because the super constructor is package scope.
 * 
 * @author markus
 *
 */
public class TruncateCascadeTableOperation extends TruncateTableOperation {

	/**
	 * Super constructor is package scope.
	 * NB: A super constructor has to be called by Java definition,
	 */
	public TruncateCascadeTableOperation() {
	}

	@Override
	protected String getQualifiedName(String prefix, String name,
			IDatabaseConnection connection) {
		String qualifiedName = super.getQualifiedName(prefix, name, connection);
		return qualifiedName + " CASCADE";
	}
}
