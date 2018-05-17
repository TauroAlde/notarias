class @Message
  template: undefined
  constructor: (data, chat, pool, chatRoom)->
    @data = data
    @id = data.id
    @message = data.message
    @read_at = data.read_at
    @user = data.user
    @receiver = data.receiver
    @segment = data.segment
    ####
    @chat = chat
    @pool = pool
    @chatRoom = chatRoom

  render: ->
    @el = @template({ data: @data, currentUser: @chat.currentUser })
    @el
