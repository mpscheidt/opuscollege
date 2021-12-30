package org.uci.opus.college.fixture;

import org.uci.opus.college.domain.Institution;
import org.uci.opus.config.OpusConstants;

/**
 * 
 * @author markus
 *
 */
public abstract class InstitutionFixture {

    public static final String UCM_CODE = "UCM";
    public static final String UCM_DESCRIPTION = "Universidade Catolica de Mocambique";
    public static final String UCM_INSTITUTIONTYPECODE = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
    public static final String UCM_PROVINCECODE = "MZ-08";
    public static final String UCM_RECTOR = "Padre Alberto";

    public static final String MU_CODE = "MU";
    public static final String MU_DESCRIPTION = "Munlungushi University";
    public static final String MU_INSTITUTIONTYPECODE = OpusConstants.INSTITUTION_TYPE_HIGHER_EDUCATION;
    public static final String MU_PROVINCECODE = "ZM-01";
    public static final String MU_RECTOR = "Hellicy Ngambi";

    public static final String SEC1_CODE = "142";
    public static final String SEC1_DESCRIPTION = "Liceu Alvorada";
    public static final String SEC1_INSTITUTIONTYPECODE = OpusConstants.INSTITUTION_TYPE_SECONDARY_SCHOOL;
    public static final String SEC1_PROVINCECODE = "MZ-01";
    public static final String SEC1_RECTOR = "AB";

    public static final String SEC2_CODE = "143";
    public static final String SEC2_DESCRIPTION = "Colegio Gutemberg";
    public static final String SEC2_INSTITUTIONTYPECODE = OpusConstants.INSTITUTION_TYPE_SECONDARY_SCHOOL;
    public static final String SEC2_PROVINCECODE = "MZ-02";
    public static final String SEC2_RECTOR = "CD";

    public static Institution ucm() {

        Institution ucm = new Institution(UCM_CODE, UCM_DESCRIPTION, UCM_INSTITUTIONTYPECODE);
        ucm.setProvinceCode(UCM_PROVINCECODE);
        ucm.setRector(UCM_RECTOR);
        return ucm;
    }

    public static Institution mu() {

        Institution mu = new Institution(MU_CODE, MU_DESCRIPTION, MU_INSTITUTIONTYPECODE);
        mu.setProvinceCode(MU_PROVINCECODE);
        mu.setRector(MU_RECTOR);
        return mu;
    }

    public static Institution sec1() {

        Institution sec = new Institution(SEC1_CODE, SEC1_DESCRIPTION, SEC1_INSTITUTIONTYPECODE);
        sec.setProvinceCode(SEC1_PROVINCECODE);
        sec.setRector(SEC1_RECTOR);
        return sec;
    }

    public static Institution sec2() {

        Institution sec = new Institution(SEC2_CODE, SEC2_DESCRIPTION, SEC2_INSTITUTIONTYPECODE);
        sec.setProvinceCode(SEC2_PROVINCECODE);
        sec.setRector(SEC2_RECTOR);
        return sec;
    }

}
