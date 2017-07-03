$(function() {
	// init date tables
	var jobTable = $("#job_list").dataTable({
		"deferRender": true,
		"processing" : true, 
	    "serverSide": true,
		"ajax": {
			url: base_url + "/jobinfo/pageList",
			type:"post",
	        data : function ( d ) {
	        	var obj = {};
	        	obj.jobGroup = $('#jobGroup').val();
	        	obj.executorHandler = $('#executorHandler').val();
	        	obj.start = d.start;
	        	obj.length = d.length;
                return obj;
            }
	    },
	    "searching": false,
	    "ordering": false,
	    //"scrollX": true,	// X轴滚动条，取消自适应
	    "columns": [
	                { "data": 'id', "bSortable": false, "visible" : false},
	                { 
	                	"data": 'jobGroup', 
	                	"visible" : false,
	                	"render": function ( data, type, row ) {
	            			var groupMenu = $("#jobGroup").find("option");
	            			for ( var index in $("#jobGroup").find("option")) {
	            				if ($(groupMenu[index]).attr('value') == data) {
									return $(groupMenu[index]).html();
								}
							}
	            			return data;
	            		}
            		},
					{
						"data": 'childJobKey',
						"width":'10%',
						"visible" : true,
						"render": function ( data, type, row ) {
							var jobKey = row.jobGroup + "_" + row.id;
							return jobKey;
						}
					},
	                { "data": 'jobDesc', "visible" : true,"width":'20%'},
					{
						"data": 'glueType',
						"width":'20%',
						"visible" : true,
						"render": function ( data, type, row ) {
							if ('GLUE_GROOVY'==row.glueType) {
								return "GLUE模式(Java)";
							} else if ('GLUE_SHELL'==row.glueType) {
								return "GLUE模式(Shell)";
							} else if ('GLUE_PYTHON'==row.glueType) {
								return "GLUE模式(Python)";
							} else if ('BEAN'==row.glueType) {
								return "BEAN模式：" + row.executorHandler;
							}
							return row.executorHandler;
						}
					},
	                { "data": 'executorParam', "visible" : false},
					{ "data": 'jobCron', "visible" : true,"width":'10%'},
	                { 
	                	"data": 'addTime', 
	                	"visible" : false, 
	                	"render": function ( data, type, row ) {
	                		return data?moment(new Date(data)).format("YYYY-MM-DD HH:mm:ss"):"";
	                	}
	                },
	                { 
	                	"data": 'updateTime', 
	                	"visible" : false, 
	                	"render": function ( data, type, row ) {
	                		return data?moment(new Date(data)).format("YYYY-MM-DD HH:mm:ss"):"";
	                	}
	                },
	                { "data": 'author', "visible" : true, "width":'10%'},
	                { "data": 'alarmEmail', "visible" : false},
	                { "data": 'glueType', "visible" : false},
	                { 
	                	"data": 'jobStatus',
						"width":'10%',
	                	"visible" : true,
	                	"render": function ( data, type, row ) {
	                		if ('NORMAL' == data) {
	                			return '<small class="label label-success" ><i class="fa fa-clock-o"></i>'+ data +'</small>'; 
							} else if ('PAUSED' == data){
								return '<small class="label label-default" title="暂停" ><i class="fa fa-clock-o"></i>'+ data +'</small>'; 
							} else if ('BLOCKED' == data){
								return '<small class="label label-default" title="阻塞[串行]" ><i class="fa fa-clock-o"></i>'+ data +'</small>'; 
							}
	                		return data;
	                	}
	                },
	                {
						"data": '操作' ,
						"width":'15%',
	                	"render": function ( data, type, row ) {
	                		return function(){
	                			// status
	                			var pause_resume = "";
	                			if ('NORMAL' == row.jobStatus) {
	                				pause_resume = '<button class="btn btn-primary btn-xs job_operate" _type="job_pause" type="button">暂停</button>  ';
								} else if ('PAUSED' == row.jobStatus){
									pause_resume = '<button class="btn btn-primary btn-xs job_operate" _type="job_resume" type="button">恢复</button>  ';
								}
	                			// log url
	                			var logUrl = base_url +'/joblog?jobId='+ row.id;
	                			
	                			// log url
	                			var codeBtn = "";
                                if ('BEAN' != row.glueType) {
									var codeUrl = base_url +'/jobcode?jobId='+ row.id;
									codeBtn = '<button class="btn btn-warning btn-xs" type="button" onclick="javascript:window.open(\'' + codeUrl + '\')" >GLUE</button>  '
								}

								// html
                                tableData['key'+row.id] = row;
								var html = '<p id="'+ row.id +'" >'+
									'<button class="btn btn-primary btn-xs job_operate" _type="job_trigger" type="button">执行</button>  '+
									pause_resume +
									'<button class="btn btn-primary btn-xs" type="job_del" type="button" onclick="javascript:window.open(\'' + logUrl + '\')" >日志</button><br>  '+
									'<button class="btn btn-warning btn-xs update" type="button">编辑</button>  '+
									codeBtn +
									'<button class="btn btn-danger btn-xs job_operate" _type="job_del" type="button">删除</button>  '+
									'</p>';

	                			return html;
							};
	                	}
	                }
	            ],
		"language" : {
			"sProcessing" : "处理中...",
			"sLengthMenu" : "每页 _MENU_ 条记录",
			"sZeroRecords" : "没有匹配结果",
			"sInfo" : "第 _PAGE_ 页 ( 总共 _PAGES_ 页，_TOTAL_ 条记录 )",
			"sInfoEmpty" : "无记录",
			"sInfoFiltered" : "(由 _MAX_ 项结果过滤)",
			"sInfoPostFix" : "",
			"sSearch" : "搜索:",
			"sUrl" : "",
			"sEmptyTable" : "表中数据为空",
			"sLoadingRecords" : "载入中...",
			"sInfoThousands" : ",",
			"oPaginate" : {
				"sFirst" : "首页",
				"sPrevious" : "上页",
				"sNext" : "下页",
				"sLast" : "末页"
			},
			"oAria" : {
				"sSortAscending" : ": 以升序排列此列",
				"sSortDescending" : ": 以降序排列此列"
			}
		}
	});

    // table data
    var tableData = {};

	// 搜索按钮
	$('#searchBtn').on('click', function(){
		jobTable.fnDraw();
	});
	
	// job operate
	$("#job_list").on('click', '.job_operate',function() {
		var typeName;
		var url;
		var needFresh = false;

		var type = $(this).attr("_type");
		if ("job_pause" == type) {
			typeName = "暂停";
			url = base_url + "/jobinfo/pause";
			needFresh = true;
		} else if ("job_resume" == type) {
			typeName = "恢复";
			url = base_url + "/jobinfo/resume";
			needFresh = true;
		} else if ("job_del" == type) {
			typeName = "删除";
			url = base_url + "/jobinfo/remove";
			needFresh = true;
		} else if ("job_trigger" == type) {
			typeName = "执行";
			url = base_url + "/jobinfo/trigger";
		} else {
			return;
		}
		
		var id = $(this).parent('p').attr("id");

		layer.confirm('确认' + typeName + '?', {icon: 3, title:'系统提示'}, function(index){
			layer.close(index);

			$.ajax({
				type : 'POST',
				url : url,
				data : {
					"id" : id
				},
				dataType : "json",
				success : function(data){
					if (data.code == 200) {

						layer.open({
							title: '系统提示',
							content: typeName + "成功",
							icon: '1',
							end: function(layero, index){
								if (needFresh) {
									//window.location.reload();
									jobTable.fnDraw();
								}
							}
						});
					} else {
						layer.open({
							title: '系统提示',
							content: (data.msg || typeName + "失败"),
							icon: '2'
						});
					}
				},
			});
		});
	});
	
	// jquery.validate 自定义校验 “英文字母开头，只含有英文字母、数字和下划线”
	jQuery.validator.addMethod("myValid01", function(value, element) {
		var length = value.length;
		var valid = /^[a-zA-Z][a-zA-Z0-9_]*$/;
		return this.optional(element) || valid.test(value);
	}, "只支持英文字母开头，只含有英文字母、数字和下划线");
	
	// 新增
	$(".add").click(function(){
		$('#addModal').modal({backdrop: false, keyboard: false}).modal('show');
	});
	var addModalValidate = $("#addModal .form").validate({
		errorElement : 'span',  
        errorClass : 'help-block',
        focusInvalid : true,  
        rules : {
			jobDesc : {
				required : true,
				maxlength: 50
			},
            jobCron : {
            	required : true
            },
			author : {
				required : true
			}
        }, 
        messages : {  
            jobDesc : {
            	required :"请输入“描述”."
            },
            jobCron : {
            	required :"请输入“Cron”."
            },
            author : {
            	required : "请输入“负责人”."
            }
        },
		highlight : function(element) {  
            $(element).closest('.form-group').addClass('has-error');  
        },
        success : function(label) {  
            label.closest('.form-group').removeClass('has-error');  
            label.remove();  
        },
        errorPlacement : function(error, element) {  
            element.parent('div').append(error);  
        },
        submitHandler : function(form) {
        	$.post(base_url + "/jobinfo/add",  $("#addModal .form").serialize(), function(data, status) {
    			if (data.code == "200") {
					$('#addModal').modal('hide');
					layer.open({
						title: '系统提示',
						content: '新增任务成功',
						icon: '1',
						end: function(layero, index){
							jobTable.fnDraw();
							//window.location.reload();
						}
					});
    			} else {
					layer.open({
						title: '系统提示',
						content: (data.msg || "新增失败"),
						icon: '2'
					});
    			}
    		});
		}
	});
	$("#addModal").on('hide.bs.modal', function () {
		$("#addModal .form")[0].reset();
		addModalValidate.resetForm();
		$("#addModal .form .form-group").removeClass("has-error");
		$(".remote_panel").show();	// remote

		$("#addModal .form input[name='executorHandler']").removeAttr("readonly");
	});


    // 运行模式
    $(".glueType").change(function(){
		// executorHandler
        var $executorHandler = $(this).parents("form").find("input[name='executorHandler']");
        var glueType = $(this).val();
        if ('BEAN' != glueType) {
            $executorHandler.val("");
            $executorHandler.attr("readonly","readonly");
        } else {
            $executorHandler.removeAttr("readonly");
        }
    });

	$("#addModal .glueType").change(function(){
		// glueSource
		var glueType = $(this).val();
		if ('GLUE_GROOVY'==glueType){
			$("#addModal .form textarea[name='glueSource']").val( $("#addModal .form .glueSource_java").val() );
		} else if ('GLUE_SHELL'==glueType){
			$("#addModal .form textarea[name='glueSource']").val( $("#addModal .form .glueSource_shell").val() );
		} else if ('GLUE_PYTHON'==glueType){
			$("#addModal .form textarea[name='glueSource']").val( $("#addModal .form .glueSource_python").val() );
		}
	});

	// 更新
	$("#job_list").on('click', '.update',function() {

        var id = $(this).parent('p').attr("id");
        var row = tableData['key'+id];
        if (!row) {
            layer.open({
                title: '系统提示',
                content: ("任务信息加载失败，请刷新页面"),
                icon: '2'
            });
            return;
        }

		// base data
		$("#updateModal .form input[name='id']").val( row.id );
		$('#updateModal .form select[name=jobGroup] option[value='+ row.jobGroup +']').prop('selected', true);
		$("#updateModal .form input[name='jobDesc']").val( row.jobDesc );
		$("#updateModal .form input[name='jobCron']").val( row.jobCron );
		$("#updateModal .form input[name='author']").val( row.author );
		$("#updateModal .form input[name='alarmEmail']").val( row.alarmEmail );
		$('#updateModal .form select[name=executorRouteStrategy] option[value='+ row.executorRouteStrategy +']').prop('selected', true);
		$("#updateModal .form input[name='executorHandler']").val( row.executorHandler );
		$("#updateModal .form input[name='executorParam']").val( row.executorParam );
        $("#updateModal .form input[name='childJobKey']").val( row.childJobKey );
		$('#updateModal .form select[name=executorBlockStrategy] option[value='+ row.executorBlockStrategy +']').prop('selected', true);
		$('#updateModal .form select[name=executorFailStrategy] option[value='+ row.executorFailStrategy +']').prop('selected', true);
		$('#updateModal .form select[name=glueType] option[value='+ row.glueType +']').prop('selected', true);

        $("#updateModal .form select[name=glueType]").change();

		// show
		$('#updateModal').modal({backdrop: false, keyboard: false}).modal('show');
	});
	var updateModalValidate = $("#updateModal .form").validate({
		errorElement : 'span',  
        errorClass : 'help-block',
        focusInvalid : true,

		rules : {
			jobDesc : {
				required : true,
				maxlength: 50
			},
			jobCron : {
				required : true
			},
			author : {
				required : true
			}
		},
		messages : {
			jobDesc : {
				required :"请输入“描述”."
			},
			jobCron : {
				required :"请输入“Cron”."
			},
			author : {
				required : "请输入“负责人”."
			}
		},
		highlight : function(element) {
            $(element).closest('.form-group').addClass('has-error');  
        },
        success : function(label) {  
            label.closest('.form-group').removeClass('has-error');  
            label.remove();  
        },
        errorPlacement : function(error, element) {  
            element.parent('div').append(error);  
        },
        submitHandler : function(form) {
			// post
    		$.post(base_url + "/jobinfo/reschedule", $("#updateModal .form").serialize(), function(data, status) {
    			if (data.code == "200") {
					$('#updateModal').modal('hide');
					layer.open({
						title: '系统提示',
						content: '更新成功',
						icon: '1',
						end: function(layero, index){
							//window.location.reload();
							jobTable.fnDraw();
						}
					});
    			} else {
					layer.open({
						title: '系统提示',
						content: (data.msg || "更新失败"),
						icon: '2'
					});
    			}
    		});
		}
	});
	$("#updateModal").on('hide.bs.modal', function () {
		$("#updateModal .form")[0].reset()
	});


	//新增执行器参数控制
    gettypename();

    $(".subAdd").on('click',function(){
       alert("subaddddd")
    });


    // 动态创建的元素要用on中的第二个参数绑定。
    $('#exeParameters').on('click','.updateSub',function(){
        // var id = $(this).attr('id');
        // $.ajax({
        //     type: 'POST',
        //     url: base_url + '/jobsql/subTaskList',
        //     data: {"id": id},
        //     dataType: "json",
        //     success: function (data) {
        //         var addbody = $('#subtasklist');
        //         addbody.html("");//进入前清空之前的数据
        //         if (typeof(data.length) != "undefined") {
        //             for (var o in data) {
        //                 var subtable = $(
        //                     "<tr> " +
        //                     "<td>" + o + 1 + "</td>" +
        //                     "<td>" + data[o].subtask_name + "</td>" +
        //                     // "<input type='hidden' name='sql' value='+" + datajson[o].sql + "'" + "</input>" +
        //                     "<td>" +
        //                     "<button class='btn btn-warning btn-xs updateSub' id='${item_index+1}' subtask_name='${item.subtask_name}' sql='${item.sql}'>编辑</button>" +
        //                     "<button class='btn btn-danger btn-xs remove' id='"+data[o].subtask_name+"'>删除</button>" +
        //                     "<button class='btn btn-warning btn-xs up' id='"+data[o].subtask_name+"'>上移</button>" +
        //                     "<button class='btn btn-warning btn-xs down' id='"+data[o].subtask_name+"'>下移</button>"+
        //                     "</td>" +
        //                     "</tr>"
        //                 );
        //                 addbody.append(subtable);
        //             }
        //         } else {
        //             layer.open({
        //                 title: '错误',
        //                 content: ('未找到对应的数据！'),
        //                 icon: '2'
        //             });
        //         }
        //     }
        // });
        $('#updateSubModal').modal({backdrop: false, keyboard: false}).modal('show');
    })
});

// 选择执行器触事件
function gettypename() {
    $("#typename").val();
    var typename = $('#typeid option:selected').text();//选中的值
    var typename_val = $('#typeid option:selected').val();//选中的value
    // alert(typename + ":" + typename_val);   //示例执行器:1 Kylin执行器:2   SQL执行器:3

    var addbody = $('#exeParameters');
    var subtable;
    addbody.html("");//进入前清空之前的数据
    if (typename == "SQL执行器") {

        $.ajax({
            type: 'POST',
            url: base_url + '/jobsql/findAll',
            data: {"id": 222},
            dataType: "json",
            success: function (data) {
                if (typeof(data.length) != "undefined") {
                    subtable =
                        "<div class='col-sm-4'>" +
                        "<select class='form-control glueType' name='datasource_name'>";
                    subtable += "<option value='选择SQL'>选择SQL</option>";
                    for (var i = 0; i < data.length; i++) {
                        subtable += "<option value=" + JSON.parse(data[i]).task_name + ">" + JSON.parse(data[i]).task_name + "</option>";
                    }
                    subtable += "</select><a class='btn btn-info btn-xs col-sm-2 updateSub' >新建SQL</a></div>";
                    addbody.append(subtable);
                } else {
                    subtable = "<div class='col-sm-4'>" +
                        "<select class='form-control glueType' name='datasource_name'>";
                    subtable += "</select><a class='btn btn-info btn-xs col-sm-2 updateSub' >新建SQL</a></div>";
                }
            }
        });
        // var subtable =  $(subtable);
        // var subtable = $(
        //     "<div class='col-sm-4'><select class='form-control glueType' name='datasource_name'><#list echoList as item> <option value='0' >选择SQL</option><option value='${item}' >${item}</option> </#list></select>" +
        //     "<a class='btn btn-info btn-xs col-sm-2 updateSub' >新建SQL</a></div>"
        // );
    } else if (typename == "Kylin执行器") {
        var subtable = $(
            "<div class='col-sm-4'><input type='text' class='form-control' name='executorParam' placeholder='请输入“Kylin日期”' maxlength='100'></div>"
        );
    } else {
        var subtable = $(
            "<div class='col-sm-4'><input type='text' class='form-control' name='executorParam' placeholder='请输入“执行参数”' maxlength='100'></div>"
        );
    }
    addbody.append(subtable);
}