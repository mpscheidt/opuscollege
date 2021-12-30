package org.uci.opus.finance.service.extpoint;

import java.lang.reflect.Field;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Student;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;
import org.uci.opus.college.web.extpoint.IExtensionCollection;
import org.uci.opus.fee.domain.Fee;

@Service
public class FinanceServiceExtensions implements IExtensionCollection {

    private static Logger log = LoggerFactory.getLogger(FinanceServiceExtensions.class);

    @Autowired private ExtensionPointUtil extensionPointUtil;

    private Collection<IFeeDiscount> feeDiscounts;

    @Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }

    public Collection<IFeeDiscount> getFeeDiscounts() {
        return feeDiscounts;
    }

    @Autowired(required=false)
    public void setFeeDiscounts(Collection<IFeeDiscount> feeDiscounts) {
        this.feeDiscounts = feeDiscounts;
        extensionPointUtil.logExtensions(log, IFeeDiscount.class, feeDiscounts);
    }
    
    public int getDiscountPercentage(Student student, Fee fee) {
        int discountPercentage = 0;
        if (feeDiscounts != null) {
            for (IFeeDiscount extension : feeDiscounts) {
                discountPercentage += extension.getDiscountPercentage(student, fee);
            }
        }
        return discountPercentage;
    }

}
