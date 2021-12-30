package org.uci.opus.ucm.domain;

public class Result
{
  private String Modulo;
  private String TipoDoc;
  private String NumDocu;
  private String DataDoc;
  private String DataVenc;
  private String DataLiq;
  private double ValorTotal;
  private double ValorPendente;
  private String DescDoc;
  
  public String getModulo()
  {
    return this.Modulo;
  }
  
  public void setModulo(String Modulo)
  {
    this.Modulo = Modulo;
  }
  
  public String getTipoDoc()
  {
    return this.TipoDoc;
  }
  
  public void setTipoDoc(String TipoDoc)
  {
    this.TipoDoc = TipoDoc;
  }
  
  public String getNumDocu()
  {
    return this.NumDocu;
  }
  
  public void setNumDocu(String NumDocu)
  {
    this.NumDocu = NumDocu;
  }
  
  public String getDataDoc()
  {
    return this.DataDoc;
  }
  
  public void setDataDoc(String DataDoc)
  {
    this.DataDoc = DataDoc;
  }
  
  public String getDataVenc()
  {
    return this.DataVenc;
  }
  
  public void setDataVenc(String DataVenc)
  {
    this.DataVenc = DataVenc;
  }
  
  public String getDataLiq()
  {
    return this.DataLiq;
  }
  
  public void setDataLiq(String DataLiq)
  {
    this.DataLiq = DataLiq;
  }
  
  public double getValorTotal()
  {
    return this.ValorTotal;
  }
  
  public void setValorTotal(double ValorTotal)
  {
    this.ValorTotal = ValorTotal;
  }
  
  public double getValorPendente()
  {
    return this.ValorPendente;
  }
  
  public void setValorPendente(double ValorPendente)
  {
    this.ValorPendente = ValorPendente;
  }
  
  public String getDescDoc()
  {
    return this.DescDoc;
  }
  
  public void setDescDoc(String DescDoc)
  {
    this.DescDoc = DescDoc;
  }
  
  public String toString()
  {
    return "Result [Modulo=" + this.Modulo + ", TipoDoc=" + this.TipoDoc + ", NumDocu=" + this.NumDocu + ", DataDoc=" + this.DataDoc + ", DataVenc=" + this.DataVenc + ", DataLiq=" + this.DataLiq + ", ValorTotal=" + this.ValorTotal + ", ValorPendente=" + this.ValorPendente + ", DescDoc=" + this.DescDoc + "]";
  }
}
