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
    $('.dataTable').DataTable();//use for simple table into datatable
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

function show_message(message, message_type){
    if(message_type=="notice"){
        $('div.container div#custom_message').append("<div class='alert alert-success'>" +
            "<button type='button' class='close' data-dismiss='alert'>" +
            "&times;</button>" +message+"</div>");
    }else{
        if(message_type =="error"){
            $('div.container div#custom_message').append("<div class='alert alert-danger'>" +
                "<button type='button' class='close' data-dismiss='alert'>" +
                "&times;</button>" +message+"</div>");
        }else{
            $('div.container div#custom_message').append("<div class='alert alert-info'>" +
                "<button type='button' class='close' data-dismiss='alert'>" +
                "&times;</button>" +message+"</div>");
        }
    }
}

$(document).ready(function () {
    $("#div_loading_window").modal('hide');
    $(window).on('popstate', function() {
        if(history.length) {
            $("#div_loading_window").modal('hide');
            window.location.reload();
        }
    });
});

