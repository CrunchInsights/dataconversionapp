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

$(document).ready(function () {	
  var csv_form = $('#uploadForm');
  var wrapper = $('.progress-wrapper');
  wrapper.hide();
  var bitrate = wrapper.find('.bitrate');
  var progress_bar = wrapper.find('.progress-bar');
  $(document).ajaxSuccess( function(event, xhr, settings) {
  	  $('div.container div#custom_message').empty();
      var result=JSON.parse(xhr.responseText);
      if ((result[0]) && ("is_error" in result[0])){
      	if (result[0].is_error) {
          	var div="<div class='alert alert-danger'>" +
              "<button type='button' class='close' data-dismiss='alert'>" +
              "&times;</button>" +result[0].error_message+"</div>";
          	$('div.container div#custom_message').append(div);
          	wrapper.hide();
      	}
      	else {
        	var message = 'File is successfully uploaded. Click <a href="/datauploaders/uploadedfile">here</a> to view all uploaded files.';
          	var div="<div class='alert alert-success'>" +
             	 "<button type='button' class='close' data-dismiss='alert'>" +
              	"&times;</button>" +message+"</div>";
          	$('div.container div#custom_message').append(div);
          	wrapper.show();
      	}
      }        
  });
   
  $(document).ajaxError( function(event, xhr, settings,thrownError) {
  	    $('div.container div#custom_message').empty();
    	var div="<div class='alert alert-danger'>" +
              "<button type='button' class='close' data-dismiss='alert'>" +
              "&times;</button>" +thrownError+"</div>";
  		$('div.container div#custom_message').append(div);
  });

  csv_form.fileupload({
    	dataType: 'script',
    	dropZone: $('#dropzone'),
    	add: function (e, data) {
	     	types = /(\.|\/)(comma-separated-values|vnd.ms-excel|csv)$/i;
	  		file = data.files[0];
	  		if (types.test(file.type) || types.test(file.name)) {
		          $.ajax({
		            type: 'GET',
		            url: '/datauploaders/checkfileuploaded',
		            data: { file_name: file.name },
		            success: function(result) {
		                if(result[0].is_file_exits){
		                  selected_file = '';  
		                  alertify.set({ labels: {
		                    ok     : "Overide!!!",
		                    cancel : "Create New!!!"
		                  }, buttonReverse: true, buttonFocus: "cancel" });
		                  // button labels will be "Accept" and "Deny"
		                  alertify.confirm("CSV with same file name already exist. Do you want to overide the existing or upload a new file with the same name.", function (e, str) {
		                    if (e) {
		                        var body_str = $('table#uploadedSchema tbody');
		                        body_str.empty();
		                        for(var i=0; i<(result[0].matching_record).length; i++){
		                          var row_data = (result[0].matching_record)[i];          
		                          body_str.append('<tr><td>'+ row_data.file_name + '</td><td>'+ row_data.table_name + '</td><td>'
		                            + row_data.created_on + '</td><td><button type="button" class="btn-link selected-file" value="'+ row_data.table_name +'" onclick="get">Select</button></td></tr>');
		                        }
		                        
		                        $('button.selected-file').on('click', function(){
		                          $('#uploadForm input[name="selected_file_name"]').remove();
		                          $('#possibleMatch-model-popup').modal('hide'); 
		                          var input = $("<input>").attr("type", "hidden").attr("name", "selected_file_name").val(this.value);
		                          $('#uploadForm').append($(input));
		                          data.submit(); 
		                        });
		
		                        $('#possibleMatch-model-popup').modal('show');        
		                        alertify.error("You chose to overwrite the existing file");
		                    } else {
		                        $('#uploadForm input[name="selected_file_name"]').remove();
		                        $('#possibleMatch-model-popup').modal('hide');                
		                        alertify.success("You chose to upload a new file with the same name");
		                        data.submit(); 
		                    }                  
		                  });
		                }else{
							data.submit();
						}
		            }
		          }); 		
	  		}
	  		else {
	  			alertify.alert("File format supported is only csv");
          		$('#file').val(""); 
	  		}
    	}
  });
 
  csv_form.on('fileuploadstart', function() {
    	progress_bar.width(0);
    	wrapper.show();
  });

  csv_form.on('fileuploaddone', function() {
      	progress_bar.css('width', '100%').text('File uploaded successfully');
  });

  csv_form.on('fileuploadprogressall', function (e, data) {
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

function create_duplicate_file_modal(data){
  selected_file = '';  
  alertify.set({ labels: {
    ok     : "Overide!!!",
    cancel : "Create New!!!"
  }, buttonReverse: true, buttonFocus: "cancel" });
  // button labels will be "Accept" and "Deny"
  alertify.confirm("CSV with same file name already exist. Do you want to overide the existing or upload a new file with the same name.", function (e, str) {
    if (e) {
        var body_str = $('table#uploadedSchema tbody');
        body_str.empty();
        for(var i=0; i<(data[0].matching_record).length; i++){
          var row_data = (data[0].matching_record)[i];          
          body_str.append('<tr><td>'+ row_data.file_name + '</td><td>'+ row_data.table_name + '</td><td>'
            + row_data.created_on + '</td><td><button type="button" class="btn-link selected-file" value="'+ row_data.table_name +'" onclick="get">Select</button></td></tr>');
        }
        var btn = $('button.selected-file').on('click', function(){
          $('#possibleMatch-model-popup').modal('hide'); 
          alert(this.value);
          return this.value;
        });
        $('#possibleMatch-model-popup').modal('show');        
        alertify.error("You chose to overwrite the existing file");
        return selected_file;
    } else {
        $('#possibleMatch-model-popup').modal('hide');                
        alertify.success("You chose to upload a new file with the same name");
        return selected_file;
    }
  });  
}

