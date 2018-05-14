class @ChatForm
  constructor: (chat)->
    @el = chat.el.find("#chat-form")
    @chat = chat
    @render()

  render: ()->
    @el.attr("action", @currentChatPath())
    if !@alreadySubmitBind
      @bindMessagesFileUploader() 
      @bindOnSubmit()
      @alreadySubmitBind = true

  bindMessagesFileUploader: ->
    form = @ 
    #if @el.hasClass("jquery-fileupload-initialized")
    #  @el.fileupload('destroy')
    #  @el.removeClass("jquery-fileupload-initialized")
    #if @chat.currentIsSegmentMessage() || @chat.currentIsUserMessage()
    #@el.addClass("jquery-fileupload-initialized")
    @el.fileupload
      dataType: 'json'
      fileInput: $('#fileupload-evidence')
      limitMultiFileUploads: 1
      autoUpload: true,
      url: form.el.attr("action")
      add: (e, data)->
        data.url = form.el.attr("action")
        data.process().done -> data.submit()
      done: (e, data)->
        form.addNewMessage(data.result)
      fail: (e, data) ->
        console.log "form fail"
      submit: (e, data) ->
        if !form.canSubmit() then return false
        console.log "form submit"
      send: (e, data) =>
        console.log "form send"

  currentChatPath: ->
    if @chat.currentIsChatRoom()
      @chat.current.responsePath()
    else
      "#"

  canSubmit: ->
    !(@el.attr("action") == "#" || !@text)

  bindOnSubmit: ->
    @el.submit (e) =>
      e.preventDefault()
      if @canSubmit()
        return false
      $.post
        url: @el.attr("action")
        data: @el.serialize()
        datatype: "JSON"
        success: (messageData, textStatus, jqXHR) =>
          @clearText()
          @addNewMessage(messageData)

  addNewMessage: (messageData)->
    message = new @chat.current.messageClass(messageData, @chat, @chat.current.pool, @chat.current)
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