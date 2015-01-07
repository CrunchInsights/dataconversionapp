//use for file upload action , only allow csv format
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
    $('.dropdown-toggle').dropdown();//use for top menu dropdown
    $('.dataTable').DataTable();//use for simple table into datatable

} );
//Edit button click on table schema screen
function editbuttonclick(view){
    var tr =$(view).closest('tr');
    (tr.find('td[isEditable="yes"]')).find('div[isDefault="yes"]').hide();
    (tr.find('td[isEditable="yes"]')).find('div.form-group').show();
    (tr.find('td[isbuttoncolumn="yes"]')).find('button[buttontype="edit"]').hide();
    (tr.find('td[isbuttoncolumn="yes"]')).find('a[buttontype="save"]').show();
}