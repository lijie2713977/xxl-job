package com.xxl.job.admin.core.model;

public class XxlJobSubSQL {

    private int id;
    private String subtask_name;
    private String sql;

    public int getId() {
        return id;
    }

    

    public String getSql() {
        return sql;
    }

    public void setId(int id) {
        this.id = id;
    }

    

    public String getSubtask_name() {
		return subtask_name;
	}



	public void setSubtask_name(String subtask_name) {
		this.subtask_name = subtask_name;
	}



	public void setSql(String sql) {
        this.sql = sql;
    }
}
