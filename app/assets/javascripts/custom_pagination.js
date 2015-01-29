
// DataTables initialisation
//
$(document).ready(function() {
    $.ajax({
        url: 'uploadfilecolumnsforrecord',
        type: 'POST',
        data: {table_name: $('#page_params').val()},
        dataType: 'json',
        success: function (data) {            
            $('#uploadedRecords') .dataTable( {
                "processing": true,
                "serverSide": true,
                "bDestroy": true,
                "bJQueryUI": true,
                "aoColumns": data.columns,               
                "ajax": {
                    "url": "uploadfilerecord",
                    "type": "POST",
                    "data": {
                       table_name: $('#page_params').val()
                    }                     
                },        
            });
        }
    });   
} );