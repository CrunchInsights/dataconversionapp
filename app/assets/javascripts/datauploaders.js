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
    $('.custom_table').dataTable();   
});

//Edit button click on table schema screen
function edit_button_click(view){
    var tr =$(view).closest('tr');
    (tr.find('td[is_editable = "yes"]')).find('div[is_default = "yes"]').hide();
    (tr.find('td[is_editable = "yes"]')).find('div.form-group').show();
    (tr.find('td[is_button_column="yes"]')).find('button[button_type = "edit"]').hide();
    (tr.find('td[is_button_column="yes"]')).find('a[button_type = "save"]').show();
}

/*function show_loading_window() {
    $("#div_loading_window").modal('show');
}*/

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

$(document).ready(function () {
	
	var multiple_photos_form = $('#uploadForm');
    var wrapper = multiple_photos_form.find('.progress-wrapper');
    wrapper.hide();
    var bitrate = wrapper.find('.bitrate');
    var progress_bar = wrapper.find('.progress-bar');

    multiple_photos_form.fileupload({
      dataType: 'script',
      dropZone: $('#dropzone'),
      add: function (e, data) {
        types = /(\.|\/)(comma-separated-values|vnd.ms-excel|csv)$/i;
        file = data.files[0];
        if (types.test(file.type) || types.test(file.name)) {
          data.submit();
        }
        else { alert(file.name + " must be csv"); }
      }
    });
   
    multiple_photos_form.on('fileuploadstart', function() {    	
      progress_bar.width(0);
      wrapper.show();
    });

    multiple_photos_form.on('fileuploaddone', function() {    	
      wrapper.hide();
      progress_bar.width(0);
    });

    multiple_photos_form.on('fileuploadsubmit', function (e, data) {
    	console.log("3");
      data.formData = {'photo[author]': $('#photo_author').val()};
    });

    multiple_photos_form.on('fileuploadprogressall', function (e, data) {
    	console.log("4");
      bitrate.text((data.bitrate / 1024).toFixed(2) + 'Kb/s');
      var progress = parseInt(data.loaded / data.total * 100, 10);
      progress_bar.css('width', progress + '%').text(progress + '%');
    });
	
	
	
	$(document).bind('dragover', function (e) {
      var dropZone = $('#dropzone'),
              timeout = window.dropZoneTimeout;
      if (!timeout) {
        dropZone.addClass('in');
      } else {
        clearTimeout(timeout);
      }
      var found = false,
              node = e.target;
      do {
        if (node === dropZone[0]) {
          found = true;
          break;
        }
        node = node.parentNode;
      } while (node != null);
      if (found) {
        dropZone.addClass('hover');
      } else {
        dropZone.removeClass('hover');
      }
      window.dropZoneTimeout = setTimeout(function () {
        window.dropZoneTimeout = null;
        dropZone.removeClass('in hover');
      }, 100);
    });		
});

