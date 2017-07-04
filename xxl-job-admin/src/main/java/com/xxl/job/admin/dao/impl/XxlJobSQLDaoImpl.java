package com.xxl.job.admin.dao.impl;

import com.xxl.job.admin.core.model.XxlJobInfo;
import com.xxl.job.admin.core.model.XxlJobSQL;
import com.xxl.job.admin.core.model.XxlJobSQLEntity;
import com.xxl.job.admin.dao.IXxlJobSQLDao;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;


@Repository
public class XxlJobSQLDaoImpl implements IXxlJobSQLDao {

    @Resource
    public SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<XxlJobSQL> findAll() {
        return sqlSessionTemplate.selectList("XxlJobSQLMapper.findAll");
    }

    @Override
    public String querySubTasks(int id) {
        XxlJobSQL xxlJobSQL = sqlSessionTemplate.selectOne("XxlJobSQLMapper.queryTaskById", id);
        return xxlJobSQL.getSqlList();
    }

    @Override
    public int update(int id, String jsonStr) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("id", id);
        params.put("sqlList", jsonStr);
        return sqlSessionTemplate.update("XxlJobSQLMapper.updateSubTask", params);
    }

    @Override
    public String queryTasks(int id) {
        XxlJobSQL xxlJobSQL = sqlSessionTemplate.selectOne("XxlJobSQLMapper.queryTaskById", id);
        return xxlJobSQL.getSqlList();
    }

    /**
     * 查询所有数据
     *
     * @return
     */
    public List<XxlJobSQLEntity> findAllEntity() {
        return sqlSessionTemplate.selectList("XxlJobSQLEntityMapper.findAll");
    }
    
    @Override
    public List<XxlJobInfo> pageList(int offset, int pagesize, int jobGroup, String executorHandler) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("offset", offset);
        params.put("pagesize", pagesize);
        params.put("jobGroup", jobGroup);
        params.put("executorHandler", executorHandler);

        return sqlSessionTemplate.selectList("XxlJobInfoMapper.pageList", params);
    }

    @Override
    public int pageListCount(int offset, int pagesize, int jobGroup, String executorHandler) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("offset", offset);
        params.put("pagesize", pagesize);
        params.put("jobGroup", jobGroup);
        params.put("executorHandler", executorHandler);

        return sqlSessionTemplate.selectOne("XxlJobInfoMapper.pageListCount", params);
    }

    @Override
    public int save(String sqlList) {
        return sqlSessionTemplate.insert("XxlJobSQLMapper.save", sqlList);
    }

    @Override
    public XxlJobInfo loadById(int id) {
        return sqlSessionTemplate.selectOne("XxlJobInfoMapper.loadById", id);
    }

    @Override
    public int update(XxlJobSQL xxlJobSQL) {
        return sqlSessionTemplate.update("XxlJobSQLMapper.update", xxlJobSQL);
    }

    @Override
    public int remove(int id) {
        return sqlSessionTemplate.update("XxlJobSQLMapper.remove", id);
    }

    @Override
    public List<XxlJobInfo> getJobsByGroup(String jobGroup) {
        return sqlSessionTemplate.selectList("XxlJobInfoMapper.getJobsByGroup", jobGroup);
    }

    @Override
    public int findAllCount() {
        return sqlSessionTemplate.selectOne("XxlJobInfoMapper.findAllCount");
    }


}
