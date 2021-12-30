package org.uci.opus.scholarship.web.extpoint;

import java.lang.reflect.Field;
import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;
import org.uci.opus.college.web.extpoint.IExtensionCollection;

@Service
public class ScholarshipWebExtensions implements IExtensionCollection {

    private static Logger log = LoggerFactory.getLogger(ScholarshipWebExtensions.class);

    @Autowired private ExtensionPointUtil extensionPointUtil;

    private Collection<SponsorsButtonsCellReport> sponsorsButtonsCellReports;


    public Collection<SponsorsButtonsCellReport> getSponsorsButtonsCellReports() {
        return sponsorsButtonsCellReports;
    }

    @Autowired(required=false)
    public void setSponsorsButtonsCellReports(Collection<SponsorsButtonsCellReport> sponsorsButtonsCellReports) {
        this.sponsorsButtonsCellReports = sponsorsButtonsCellReports;
        extensionPointUtil.logExtensions(log, SponsorsButtonsCellReport.class, sponsorsButtonsCellReports);
    }

    @Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }
    
}
