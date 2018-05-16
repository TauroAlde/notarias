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
      @chat.before = @
      @scrolled = false
      e.preventDefault()
      e.stopPropagation()
      @render()

  chatRoomPath: ->
    console.log("implement")

  responsePath: ->
    console.log("implement")

  renderRow: ->
    @el = $(@template(@model.data))
    @bindClickLoadChat()
    @el

  render: (poller)->
    @chat.chatForm.render()
    @pool.startLoadingIcon() if !poller
    $.get
      url: @chatRoomPath()
      datatype: "JSON"
      success: (messages, textStatus, jqXHR) =>
        @messages = []
        $.each messages, (index, message) =>
          message = new @messageClass(message, @chat, @pool, @)
          @messages.push(message)
        if @chat.current == @
          @pool.stopLoadingIcon()
          @renderMessages()
          @chat.startPoller()

  reload: ->
    @render(true)

  renderMessages: ->
    @pool.renderMessages(@messages)
    if @chat.el.find("#chat-viewport-scroll")[0].scrollTop < (@pool.el.height() - 300) && !@scrolled
      @scrolled = true
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
