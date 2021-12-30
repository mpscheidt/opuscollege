package org.uci.opus.college.web.util.exam;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.validation.BindingResult;
import org.uci.opus.college.domain.AuthorizationMap;
import org.uci.opus.college.domain.result.AuthorizationSubExTest;
import org.uci.opus.college.domain.result.IResult;
import org.uci.opus.college.service.ResultManagerInterface;
import org.uci.opus.college.validator.result.AbstractResultValidator;
import org.uci.opus.util.StringUtil;

public class ResultLines<R extends IResult, L extends ResultLine<R>> extends ArrayList<L> {

    private static final long serialVersionUID = 1L;

    private AuthorizationMap<AuthorizationSubExTest> authorizationMap;

    public AuthorizationMap<AuthorizationSubExTest> getResultAuthorizationMap() {
        return authorizationMap;
    }

    public void setResultAuthorizationMap(AuthorizationMap<AuthorizationSubExTest> resultAuthorizationMap) {
        this.authorizationMap = resultAuthorizationMap;
    }

    /**
     * 
     * @param lineIdx
     * @param attemptIdx
     * @return
     */
    public R getResult(int lineIdx, int attemptIdx) {
        List<R> results = getResults(lineIdx);
        R result = results.get(attemptIdx);
        return result;
    }

    /**
     * Get the results for the given line index.
     * @param lineIdx
     * @return
     */
    public List<R> getResults(int lineIdx) {
        List<R> results = get(lineIdx).getResults();
        return results;
    }
    
    /**
     * Get index (not attemptNr) of the last attempt for the line with the given line index.
     * @param lineIdx
     * @return
     */
    public int getLastAttemptIndex(int lineIdx) {
        List<R> results = getResults(lineIdx);
        return results.size() - 1;
    }

    public void saveAllResults(AbstractResultValidator<R> resultValidator, BindingResult bindingResult, ResultManagerInterface resultManager, HttpServletRequest request) {
        
        List<R> results = new ArrayList<>();
        List<R> resultsInDB = new ArrayList<>();
        
        for (int i = 0; i < this.size(); i++) {
            L examinationResultLine = this.get(i);
            for (int j = 0; j < examinationResultLine.getResults().size(); j++) {
                R result = examinationResultLine.getResults().get(j);
                int resultId = result.getId();

                R resultInDB = examinationResultLine.getResultsInDB().size() > j ? examinationResultLine.getResultsInDB().get(j) : null;

                AuthorizationSubExTest authorization = authorizationMap.getAuthorization(result);
                resultValidator.setAuthorization(authorization);

                String mark = result.getMark();

                // This line can be ignored if no data was entered: ie. new result && no mark entered
                // - ignore teacher because when only one teacher then always automatically selected
                boolean ignore = (resultId == 0 && StringUtil.isNullOrEmpty(mark, true)) || result.unmodified(resultInDB);
                if (ignore) {
                    continue;       // ignore this result and go to next one
                }

                // -- Validation --

                bindingResult.pushNestedPath("allLines[" + i + "].results[" + j + "]");
                resultValidator.validate(result, bindingResult);
                bindingResult.popNestedPath(); // end of validation of this line

                // Store all rows without errors: prevent possible data loss, which could occur if only storing in case no row having any errors
                results.add(result);
                resultsInDB.add(resultInDB);
            }
        }

        if (bindingResult.hasErrors()) {
            return;
        }

        for (int i = 0; i < results.size(); i++) {
            R result = results.get(i);
            R resultInDB = resultsInDB.get(i);
            resultManager.saveResultIfModified(request, result, resultInDB);
        }

    }

}
