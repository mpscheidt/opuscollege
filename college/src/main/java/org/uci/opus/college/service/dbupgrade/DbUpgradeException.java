package org.uci.opus.college.service.dbupgrade;

public class DbUpgradeException extends Exception {

    private static final long serialVersionUID = 1L;

    public DbUpgradeException() {
        super();
    }

    public DbUpgradeException(String message, Throwable cause) {
        super(message, cause);
    }

    public DbUpgradeException(String message) {
        super(message);
    }

    public DbUpgradeException(Throwable cause) {
        super(cause);
    }

}
