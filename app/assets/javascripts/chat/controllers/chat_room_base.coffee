class @ChatRoomBase
  template: undefined
  chatRoomModelClass: undefined
  messageClass: undefined

  constructor: (data, chat, pool) ->
    @model = new @chatRoomModelClass(data)
    @chat = chat
    @pool = pool
    @messages = []

  bindClickLoadChat: ->
    @el.click (e) =>
      @chat.current = @
      e.preventDefault()
      e.stopPropagation()
      @chat.chatForm.render()
      @render()

  chatRoomPath: ->
    console.log("implement")

  responsePath: ->
    console.log("implement")

  renderRow: ->
    @el = $(@template(@model.data))
    @bindClickLoadChat()
    @el

  render: ->
    @pool.startLoadingIcon()
    $.get
      url: @chatRoomPath()
      datatype: "JSON"
      success: (messages, textStatus, jqXHR) =>
        @pool.stopLoadingIcon()
        $.each messages, (index, message) =>
          message = new @messageClass(message, @chat, @pool, @)
          @messages.push(message)
        @renderMessages()

  renderMessages: ->
    @pool.renderMessages(@messages)
    @chat.el.find("#chat-viewport-scroll")[0].scrollTop = @pool.el.height()
    #@chat.chatForm.render()
    #$.getScript @message_path(), ()=>
    #  #lightbox.init();
    #  #lightbox.option({
    #  #  'resizeDuration': 20,
    #  #  'maxWidth': 500,
    #  #  'maxHeight': 500,
    #  #})
    #  @chat.loading = false
    #  @chat.historyFunnel.push(@) if @chat.historiable()
    #  @chat.chatForm.render()
    #  

  startLoadingIcon: ->
    @pool.startLoadingIcon()

  reload: (poller)->
    @chat.chatForm.render()