package org.uci.opus.ucm.domain;

import java.util.List;

public class Primavera
{
  private String status;
  private List<Result> result;
  
  public String getStatus()
  {
    return this.status;
  }
  
  public void setStatus(String status)
  {
    this.status = status;
  }
  
  public List<Result> getResult()
  {
    return this.result;
  }
  
  public void setResult(List<Result> result)
  {
    this.result = result;
  }
}
