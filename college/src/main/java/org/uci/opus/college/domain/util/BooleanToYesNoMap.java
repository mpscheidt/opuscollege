package org.uci.opus.college.domain.util;

import org.springframework.stereotype.Service;
import org.uci.opus.util.DummyMap;

@Service
public class BooleanToYesNoMap extends DummyMap<Boolean, String> {

    @Override
    public String get(Object obj) {
        return Boolean.TRUE.equals(obj) ? "jsp.general.yes" : "jsp.general.no";
    }

}
