package org.uci.opus.college.util;

import java.io.Serializable;

import org.uci.opus.college.domain.Lookup8;

/**
 * This class represents a combination of cardinalTimeUnitCode and cardinalTimeUnitNumber.
 * E.g. semester 1, trimester 2.
 * @author markus
 *
 */
@SuppressWarnings("serial")
public class TimeUnit implements Serializable {

    protected int cardinalTimeUnitNumber;
    protected Lookup8 cardinalTimeUnit;

    public TimeUnit() {
    }
    
    public TimeUnit(Lookup8 cardinalTimeUnit, int cardinalTimeUnitNumber) {
        this.cardinalTimeUnit = cardinalTimeUnit;
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }

    public Lookup8 getCardinalTimeUnit() {
        return cardinalTimeUnit;
    }

    public void setCardinalTimeUnit(Lookup8 cardinalTimeUnit) {
        this.cardinalTimeUnit = cardinalTimeUnit;
    }

    public int getCardinalTimeUnitNumber() {
        return cardinalTimeUnitNumber;
    }

    public void setCardinalTimeUnitNumber(int cardinalTimeUnitNumber) {
        this.cardinalTimeUnitNumber = cardinalTimeUnitNumber;
    }

    @Override
    public String toString() {
        return getDescription();
    }
    
    /**
     * A description of this object, e.g. to be shown in the user interface
     * @return
     */
    public String getDescription() {
        StringBuilder sb = new StringBuilder();
        sb.append(cardinalTimeUnit != null ? cardinalTimeUnit.getDescription() : "?");
        sb.append(" ");
        sb.append(cardinalTimeUnitNumber);
        return sb.toString();
    }
    
    /**
     * An identifier e.g. used in html code to identify this object.
     * @return
     */
    public String getCode() {
        return makeCode(cardinalTimeUnit.getCode(), cardinalTimeUnitNumber);
    }

    /**
     * Create a time unit code with the given parameters
     * @param cardinalTimeUnitCode
     * @param cardinalTimeUnitNumber
     * @return
     */
    public static String makeCode(String cardinalTimeUnitCode, int cardinalTimeUnitNumber) {
        return cardinalTimeUnitCode + "_" + cardinalTimeUnitNumber;
    }

}
