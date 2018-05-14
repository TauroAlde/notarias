class @ChatForm
  constructor: (chat)->
    @el = $("#chat-form")
    @chat = chat
    @bindOnSubmit()
    @render()

  bindMessagesFileUploader: ->
    chat = @chat
    if @el.hasClass("jquery-fileupload-initialized")
      @el.fileupload('destroy')
      @el.removeClass("jquery-fileupload-initialized")
    if @chat.currentIsSegmentMessage() || @chat.currentIsUserMessage()
      current_path = @currentChatPath()
      @el.addClass("jquery-fileupload-initialized")
      @el.fileupload
        dataType: 'json',
        fileInput: $('#fileupload-evidence'),
        limitMultiFileUploads: 1,
        #autoUpload: true,
        url: current_path.split(".")[0] + ".json"
        done: (e, data)->
          console.log "done"
          chat.historyFunnelLast().render()
          #formData: { segment_message: { message: $("#step-one-textarea") } },
        fail: (e, data) ->
          console.log "form fail"
        submit: (e, data) ->
          console.log "form submit"
        send: (e, data)->
          console.log "form send"

  render: (poller)->
    @el.attr("action", @currentChatPath())
    @bindMessagesFileUploader()

  currentChatPath: ->
    if @chat.currentIsSegmentMessage()
      "/segment_messages/#{@chat.historyFunnelLast().id}/responses.js"
    else if @chat.currentIsUserMessage()
      "/user_messages/#{@chat.historyFunnelLast().id}/responses.js"
    else
      "#"

  bindOnSubmit: ->
    @el.submit (e) =>
      if @el.attr("action") == "#" || !@el.find("#message-text").val()
        e.preventDefault()
        return false

  clearText: ->
    @el.find("#message-text").val("")

  disable: ->
    $("#form-fieldset").attr("disabled", "true")
  enable: ->
    $("#form-fieldset").attr("enabled", "true")