package org.uci.opus.college.web.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.web.form.AddressLookup;
import org.uci.opus.util.LookupCacher;

/**
 * Fill {@link AddressLookup} lists based on its current values for country, province and district.
 * 
 * @author Markus Pscheidt
 *
 */
@Service
public class AddressLookupBuilder {

    @Autowired
    private LookupCacher lookupCacher;
    
    public void loadProvinces(AddressLookup addressLookup, String countryCode) {
        addressLookup.setAllProvinces(lookupCacher.getAllProvinces(countryCode, addressLookup.getLang()));
    }
    
    public void loadDistricts(AddressLookup addressLookup, String provinceCode) {
        addressLookup.setAllDistricts(lookupCacher.getAllDistricts(provinceCode, addressLookup.getLang()));
    }
    
    public void loadAdministrativePosts(AddressLookup addressLookup, String districtCode) {
        addressLookup.setAllAdministrativePosts(lookupCacher.getAllAdministrativePosts(districtCode, addressLookup.getLang()));
    }
    
    public AddressLookup newAddressLookup(String lang, String countryCode, String provinceCode, String districtCode) {
        AddressLookup addressLookup = new AddressLookup(lang);
        
        addressLookup.setAllCountries(lookupCacher.getAllCountries(lang));
        if (countryCode != null) {
            loadProvinces(addressLookup, countryCode);
        }
        if (provinceCode != null) {
            loadDistricts(addressLookup, provinceCode);
        }
        if (districtCode != null) {
            loadAdministrativePosts(addressLookup, districtCode);
        }
        
        return addressLookup;
    }
    
}
