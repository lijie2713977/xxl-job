package com.xxl.job.admin.controller;


import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xxl.job.admin.core.model.XxlJobSQL;
import com.xxl.job.admin.core.model.XxlJobSubSQL;
import com.xxl.job.admin.dao.IXxlJobInfoDao;
import com.xxl.job.admin.dao.IXxlJobSQLDao;
import com.xxl.job.core.biz.model.ReturnT;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * SQL控制器
 */
@Controller
@RequestMapping("/jobsql")
public class JobSQLController {
    public static final String datasourceDeploy = JobDataSourceController.class.getClassLoader().getResource("").getPath() + "deploy/datasource";
    @Resource
    public IXxlJobInfoDao xxlJobInfoDao;
    @Resource
    public IXxlJobSQLDao xxlJobSQLDao;

    @RequestMapping
    public String index(Model model) {

        List<XxlJobSQL> list = xxlJobSQLDao.findAll();

        File file = new File(datasourceDeploy.substring(1, datasourceDeploy.length()));
//        System.out.println("数据源路径：" + datasourceDeploy.substring(1, datasourceDeploy.length()));
        File[] listFiles = file.listFiles();
        List<String> echoList = new ArrayList<>();
        for (File dataName : listFiles) {
            echoList.add(dataName.getName());
        }
        model.addAttribute("echoList", echoList);

        model.addAttribute("list", list);
        return "jobsql/jobsql.index";
    }

    @RequestMapping("/subTaskList")
    @ResponseBody
    public String subTaskList(int id) {
        String subTasks = xxlJobSQLDao.querySubTasks(id);
        JSONObject jsonObject = JSON.parseObject(subTasks);//json字符串转换成jsonobject对象
        JSONArray jsonArray = jsonObject.getJSONArray("subtasks");
        String jsonStr = jsonArray.toJSONString();//JSONArray转化json字符串
        return jsonStr;
    }


    @RequestMapping("/save")
    @ResponseBody
    public ReturnT<String> save(XxlJobSQL xxlJobSQL) {

        // valid
        if (xxlJobSQL.getTask_name() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入任务名称");
        }
        if (xxlJobSQL.getDatasource_name() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入数据源");
        }
        if (xxlJobSQL.getCc_lists() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入发件人");
        }
        if (xxlJobSQL.getRecipient_lists() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入收件人");
        }

        String sqlList = JSON.toJSONString(xxlJobSQL);
        int ret = xxlJobSQLDao.save(sqlList);
        return (ret > 0) ? ReturnT.SUCCESS : ReturnT.FAIL;
    }

    @RequestMapping("/update")
    @ResponseBody
    public ReturnT<String> update(XxlJobSQL xxlJobSQL, int id) {

        // valid
        if (xxlJobSQL.getTask_name() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入任务名称");
        }
        if (xxlJobSQL.getDatasource_name() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入数据源");
        }
        if (xxlJobSQL.getCc_lists() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入发件人");
        }
        if (xxlJobSQL.getRecipient_lists() == null || StringUtils.isBlank(xxlJobSQL.getTask_name())) {
            return new ReturnT<String>(500, "请输入收件人");
        }

        String sqlList = JSON.toJSONString(xxlJobSQL);
        xxlJobSQL.setSqlList(sqlList);
        xxlJobSQL.setId(id);
        int ret = xxlJobSQLDao.update(xxlJobSQL);
        return (ret > 0) ? ReturnT.SUCCESS : ReturnT.FAIL;
    }

   

    @RequestMapping("/subSave")
    @ResponseBody
    public ReturnT<String> subSave(XxlJobSubSQL xxlJobSubSQL,int id) {
        // valid
       String sqlList = xxlJobSQLDao.querySubTasks(id);
       JSONObject jsonObject = JSON.parseObject(sqlList);//json字符串转换成jsonobject对象
       JSONArray jsonArray = jsonObject.getJSONArray("subtasks");
       String task_name=jsonObject.get("task_name").toString();
       String datasource_name =jsonObject.get("datasource_name").toString();
       String recipient_lists=jsonObject.get("recipient_lists").toString();
       String cc_lists=jsonObject.getJSONObject("cc_lists").toString();
       List<XxlJobSubSQL> subList = jsonArray.toJavaList(XxlJobSubSQL.class);
       subList.add(xxlJobSubSQL);
       XxlJobSQL jobSQL=new XxlJobSQL();
        jobSQL.setId(id);
        jobSQL.setTask_name(task_name);
        jobSQL.setRecipient_lists(recipient_lists);
        jobSQL.setDatasource_name(datasource_name);
        jobSQL.setCc_lists(cc_lists);
        jobSQL.setSubtasks(subList);
        String newSqlList = JSON.toJSONString(jobSQL);
        jobSQL.setSqlList(sqlList);
        int ret = xxlJobSQLDao.update(jobSQL);
        return (ret > 0) ? ReturnT.SUCCESS : ReturnT.FAIL;
        
    }

    @RequestMapping("/remove")
    @ResponseBody
    public ReturnT<String> remove(int id) {

        // valid
        int count = xxlJobInfoDao.pageListCount(0, 10, id, null);
        if (count > 0) {
            return new ReturnT<String>(500, "该分组使用中, 不可删除");
        }

        List<XxlJobSQL> allList = xxlJobSQLDao.findAll();
        if (allList.size() == 1) {
            return new ReturnT<String>(500, "删除失败, 系统需要至少预留一个默认分组");
        }

        int ret = xxlJobSQLDao.remove(id);
        return (ret > 0) ? ReturnT.SUCCESS : ReturnT.FAIL;
    }

    @RequestMapping("/testsql")
    @ResponseBody
    public ReturnT<String> testSql(XxlJobSubSQL jobSubSql) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@172.16.136.253:1521:otestdb";
            String user = "query";// 用户名,系统默认的账户名
            String password = "query_on";// 你安装时选设置的密码
            Connection con = DriverManager.getConnection(url, user, password);// 获取连接
            PreparedStatement pre = con.prepareStatement(jobSubSql.getSql());// 实例化预编译语句
            String[] sqls = jobSubSql.getSql().split(" ");
            if (sqls[0].equals("select")) {
                ResultSet rs = pre.executeQuery();// 执行查询
                if (rs.next()) {
                    return ReturnT.SUCCESS;
                } else {
                    return ReturnT.FAIL;
                }
            } else {
                int rs = pre.executeUpdate();
                if (rs != -1) {
                    return ReturnT.SUCCESS;
                } else {
                    return ReturnT.FAIL;
                }
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return ReturnT.FAIL;
        }
    }


}
