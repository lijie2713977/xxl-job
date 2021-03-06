<!DOCTYPE html>
<html>
<head>
    <title>任务调度中心</title>
    <style type="text/css" rel="stylesheet">
        .table th, .table td {
            text-align: center;
            vertical-align: middle !important;
        }
    </style>
<#import "/common/common.macro.ftl" as netCommon>
<@netCommon.commonStyle />
    <!-- DataTables -->
    <link rel="stylesheet" href="${request.contextPath}/static/adminlte/plugins/datatables/dataTables.bootstrap.css">
</head>
<body class="hold-transition skin-blue sidebar-mini <#if cookieMap?exists && "off" == cookieMap["adminlte_settings"].value >sidebar-collapse</#if> ">

<div class="wrapper">
    <!-- header -->
<@netCommon.commonHeader />
    <!-- left -->
<@netCommon.commonLeft "jobsql" />

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>数据源管理
                <small>任务调度中心</small>
            </h1>
        </section>

        <!-- Main content -->
        <section class="content">

            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                            <h3 class="box-title">SQL任务列表</h3>&nbsp;&nbsp;
                            <button class="btn btn-info btn-xs pull-left2 add">+新增</button>
                        </div>
                        <div class="box-body">
                            <table id="joblog_list" class="table table-bordered table-striped display" width="100%">
                                <thead>
                                <tr>
                                <#--<th name="id" >ID</th>-->
                                    <th name="order">序号</th>
                                    <th name="appName">任务名称</th>
                                    <th name="appName">数据源名称</th>
                                    <th name="operate">操作</th>
                                </tr>
                                </thead>
                                <tbody>
                                <#if list?exists && list?size gt 0>
                                    <#list list as group>
                                        <#assign sqllist="${group.sqlList}"?eval />

                                    <tr>
                                        <td>${group.id}</td>
                                        <td>${sqllist.task_name}</td>
                                        <td>${sqllist.datasource_name}</td>
                                        <td>
                                            <button class="btn btn-warning btn-xs update" data-toggle="modal"
                                                    id="${group.id}"
                                                    task_name="${sqllist.task_name}"
                                                    datasource_name="${sqllist.datasource_name}"
                                                    cc_lists="${sqllist.cc_lists}"
                                                    recipient_lists="${sqllist.recipient_lists}"
                                            >编辑任务
                                            </button>
                                            <button class="btn btn-danger btn-xs remove" id="${group.id}">删除</button>
                                            <button class="btn btn-warning btn-xs updateSub" data-toggle="modal"
                                                    id="${group.id}">编辑子任务
                                            </button>

                                        </td>
                                    </tr>
                                    </#list>
                                </#if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- 新增.模态框 -->
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog ">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">新增执行器</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal form" role="form">
                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">任务名称：<font color="red">*</font></label>
                            <div class="col-sm-9"><input type="text" class="form-control" name="task_name"
                                                         placeholder="请输入“任务名称”"></div>
                        </div>


                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">选择数据源：<font
                                    color="red">*</font></label>
                            <div class="col-sm-9">
                                <select class="form-control glueType" name="datasource_name">
                                <#list echoList as item>
                                    <option value="${item}">${item}</option>
                                </#list>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">发送邮件列表：<font
                                    color="red">*</font></label>
                            <div class="col-sm-9"><input type="text" class="form-control" name="recipient_lists"
                                                         placeholder="请输入“发件人”"></div>
                        </div>
                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">抄送邮件列表：<font
                                    color="red">*</font></label>
                            <div class="col-sm-9"><input type="text" class="form-control" name="cc_lists"
                                                         placeholder="请输入“抄送人”"></div>
                        </div>


                        <div class="form-group">
                            <div class="col-sm-offset-3 col-sm-6">
                                <button type="submit" class="btn btn-primary">保存</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- 更新.模态框 -->
    <div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog ">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title">任务</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal form" role="form">
                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">任务名称：<font color="red">*</font></label>
                            <div class="col-sm-9"><input type="text" class="form-control" name="task_name"
                                                         placeholder="请输入“任务名称”"></div>
                        </div>
                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">选择数据源：<font
                                    color="red">*</font></label>
                            <div class="col-sm-9">
                                <select class="form-control glueType" name="datasource_name">
                                <#list echoList as item>
                                    <option value="${item}">${item}</option>
                                </#list>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">发送邮件列表：<font
                                    color="red">*</font></label>
                            <div class="col-sm-9"><input type="text" class="form-control" name="recipient_lists"
                                                         placeholder="请输入“发件人”"></div>
                        </div>
                        <div class="form-group">
                            <label for="lastname" class="col-sm-3 control-label">抄送邮件列表：<font
                                    color="red">*</font></label>
                            <div class="col-sm-9"><input type="text" class="form-control" name="cc_lists"
                                                         placeholder="请输入“抄送人”"></div>
                        </div>

                        <hr>
                        <div class="form-group">
                            <div class="col-sm-offset-3 col-sm-6">
                                <button type="submit" class="btn btn-primary">保存</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                                </button>
                                <input type="hidden" name="id">
                            </div>
                        </div>
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
                                                         id="subtask_name"
                                                         placeholder="请输入子任务名称"></div>
                        </div>

                        <div class="form-group">
                            <label for="lastname" class="col-sm-2 control-label">SQL脚本：<font
                                    color="red">*</font></label>
                            <div class="col-sm-8"><textarea class="form-control" rows="3" name="sql" id="sql"
                                                            placeholder="请输入SQL脚本"></textarea></div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-3 col-sm-6">
                                <a class="btn btn-default subAdd">+新增</a>
                                <a class="btn btn-default subSave">+保存</a>
                                <a type="submit" class="btn btn-default testsql">测试SQL</a>
                                <button type="button" id="rebut" class="btn btn-default" data-dismiss="modal">取消
                                </button>
                                <div class="col-sm-9" id="errMsg" style="display: none;"><font color="red">测试失败!</font>
                                </div>
                                <div class="col-sm-9" id="rigMsg" style="display: none;"><font
                                        color="green">测试成功!</font></div>
                                <input type="hidden" name="sid">
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
                                </tbody>
                            </table>
                        </div>
                </div>

            </div>
            </form>
        </div>

    </div>

</div>
<!-- footer -->
<@netCommon.commonFooter />
</div>

<@netCommon.commonScript />
<!-- DataTables -->
<script src="${request.contextPath}/static/adminlte/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="${request.contextPath}/static/adminlte/plugins/datatables/dataTables.bootstrap.min.js"></script>
<#-- jquery.validate -->
<script src="${request.contextPath}/static/plugins/jquery/jquery.validate.min.js"></script>
<script src="${request.contextPath}/static/js/jobsql.index.1.js"></script>
</body>
</html>
