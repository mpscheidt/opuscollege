package org.uci.opus.college.service.fixture;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.fixture.InstitutionFixture;
import org.uci.opus.college.persistence.InstitutionMapper;

@Service
public class InstitutionFixtureService {
    
    @Autowired
    private InstitutionMapper institutionMapper;

    public Institution saveUcm() {
        return saveInstitution(InstitutionFixture.ucm());
    }
    
    public Institution findOrSaveUcm() {
        Institution i = institutionMapper.findInstitutionByCode(InstitutionFixture.UCM_CODE);
        return i != null ? i : saveUcm();
    }

    public Institution saveMu() {
        return saveInstitution(InstitutionFixture.mu());
    }

    public Institution saveSec1() {
        return saveInstitution(InstitutionFixture.sec1());
    }

    public Institution saveSec2() {
        return saveInstitution(InstitutionFixture.sec2());
    }

    private Institution saveInstitution(Institution i) {
        institutionMapper.addInstitution(i);
        return i;
    }

}
