package org.uci.opus.college.domain.result;

public abstract class AssessmentResultAttemptComment extends AssessmentResultComment {

    private boolean failSubject;
    private boolean failsubjectblock;
    private boolean failTimeUnit;
    public boolean isFailSubject() {
        return failSubject;
    }

    public void setFailSubject(boolean failSubject) {
        this.failSubject = failSubject;
    }

    public boolean isFailTimeUnit() {
        return failTimeUnit;
    }

    public void setFailTimeUnit(boolean failTimeUnit) {
        this.failTimeUnit = failTimeUnit;
    }

    public boolean isFailsubjectblock() {
		return failsubjectblock;
	}

	public void setFailsubjectblock(boolean failsubjectblock) {
		this.failsubjectblock = failsubjectblock;
	}

}
