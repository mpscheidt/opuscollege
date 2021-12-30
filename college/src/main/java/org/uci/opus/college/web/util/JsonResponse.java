package org.uci.opus.college.web.util;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * Send response from server to client via Json.
 * Status indicates success or failure.
 * Result is e.g. validation error.
 * 
 * @author Markus Pscheidt
 *
 */
public class JsonResponse {
    
    public static final String SUCCESS = "SUCCESS";
    public static final String FAILURE = "FAILURE";

    private String status = null;
    private Object result = null;
    
    public JsonResponse() {
    }

    public JsonResponse(String status) {
        this.status = status;
    }

    public JsonResponse(boolean success) {
        this.status = success ? SUCCESS : FAILURE;
    }

    public JsonResponse(boolean success, Object failureResult) {
        this(success);
        if (!success) {
            this.result = failureResult;
        }
    }

    @JsonIgnore
    public boolean isSuccessful() {
        return SUCCESS.equals(status);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Object getResult() {
        return result;
    }

    public void setResult(Object result) {
        this.result = result;
    }

    @Override
    public String toString() {
        return "JsonResponse [status=" + status + ", result=" + result + "]";
    }
    
}
