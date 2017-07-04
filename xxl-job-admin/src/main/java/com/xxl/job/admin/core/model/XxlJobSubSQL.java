package com.xxl.job.admin.core.model;

public class XxlJobSubSQL {
    private String subtask_name;
    private String sql;

    public String getSql() {
        return sql;
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
