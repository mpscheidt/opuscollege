package org.uci.opus.ucm.web.service.campusonline.fullresults;

import java.util.Comparator;

import org.uci.opus.util.CompareUtil;

public class SubExTestDTOComparator implements Comparator<SubjectDTO> {

    @Override
    public int compare(SubjectDTO o1, SubjectDTO o2) {

        // compare time unit number
//        int c = o1.getTimeUnit() - o2.getTimeUnit();
//        if (c != 0) {
//            return c;
//        }

        // compare code
        int c = CompareUtil.compare(o1.getCode(), o2.getCode());
        if (c != 0) {
            return c;
        }

        // compare description
        c = CompareUtil.compare(o1.getDescription(), o2.getDescription());

        return c;
    }

}
