package org.uci.opus.college.domain.audit;

import org.uci.opus.college.domain.EndGrade;

public class EndGradeHistory extends EndGrade implements HistoryDO {

    private static final long serialVersionUID = 1L;

    private char operation;

    @Override
    public char getOperation() {
        return operation;
    }

    public void setOperation(char operation) {
        this.operation = operation;
    }
    
    
    
}
