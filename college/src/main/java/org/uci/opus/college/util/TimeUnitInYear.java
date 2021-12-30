package org.uci.opus.college.util;

import org.uci.opus.college.domain.Lookup8;

/**
 * This class represents a time unit within a year. For example, this can be
 * semester 1 and semester 2, but not semester 3 since one year only has 2
 * semesters.
 * 
 * @author markus
 * 
 */
@SuppressWarnings("serial")
public class TimeUnitInYear extends TimeUnit {

    public TimeUnitInYear() {
    }

    /**
     * If cardinalTimeUnitNumber > than nr of units per year, it will be modulo divided.
     * @param cardinalTimeUnit
     * @param cardinalTimeUnitNumber
     */
    public TimeUnitInYear(Lookup8 cardinalTimeUnit, int cardinalTimeUnitNumber) {
        super();
        
        setCardinalTimeUnit(cardinalTimeUnit);
        
        // instead of ctuNumber = 0, we shall use nrOfTimeUnitsPerYear, ie. semester 2 rather than semester 0
        int ctuNumber = cardinalTimeUnitNumber % cardinalTimeUnit.getNrOfUnitsPerYear();
        if (ctuNumber == 0) {
            ctuNumber = cardinalTimeUnit.getNrOfUnitsPerYear();
        }
        setCardinalTimeUnitNumber(ctuNumber);

    }
    
    /**
     * E.g. semester 1, semester 2, but only year (not year 1).
     */
    @Override
    public String getDescription() {
        StringBuilder sb = new StringBuilder();
        if (cardinalTimeUnit != null) {
            sb.append(cardinalTimeUnit.getDescription());
            if (cardinalTimeUnit.getNrOfUnitsPerYear() > 1) {
                sb.append(" ");
                sb.append(cardinalTimeUnitNumber);
            }
        }
        return sb.toString();
    }

}
