<!DOCTYPE html>
<html>
<head>
  	<title>任务调度中心</title>
  	<#import "/common/common.macro.ftl" as netCommon>
	<@netCommon.commonStyle />
	<!-- DataTables -->
  	<link rel="stylesheet" href="${request.contextPath}/static/adminlte/plugins/datatables/dataTables.bootstrap.css">

</head>
<body class="hold-transition skin-blue sidebar-mini <#if cookieMap?exists && "off" == cookieMap["adminlte_settings"].value >sidebar-collapse</#if>">
<div class="wrapper">
	<!-- header -->
	<@netCommon.commonHeader />
	<!-- left -->
	<@netCommon.commonLeft "jobinfo" />
	
	<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper">
		<!-- Content Header (Page header) -->
		<section class="content-header">
			<h1>任务管理<small>任务调度中心</small></h1>
			<!--
			<ol class="breadcrumb">
				<li><a><i class="fa fa-dashboard"></i>调度管理</a></li>
				<li class="active">调度中心</li>
			</ol>
			-->
		</section>
		
		<!-- Main content -->
	    <section class="content">
	    
	    	<div class="row">
	    		<div class="col-xs-4">
	              	<div class="input-group">
	                	<span class="input-group-addon">执行器</span>
                		<select class="form-control" id="jobGroup" >
                			<#list JobGroupList as group>
                				<option value="${group.id}" >${group.title}</option>
                			</#list>
	                  	</select>
	              	</div>
	            </div>
                <div class="col-xs-4">
                    <div class="input-group">
                        <span class="input-group-addon">JobHandler</span>
                        <input type="text" class="form-control" id="executorHandler" autocomplete="on" >
                    </div>
                </div>
	            <div class="col-xs-2">
	            	<button class="btn btn-block btn-info" id="searchBtn">搜索</button>
	            </div>
	            <div class="col-xs-2">
	            	<button class="btn btn-block btn-success add" type="button">+新增任务</button>
	            </div>
          	</div>
	    	
			<div class="row">
				<div class="col-xs-12">
					<div class="box">
			            <div class="box-header">
			            	<h3 class="box-title">调度列表</h3>
			            </div>
			            <div class="box-body" >
			              	<table id="job_list" class="table table-bordered table-striped">
				                <thead>
					            	<tr>
					            		<th name="id" >id</th>
					                	<th name="jobGroup" >jobGroup</th>
                                        <th name="childJobKey" >JobKey</th>
					                  	<th name="jobDesc" >描述</th>
                                        <th name="glueType" >运行模式</th>
					                  	<th name="executorParam" >任务参数</th>
                                        <th name="jobCron" >Cron</th>
					                  	<th name="addTime" >新增时间</th>
					                  	<th name="updateTime" >更新时间</th>
					                  	<th name="author" >负责人</th>
					                  	<th name="alarmEmail" >报警邮件</th>
					                  	<th name="glueType" >运行模式</th>
					                  	<th name="jobStatus" >状态</th>
					                  	<th>操作</th>
					                </tr>
				                </thead>
				                <tbody></tbody>
				                <tfoot></tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
	    </section>
	</div>
	
	<!-- footer -->
	<@netCommon.commonFooter />
</div>

<!-- job新增.模态框 -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog"  aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
            	<h4 class="modal-title" >新增任务</h4>
         	</div>
         	<div class="modal-body">
				<form class="form-horizontal form" role="form" >
					<div class="form-group">
						<label for="firstname" class="col-sm-2 control-label">执行器<font color="red">*</font></label>
						<div class="col-sm-4">
							<select id="typeid" class="form-control executorSelect" name="jobGroup" onchange="gettypename()">
		            			<#list JobGroupList as group>
		            				<option value="${group.id}">${group.title}</option>
		            			</#list>
		                  	</select>
                            <input id="typename" name="typename" type="hidden" value=""/>
						</div>
                        <label for="lastname" class="col-sm-2 control-label">任务描述<font color="red">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="jobDesc" placeholder="请输入“描述”" maxlength="50" ></div>
					</div>
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">路由策略<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control" name="executorRouteStrategy" >
							<#list ExecutorRouteStrategyEnum as item>
                                <option value="${item}" >${item.title}</option>
							</#list>
                            </select>
                        </div>
                        <label for="lastname" class="col-sm-2 control-label">Cron<font color="red">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="jobCron" placeholder="请输入“Cron”" maxlength="20" ></div>
                    </div>
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">运行模式<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control glueType" name="glueType" >
								<#list GlueTypeEnum as item>
									<option value="${item}" >${item.desc}</option>
								</#list>
                            </select>
                        </div>
                        <label for="firstname" class="col-sm-2 control-label">JobHandler<font color="black">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="executorHandler" placeholder="请输入“JobHandler”" maxlength="100" ></div>
                    </div>
                    <div class="form-group">
                        <#--<input id="exeParameters" name="exeParameters" type="hidden" value="32"/>-->
                        <label for="firstname" class="col-sm-2 control-label">执行参数<font color="black">*</font></label>
                            <#--<div id="exeParameters1" style="display: none;">-->
                                <#--<div class="col-sm-4"><input type="text" class="form-control" name="executorParam"-->
                                                             <#--placeholder="请输入“执行参数”" maxlength="100"></div>-->
                            <#--</div>-->
                            <#--<div id="exeParameters2" style="display: none;">-->
                                <#--<div class="col-sm-4"><select class="form-control glueType"-->
                                                              <#--name="datasource_name"><#list echoList as item>-->
                                    <#--<option value="0">选择SQL</option>-->
                                    <#--<option value="${item}">${item}</option> </#list></select>" +-->
                                    <#--<button type="button" class="btn btn-warning btn-xs updateSub" id="2321">新建SQL2-->
                                    <#--</button>-->
                                <#--</div>-->
                            <#--</div>-->
                            <#--<div id="exeParameters3" style="display: none;">22</div>-->
                            <#--<div id="exeParameters4" style="display: none;">2223</div>-->
                            <div id="exeParameters"></div>
					<#--<#if "${exeParameters}" == 1>-->

					<#--<#elseif "${exeParameters}" == 2>-->
                        <#--x is 2-->
					<#--<#else>-->
                        <#--<div class="col-sm-4"><input type="text" class="form-control" name="executorParam"-->
                                                     <#--placeholder="请输入“执行参数”" maxlength="100"></div>-->
					<#--</#if>-->
                        <label for="lastname" class="col-sm-2 control-label">子任务Key<font color="black">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="childJobKey" placeholder="请输入子任务的任务Key,如存在多个逗号分隔" maxlength="100" ></div>
                    </div>
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">阻塞处理策略<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control" name="executorBlockStrategy" >
								<#list ExecutorBlockStrategyEnum as item>
									<option value="${item}" >${item.title}</option>
								</#list>
                            </select>
						</div>
                        <label for="lastname" class="col-sm-2 control-label">失败处理策略<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control" name="executorFailStrategy" >
								<#list ExecutorFailStrategyEnum as item>
									<option value="${item}" >${item.title}</option>
								</#list>
                            </select>
						</div>
                    </div>
					<div class="form-group">
                        <label for="lastname" class="col-sm-2 control-label">负责人<font color="red">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="author" placeholder="请输入“负责人”" maxlength="50" ></div>
						<label for="lastname" class="col-sm-2 control-label">报警邮件<font color="black">*</font></label>
						<div class="col-sm-4"><input type="text" class="form-control" name="alarmEmail" placeholder="请输入“报警邮件”，多个邮件地址逗号分隔" maxlength="100" ></div>
					</div>

                    <hr>
					<div class="form-group">
						<div class="col-sm-offset-3 col-sm-6">
							<button type="submit" class="btn btn-primary"  >保存</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						</div>
					</div>

<input type="hidden" name="glueRemark" value="GLUE代码初始化" >
<textarea name="glueSource" style="display:none;" ></textarea>
<textarea class="glueSource_java" style="display:none;" >
package com.xxl.job.service.handler;

import com.xxl.job.core.log.XxlJobLogger;
import com.xxl.job.core.biz.model.ReturnT;
import com.xxl.job.core.handler.IJobHandler;

public class DemoGlueJobHandler extends IJobHandler {

	@Override
	public ReturnT<String> execute(String... params) throws Exception {
		XxlJobLogger.log("XXL-JOB, Hello World.");
		return ReturnT.SUCCESS;
	}

}
</textarea>
<textarea class="glueSource_shell" style="display:none;" >
#!/bin/bash
echo "xxl-job: hello shell"

echo "脚本位置：$0"
echo "参数数量：$#"
for param in $*
do
    echo "参数 : $param"
    sleep 1s
done

echo "Good bye!"
exit 0
</textarea>
<textarea class="glueSource_python" style="display:none;" >
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import time
import sys

print "xxl-job: hello python"
print "脚本文件：", sys.argv[0]
for i in range(1, len(sys.argv)):
	time.sleep(1)
	print "参数", i, sys.argv[i]

print "Good bye!"
exit(0)<#--
import logging
logging.basicConfig(level=logging.DEBUG)
logging.info("脚本文件：" + sys.argv[0])
-->
</textarea>
					
				</form>
         	</div>
		</div>
	</div>
</div>

<!-- 子更新.模态框 -->
<div class="modal fade" id="updateSubModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">子任务</h4>
            </div>

            <div class="modal-body">
                <form class="form-horizontal form" role="form">
                    <div class="form-group">
                        <label for="lastname" class="col-sm-2 control-label">子任务名称：<font
                                color="red">*</font></label>
                        <div class="col-sm-8"><input type="text" class="form-control" name="subtask_name"
                                                     placeholder="请输入子任务名称"></div>
                    </div>

                    <div class="form-group">
                        <label for="lastname" class="col-sm-2 control-label">SQL脚本：<font
                                color="red">*</font></label>
                        <div class="col-sm-8"><textarea class="form-control" rows="3" name="sql"
                                                        placeholder="请输入SQL脚本"></textarea></div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-3 col-sm-6">
                            <button class="btn btn-default add">+新增</button>
                            <button class="btn btn-default save">+保存</button>
                            <a type="submit" class="btn btn-default testsql">测试SQL</a>
                            <button type="button" id="rebut" class="btn btn-default" data-dismiss="modal">取消
                            </button>
                            <div class="col-sm-9" id="errMsg" style="display: none;"><font color="red">测试失败!</font>
                            </div>
                            <div class="col-sm-9" id="rigMsg" style="display: none;"><font
                                    color="green">测试成功!</font></div>
                            <input type="hidden" name="id">
                        </div>
                    </div>

                    <div class="form-group">
                        <table id="joblog_list" class="table table-bordered table-striped display" width="100%">
                            <thead>
                            <tr>
                                <th name="id">序号</th>
                                <th name="subtasks">子任务名称</th>
                                <th name="operate">操作</th>
                            </tr>
                            </thead>
                            <tbody id="subtasklist">
							<#--<#assign sqllist="${group.sqlList}"?eval />-->
                                <#--<#list sqllist.subtasks as item>-->
                                <#--<tr>-->
                                    <#--<td>${item_index+1}</td>-->
                                    <#--<td>${item.subtask_name}</td>-->
                                    <#--<input type="hidden" name="sql">-->
                                    <#--<td>-->
                                        <#--<button class="btn btn-warning btn-xs updateSub"-->
                                                <#--id="${item_index+1}"-->
                                                <#--subtask_name="${item.subtask_name}"-->
                                                <#--sql="${item.sql}">编辑-->
                                        <#--</button>-->
                                        <#--<button class="btn btn-danger btn-xs remove" id="${item.subtask_name}">删除-->
                                        <#--</button>-->
                                        <#--<button class="btn btn-warning btn-xs up" id="${item.subtask_name}">上移</button>-->
                                        <#--<button class="btn btn-warning btn-xs down" id="${item.subtask_name}">下移-->
                                        <#--</button>-->
                                    <#--</td>-->
                                <#--</tr>-->
                                <#--</#list>-->
                            </tbody>
                        </table>
                    </div>
            </div>
            <!--<div class="modal-footer">
                  <button type="button" id="rebut" class="btn btn-default" data-dismiss="modal">关闭
                  </button>

              </div>-->
		<#--<hr>-->

        </div>
        </form>
    </div>

</div>

<!-- 更新.模态框 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog"  aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
            	<h4 class="modal-title" >更新任务</h4>
         	</div>
         	<div class="modal-body">
				<form class="form-horizontal form" role="form" >
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">执行器<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control" name="jobGroup" disabled >
							<#list JobGroupList as group>
                                <option value="${group.id}" >${group.title}</option>
							</#list>
                            </select>
                        </div>
                        <label for="lastname" class="col-sm-2 control-label">任务描述<font color="red">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="jobDesc" placeholder="请输入“描述”" maxlength="50" ></div>
                    </div>
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">路由策略<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control" name="executorRouteStrategy" >
							<#list ExecutorRouteStrategyEnum as item>
                                <option value="${item}" >${item.title}</option>
							</#list>
                            </select>
                        </div>
                        <label for="lastname" class="col-sm-2 control-label">Cron<font color="red">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="jobCron" placeholder="请输入“Cron”" maxlength="20" ></div>
                    </div>
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">运行模式<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control glueType" name="glueType" disabled >
							<#list GlueTypeEnum as item>
                                <option value="${item}" >${item.desc}</option>
							</#list>
                            </select>
                        </div>
                        <label for="firstname" class="col-sm-2 control-label">JobHandler<font color="black">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="executorHandler" placeholder="请输入“JobHandler”" maxlength="100" ></div>
                    </div>
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">执行参数<font color="black">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="executorParam" placeholder="请输入“执行参数”" maxlength="100" ></div>
                        <label for="lastname" class="col-sm-2 control-label">子任务Key<font color="black">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="childJobKey" placeholder="请输入子任务的任务Key,如存在多个逗号分隔" maxlength="100" ></div>
                    </div>
                    <div class="form-group">
                        <label for="firstname" class="col-sm-2 control-label">阻塞处理策略<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control" name="executorBlockStrategy" >
							<#list ExecutorBlockStrategyEnum as item>
                                <option value="${item}" >${item.title}</option>
							</#list>
                            </select>
                        </div>
                        <label for="lastname" class="col-sm-2 control-label">失败处理策略<font color="red">*</font></label>
                        <div class="col-sm-4">
                            <select class="form-control" name="executorFailStrategy" >
							<#list ExecutorFailStrategyEnum as item>
                                <option value="${item}" >${item.title}</option>
							</#list>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="lastname" class="col-sm-2 control-label">负责人<font color="red">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="author" placeholder="请输入“负责人”" maxlength="50" ></div>
                        <label for="lastname" class="col-sm-2 control-label">报警邮件<font color="black">*</font></label>
                        <div class="col-sm-4"><input type="text" class="form-control" name="alarmEmail" placeholder="请输入“报警邮件”，多个邮件地址逗号分隔" maxlength="100" ></div>
                    </div>

					<hr>
					<div class="form-group">
                        <div class="col-sm-offset-3 col-sm-6">
							<button type="submit" class="btn btn-primary"  >保存</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                            <input type="hidden" name="id" >
						</div>
					</div>
				</form>
         	</div>
		</div>
	</div>
</div>

<@netCommon.commonScript />
<!-- DataTables -->
<script src="${request.contextPath}/static/adminlte/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="${request.contextPath}/static/adminlte/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script src="${request.contextPath}/static/plugins/jquery/jquery.validate.min.js"></script>
<!-- moment -->
<script src="${request.contextPath}/static/adminlte/plugins/daterangepicker/moment.min.js"></script>
<script src="${request.contextPath}/static/js/jobinfo.index.1.js"></script>

<#--<link href="${request.contextPath}/static/adminlte/bootstrap-datetimepicker/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">-->
<#--<link href="../css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">-->
<#--<script type="text/javascript" src="${request.contextPath}/static/adminlte/bootstrap-datetimepicker/jquery/jquery-1.8.3.min.js" charset="UTF-8"></script>-->
<#--<script type="text/javascript" src="${request.contextPath}/static/adminlte/bootstrap-datetimepicker/bootstrap/js/bootstrap.min.js"></script>-->
<#--<script type="text/javascript" src="${request.contextPath}/static/adminlte/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>-->
<#--<script type="text/javascript" src="${request.contextPath}/static/adminlte/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.fr.js" charset="UTF-8"></script>-->

</body>
</html>
