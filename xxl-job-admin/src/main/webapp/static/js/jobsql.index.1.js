$(function () {

    // remove
    $('.remove').on('click', function () {
        var id = $(this).attr('id');

        layer.confirm('确认删除分组?', {icon: 3, title: '系统提示'}, function (index) {
            layer.close(index);

            $.ajax({
                type: 'POST',
                url: base_url + '/jobsql/remove',
                data: {"id": id},
                dataType: "json",
                success: function (data) {
                    if (data.code == 200) {
                        layer.open({
                            title: '系统提示',
                            content: '删除成功',
                            icon: '1',
                            end: function (layero, index) {
                                window.location.reload();
                            }
                        });
                    } else {
                        layer.open({
                            title: '系统提示',
                            content: (data.msg || "删除失败"),
                            icon: '2'
                        });
                    }
                },
            });
        });

    });
   
    // jquery.validate 自定义校验 “英文字母开头，只含有英文字母、数字和下划线”
    

    $('.add').on('click', function () {
        $('#addModal').modal({backdrop: false, keyboard: false}).modal('show');
    });
    var addModalValidate = $("#addModal .form").validate({
        errorElement: 'span',
        errorClass: 'help-block',
        focusInvalid: true,
        rules: {
        	task_name: {
                required: true,
                rangelength: [4, 1000],
               
            },
            cc_lists: {
                required: true,
                rangelength: [4, 1000]
            },
            recipient_lists: {
            	required: true,
            	rangelength: [4, 1000]
            }
            
        },
        messages: {
        	task_name: {
                required: "请输入“任务名称”",
                rangelength: "任务名称长度限制为4~1000"
                
            },
            cc_lists: {
                required: "请输入“发件人”",
                rangelength: "发件人长度限制为4~1000"
            },
            recipient_lists: {
                required: "请输入“收件人”",
                rangelength: "收件人长度限制为4~1000"
               
            }
        },
        highlight: function (element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        success: function (label) {
            label.closest('.form-group').removeClass('has-error');
            label.remove();
        },
        errorPlacement: function (error, element) {
            element.parent('div').append(error);
        },
        submitHandler: function (form) {
            $.post(base_url + "/jobsql/save", $("#addModal .form").serialize(), function (data, status) {
                if (data.code == "200") {
                    $('#addModal').modal('hide');
                    layer.open({
                        title: '系统提示',
                        content: '新增成功',
                        icon: '1',
                        end: function (layero, index) {
                            window.location.reload();
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
    });

    // 注册方式，切换
    $("#addModal input[name=addressType], #updateModal input[name=addressType]").click(function () {
        var addressType = $(this).val();
        var $addressList = $(this).parents("form").find("input[name=addressList]");
        if (addressType == 0) {
            $addressList.val("");
            $addressList.attr("readonly", "readonly");
        } else {
            $addressList.removeAttr("readonly");
        }
    });

    // update
    $('.update').on('click', function () {
    	$('#updateModal').modal({backdrop: false, keyboard: false}).modal('show');
        $("#updateModal .form input[name='task_name']").val($(this).attr("task_name"));
        $("#updateModal .form input[name='cc_lists']").val($(this).attr("cc_lists"));
        $("#updateModal .form input[name='recipient_lists']").val($(this).attr("recipient_lists"));
        $("#updateModal .form input[name='id']").val($(this).attr("id"));

        // 注册方式
        var datasource_name = $(this).attr("datasource_name");
      
        $("#updateModal .form select[name='datasource_name'][value='"+ datasource_name +"']").attr('selected', 'true');
       
       
    });
    var updateModalValidate = $("#updateModal .form").validate({
        errorElement: 'span',
        errorClass: 'help-block',
        focusInvalid: true,
        rules: {
        	task_name: {
                required: true,
                rangelength: [4, 1000],
               
            },
            cc_lists: {
                required: true,
                rangelength: [4, 1000]
            },
            recipient_lists: {
            	required: true,
            	rangelength: [4, 1000]
            }
            
        },
        messages: {
        	task_name: {
                required: "请输入“任务名称”",
                rangelength: "任务名称长度限制为4~1000"
                
            },
            cc_lists: {
                required: "请输入“发件人”",
                rangelength: "发件人长度限制为4~1000"
            },
            recipient_lists: {
                required: "请输入“收件人”",
                rangelength: "收件人长度限制为4~1000"
               
            }
        },
        highlight: function (element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        success: function (label) {
            label.closest('.form-group').removeClass('has-error');
            label.remove();
        },
        errorPlacement: function (error, element) {
            element.parent('div').append(error);
        },
        submitHandler: function (form) {
            $.post(base_url + "/jobsql/update", $("#updateModal .form").serialize(), function (data, status) {
                if (data.code == "200") {
                    $('#addModal').modal('hide');

                    layer.open({
                        title: '系统提示',
                        content: '更新成功',
                        icon: '1',
                        end: function (layero, index) {
                            window.location.reload();
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
        $("#updateModal .form")[0].reset();
        updateModalValidate.resetForm();
        $("#updateModal .form .form-group").removeClass("has-error");
    });

    // updateSub
    $('.updateSub').on('click', function () {
    	
    	$('#updateSubModal').modal({backdrop: false, keyboard: false}).modal('show');
    	$("#updateSubModal .form input[name='id']").val($(this).attr("id"));
    	// alert($(this).attr("subtasks"));
    	// $("#updateSubModal .form input[name='subtasks']").val($(this).attr("subtasks"));
    	var id = $(this).attr('id');
    	var testlist = $(this).attr('testlist');
        $.ajax({
             type: 'POST',
             url: base_url + '/jobsql/subTaskList',
             data: {"id": id},
             dataType: "json",
             success: function (data) {
            	 var sqllist=eval(data);
            	 var subtasks=sqllist.subtasks;
            	 for(var i=0;i<subtasks.length;i++){  
                     var subtask_name = subtasks[i].subtask_name;  
                     var sql = subtasks[i].sql; 
                $("#haha").append('<tr><td>'+i+'</td><td>'+subtask_name+'</td><td><button class="btn btn-warning btn-xs updateSub"'+ 
                                        'subtask_name='+subtask_name+
                                        'sql='+sql+'>编辑</button>'+
                                '<button class="btn btn-danger btn-xs remove" id='+subtask_name+'>删除</button>'+
                                '<button class="btn btn-warning btn-xs up" id='+subtask_name+'>上移</button>'+
                                '<button class="btn btn-warning btn-xs down" id='+subtask_name+'>下移</button></td></tr>');
            	 }
             },
         });

        // $("#updateSubModal .form input[name='title']").val($(this).attr("title"));
        // $("#updateSubModal .form input[name='order']").val($(this).attr("order"));

        // // 注册方式
        // var addressType = $(this).attr("addressType");
        // $("#updateSubModal .form input[name='addressType']").removeAttr('checked');
        // //$("#updateModal .form input[name='addressType'][value='"+ addressType +"']").attr('checked', 'true');
        // $("#updateSubModal .form input[name='addressType'][value='" + addressType + "']").click();
        // // 机器地址
        // $("#updateSubModal .form input[name='addressList']").val($(this).attr("addressList"));

       
    });
    var updateSubModalValidate = $("#updateSubModal .form").validate({
        errorElement: 'span',
        errorClass: 'help-block',
        focusInvalid: true,
        rules: {
        	subtask_name: {
                required: true,
                rangelength: [4, 1000]
               
            },
            sql: {
                required: true,
                rangelength: [4, 1000]
            }
        },
        messages: {
        	subtask_name: {
                required: "请输入“子任务名称”",
                rangelength: "子任务名称长度限制为4~1000"
               
            },
            sql: {
                required: "请输入“sql脚本”",
                rangelength: "长度限制为4~1000"
            }
        },
        highlight: function (element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        success: function (label) {
            label.closest('.form-group').removeClass('has-error');
            label.remove();
        },
        errorPlacement: function (error, element) {
            element.parent('div').append(error);
        },
        submitHandler: function (form) {
            $.post(base_url + "/jobsql/updateSub", $("#updateSubModal .form").serialize(), function (data, status) {
                if (data.code == "200") {
                    $('#addModal').modal('hide');

                    layer.open({
                        title: '系统提示',
                        content: '更新成功',
                        icon: '1',
                        end: function (layero, index) {
                            window.location.reload();
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
    $(".subAdd").on('click',function(){
    	$("subtask_name").val('');
    	$("sql").val('');
    });
    $(".subSave").on('click',function(){
    	$("subtask_name").val('');
    	$("sql").val('');
    });
    $('.testsql').on('click', function () {
        $.post(base_url + "/jobsql/testsql", $("#updateSubModal .form").serialize(), function (data, status) {
            if (data.code == "200") {
                $("#eerMsg").hide();
                $("#rigMsg").show();
            } else {
                $("#errMsg").show();
                $("#rigMsg").hide();
            }
        });
    });

    $("#rebut").on('click', function () {
        $("#msg").hide();
        $("#errMsg").hide();
    });

    $("#updateSubModal").on('hide.bs.modal', function () {
        $("#updateSubModal .form")[0].reset();
        updateSubModalValidate.resetForm();
        $("#updateSubModal .form .form-group").removeClass("has-error");
    });


    //上移
    var $up = $(".up");
    $up.click(function () {
        var $tr = $(this).parents("tr");
        if ($tr.index() != 0) {
            $tr.fadeOut().fadeIn();
            $tr.prev().before($tr);
        }
    });
    //下移
    var $down = $(".down");
    var len = $down.length;
    $down.click(function () {
        var $tr = $(this).parents("tr");
        if ($tr.index() != len - 1) {
            $tr.fadeOut().fadeIn();
            $tr.next().after($tr);
        }
    });


});
