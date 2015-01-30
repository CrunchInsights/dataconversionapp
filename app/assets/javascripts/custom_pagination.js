
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
                "scrollX" :true,                          
                "ajax": {
                    "url": "uploadfilerecord",
                    "type": "POST",
                    "data": {
                       table_name: $('#page_params').val()
                    }                     
                }      
            });
            $( window ).resize(function() {
                $('div.dataTables_scrollBody table thead th').removeClass('sorting_asc').removeClass('sorting').removeClass('sorting_desc');
            });           
        }
    });
});

