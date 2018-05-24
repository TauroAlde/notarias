# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#new_segment_user_import").fileupload
    dataType: 'script'
    fileInput: $("#new_segment_user_import").find("input")
    limitMultiFileUploads: 1
    autoUpload: true,
    add: (e, data)->
      data.process().done -> data.submit()
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10);
      $('#progress .progress-bar').attr("aria-valuenow", progress );
      $('#progress .progress-bar').css("width", progress + "%" );
      $('#loader-container').removeClass("d-none")
    done: (e, data)->
      $('#loader-container').addClass("d-none")
    fail: (e, data) ->
      $('#loader-container').addClass("d-none")
      #$.notify("Información guardada", { globalPosition: "top center", className: 'success' });
      $.notify(data.errorThrown + ": " + Object.values(data.messages).join(", "), { globalPosition: "top center" });
    submit: (e, data) ->
      console.log "form submit"
    send: (e, data) =>
      console.log "form send"