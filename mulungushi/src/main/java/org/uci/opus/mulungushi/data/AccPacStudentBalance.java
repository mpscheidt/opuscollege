package org.uci.opus.mulungushi.data;

import java.math.BigDecimal;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Data that is looked up from Mulungushi's web service.
 * 
 * Xml data example:
 * 
 * <pre>
 * {@code
 * <StudentBalance>
 *   <balance>-4000.000</balance>
 *   <canregister>Yes</canregister>
 *   <creditlimit>3150.000</creditlimit>
 *   <name>
 *     Nswana Japhet
 *   </name>
 * </StudentBalance>
 * }
 * </pre> 
 * 
 * The {@link XmlRootElement} is for converting the XML data.
 * The name "StudentBalance" corresponds with the root element name of the XML data.
 * 
 * @author markus
 *
 */
@XmlRootElement(name="StudentBalance")
public class AccPacStudentBalance {

    private BigDecimal balance;
    private String canregister;
    private BigDecimal creditlimit;
    private String name;

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public String getCanregister() {
        return canregister;
    }

    public void setCanregister(String canregister) {
        this.canregister = canregister;
    }

    public boolean getCanRegisterFlag() {
        return "yes".equalsIgnoreCase(canregister);
    }
    
    public BigDecimal getCreditlimit() {
        return creditlimit;
    }
    
    public void setCreditlimit(BigDecimal creditlimit) {
        this.creditlimit = creditlimit;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    @Override
    public String toString() {
        return "AccPacStudentBalance [balance=" + balance + ", canregister=" + canregister + ", creditlimit=" + creditlimit + ", name=" + name + "]";
    }
}
