package com.xxl.job.executor.service.jobhandler;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xxl.job.admin.core.model.XxlJobSQL;
import com.xxl.job.admin.core.model.XxlJobSubSQL;
import com.xxl.job.admin.dao.IXxlJobSQLDao;
import com.xxl.job.core.biz.model.ReturnT;
import com.xxl.job.core.handler.IJobHandler;
import com.xxl.job.core.handler.annotation.JobHander;
import com.xxl.job.core.log.XxlJobLogger;
import com.xxl.job.database.pool.DBConnectionPool;

import utils.ExportXlsTest;
import utils.JavaMail;

import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;


@JobHander(value = "sqlJobHandler")
@Service
public class SQLJobHandler extends IJobHandler {
	@Resource
    public IXxlJobSQLDao xxlJobSQLDao;
    @Override
    public ReturnT<String> execute(String... params) throws Exception {
        XxlJobLogger.log("XXL-JOB, Hello World."+params[0]);
        List<XxlJobSQL> list = xxlJobSQLDao.findAll();
        List<XxlJobSubSQL> subList=null;
        String recipient_lists="";
        String cc_lists="";
        String datasource_name="";
        for(XxlJobSQL xxlJobSQL:list){
        	String sqlList=xxlJobSQL.getSqlList();
        	JSONObject jsonObject = JSON.parseObject(sqlList);
        	String task_name = jsonObject.get("task_name").toString();
        	if(task_name.equals(params[0])){
        		JSONArray jsonArray = jsonObject.getJSONArray("subtasks");
        	    subList = jsonArray.toJavaList(XxlJobSubSQL.class);
        	    recipient_lists = jsonObject.get("recipient_lists").toString();
        		cc_lists = jsonObject.get("cc_lists").toString();
        		datasource_name = jsonObject.get("datasource_name").toString();
        	}
        }
        Connection connection = DBConnectionPool.getConnection(datasource_name);
        ExportXlsTest exportXlsTest=new ExportXlsTest();
        exportXlsTest.exportXls(connection, new FileOutputStream(new File("D:\\test1.xls")), subList);
        JavaMail javaMail=new JavaMail(true);
        javaMail.doSendHtmlEmail("主題","内容", recipient_lists, params[0], new FileInputStream(new File("D:\\test1.xls")));
        
        
        for (int i = 0; i < 5; i++) {
            XxlJobLogger.log("beat at:" + i);
            TimeUnit.SECONDS.sleep(2);
        }
        return ReturnT.SUCCESS;
    }

}
