package org.uci.opus.college.fixture;

import org.uci.opus.college.domain.DisciplineGroup;

public abstract class DisciplineGroupFixture {

    public static final String CODE1 = "DG1";
    public static final String CODE2 = "DG2";
    public static final String DESCRIPTION1 = "Disciplinegroup One";
    public static final String DESCRIPTION2 = "Disciplinegroup Two";

    public static DisciplineGroup disciplineGroup1() {
        return new DisciplineGroup(CODE1, DESCRIPTION1);
    }
    
    public static DisciplineGroup disciplineGroup2() {
        return new DisciplineGroup(CODE2, DESCRIPTION2);
    }
    
}
