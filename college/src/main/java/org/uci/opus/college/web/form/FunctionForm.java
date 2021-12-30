package org.uci.opus.college.web.form;

import java.util.List;

import org.uci.opus.college.domain.Lookup;
import org.uci.opus.college.domain.StaffMember;
import org.uci.opus.college.domain.StaffMemberFunction;

public class FunctionForm {

    private NavigationSettings navigationSettings;

    private String lookupCode;
    private String functionLevelCode;

    private StaffMember staffMember;

    private List<StaffMemberFunction> allStaffMemberFunctions;

    private List<Lookup> allFunctions;
    private List<Lookup> allFunctionLevels;

    public FunctionForm() {
    }

    public String getLookupCode() {
        return lookupCode;
    }

    public void setLookupCode(String lookupCode) {
        this.lookupCode = lookupCode;
    }

    public String getFunctionLevelCode() {
        return functionLevelCode;
    }

    public void setFunctionLevelCode(String functionLevelCode) {
        this.functionLevelCode = functionLevelCode;
    }

    public List<StaffMemberFunction> getAllStaffMemberFunctions() {
        return allStaffMemberFunctions;
    }

    public void setAllStaffMemberFunctions(List<StaffMemberFunction> allStaffMemberFunctions) {
        this.allStaffMemberFunctions = allStaffMemberFunctions;
    }

    public StaffMember getStaffMember() {
        return staffMember;
    }

    public void setStaffMember(StaffMember staffMember) {
        this.staffMember = staffMember;
    }

    public List<Lookup> getAllFunctions() {
        return allFunctions;
    }

    public void setAllFunctions(List<Lookup> allFunctions) {
        this.allFunctions = allFunctions;
    }

    public List<Lookup> getAllFunctionLevels() {
        return allFunctionLevels;
    }

    public void setAllFunctionLevels(List<Lookup> allFunctionLevels) {
        this.allFunctionLevels = allFunctionLevels;
    }

    public NavigationSettings getNavigationSettings() {
        return navigationSettings;
    }

    public void setNavigationSettings(NavigationSettings navigationSettings) {
        this.navigationSettings = navigationSettings;
    }

}
