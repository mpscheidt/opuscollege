package org.uci.opus.college.domain.util;

import org.springframework.stereotype.Service;
import org.uci.opus.util.DummyMap;

@Service
public class StringToYesNoMap extends DummyMap<String, String> {

    @Override
    public String get(Object obj) {
        String s = (String) obj;
        return "Y".equalsIgnoreCase(s) ? "jsp.general.yes" : "jsp.general.no";
    }

}
