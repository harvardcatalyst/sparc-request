$("#modal_place").html("<%= escape_javascript(render(:partial =>'dashboard/fulfillment/service_request_info/admin_approvals', locals: { sub_service_request: @sub_service_request })) %>");
$("#modal_place").modal 'show'
