package org.uci.opus.ucm.web.service.campusonline;

import java.util.Comparator;

import org.uci.opus.util.CompareUtil;

public class ResultDTOComparator implements Comparator<ResultDTO> {

    @Override
    public int compare(ResultDTO o1, ResultDTO o2) {

        // compare time unit number
        int c = o1.getTimeUnit() - o2.getTimeUnit();
        if (c != 0) {
            return c;
        }

        // compare code
        c = CompareUtil.compare(o1.getCode(), o2.getCode());
        if (c != 0) {
            return c;
        }

        // compare description
        c = CompareUtil.compare(o1.getDescription(), o2.getDescription());

        return c;
    }

}
