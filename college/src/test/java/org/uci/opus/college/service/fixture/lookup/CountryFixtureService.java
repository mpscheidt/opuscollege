package org.uci.opus.college.service.fixture.lookup;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.admin.domain.LookupTable;
import org.uci.opus.college.domain.Lookup3;
import org.uci.opus.college.fixture.lookup.CountryFixture;
import org.uci.opus.college.service.LookupManagerInterface;

@Service
public class CountryFixtureService {

    @Autowired
    private LookupManagerInterface lookupManagerInterface;
    
    public Lookup3 saveAtDe() {
        return save(CountryFixture.atDe());
//        Lookup3 country = CountryFixture.atDe();
//        lookupManagerInterface.addLookup(country, LookupTable.COUNTRY);
//        return country;
    }

    public Lookup3 saveAtEn() {
        return save(CountryFixture.atEn());
    }

    public Lookup3 save(Lookup3 country) {
        lookupManagerInterface.addLookup(country, LookupTable.COUNTRY);
        return country;
    }

}
