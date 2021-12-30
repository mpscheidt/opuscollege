package org.uci.opus.college.domain;

public interface ILookup {

    public String getDescription();
    public String getCode();
    public void setCode(String newCode);
    public void setDescription(String newDescription);
    public int getId();
    public void setId(int newId);
    public String getLang();
    public void setLang(String newLang);
    public String getActive();
    public void setActive(String newactive);

}
