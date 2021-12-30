package org.uci.opus.cbu.domain;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class Programme {
	private String code;
	private String name;
	private String programmeLevel;
	private SchoolDepartment department;
	private int cutOffPointMale;
	private int cutOffPointFemale;
	private int programmeDuration;
	private int yearStopped;
	private int yearStarted;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getProgrammeLevel() {
		return programmeLevel;
	}

	public void setProgrammeLevel(String programmeLevel) {
		this.programmeLevel = programmeLevel;
	}

	public SchoolDepartment getDepartment() {
		return department;
	}

	public void setDepartment(SchoolDepartment department) {
		this.department = department;
	}

	public int getCutOffPointMale() {
		return cutOffPointMale;
	}

	public void setCutOffPointMale(int cutOffPointMale) {
		this.cutOffPointMale = cutOffPointMale;
	}

	public int getCutOffPointFemale() {
		return cutOffPointFemale;
	}

	public void setCutOffPointFemale(int cutOffPointFemale) {
		this.cutOffPointFemale = cutOffPointFemale;
	}

	public int getProgrammeDuration() {
		return programmeDuration;
	}

	public void setProgrammeDuration(int programmeDuration) {
		this.programmeDuration = programmeDuration;
	}
	
	public int getYearStopped() {
		return yearStopped;
	}

	public void setYearStopped(int yearStopped) {
		this.yearStopped = yearStopped;
	}

	public int getYearStarted() {
		return yearStarted;
	}

	public void setYearStarted(int yearStarted) {
		this.yearStarted = yearStarted;
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
		return getClass().getName() + " = [" + values + "]";
	}
}
