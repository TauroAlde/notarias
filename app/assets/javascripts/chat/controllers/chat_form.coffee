class @ChatForm
  constructor: (chat)->
    @el = chat.el.find("#chat-form")
    @chat = chat
    @bindOnSubmit() if !@alreadySubmitBind
    @alreadySubmitBind = true
    @render()

  render: ()->
    @el.attr("action", @currentChatPath())
    #@bindMessagesFileUploader()

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

  currentChatPath: ->
    if @chat.currentIsChatRoom()
      @chat.current.responsePath()
    else
      "#"

  bindOnSubmit: ->
    @el.submit (e) =>
      e.preventDefault()
      if @el.attr("action") == "#" || !@text
        return false
      $.post
        url: @el.attr("action")
        data: @el.serialize()
        datatype: "JSON"
        success: (message, textStatus, jqXHR) =>
          @clearText()
          message = new @chat.current.messageClass(message, @chat, @chat.current.pool, @chat.current)
          @chat.current.messages.push(message)
          @chat.current.renderMessages()

  clearText: ->
    @el.find("#message-text").val("")

  text: ->
    @el.find("#message-text").val()

  disable: ->
    $("#form-fieldset").attr("disabled", "true")
  enable: ->
    $("#form-fieldset").attr("enabled", "true")