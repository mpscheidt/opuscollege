package org.uci.opus.college.service.fixture;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.college.domain.Branch;
import org.uci.opus.college.domain.Institution;
import org.uci.opus.college.fixture.BranchFixture;
import org.uci.opus.college.persistence.BranchMapper;

/**
 * 
 * @author markus
 *
 */
@Service
public class BranchFixtureService {

    @Autowired
    private BranchMapper branchMapper;

    @Autowired
    private InstitutionFixtureService institutionFixtureService;

    public Branch saveUcmFcs() {
        Institution i = institutionFixtureService.findOrSaveUcm();
        return save(BranchFixture.ucmFcs(i.getId()));
    }

    public Branch saveUcmFd() {
        Institution i = institutionFixtureService.findOrSaveUcm();
        return save(BranchFixture.ucmFd(i.getId()));
    }

    private Branch save(Branch b) {
        branchMapper.addBranch(b);
        return b;
    }
}
