$('#file').change(function(){
	var fileType = 'comma-separated-values,vnd.ms-excel';
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


$(document).ready(function() {
    $('.dropdown-toggle').dropdown();
    $('.dataTable').DataTable();
} );
