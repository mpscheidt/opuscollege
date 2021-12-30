package org.uci.opus.accommodation.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.service.LookupManagerInterface;
import org.uci.opus.college.service.extpoint.DBUpgradeListener;
import org.uci.opus.util.dbupgrade.DbUpgradeCommandInterface;

// Note MP 2012-12-18: This cache works, but it is not possible to evict stale data.
// An option would be to use Spring cache integration, e.g. with EHCache.

@Service
public class AccommodationLookupCacher implements DBUpgradeListener {

    @Autowired private LookupManagerInterface lookupManager;

    // language -> List<Lookup>
    private Map<String, List<Lookup>> allHostelTypesMap = new HashMap<String, List<Lookup>>();
    private Map<String, List<Lookup>> allRoomTypesMap = new HashMap<String, List<Lookup>>();

//    public void loadAllRoomTypes(String preferredLanguage) {
//        
//        if (allRoomTypes == null
//                || allRoomTypes.size() == 0
//                || (allRoomTypes.size() != 0 && !preferredLanguage.equals(allRoomTypes.get(0).getLang()))) {
//            
//            allRoomTypes = (List<Lookup>) lookupManager.findAllRows(preferredLanguage, "acc_roomType");
//        }
//    }
//
//    public List<Lookup> getAllRoomTypes() {
//        return allRoomTypes;
//    }
//
//    public void setAllRoomTypes(List<Lookup> allRoomTypes) {
//        this.allRoomTypes = allRoomTypes;
//    }

    public List<Lookup> getAllRoomTypes(String language) {
        List<Lookup> allRoomTypes = allRoomTypesMap.get(language);
        if (allRoomTypes == null) {
            allRoomTypes = (List<Lookup>) lookupManager.findAllRows(language, "acc_roomType");
//            allRoomTypesMap.put(language, allRoomTypes);  MP 2012-12-18 Cache deactivated, otherwise stale data may reside after editing e.g. in edit lookup screens
        }
        return allRoomTypes;
    }

    public List<Lookup> getAllHostelTypes(String language) {
        List<Lookup> allHostelTypes = allHostelTypesMap.get(language);
        if (allHostelTypes == null) {
            allHostelTypes = (List<Lookup>) lookupManager.findAllRows(language, "acc_hostelType");
//            allHostelTypesMap.put(language, allHostelTypes);  MP 2012-12-18 Cache deactivated, otherwise stale data may reside after editing e.g. in edit lookup screens
        }
        return allHostelTypes;
    }

    @Override
    public void dbUpgradesExecuted(List<DbUpgradeCommandInterface> upgrades) {

        allHostelTypesMap.clear();
        allRoomTypesMap.clear();

    }

}
