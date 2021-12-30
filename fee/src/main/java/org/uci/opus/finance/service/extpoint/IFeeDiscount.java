package org.uci.opus.finance.service.extpoint;

import org.uci.opus.college.domain.Student;
import org.uci.opus.fee.domain.Fee;

public interface IFeeDiscount {

    int getDiscountPercentage(Student student, Fee fee);

}
