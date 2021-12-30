package org.uci.opus.college.service.extpoint;

import java.util.Collection;

import org.slf4j.Logger;
import org.springframework.stereotype.Component;

@Component
public class ExtensionPointUtil {

//    public void logExtensions(Logger log, Class<?> extensionPointType, List<?> extensions) {
//        if (extensions == null || extensions.isEmpty()) return;
//        int nExtensions = extensions.size();
//        log.info("Found " + nExtensions + " " + extensionPointType.getName() + " extensions: " + extensions);
//    }

    
    /**
     * Log a collection of extensions.
     * @param log
     * @param extensionPointType
     * @param extensions
     */
    public <T> void logExtensions(Logger log, Class<T> extensionPointType, Collection<T> extensions) {
        if (extensions == null || extensions.isEmpty()) {
            return;
        }
        int nExtensions = extensions.size();
        log.info("Found " + nExtensions + " " + extensionPointType.getName() + " extensions: " + extensions);
    }

    public <T> void logExtensions(Logger log, Class<T> extensionPointType, T extension) {
      log.info("Found " + extensionPointType.getName() + " extension: " + extension);
    }

}
