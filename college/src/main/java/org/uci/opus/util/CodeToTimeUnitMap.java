package org.uci.opus.util;

import java.util.List;
import java.util.Map;

import org.uci.opus.college.util.TimeUnit;
import org.uci.opus.util.lookup.LookupUtil;

public class CodeToTimeUnitMap extends DummyMap<String, TimeUnit> {

    private List<? extends TimeUnit> list;
    private Map<String, ? extends TimeUnit> map = null;
    
    public CodeToTimeUnitMap(List<? extends TimeUnit> list) {
        this.list = list;
    }

    @Override
    public TimeUnit get(Object obj) {
        if (map == null) {
            map = (Map<String, ? extends TimeUnit>) LookupUtil.makeCodeToTimeUnitMap(list);
        }
        return map.get(obj);
    }

}
