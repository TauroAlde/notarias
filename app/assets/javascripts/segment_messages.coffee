# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.bindMessagesFileUploader = ->
  segment_id = $("#current-segment").attr("data-current-segment")

  $('#segment_message_form').fileupload
    dataType: 'json',
    fileInput: $('#fileupload-evidence'),
    limitMultiFileUploads: 1,
    autoUpload: true,
    url: "/segments/#{segment_id}/segment_messages.json",
    done: (e, data)->
      $.getScript "/segments/#{segment_id}/segment_messages.js"
    #formData: { segment_message: { message: $("#step-one-textarea") } },
  
$ ->
  window.bindMessagesFileUploader()