# /////////////////////////////////////////////
# //
# // STUDY - Create.js for New Studies
# //
# /////////////////////////////////////////////

if <%= @study.valid? %>
  window.location.href = "<%= protocol_service_request_path @service_request %>"
else
  $('.new_study').html("<%= escape_javascript(render :partial => 'studies/form', :locals => {:study => @study, :service_request => @service_request}) %>")
