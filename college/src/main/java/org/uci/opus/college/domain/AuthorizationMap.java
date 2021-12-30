package org.uci.opus.college.domain;

import java.util.HashMap;

import org.uci.opus.college.domain.result.IResult;

public class AuthorizationMap<A extends Authorization> extends HashMap<String, A> {

    private static final long serialVersionUID = 1L;

    public A getAuthorization(IResult result) {
        A authorization = null;
        if (result != null) {
            String authorizationKey = result.getUniqueKey();
            authorization = this.get(authorizationKey);
        }
        return authorization;
    }

}
