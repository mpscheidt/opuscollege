package org.uci.opus.college.util;

import java.util.HashMap;
import java.util.Map;

/**
 * 
 * @author markus
 *
 */
public abstract class MybatisUtil {

    /**
     * Create a map with a single key/value pair.
     */
    public static Map<String, Object> map(String key, Object value) {
        Map<String, Object> map = new HashMap<>();
        map.put(key, value);
        return map;
    }

    /**
     * Create a map with a two key/value pairs.
     */
    public static Map<String, Object> map(String key1, Object value1, String key2, Object value2) {
        Map<String, Object> map = new HashMap<>();
        map.put(key1, value1);
        map.put(key2, value2);
        return map;
    }

    /**
     * Create a map with a three key/value pairs.
     */
    public static Map<String, Object> map(String key1, Object value1, String key2, Object value2, String key3, Object value3) {
        Map<String, Object> map = new HashMap<>();
        map.put(key1, value1);
        map.put(key2, value2);
        map.put(key3, value3);
        return map;
    }

}
