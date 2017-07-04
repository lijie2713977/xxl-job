package com.xxl.job.admin.dao;

import com.xxl.job.admin.core.model.XxlJobInfo;
import com.xxl.job.admin.core.model.XxlJobSQL;

import java.util.List;


public interface IXxlJobSQLDao {

    /**
     * 查询所有数据
     *
     * @return
     */
    public List<XxlJobSQL> findAll();

    /**
     * 任务id
     *
     * @param id 任务ID
     * @return
     */
    public String queryTasks(int id);

    /**
     * 子任务id
     *
     * @param id 任务ID
     * @return
     */
    public String querySubTasks(int id);

    /**
     * 更新子任务
     * @param id
     * @param jsonStr 子任务json转化后的字符串
     * @return
     */
    public int update(int id,String jsonStr);

    public List<XxlJobInfo> pageList(int offset, int pagesize, int jobGroup, String executorHandler);

    public int pageListCount(int offset, int pagesize, int jobGroup, String executorHandler);

    public int save(String sqlList);

    public XxlJobInfo loadById(int id);

    public int update(XxlJobSQL xxlJobSQL);

    public int remove(int id);

    public List<XxlJobInfo> getJobsByGroup(String jobGroup);

    public int findAllCount();


}
