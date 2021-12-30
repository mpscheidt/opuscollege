package org.uci.opus.cbu.domain;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class SecondarySchool {
	private String code;
	private String name;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return prettyFormat(name);
	}

	public void setName(String name) {
		this.name = name;
	}

	private String prettyFormat(String words){
		String value=null;
		if(words!=null){
			value="";
			String[] word=words.split(" ");
			for(int i=0;i<word.length;i++){
				if(word[i].equalsIgnoreCase("i") || word[i].equalsIgnoreCase("ii") || word[i].equalsIgnoreCase("iii"))
					word[i]=word[i].toUpperCase().trim();
				else if(word[i].equalsIgnoreCase("and") || word[i].equalsIgnoreCase("of") || word[i].equalsIgnoreCase("in"))
					word[i]=word[i].toLowerCase().trim();
				else if(word[i].length()>1)
					word[i]=word[i].substring(0,1).toUpperCase()+word[i].substring(1).toLowerCase().trim();
				
				value+=word[i]+" ";
			}
		}
		return value.trim();
	}
	@Override
	public String toString() {
		String values = "";
		Field[] fields = getClass().getDeclaredFields();
		Method[] methods = getClass().getDeclaredMethods();

		for (Field f : fields) {
			try {
				for (Method m : methods) {
					if (Modifier.isPublic(m.getModifiers())	&& (f.getName().length() == 1 || (m.getName().indexOf("get"+ f.getName().substring(0, 1).toUpperCase() + f.getName().substring(1)) != -1))) {
						values += f.getName() + " = " + f.get(this) + ", ";
						break;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		values=values.substring(0,values.lastIndexOf(","));
		return getClass().getName() + " = [" + values +"]";
	}
}
