package org.uci.opus.cbu.domain;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class Course {
	private String code;
	private String name;
	private Programme programme;
	private int yearOfStudy;
	private boolean active;
	private Lecturer lecturer;

	public String getCode() {
		return code!=null?code.trim():code;
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

	public Programme getProgramme() {
		return programme;
	}

	public void setProgramme(Programme programme) {
		this.programme = programme;
	}

	public int getYearOfStudy() {
		return yearOfStudy;
	}

	public void setYearOfStudy(int yearOfStudy) {
		this.yearOfStudy = yearOfStudy;
	}

	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}

	public Lecturer getLecturer() {
		return lecturer;
	}

	public void setLecturer(Lecturer lecturer) {
		this.lecturer = lecturer;
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
		return getClass().getName() + " = [" + values +",active = "+active+"]";
	}
}
