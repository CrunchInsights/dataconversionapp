//use for file upload action , only allow csv format
$('#file').change(function(){
    //debugger;
	var fileType = 'comma-separated-values,vnd.ms-excel,csv';
	var isCorrectType = false;
    var chosen = this.files[0];
    
	if ( fileType!=""){
        var type = (chosen.type).split("/")[1];
        fileTypeArr = fileType.split(",");
        var i=0;
        for(i=0; i<fileTypeArr.length;i++){
            if (type == fileTypeArr[i]){
                isCorrectType = true;
                break;
            }
        }
        if(!isCorrectType){
            alertify.alert("File format supported is only csv");
            $('#file').val("");
        }
    }
});

$(function(){
    $('.dataTable').dataTable();//use for simple table into datatable
});

//Edit button click on table schema screen
function edit_button_click(view){
    var tr =$(view).closest('tr');
    (tr.find('td[is_editable = "yes"]')).find('div[is_default = "yes"]').hide();
    (tr.find('td[is_editable = "yes"]')).find('div.form-group').show();
    (tr.find('td[is_button_column="yes"]')).find('button[button_type = "edit"]').hide();
    (tr.find('td[is_button_column="yes"]')).find('a[button_type = "save"]').show();
}

function show_loading_window() {
    $("#div_loading_window").modal('show');
}
function show_message(message, message_type, obj,is_use_clone){
    var hyper_link_exist =$(obj).parent().find('a').length;
    var html='';
    if(is_use_clone==true && hyper_link_exist > 0){
        html = $(obj).parent().find('a').first().clone().show();
    }
    if(message_type=="notice"){
        var div="<div class='alert alert-success'>" +
            "<button type='button' class='close' data-dismiss='alert'>" +
            "&times;</button>" +message+"</div>";
        $('div.container div#custom_message').append( $(div).append($(html)));
    }else{
        if(message_type =="error"){
            var div="<div class='alert alert-danger'>" +
                "<button type='button' class='close' data-dismiss='alert'>" +
                "&times;</button>" +message+"</div>";
            $('div.container div#custom_message').append( $(div).append($(html)));
        }else{
            var div="<div class='alert alert-info'>" +
                "<button type='button' class='close' data-dismiss='alert'>" +
                "&times;</button>" +message+"</div>";
            $('div.container div#custom_message').append( $(div).append($(html)));
        }
    }
}

$(window).on('popstate', function() {
    if(history.length) {
        $("#div_loading_window").modal('hide');
        window.location.reload();
    }
});
/*$(document).ready(function () {

})*/;

