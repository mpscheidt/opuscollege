package org.uci.opus.cbu.domain;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

public class Results {

	private String mark;
	private String grade;
	private Course course;
	private int year;
	private String comment;
	private String studyCategoryCode;
	
	public Course getCourse() {
		return course;
	}

	public void setCourse(Course course) {
		this.course = course;
	}

	public String getMark() {
		return mark;
	}

	public void setMark(String mark) {
		this.mark = mark;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}
	
	public String getComment(){
		return comment;
	}
	
	public void setComment(String comment){
		this.comment=comment;
	}
	
	public String getStudyCategoryCode() {
		return studyCategoryCode;
	}

	public void setStudyCategoryCode(String studyCategoryCode) {
		this.studyCategoryCode = studyCategoryCode;
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
