package org.uci.opus.ucm.web.service;

import org.springframework.stereotype.Service;
import org.uci.opus.college.web.util.JsonResponse;
import org.uci.opus.util.Encode;

@Service
public class JsonResponseFactory {

    public static final String PRIVATE_KEY = "0F5DD14AE2E38C7EBD8814D29CF6F6F0";

    public static final String INVALID_HASH = "Invalid hash";
    public static final String INVALID_STUDENT_CODE = "Invalid student code";
    public static final String INVALID_STUDENT_CODE_OR_BIRTH_DATE = "Invalid student code or birth date";

    /**
     * Check if MD5(privateKey + params) matches givenHash.
     * 
     * @param params
     * @param givenHash
     * @return
     */
    public JsonResponse fromMD5Hash(String params, String givenHash) {

        boolean matches = Encode.encodeMd5(PRIVATE_KEY + params).equals(givenHash);

        JsonResponse jsonResponse = new JsonResponse(matches, INVALID_HASH);
        return jsonResponse;
    }

    public JsonResponse fromInvalidStudentCode() {

        JsonResponse jsonResponse = new JsonResponse(false, INVALID_STUDENT_CODE);
        return jsonResponse;
    }

    public JsonResponse fromInvalidStudentCodeOrBirthDate() {

        JsonResponse jsonResponse = new JsonResponse(false, INVALID_STUDENT_CODE_OR_BIRTH_DATE);
        return jsonResponse;
    }

}
